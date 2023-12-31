import 'dart:convert';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/ui/kambing/tambah_kambing.dart';
import 'package:aslis_application/ui/kandang/edit_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../../model/model_detail_kandang.dart';

class DetailKandang extends StatefulWidget {
  // const DetailKandang({Key? key}) : super(key: key);
  var id;
  DetailKandang({required this.id});

  @override
  _DetailKandangState createState() => _DetailKandangState();
}

class _DetailKandangState extends State<DetailKandang> {
  late DetailKandangModel detailk;
  KandangController kandang_c = Get.find();
  final kambing_c = Get.put(KambingController());

  final box = GetStorage();
  String nama_kandang = "";

  String harga = "";
  String jarak = "";

  Future getDetailKandang() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/detail");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api,
          body: {"id": widget.id}, headers: {"Authorization": is_token});
      var data = json.decode(response.body)['data'];
      print(data);
      if (response.statusCode == 200) {
        print("test" + data['province'].toString());
        // nama_kandang = data['shed_name'];
        detailk = DetailKandangModel.fromJson(data);
        kandang_c.nama_kandang_u.text = data['shed_name'];
        kandang_c.id_kandang_u.text = data['shed_id'];
        kandang_c.alamat_kandang_u.text = data['address'];
        kandang_c.kapasitas_kandang_u.text = data['capacity'].toString();
        kandang_c.id_provinsi_u.value = data['id_province'];
        kandang_c.id_kota_u.value = data['id_city'];
        kandang_c.name_provinsi_u.value = data['province'];
        kandang_c.name_kota_u.value = data['city'];
        kandang_c.kandang_id.value = data['id'];
        harga = data['delivery_fee'] ?? "";
        jarak = data['maximum_distance'].toString();
        if (harga != "") {
          kandang_c.harga_pengiriman_u.text =
              NumberFormat.decimalPattern().format(int.parse(harga));
        } else {
          kandang_c.harga_pengiriman_u.text = "";
        }

        if (jarak == "null") {
          kandang_c.jarak_pengiriman_u.text = "";
        } else {
          kandang_c.jarak_pengiriman_u.text = jarak;
        }
      } else {
        print("Not Good");
      }
    } catch (e) {
      print(e);
    }
  }

  ScrollController _scrolC = new ScrollController();
  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      // kandang_c.PaginatelistHewanKandang();
      kambing_c.PaginatelistHewanKandang(widget.id, "");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Container(
            height: 100,
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
                      "Detail Kandang ",
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
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: onNotificatin,
        child: SingleChildScrollView(
          controller: _scrolC,
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getDetailKandang(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
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
                            height: 5,
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
                            height: 10,
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
                            height: 5,
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
                            height: 10,
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
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            detailk.shedName,
                            style: ThemesCustom.black1_18_700,
                          ),
                          Text(
                            detailk.shedId,
                            style: ThemesCustom.black_11_700_07,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            detailk.address +
                                " " +
                                detailk.city +
                                " " +
                                detailk.province,
                            style: ThemesCustom.black_14_400,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Image(
                                  width: 14,
                                  height: 14,
                                  image:
                                      AssetImage("assets/image/i_kambing.png")),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                detailk.numberOfCattle.toString() + " Ekor",
                                style: ThemesCustom.black_12_400,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image(
                                  width: 14,
                                  height: 14,
                                  image:
                                      AssetImage("assets/image/i_ukuran.png")),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                detailk.weigthOfCattle.toString() + " Kg",
                                style: ThemesCustom.black_12_400,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    }
                  },
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
                          onChanged: (value) {
                            kambing_c.listHewanKandang(widget.id, value);
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0XFF71A841), width: 2.0),
                            ),
                            hintText: "Cari Kambing",

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
                    // InkWell(
                    //   onTap: () {
                    //     // showModal(context);
                    //   },
                    //   child: Container(
                    //     width: 42,
                    //     height: 50,
                    //     padding: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         border: Border.all(
                    //             width: 1.5,
                    //             color: Color.fromRGBO(35, 31, 32, 0.16))),
                    //     child: Image(
                    //         width: 10,
                    //         height: 10,
                    //         image: AssetImage("assets/image/filter.png")),
                    //   ),
                    // )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                FutureBuilder(
                  future: kambing_c.listHewanKandang(widget.id, ""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return Obx(() => kambing_c.listKambing_kandang.length == 0
                          ? Column(
                              children: [
                                Center(
                                  child: Image(
                                      width: 200,
                                      height: 300,
                                      image: AssetImage(
                                          "assets/image/empty_ternak.png")),
                                ),
                                Text(
                                  "Anda Belum Memiliki Kambing",
                                  style: ThemesCustom.black_18_700,
                                ),
                                InkWell(
                                  onTap: () {
                                    // login_c.sendLogin();
                                    // kandang_c.tambah_kandang();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AddGoat();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2,
                                              color: Color(0xff45B549)),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: Text(
                                          "Tambah Hewan",
                                          style: ThemesCustom.green_16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Obx(() => ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: kambing_c.listKambing_kandang.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      BoxKambing(
                                        context,
                                        kambing_c.listKambing_kandang[index]
                                                ['cattle_name'] ??
                                            "",
                                        kambing_c.listKambing_kandang[index]
                                                ['category'] ??
                                            "",
                                        kambing_c.listKambing_kandang[index]
                                                ['gender'] ??
                                            1,
                                        kambing_c.listKambing_kandang[index]
                                                ['weigth'] ??
                                            "",
                                        kambing_c.listKambing_kandang[index]
                                                ['age'] ??
                                            "",
                                        kambing_c.listKambing_kandang[index]
                                                ['id'] ??
                                            "",
                                        kambing_c.listKambing_kandang[index]
                                                ['photo'] ??
                                            "",
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                },
                              )));
                    }
                  },
                )

                // BoxKambingList(context),
                // SizedBox(
                //   height: 20,
                // ),
                // BoxKambingList(context),
                // SizedBox(
                //   height: 20,
                // ),
                // BoxKambingList(context),
                // SizedBox(
                //   height: 20,
                // ),
              ],
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
}

Widget BoxKambing(context, String nama, String kategori, int jk, String berat,
    String umur, String id, String foto) {
  return InkWell(
    onTap: () {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return DetailGoatPage(
      //     id: id,
      //   );
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
          foto == ""
              ? Image(
                  width: 64,
                  height: 54,
                  image: AssetImage("assets/image/kambing.png"))
              : Image(
                  width: 64,
                  height: 54,
                  image: CachedNetworkImageProvider(foto)),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: ThemesCustom.black_14_700,
              ),
              Text(
                kategori,
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
                    jk == 1 ? "Jantan" : "Betina",
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
                    berat + " Kg",
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
                    "0 Tahun",
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              ),
            ],
          )),
          // menuModal
          // IconButton(
          //     onPressed: () {
          //       menuModal(id);
          //     },
          //     icon: Image(image: AssetImage("assets/image/i_filter2.png")))
        ],
      ),
    ),
  );
}
