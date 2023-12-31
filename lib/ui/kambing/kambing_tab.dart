import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/ui/kambing/list_kambing.dart';
import 'package:aslis_application/ui/kambing/list_kambing_dijual.dart';
import 'package:aslis_application/ui/kambing/tambah_kambing.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';

class TabKambingPage extends StatefulWidget {
  const TabKambingPage({Key? key}) : super(key: key);

  @override
  State<TabKambingPage> createState() => _TabKambingPageState();
}

class _TabKambingPageState extends State<TabKambingPage> {
  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff45B549),
          title: Text(
            "Hewan Ternak",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  // showModal(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddGoat();
                  }));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        labelColor: Color(0xff71A841),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Color(0xff71A841),
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Hewan Ternak"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Lagi Dijual"),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    width: 18,
                  ),
                ],
              ),
              Container(
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    // LaporanTernakPage(),
                    // LaporanPakanPage()

                    ListGoat(),
                    ListGoatSell(),

                    // PageCartAll(),
                    // PageListDiskonCart(),
                    // PageListBuyCart()
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
