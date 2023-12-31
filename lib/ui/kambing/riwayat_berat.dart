import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRiwayatBeratKambing extends StatefulWidget {
  var id;
  PageRiwayatBeratKambing({required this.id});
  // const PageRiwayatBeratKambing({Key? key}) : super(key: key);

  @override
  _PageRiwayatBeratKambingState createState() =>
      _PageRiwayatBeratKambingState();
}

class _PageRiwayatBeratKambingState extends State<PageRiwayatBeratKambing> {
  KambingController kambing_c = Get.find();

  ScrollController _scrolC = new ScrollController();
  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      kambing_c.PaginategetRiwayatBerat(widget.id);
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
                    "Riwayat Berat",
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
              future: kambing_c.getRiwayatBerat(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return Obx(() => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kambing_c.listRiwayatPindahBerat.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RiwayatKambing(
                                kambing_c.listRiwayatPindahBerat[index]['date'],
                                kambing_c.listRiwayatPindahBerat[index]
                                    ['weigth'],
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

  Container RiwayatKambing(String tanggal, String berat) {
    return Container(
      width: double.infinity,
      height: 83,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(width: 1, color: Color(0xffF2F6FF))),
      child: Row(
        children: [
          Image(
              width: 60,
              height: 60,
              image: CachedNetworkImageProvider(
                  "https://souq.s3-id-jkt-1.kilatstorage.id/available_1654059656.png")),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tanggal,
                style: ThemesCustom.black_12_400,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                      width: 14,
                      height: 14,
                      image: AssetImage("assets/image/i_ukuran.png")),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    berat + " Kg",
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
