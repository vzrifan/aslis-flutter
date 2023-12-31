import 'dart:ffi';

import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/ui/kandang/detail_kandang.dart';
import 'package:aslis_application/ui/kandang/edit_kandang.dart';
import 'package:aslis_application/ui/kandang/tambah_kandang.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class KandangPage extends StatefulWidget {
  @override
  State<KandangPage> createState() => _KandangPageState();
}

class _KandangPageState extends State<KandangPage> {
  // const KandangPage({Key? key}) : super(key: key);
  final kandang_c = Get.put(KandangController());

  final RefreshController refreshController = RefreshController();

  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      kandang_c.LoadGetKandang();
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
            "Kandang",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TambahKandang();
                  }));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: NotificationListener(
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
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextFormField(
                        controller: kandang_c.cari_kandang,
                        onChanged: (val) {
                          print(val);
                          kandang_c.GetKandang(val);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),
                          hintText: "Cari Kandang",
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: kandang_c.GetKandang(""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              BoxKandangShimmer(context),
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
                              BoxKandangShimmer(context),
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
                              BoxKandangShimmer(context),
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
                              BoxKandangShimmer(context),
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
                          return Obx(() => kandang_c.listKandang.length == 0
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
                                              "assets/image/empty_kandang_2.png")),
                                    ),
                                    Text(
                                      "Anda belom mempunyai kandang",
                                      style: ThemesCustom.black1_18_700,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return TambahKandang();
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
                                              "Tambah Kandang",
                                              style: ThemesCustom.green_16_700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Obx(() => ListView.builder(
                                    itemCount: kandang_c.listKandang.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          BoxKandang(
                                            context,
                                            kandang_c.listKandang[index]['id'],
                                            kandang_c.listKandang[index]
                                                    ['shed_name'] ??
                                                "-",
                                            "-",
                                            kandang_c.listKandang[index]
                                                    ['weigth_of_cattle']
                                                .toString(),
                                            kandang_c.listKandang[index]
                                                    ['number_of_cattle'] ??
                                                0,
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: Color.fromRGBO(
                                                  35, 31, 32, 0.1)),
                                          SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      );
                                    },
                                  )));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BoxKambingList(context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return DetailGoatPage();
        // }));
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Color(0xffF2F6FF))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: 64,
                height: 54,
                image: AssetImage("assets/image/kambing.png")),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kambing #A124",
                  style: ThemesCustom.black_14_700,
                ),
                Text(
                  "Kambing Etawa",
                  style: ThemesCustom.black_12_400,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image(
                        width: 14,
                        height: 14,
                        image: AssetImage("assets/image/i_kambing.png")),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Jantan",
                      style: ThemesCustom.black_12_400,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                        width: 14,
                        height: 14,
                        image: AssetImage("assets/image/i_ukuran.png")),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "35 Tahun",
                      style: ThemesCustom.black_12_400,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                        width: 14,
                        height: 14,
                        image: AssetImage("assets/image/i_kalender.png")),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "2 Tahun",
                      style: ThemesCustom.black_12_400,
                    ),
                  ],
                ),
              ],
            )),
            // Image(image: AssetImage("assets/image/i_filter2.png"))
          ],
        ),
      ),
    );
  }

  Widget BoxKandangShimmer(BuildContext ctx) {
    return InkWell(
      onTap: () {
        // showModalDetailKandang(ctx);
      },
      child: Row(
        children: [
          Expanded(
              child: Column(
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
                height: 8,
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
                height: 8,
              ),
              Row(
                children: [
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
                    width: 10,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[400]!,
                    borderRadius: BorderRadius.circular(14))),
          ),
        ],
      ),
    );
  }

  Widget BoxKandang(BuildContext ctx, String id, String nama, String kota,
      String umur, int total) {
    double umurs = double.parse(umur);
    return InkWell(
      onTap: () {
        // showModalDetailKandang(ctx);
        Navigator.push(ctx, MaterialPageRoute(builder: (context) {
          return DetailKandang(
            id: id,
          );
        }));
      },
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Image(
                      width: 14,
                      height: 14,
                      image: AssetImage("assets/image/i_ukuran.png")),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    total.toString() + " Kambing",
                    style: ThemesCustom.black_12_400,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                      width: 14,
                      height: 14,
                      image: AssetImage("assets/image/i_kalender.png")),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    double.parse((umurs).toStringAsFixed(2)).toString() + " Kg",
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              ),
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

  // modal hapus data
  void confirm_delete(String id) {
    // warehouseController w_controller = Get.find();
    KandangController kandang_c = Get.find();

    Get.defaultDialog(
        title: 'Hapus Kandang',
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
              child: Text("Apakah anda yakin akan hapus Kandang ?",
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

                      kandang_c.hapuskandang(id);
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

  void showModalDetailKandang(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) => DraggableScrollableSheet(
            initialChildSize: 1, //set this as you want
            maxChildSize: 1, //set this as you want
            minChildSize: 1, //set this as you want
            expand: true,
            builder: (context, scrollController) {
              RangeValues _currentRangeValues = const RangeValues(40, 80);

              return Padding(
                padding: EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close)),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Detail Kandang",
                                style: ThemesCustom.black_14_700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EdtiKandang();
                              }));
                            },
                            child: Text(
                              "Ubah",
                              style: ThemesCustom.black_14_700,
                            ),
                          )
                        ],
                      ),
                      //  kosong
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Kandang A",
                        style: ThemesCustom.black1_18_700,
                      ),
                      Text(
                        "#12848884",
                        style: ThemesCustom.black_11_700_07,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        "Dusun Plaosan RT 01 RW 01 Desa, Area Sawah/Kebun, Sambilawang, Kec. Dlanggu, Mojokerto, Jawa Timur",
                        style: ThemesCustom.black_14_400,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: double.infinity,
                          height: 7,
                          color: Color(0xffF2F6FF)),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Cari Catatan",
                              // suffix: Icon(Icons.search),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              // showModal(context);
                            },
                            child: Container(
                              width: 42,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(35, 31, 32, 0.16))),
                              child: Image(
                                  width: 10,
                                  height: 10,
                                  image: AssetImage("assets/image/filter.png")),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      BoxKambingList(context),
                      SizedBox(
                        height: 20,
                      ),
                      BoxKambingList(context),
                      SizedBox(
                        height: 20,
                      ),
                      BoxKambingList(context),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ); //whatever you're returning, does not have to be a Container
            }));
  }
}
