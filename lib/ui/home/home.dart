import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/controller/home_controller.dart';
import 'package:aslis_application/ui/CatatanBerat/weight_page.dart';
import 'package:aslis_application/ui/Noted_page/note.dart';
import 'package:aslis_application/ui/beriPakan/beri_pakan.dart';
import 'package:aslis_application/ui/beriPakan/list_%20feed.dart';
import 'package:aslis_application/ui/device/add_device.dart';
import 'package:aslis_application/ui/device/list_device.dart';
import 'package:aslis_application/ui/kambing/kambing_tab.dart';
import 'package:aslis_application/ui/kambing/list_kambing.dart';
import 'package:aslis_application/ui/kandang/kandang_list.dart';
import 'package:aslis_application/ui/laporan/laporan_page.dart';
import 'package:aslis_application/ui/notifikasi/list_notifikasi.dart';
import 'package:aslis_application/ui/pakan/list_pakan.dart';
import 'package:aslis_application/ui/profile/profile.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({Key? key}) : super(key: key);
  final home_c = Get.put(HomeController());
  final kambing_c = Get.put(KambingController());
  final box = GetStorage();
  final RefreshController refreshController = RefreshController();

  String getCurrentMonthAndYear() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM yyyy');
    return formatter.format(now);
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.DEFAULT)!
        .listen(
      (event) {
        // print(event);

        kambing_c.search_qr(event);
      },
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        false,
        ScanMode.QR,
      );
      kambing_c.search_hewan_qr.value = barcodeScanRes;
      kambing_c.search_qr(barcodeScanRes);
      print("Your Barcode Is" + barcodeScanRes);

      // konek api
      // var is_token = "Bearer " + box.read("token");
      // var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/detail");
      // var response = await http.post(uri_api,
      //     body: {"id": barcodeScanRes}, headers: {"Authorization": is_token});
      // var data_respone = json.decode(response.body)['data'];
      // print(data_respone);
      // if (response.statusCode == 200) {
      //   print("Berhasil");
      //   Fluttertoast.showToast(
      //     msg: "QrCode  Valid", // message
      //     toastLength: Toast.LENGTH_SHORT, // length
      //     gravity: ToastGravity.BOTTOM, // location
      //   );
      // } else {
      //   print("gagal pages");
      //   Fluttertoast.showToast(
      //     msg: "QrCode Tidak Valid", // message
      //     toastLength: Toast.LENGTH_SHORT, // length
      //     gravity: ToastGravity.BOTTOM, // location
      //   );
      // }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print("Oke");

    // setState(() {
    //   // _scanBarcode = barcodeScanRes;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: SmartRefresher(
          enablePullUp: false,
          controller: refreshController,
          onRefresh: () {
            print("Oke");
            setState(() {});
            refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  flexibleSpace: Container(
                    width: double.infinity,
                    height: 290,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Image(
                            image: AssetImage("assets/image/banner_home.png")),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                  width: 42,
                                  height: 42,
                                  image: AssetImage(
                                      "assets/image/logo_putih.png")),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfilePage();
                                  }));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selamat Datang",
                                      style: ThemesCustom.white_14_400,
                                    ),
                                    FutureBuilder(
                                      future: home_c.getData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            "-",
                                            style: ThemesCustom.white_20_700,
                                          );
                                        } else {
                                          return Text(
                                            home_c.nama_user.value,
                                            style: ThemesCustom.white_20_700,
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )),
                              // IconButton(
                              //     onPressed: () {
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) {
                              //         return NotifikasiPage();
                              //       }));
                              //     },
                              //     icon: Image(
                              //         image:
                              //             AssetImage("assets/image/notif.png")))
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 18, right: 18, top: 120),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            width: double.infinity,
                            height: 155,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(11, 39, 111, 0.08),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(230, 233, 239, 0.5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                      "Dashboard" +
                                          kambing_c.search_hewan_qr.value,
                                      style: ThemesCustom.black_11_600_07,
                                    )),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Periode: ${getCurrentMonthAndYear()}",
                                  style: ThemesCustom.black_10_400_07,
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Ternak",
                                          style: ThemesCustom.black_11_400_07,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Obx(() => Text(
                                              home_c.total_ternak.value,
                                              style: ThemesCustom.black_21_500,
                                            )),
                                        SizedBox(
                                          height: 14,
                                        ),

                                        // int.parse( double.parse((12.3412).toStringAsFixed(2)) home_c
                                        //             .persen_total_ternak.value) <
                                        //         0

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Obx(() => double.parse((home_c
                                                            .persen_total_ternak
                                                            .value))
                                                        .floor() <
                                                    0
                                                // int.parse(home_c
                                                //       .persen_total_ternak
                                                //       .value) <
                                                //   0
                                                ? Text(
                                                    double.parse((home_c
                                                                .persen_total_ternak
                                                                .value))
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .red_09_500_05,
                                                  )
                                                : Text(
                                                    double.parse((home_c
                                                                .persen_total_ternak
                                                                .value))
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .green_09_500_05,
                                                  )),
                                            Text(
                                              " dari bulan lalu",
                                              style:
                                                  ThemesCustom.black_09_500_05,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Growth",
                                          style: ThemesCustom.black_11_400_07,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Obx(() => Text(
                                              home_c.growth.value,
                                              style: ThemesCustom.black_21_500,
                                            )),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Obx(() => double.parse(home_c
                                                            .persen_growth
                                                            .value)
                                                        .floor() <
                                                    0
                                                ? Text(
                                                    double.parse(home_c
                                                                .persen_growth
                                                                .value)
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .red_09_500_05,
                                                  )
                                                : Text(
                                                    double.parse(home_c
                                                                .persen_growth
                                                                .value)
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .green_09_500_05,
                                                  )),
                                            Text(
                                              " dari bulan lalu",
                                              style:
                                                  ThemesCustom.black_09_500_05,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Berat",
                                          style: ThemesCustom.black_11_400_07,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Obx(() => Text(
                                              double.parse((home_c.berat_double
                                                              .value)
                                                          .toStringAsFixed(2))
                                                      .toString() +
                                                  " Kg",
                                              style: ThemesCustom.black_21_500,
                                            )),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Obx(() => double.parse(home_c
                                                            .persen_berat.value)
                                                        .floor() <
                                                    0
                                                ? Text(
                                                    double.parse(home_c
                                                                .persen_berat
                                                                .value)
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .red_09_500_05,
                                                  )
                                                : Text(
                                                    double.parse(home_c
                                                                .persen_berat
                                                                .value)
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    style: ThemesCustom
                                                        .green_09_500_05,
                                                  )),
                                            Text(
                                              " dari bulan lalu",
                                              style:
                                                  ThemesCustom.black_09_500_05,
                                            )
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BeriPakan();
                          }));
                        },
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                              color: Color(0xffEF9218),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  width: 16,
                                  height: 16,
                                  image:
                                      AssetImage("assets/image/i_pakan.png")),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Beri Pakan",
                                style: ThemesCustom.white_12_700,
                              )
                            ],
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WeightPage();
                          }));
                        },
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                              color: Color(0xffEDAA24),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  width: 16,
                                  height: 16,
                                  image:
                                      AssetImage("assets/image/i_catat.png")),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Catat Berat",
                                style: ThemesCustom.white_12_700,
                              )
                            ],
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          // startBarcodeScanStream();

                          scanQR();

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return WeightPage();
                          // }));
                        },
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                              color: Color(0xffA34C3E),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  width: 16,
                                  height: 16,
                                  color: Colors.white,
                                  image: AssetImage("assets/image/i_scan.png")),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cari Ternak",
                                    style: ThemesCustom.white_12_700,
                                  ),
                                  Text(
                                    "QrCode",
                                    style: ThemesCustom.white_08_300,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  width: double.infinity,
                  height: 7,
                  color: Color(0xffF2F6FF),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Text(
                    "Tools",
                    style: ThemesCustom.black_18_700,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          // return ListGoat();
                          return TabKambingPage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/ternak.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Ternak",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return KandangPage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/kandang.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Kandang",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PakanPage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/pakan.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Pakan",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NotePage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/catatan.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Catatan",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ListFeed();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image:
                                  AssetImage("assets/image/riwayat_pakan.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Riwayat Pakan",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LaporanPage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/laporan.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Laporan",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DevicePage();
                        }));
                      },
                      child: Column(
                        children: [
                          Image(
                              width: 75,
                              height: 75,
                              image: AssetImage("assets/image/aslis.png")),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Aslis",
                            style: ThemesCustom.black_14_400,
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        // Image(
                        //     width: 75,
                        //     height: 75,
                        //     image: AssetImage("assets/image/aslis.png")),
                        // SizedBox(
                        //   height: 14,
                        // ),
                        // Text(
                        //   "Aslis",
                        //   style: ThemesCustom.black_14_400,
                        // )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [],
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
