import 'package:aslis_application/controller/catatberat_controller.dart';
import 'package:aslis_application/ui/CatatanBerat/add_weight.dart';
import 'package:aslis_application/ui/CatatanBerat/edit_weight.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class WeightPage extends StatefulWidget {
  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  // const WeightPage({Key? key}) : super(key: key);
  final cb_controller = Get.put(CatatBeratController());

  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      // kandang_c.loadHewan();
      cb_controller.loadData();
    }
    return true;
  }

  final RefreshController refreshController = RefreshController();

  @override
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
            "Catat Berat",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddWeightPage();
                  }));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(18),
          child: NotificationListener(
            onNotification: onNotificatin,
            child: SmartRefresher(
              enablePullUp: false,
              controller: refreshController,
              onRefresh: () {
                print("Oke");
                setState(() {});
                refreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                  controller: _scrolC,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          print("Nok");
                          cb_controller.getData(value);
                        },
                        controller: cb_controller.cari,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),
                          hintText: "Cari",
                          // suffix: Icon(Icons.search),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FutureBuilder(
                        future: cb_controller.getData(""),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                boxShimer(),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Color.fromRGBO(35, 31, 32, 0.1)),
                                SizedBox(
                                  height: 14,
                                ),
                                boxShimer(),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Color.fromRGBO(35, 31, 32, 0.1)),
                                SizedBox(
                                  height: 14,
                                ),
                                boxShimer(),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Color.fromRGBO(35, 31, 32, 0.1)),
                                SizedBox(
                                  height: 14,
                                ),
                                boxShimer(),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Color.fromRGBO(35, 31, 32, 0.1)),
                                SizedBox(
                                  height: 14,
                                ),
                              ],
                            );
                          } else {
                            return Obx(() => cb_controller.list_berat.length ==
                                    0
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      Image(
                                          width: 200,
                                          height: 300,
                                          image: AssetImage(
                                              "assets/image/empty.png")),
                                      Text(
                                        "Anda belum memiliki catat berat",
                                        style: ThemesCustom.black_18_700,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return AddWeightPage();
                                            }));
                                          },
                                          child: Container(
                                            height: 44,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color(0xff45B549),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Center(
                                              child: Text(
                                                "Catat Berat",
                                                style:
                                                    ThemesCustom.green_16_700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Obx(() => ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          cb_controller.list_berat.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ListBerat(
                                              cb_controller.list_berat[index]
                                                  ['id'],
                                              cb_controller.list_berat[index]
                                                  ['date'],
                                              cb_controller.list_berat[index]
                                                  ['shed_name'],
                                              cb_controller.list_berat[index]
                                                      ['total_weigth']
                                                  .toString(),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: double.infinity,
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    35, 31, 32, 0.1)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      },
                                    )));
                          }
                        },
                      )

                      // ListBerat(),
                      // SizedBox(
                      //   height: 14,
                      // ),
                      // Container(
                      //     width: double.infinity,
                      //     height: 1,
                      //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                      // SizedBox(
                      //   height: 14,
                      // ),
                      // ListBerat(),
                      // SizedBox(
                      //   height: 14,
                      // ),
                      // Container(
                      //     width: double.infinity,
                      //     height: 1,
                      //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                      // SizedBox(
                      //   height: 14,
                      // ),
                      // ListBerat(),
                      // SizedBox(
                      //   height: 14,
                      // ),
                      // Container(
                      //     width: double.infinity,
                      //     height: 1,
                      //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                      // SizedBox(
                      //   height: 14,
                      // ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void confirm_delete(String id) {
    // warehouseController w_controller = Get.find();
    CatatBeratController cb_controller = Get.find();

    Get.defaultDialog(
        title: 'Catatan Berat',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, bottom: 10),
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Center(
              child: Text("Apakah anda yakin akan hapus Catatan?",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.normal)),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.close(0);
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Tidak",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffffffff)),
                      )),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // w_controller.hapus(id);
                      Get.close(0);
                      cb_controller.hapusCatat(id);
                      // up_controller.hapusProduk(id);
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Ya",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffffffff)),
                      )),
                      decoration: BoxDecoration(
                        color: Color(0xff019905),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        radius: 10.0);
  }

  Widget boxShimer() {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Color(0xffF2F6FF))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
                SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
                SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
              ],
            )),
            // menuModal
            Shimmer.fromColors(
              baseColor: Colors.grey[500]!,
              highlightColor: Colors.grey[300]!,
              period: Duration(seconds: 2),
              child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey[400]!,
                      borderRadius: BorderRadius.circular(14))),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListBerat(String id, String date, String kandang, String umur) {
    return InkWell(
      onTap: () {
        Get.to(() => EditWeightPage(
              id: id,
            ));

        // EditWeightPage()
      },
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kandang,
                maxLines: 1,
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                date,
                style: ThemesCustom.grey_12_400_italic,
              ),

              // Row(
              //   children: [
              //     Image(
              //         width: 14,
              //         height: 14,
              //         image: AssetImage("assets/image/i_ukuran.png")),
              //     SizedBox(
              //       width: 4,
              //     ),
              //     Text(
              //       umur.toString() + " Kg",
              //       style: ThemesCustom.black_12_400,
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //   ],
              // )
            ],
          )),
          IconButton(
              onPressed: () {
                confirm_delete(id);
              },
              icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
