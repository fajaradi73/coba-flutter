import 'package:coba_flutter/screen/contohMvp/presenter/MvpPresenter.dart';
import 'package:coba_flutter/screen/recycleView/recycleViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:coba_flutter/screen/contohMvp/view/MvpScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void onClick(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RecycleView()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MvpPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
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
                                  image:
                                      AssetImage('assets/images/bg_detail.jpg'),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            "Senin",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "20 Juni 2022",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          height: 10,
                                          child: Card(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Kecamatan Grogol Petamburan",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
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
                      ))),
              Container(
                height: MediaQuery.of(context).size.height * 1,
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 2 / 2.7),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          onClick(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.purpleAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                            Container(
                              height: 120,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/ic_menu.png'),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const Text(
                              "Recycle View",
                            )
                          ]),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
