import 'dart:convert';

import 'package:aslis_application/controller/pakan_controller.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/model/model_kategori_makanan.dart';
import 'package:aslis_application/ui/beriPakan/beri_pakan.dart';
import 'package:aslis_application/ui/beriPakan/detail_beri_pakan.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/ui/pakan/tambah_pakan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ListFeed extends StatefulWidget {
  @override
  State<ListFeed> createState() => _ListFeedState();
}

class _ListFeedState extends State<ListFeed> {
  // const ListFeed({Key? key}) : super(key: key);

  final RefreshController refreshController = RefreshController();

  final pakan_c = Get.put(PakanController());

  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      pakan_c.LoadRiwayatPakan();
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
            "Riwayat Pakan",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  // showModalPindahKandang(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BeriPakan();
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
                        controller: pakan_c.cari_pakan_riwayat,
                        onChanged: (value) {
                          pakan_c.getRiwayatPakan(value);
                        },
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
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    FutureBuilder(
                      future: pakan_c.getRiwayatPakan(""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              boxShimer(),
                              SizedBox(
                                height: 20,
                              ),
                              boxShimer(),
                              SizedBox(
                                height: 20,
                              ),
                              boxShimer(),
                            ],
                          );
                        } else {
                          return Obx(() => pakan_c.listriwayat.length == 0
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
                                              "assets/image/empty.png")),
                                    ),
                                    Text(
                                      "Anda belum memiliki riwayat pakan",
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
                                            return BeriPakan();
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
                                              "Beri Makan",
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
                                    itemCount: pakan_c.listriwayat.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          BoxListPakan(
                                            context,
                                            pakan_c.listriwayat[index]
                                                    ['food_name'] ??
                                                "",
                                            pakan_c.listriwayat[index]
                                                    ['shed_name'] ??
                                                "",
                                            pakan_c.listriwayat[index]
                                                    ['date'] ??
                                                "",
                                            pakan_c.listriwayat[index]
                                                    ['price'] ??
                                                "",
                                            pakan_c.listriwayat[index]
                                                    ['weigth'] ??
                                                "",
                                            pakan_c.listriwayat[index]['id'] ??
                                                "",
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

  Widget BoxListPakan(BuildContext ctx, String nama, String jenis,
      String tanggal, String harga, String berat, String id) {
    if (harga == "") {
      harga = "0";
    }
    return InkWell(
      onTap: () {
        // showModalDetailKandang(ctx);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PageRiwayatMakanKambingByPakan(
            id: id,
          );
        }));
      },
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                tanggal,
                style: ThemesCustom.grey_12_400_italic,
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
                  // Text(
                  //   "Rp. " + harga,
                  //   style: ThemesCustom.black_12_400,
                  // ),
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
                    berat + " Kg",
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              )
            ],
          )),
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(69, 181, 73, 0.2)),
            child: Center(
              child: Text(
                "Selesai",
                style: ThemesCustom.green_12_700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showModalPindahKandang(ctx) {
    final box = GetStorage();

    showModalBottomSheet(
        context: ctx,
        builder: (ctx) => Container(
              // height: 200,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(ctx);
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Pakan",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      DropdownSearch<KategoriMakananModel>(
                        validator: (value) {
                          if (value == null) {
                            return 'Jenis Pakan tidak valid';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        asyncItems: (text) async {
                          var uri_api =
                              Uri.parse(ApiService.baseUrl + "/get_data/food");
                          var is_token = "Bearer " + box.read("token");
                          var respone = await http.get(uri_api,
                              headers: {"Authorization": is_token});
                          print(json.decode(respone.body));
                          // var data = json.decode(respone.body);
                          var data =
                              json.decode(respone.body) as Map<String, dynamic>;
                          var dataProvince = data['data'] as List<dynamic>;
                          var model =
                              KategoriMakananModel.fromJsonList(dataProvince);
                          return model;
                        },
                        onChanged: (value) {
                          if (value != null) {
                            // pakan_c.jenis_pakan.value = value.id;
                            // setState(() {});
                            // setState(() {
                            // warehouse_c.id_provinsi.value = value.id.toString();
                            // warehouse_c.id_kota.value = "";
                            // });
                          }
                        },
                        itemAsString: (item) => item!.foodName,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text("${item.foodName}"),
                            );
                          },
                        ),
                      ),

                      // InputDecorator(
                      //   decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 1, horizontal: 20),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8))),
                      //   child: DropdownButtonHideUnderline(
                      //       child: DropdownButtonFormField<String>(
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Jenis Kelamin Boleh Kosong';
                      //       }
                      //       return null;
                      //     },
                      //     hint: Text("Jenis Kelamin",
                      //         style: GoogleFonts.montserrat(
                      //             fontSize: 12,
                      //             color: Color(0xff999999),
                      //             fontWeight: FontWeight.bold)),
                      //     items: <String>[
                      //       'Pilih Jenis Kelaim',
                      //       'Laki Laki',
                      //       'Perempuan'
                      //     ].map((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList(),
                      //     onChanged: (select) {
                      //       print(select);
                      //     },
                      //   )),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Kandang",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      DropdownSearch<KandangModel>(
                        validator: (value) {
                          if (value == null) {
                            return 'Kandang tidak valid';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        asyncItems: (text) async {
                          var uri_api =
                              Uri.parse(ApiService.baseUrl + "/get_data/shed");
                          var is_token = "Bearer " + box.read("token");
                          var respone = await http.get(uri_api,
                              headers: {"Authorization": is_token});
                          print(json.decode(respone.body));
                          // var data = json.decode(respone.body);
                          var data =
                              json.decode(respone.body) as Map<String, dynamic>;
                          var dataProvince = data['data'] as List<dynamic>;
                          var model = KandangModel.fromJsonList(dataProvince);
                          return model;
                        },
                        onChanged: (value) {
                          if (value != null) {
                            // muhib
                            // kandang_c.kandang.value = value.id;
                          }
                        },
                        itemAsString: (item) => item!.shedName,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text("${item.shedName}"),
                            );
                          },
                        ),
                      ),
                      // InputDecorator(
                      //   decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 1, horizontal: 20),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8))),
                      //   child: DropdownButtonHideUnderline(
                      //       child: DropdownButtonFormField<String>(
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Jenis Kelamin Boleh Kosong';
                      //       }
                      //       return null;
                      //     },
                      //     hint: Text("Jenis Kelamin",
                      //         style: GoogleFonts.montserrat(
                      //             fontSize: 12,
                      //             color: Color(0xff999999),
                      //             fontWeight: FontWeight.bold)),
                      //     items: <String>[
                      //       'Pilih Jenis Kelaim',
                      //       'Laki Laki',
                      //       'Perempuan'
                      //     ].map((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList(),
                      //     onChanged: (select) {
                      //       print(select);
                      //     },
                      //   )),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Tanggal",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'Peternak tidak valid';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0XFF71A841), width: 2.0),
                            ),
                            hintText: "Contoh : Peternakan ABC",
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Berat",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'Peternak tidak valid';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0XFF71A841), width: 2.0),
                            ),
                            hintText: "Contoh : Peternakan ABC",
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return HomePage();
                          // }));
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                              color: Color(0xff45B549),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Beri Pakan",
                              style: ThemesCustom.white_16_700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget boxShimer() {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 100,
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
                SizedBox(
                  height: 5,
                ),
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
                      width: double.infinity,
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

  Row ListRiwayatPakan() {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            "5 Kg",
            style: ThemesCustom.black_13_700,
          ),
        ),
        Expanded(
            child: Container(
          width: 100,
          child: Text(
            "Kandang A",
            style: ThemesCustom.black_13_700,
          ),
        )),
        Text(
          "12 Mei 2022 15:20",
          style: ThemesCustom.black_13_400,
        ),
      ],
    );
  }
}
