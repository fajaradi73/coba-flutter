import 'package:coba_flutter/screen/contohMvp/view/MvpScreen.dart';
import 'package:coba_flutter/screen/home/presenter/HomePresenter.dart';
import 'package:coba_flutter/screen/home/view/HomeView.dart';
import 'package:coba_flutter/screen/maps/view/MapsScreen.dart';
import 'package:coba_flutter/screen/recycleView/view/recycleViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, HomeView {
  late HomePresenter presenter;
  var nowTime = DateTime.now();
  var hari = "";
  var tanggal = "";
  var address = "";

  @override
  void initState() {
    super.initState();
    presenter = BasicHomePresenter(this);

    initializeDateFormatting();
    hari = DateFormat("EEEE", "id").format(nowTime);
    tanggal = DateFormat("dd MMMM yyyy", "id").format(nowTime);

    asyncMethod();
  }

  void asyncMethod() async {
    var position = await presenter.getGeoLocationPosition();
    address = await presenter.getAddressFromLatLong(position);
    setState(() {});
  }

  @override
  void onClick(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RecycleView()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MvpPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MapsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var header = Center(
        child: Card(
            elevation: 0,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bg_detail.jpg'),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  hari,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  tanggal,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                height: 10,
                                child: Card(
                                  color: Colors.white,
                                ),
                              ),
                              (address.isEmpty)
                                  ? Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(10),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        address,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                            ]),
                      )
                    ],
                  ),
                ),
              ],
            )));

    var menu = Container(
      height: MediaQuery.of(context).size.height * 1,
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 2 / 2.7),
          itemCount: presenter.getMenu().length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onClick(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.purpleAccent.shade400,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/ic_menu.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Text(
                    presenter.getMenu()[index],style: const TextStyle(color: Colors.white),
                  )
                ]),
              ),
            );
          }),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header,
              menu,
            ],
          ),
        ));
  }
}
