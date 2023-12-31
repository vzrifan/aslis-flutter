import 'package:aslis_application/ui/laporan/laporan_pakan.dart';
import 'package:aslis_application/ui/laporan/laporan_ternak.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Hewan Ternak",
          style: ThemesCustom.black1_18_700,
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TabBar(
                      labelColor: Color(0xff71A841),
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Color(0xff71A841),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Ternak"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Pakan"),
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
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      LaporanTernakPage(),
                      LaporanPakanPage()
                      // PageCartAll(),
                      // PageListDiskonCart(),
                      // PageListBuyCart()
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
