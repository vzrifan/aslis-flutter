import 'dart:convert';

import 'package:aslis_application/controller/pakan_controller.dart';
import 'package:aslis_application/model/model_detail_pakan.dart';
import 'package:aslis_application/ui/beriPakan/beri_pakan.dart';
import 'package:aslis_application/ui/pakan/list_pakan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DetailPakan extends StatefulWidget {
  // const DetailPakan({Key? key}) : super(key: key);
  var id;
  DetailPakan({required this.id});

  @override
  _DetailPakanState createState() => _DetailPakanState();
}

class _DetailPakanState extends State<DetailPakan> {
  late DetailPakanModel m_pakan;
  final box = GetStorage();
  final pakan_c = Get.put(PakanController());

  Future getDetailPakan() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/detail");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api,
          body: {"id": widget.id}, headers: {"Authorization": is_token});
      var data = json.decode(response.body)['data'];
      print(data.toString());
      if (response.statusCode == 200) {
        // nama_kandang = data['shed_name'];
        m_pakan = DetailPakanModel.fromJson(data);
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
      // kambing_c.PaginategetListRiwayatMakan(widget.id);
      pakan_c.LoadRiwayatPakanByKategori(widget.id);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PakanPage();
                    }));
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
              // InkWell(
              //   onTap: () {
              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (context) {
              //     //   return EdtiKandang();
              //     // }));
              //   },
              //   child: Image(
              //       width: 20,
              //       height: 20,
              //       image: AssetImage("assets/image/filter.png")),
              // )
            ],
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: onNotificatin,
        child: SingleChildScrollView(
          controller: _scrolC,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getDetailPakan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(top: 20),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.green,
                                  strokeWidth: 10,
                                )),
                          ),
                        ],
                      );
                    } else {
                      // hitung
                      double percent = 0.0;

                      // double total = (int.parse(m_pakan.stock) -
                      //         int.parse(m_pakan.availableStock)) /
                      //     int.parse(m_pakan.stock);

                      double total = double.parse(m_pakan.total);

                      // if (total == 0.0) {
                      //   percent = (int.parse(m_pakan.stock) -
                      //           int.parse(m_pakan.availableStock)) /
                      //       int.parse(m_pakan.stock);
                      // } else {
                      //   percent = (int.parse(m_pakan.stock) -
                      //               int.parse(m_pakan.availableStock)) /
                      //           int.parse(m_pakan.stock) -
                      //       1.0;
                      // }

                      // int total_stok = int.parse(m_pakan.stock) -
                      //     int.parse(m_pakan.availableStock);

                      // int total_stok = double.parse(m_pakan.total_stock);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m_pakan.foodName,
                                    style: ThemesCustom.black_14_700,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    m_pakan.categoryName,
                                    style: ThemesCustom.grey_14_400,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    m_pakan.date,
                                    style: ThemesCustom.grey_14_400,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   "Rp. " +
                                      //       NumberFormat.decimalPattern().format(
                                      //           int.parse(m_pakan.capitalPrice)),
                                      //   style: ThemesCustom.black_12_400,
                                      // ),

                                      Image(
                                          width: 14,
                                          height: 14,
                                          image: AssetImage(
                                              "assets/image/i_ukuran.png")),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        m_pakan.stock + " Kg",
                                        style: ThemesCustom.black_12_400,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 19,
                                  ),
                                  m_pakan.is_available == 1
                                      ? Container(
                                          width: 150,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  69, 181, 73, 0.2)),
                                          child: Center(
                                            child: Text(
                                              "Tersedia: " +
                                                  m_pakan.availableStock +
                                                  " Kg",
                                              style: ThemesCustom.green_12_700,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Pakan Habis",
                                              style: ThemesCustom.white_12_700,
                                            ),
                                          ),
                                        )
                                ],
                              )),
                              Container(
                                height: 160,
                                width: 1,
                                color: Color(0xffF2F6FF),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  new CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 10,
                                    percent: total,
                                    // arcBackgroundColor: Colors.red,
                                    center: Text("Stok Pakan"),

                                    // Column(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   children: [
                                    //     //  Text(m_pakan.total_stock +
                                    //     //     " / " +
                                    //     //     m_pakan.stock +
                                    //     //     " Kg"),
                                    //     Text(m_pakan.total_stock + " / "),
                                    //     Text(m_pakan.stock + " Kg"),
                                    //   ],
                                    // ),
                                    progressColor: Colors.blueGrey,
                                    backgroundColor: Colors.green,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // "Stok Pakan",
                                    m_pakan.total_stock +
                                        " / " +
                                        m_pakan.stock +
                                        " Kg",
                                    style: ThemesCustom.black_14_700,
                                  ),
                                  // Image(
                                  //     width: 144,
                                  //     height: 144,
                                  //     image:
                                  //         AssetImage("assets/image/funding.png"))
                                ],
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: double.infinity,
                              height: 7,
                              color: Color(0xffF2F6FF)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Riwayat Pakan",
                            style: ThemesCustom.black_14_700,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                            future:
                                pakan_c.getRiwayatPakanBykategori(widget.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else {
                                return pakan_c.listriwayat_by.length == 0
                                    ? Column(
                                        children: [
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
                                                        color:
                                                            Color(0xff45B549),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Center(
                                                  child: Text(
                                                    "Beri Pakan",
                                                    style: ThemesCustom
                                                        .green_16_700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Obx(() => ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              pakan_c.listriwayat_by.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                ListRiwayatPakan(
                                                    pakan_c.listriwayat_by[
                                                        index]['weigth'],
                                                    pakan_c.listriwayat_by[
                                                        index]['cattle_name'],
                                                    pakan_c.listriwayat_by[
                                                        index]['date'],
                                                    pakan_c.listriwayat_by[
                                                        index]['shed_name']),
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
                                        ));
                              }
                            },
                          )
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListRiwayatPakan(
      String berat, String nama, String tanggal, String kandang) {
    return Row(
      children: [
        Text(
          tanggal,
          style: ThemesCustom.black_13_400,
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama,
              style: ThemesCustom.black_13_700,
            ),
            Text(
              kandang,
              style: ThemesCustom.black_13_400,
            ),
          ],
        )),
        Container(
          width: 100,
          child: Text(
            berat + " Kg",
            textAlign: TextAlign.right,
            style: ThemesCustom.black_13_700,
          ),
        ),
      ],
    );
  }
}
