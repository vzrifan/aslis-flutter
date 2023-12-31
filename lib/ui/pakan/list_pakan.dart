import 'package:aslis_application/controller/pakan_controller.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/ui/pakan/detail_pakan.dart';
import 'package:aslis_application/ui/pakan/edit_pakan.dart';
import 'package:aslis_application/ui/pakan/tambah_pakan.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class PakanPage extends StatefulWidget {
  @override
  State<PakanPage> createState() => _PakanPageState();
}

class _PakanPageState extends State<PakanPage> {
  // const PakanPage({Key? key}) : super(key: key);
  final pakan_c = Get.put(PakanController());

  final RefreshController refreshController = RefreshController();

  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      pakan_c.LoadPakan();
    }
    return true;
  }

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
            "Pakan",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TambahPakanPage();
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
                          pakan_c.GetKandang(value);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),

                          hintText: "Cari Pakan",
                          // suffix: Icon(Icons.search),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: pakan_c.GetKandang(""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              BoxListPakanShimer(),
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
                              BoxListPakanShimer(),
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
                              BoxListPakanShimer(),
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
                        } else {
                          return Obx(() => pakan_c.listpakan.length == 0
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Center(
                                      child: Image(
                                          width: 200,
                                          height: 300,
                                          image: AssetImage(
                                              "assets/image/empty_pakan.png")),
                                    ),
                                    Text(
                                      "Anda belum memiliki pakan",
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
                                            return TambahPakanPage();
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
                                              "Tambah Pakan",
                                              style: ThemesCustom.green_16_700,
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
                                    itemCount: pakan_c.listpakan.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          BoxListPakan(
                                            context,
                                            pakan_c.listpakan[index]
                                                ['food_name'],
                                            pakan_c.listpakan[index]
                                                ['category_name'],
                                            pakan_c.listpakan[index]
                                                    ['capital_price']
                                                .toString(),
                                            pakan_c.listpakan[index]['stock']
                                                .toString(),
                                            pakan_c.listpakan[index]
                                                    ['available_stock']
                                                .toString(),
                                            pakan_c.listpakan[index]['id'],
                                            pakan_c.listpakan[index]
                                                    ['is_available'] ??
                                                0,
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
                    ),

                    // BoxListPakan(context),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //     width: double.infinity,
                    //     height: 1,
                    //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // BoxListPakan(context),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //     width: double.infinity,
                    //     height: 1,
                    //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // BoxListPakan(context),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //     width: double.infinity,
                    //     height: 1,
                    //     color: Color.fromRGBO(35, 31, 32, 0.1)),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BoxListPakan(BuildContext ctx, String nama, String jenis, String harga,
      String berat, String ket, String id, int test) {
    return InkWell(
      onTap: () {
        // showModalDetailKandang(ctx);
        Get.off(() => DetailPakan(
              id: id,
            ));
      },
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    nama,
                    style: ThemesCustom.black_14_700,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  test == 0
                      ? Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Habis",
                              style: ThemesCustom.white_12_700,
                            ),
                          ),
                        )
                      : Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromRGBO(69, 181, 73, 0.2)),
                          child: Center(
                            child: Text(
                              "Tersedia: " + ket + " Kg",
                              style: ThemesCustom.green_12_700,
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                jenis,
                style: ThemesCustom.grey_14_400,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    "Rp. " +
                        NumberFormat.decimalPattern().format(int.parse(harga)),
                    style: ThemesCustom.black_12_400,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Image(
                      width: 14,
                      height: 14,
                      image: AssetImage("assets/image/i_ukuran.png")),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Awal: " + berat + " Kg",
                    style: ThemesCustom.black_12_400,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // Image(
                  //     width: 14,
                  //     height: 14,
                  //     image: AssetImage("assets/image/i_ukuran.png")),
                  // SizedBox(
                  //   width: 4,
                  // ),
                  // Text(
                  //   ket.toString() + " Kg",
                  //   style: ThemesCustom.black_12_400,
                  // ),
                ],
              )
            ],
          )),
          IconButton(
              onPressed: () {
                menuModal(id);
              },
              icon: Image(image: AssetImage("assets/image/i_filter2.png")))
          // Container(
          //   width: 70,
          //   height: 30,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: Color.fromRGBO(69, 181, 73, 0.2)),
          //   child: Center(
          //     child: Text(
          //       "Selesai",
          //       style: ThemesCustom.green_12_700,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget BoxListPakanShimer() {
    return InkWell(
      child: Container(
        height: 65,
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: double.infinity,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
                SizedBox(
                  height: 4,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: double.infinity,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
                SizedBox(
                  height: 4,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  period: Duration(seconds: 2),
                  child: Container(
                      width: double.infinity,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          borderRadius: BorderRadius.circular(14))),
                ),
              ],
            )),
            SizedBox(
              width: 10,
            ),
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
            // Container(
            //   width: 70,
            //   height: 30,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(50),
            //       color: Color.fromRGBO(69, 181, 73, 0.2)),
            //   child: Center(
            //     child: Text(
            //       "Selesai",
            //       style: ThemesCustom.green_12_700,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void confirm_delete(String id) {
    // warehouseController w_controller = Get.find();
    final pakan_c = Get.put(PakanController());

    Get.defaultDialog(
        title: 'Hapus Kambing',
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
              child: Text("Apakah anda yakin akan hapus produk?",
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
                      Get.close(0);
                      pakan_c.hapusPakan(id);
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

  void menuModal(
    String id,
  ) {
    Get.defaultDialog(
        title: 'Pilih Menu',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.close(0);
                confirm_delete(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Hapus Pakan",
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
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Get.close(0);
                // confirm_delete(id);
                Get.to(() => EditPakanPage(
                      id: id,
                    ));
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Edit Pakan",
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
          ],
        ),
        radius: 10.0);
  }
}
