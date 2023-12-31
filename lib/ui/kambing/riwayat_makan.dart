import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRiwayatMakanKambing extends StatefulWidget {
  var id;
  PageRiwayatMakanKambing({required this.id});
  // const PageRiwayatMakanKambing({Key? key}) : super(key: key);

  @override
  _PageRiwayatMakanKambingState createState() =>
      _PageRiwayatMakanKambingState();
}

class _PageRiwayatMakanKambingState extends State<PageRiwayatMakanKambing> {
  KambingController kambing_c = Get.find();

  ScrollController _scrolC = new ScrollController();
  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      kambing_c.PaginategetListRiwayatMakan(widget.id);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
              Expanded(
                child: Center(
                  child: Text(
                    "Riwayat Pakan",
                    style: ThemesCustom.black_14_700,
                  ),
                ),
              ),
              // IconButton(
              //     onPressed: () {
              //       // Navigator.pop(context);
              //     },
              //     icon: Image(
              //         width: 25,
              //         height: 25,
              //         image: AssetImage("assets/image/filter.png"))),
            ],
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: onNotificatin,
        child: SingleChildScrollView(
          controller: _scrolC,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: kambing_c.getListRiwayatMakan(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return Obx(() => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kambing_c.listRiwayatMakan.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              BoxMakan(
                                kambing_c.listRiwayatMakan[index]['food_name'],
                                kambing_c.listRiwayatMakan[index]['weigth'],
                                kambing_c.listRiwayatMakan[index]['date'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Color.fromRGBO(35, 31, 32, 0.1)),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget BoxMakan(String kandang, String berat, String harga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          harga,
          style: ThemesCustom.black_13_400,
        )),
        Container(
          width: 150,
          child: Text(
            kandang,
            style: ThemesCustom.black_13_700,
          ),
        ),
        Expanded(
            child: Text(
          berat + " Kg",
          style: ThemesCustom.black_13_700,
        )),
      ],
    );
  }
}
