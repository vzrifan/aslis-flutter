import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRiwayatKandangKambing extends StatefulWidget {
  var id;
  PageRiwayatKandangKambing({required this.id});
  // const PageRiwayatKandangKambing({Key? key}) : super(key: key);

  @override
  _PageRiwayatKandangKambingState createState() =>
      _PageRiwayatKandangKambingState();
}

class _PageRiwayatKandangKambingState extends State<PageRiwayatKandangKambing> {
  KambingController kambing_c = Get.find();

  ScrollController _scrolC = new ScrollController();
  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      kambing_c.PaginateGetListRiwayatPindahKandang(widget.id);
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
                    "Riwayat Pindah Kandang",
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
              future: kambing_c.getListRiwayatPindahKandang(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return Obx(() => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kambing_c.listRiwayatPindahKandang.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              BoxPindahKandang(
                                kambing_c.listRiwayatPindahKandang[index]
                                    ['kandang_baru'],
                                kambing_c.listRiwayatPindahKandang[index]
                                        ['birthday'] ??
                                    "-",
                                kambing_c.listRiwayatPindahKandang[index]
                                    ['description'],
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

  Widget BoxPindahKandang(String kandang, String harga, String catatan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 150,
          child: Text(
            kandang,
            style: ThemesCustom.black_13_700,
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              harga,
              style: ThemesCustom.black_13_400,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              catatan,
              style: ThemesCustom.black_13_400,
            ),
          ],
        )),
      ],
    );
  }
}
