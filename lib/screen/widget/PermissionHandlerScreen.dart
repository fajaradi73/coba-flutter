import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../splashScreen.dart';

class PermissionHandlerScreen extends StatefulWidget {
  const PermissionHandlerScreen({Key? key}) : super(key: key);

  @override
  State<PermissionHandlerScreen> createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  @override
  void initState() {
    super.initState();
    permissionServiceCall();
  }

  permissionServiceCall() async {
    bool success = false;

    await permissionServices().then(
      (value) async {
        for (var entry in value.entries) {
          if (await entry.key.isGranted) {
            success = true;
          }
        }
      },
    );
    if (success) {
      moveToSplash();
    }
  }

  moveToSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location, Permission.storage,

      //add more permission to request here.
    ].request();

    for (var entry in statuses.entries) {
      if (await entry.key.isPermanentlyDenied) {
        await openAppSettings().then(
          (value) async {
            if (value) {
              if ((await entry.key.status.isPermanentlyDenied == true &&
                  await entry.key.status.isGranted == false)) {
                // openAppSettings();
                permissionServiceCall(); /* opens app settings until permission is granted */
              }
            }
          },
        );
      } else {
        if (await entry.key.isDenied) {
          permissionServiceCall();
        }
      }
    }

    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }

  // Future<bool> _onWillPop() async {
  //   // This dialog will exit your app on saying yes
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Are you sure?'),
  //       content: const Text('Do you want to exit an App'),
  //       actions: <Widget>[
  //         FlatButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text('No'),
  //         ),
  //         FlatButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   )) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    permissionServiceCall();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Center(
          child: InkWell(
              onTap: () {
                permissionServiceCall();
              },
              child:
                  const Text("Click here to enable Enable Permission Screen")),
        ),
      ),
    );
  }
}
