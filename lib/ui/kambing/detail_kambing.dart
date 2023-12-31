import 'dart:convert';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/model/model_kambing_detail.dart';
import 'package:aslis_application/ui/CatatanBerat/add_weight_by_cattle.dart';
import 'package:aslis_application/ui/Noted_page/note_by_cattle.dart';
import 'package:aslis_application/ui/kambing/edit_kambing.dart';
import 'package:aslis_application/ui/kambing/pindah_kandang.dart';
import 'package:aslis_application/ui/kambing/player_video.dart';
import 'package:aslis_application/ui/kambing/riwayat_berat.dart';
import 'package:aslis_application/ui/kambing/riwayat_makan.dart';
import 'package:aslis_application/ui/kambing/riwayat_pindah_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailGoatPage extends StatefulWidget {
  // const DetailGoatPage({Key? key}) : super(key: key);
  var id;
  DetailGoatPage({required this.id});

  @override
  State<DetailGoatPage> createState() => _DetailGoatPageState();
}

class _DetailGoatPageState extends State<DetailGoatPage> {
  final box = GetStorage();
  late DetailKambingModel d_kandang_model;
  KambingController kambing_c = Get.find();

  late List<SalesData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  var id_problem = "";
  String id_kandang = "";
  String waktu = "";

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<_SalesData> data_gr = [];

  // // cara ke dua
  // List<_SalesData> data = [
  //   _SalesData('Jan', 35),
  //   _SalesData('Feb', 28),
  //   // _SalesData('Mar', 34),
  //   // _SalesData('Apr', 32),
  //   // _SalesData('May', 40)
  // ];

// data.add(_SalesData('Jan', 35))

  List<SalesData> getChartData() {
    final List<SalesData> chartData = [
      SalesData("mei", 25),
      SalesData("Juni", 12),
      SalesData("Juli", 24),
      SalesData("Agustus", 18),
      SalesData("Desember", 30)
    ];
    return chartData;
  }

  Future getData() async {
    try {
      print("Jalan");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/detail");
      var response = await http.post(uri_api,
          body: {"id": widget.id}, headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body)['data'];
      print(data_respone);
      if (response.statusCode == 200) {
        // print("muhib " + data_respone['is_editable'].toString());
        d_kandang_model = DetailKambingModel.fromJson(data_respone);
        id_problem = data_respone['id_problem'];
        id_kandang = data_respone['id_kandang'];
        waktu = data_respone['date_last_weigth'];
        kambing_c.is_editable.value = data_respone['is_editable'].toString();
        kambing_c.foto_u.value = "";
        kambing_c.foto_id.value = "";
        kambing_c.foto2_u.value = "";
        kambing_c.foto2_id.value = "";
        kambing_c.foto3_u.value = "";
        kambing_c.foto3_id.value = "";
        kambing_c.foto4_u.value = "";
        kambing_c.foto4_id.value = "";
        kambing_c.video_u.value = "";
        kambing_c.video_id.value = "";
        kambing_c.foto_on_change.value = "";
        kambing_c.foto2_on_change.value = "";
        kambing_c.foto3_on_change.value = "";
        kambing_c.foto4_on_change.value = "";
        // get foto
        List data_foto = (json.decode(response.body)
            as Map<String, dynamic>)['data']['photo'];
        if (data_foto.length >= 1) {
          if (data_foto[0]['type'] == 1) {
            kambing_c.foto_u.value = data_foto[0]["file"];
            kambing_c.foto_id.value = data_foto[0]["id"];
          }
        }
        if (data_foto.length >= 2) {
          if (data_foto[1]['type'] == 1) {
            kambing_c.foto2_u.value = data_foto[1]["file"];
            kambing_c.foto2_id.value = data_foto[1]["id"];
          }
        }
        if (data_foto.length >= 3) {
          if (data_foto[2]['type'] == 1) {
            kambing_c.foto3_u.value = data_foto[2]["file"];
            kambing_c.foto3_id.value = data_foto[2]["id"];
          }
        }
        if (data_foto.length >= 4) {
          if (data_foto[3]['type'] == 1) {
            kambing_c.foto4_u.value = data_foto[3]["file"];
            kambing_c.foto4_id.value = data_foto[3]["id"];
          }
        }
        data_foto.forEach((element) {
          if (element['type'] == 2) {
            kambing_c.video_u.value = element['file'];
            kambing_c.video_id.value = element['id'];
          }
        });
        // print("jnkjvbrenviorjeionfirnfinrfrfr");
        kambing_c.is_change_foto1.value = 0;
        kambing_c.is_change_foto2.value = 0;
        kambing_c.is_change_foto3.value = 0;
        kambing_c.is_change_foto4.value = 0;

        kambing_c.change_img.value = 0;
        kambing_c.is_change.value = 0;

        kambing_c.is_internal_u.value = data_respone['type'] ?? 1;
        kambing_c.tanggal_lahir_u.text = data_respone['birthday'] ?? "";
        kambing_c.id_jenis_kambing_u.value = data_respone['id_category'] ?? "";
        kambing_c.name_jenis_kambing_u.value =
            data_respone['category_name'] ?? "";
        kambing_c.id_hewan_u.text = data_respone['cattle_id'];
        kambing_c.jk_u.value = data_respone['gender'] ?? 1;

        // kambing_c.tanggal_lahir_eks_u.text = data_respone['birthday'] ?? "";
        kambing_c.induk_jantan_u.value = data_respone['male_parent'] ?? "";
        kambing_c.name_induk_jantan_u.value =
            data_respone['male_parent_name'] ?? "";
        kambing_c.induk_betian_u.value = data_respone['female_parent'] ?? "";
        kambing_c.name_induk_betian_u.value =
            data_respone['female_parent_name'] ?? "";
        kambing_c.tanggal_beli.text = data_respone['purchase_date'] ?? "";
        // kambing_c.harga_eks_u.text = data_respone['price'] ?? "";
        kambing_c.harga_eks_u.text = NumberFormat.decimalPattern()
            .format(int.parse(data_respone['price']));

        kambing_c.berat_hewan_u.text = data_respone['weigth'] ?? "";
        kambing_c.kandang_u.value = data_respone['id_kandang'] ?? "";
        kambing_c.name_kandang_u.value = data_respone['nama_kandang'] ?? "";
        kambing_c.nama_hewan_u.text = data_respone['cattle_name'] ?? "";
        // kambing_c.foto_u.value = data_respone['photo'];
        kambing_c.id_kambing.value = data_respone['id'];
        kambing_c.is_weight.value = data_respone['is_edit_weigth'];
        kambing_c.is_kandang.value = data_respone['is_edit_kandang'];

        // get grafik
        List data_grafik = (json.decode(response.body)
            as Map<String, dynamic>)['data']['weigth_graphic'];
        data_gr.clear();
        data_grafik.forEach((element) {
          if (element['weigth'] != "0") {
            data_gr.add(
                _SalesData(element['date'], double.parse(element['weigth'])));
          }
        });

        // List<_SalesData> data = [
        //   _SalesData('Jan', 35),
        //    data_grafik.forEach((element) {
        //   data_gr.add(SalesData("mei", 25));
        // });
        // ];

        //       RxInt is_internal_u = 1.obs;
        // TextEditingController tanggal_lahir_u = TextEditingController();
        // RxString id_jenis_kambing_u = "".obs;
        // RxString foto_u = "".obs;
        // TextEditingController id_hewan_u = TextEditingController();
        // TextEditingController nama_hewan_u = TextEditingController();
        // RxInt jk_u = 1.obs;
        // RxString induk_jantan_u = "".obs;
        // RxString induk_betian_u = "".obs;
        // TextEditingController harga_eks_u = TextEditingController();
        // TextEditingController berat_hewan_u = TextEditingController();
        // RxString kandang_u = "".obs;

      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff45B549),
        title: Text(
          "Hewan Ternak",
          style: ThemesCustom.black_18_700,
        ),
        centerTitle: true,
        actions: [
          Obx(() => kambing_c.is_editable.value == "1"
              ? IconButton(
                  onPressed: () {
                    // showModal(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditGoat();
                    }));
                  },
                  icon: Text("Edit"))
              : SizedBox())
        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getData(),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // form baru
                Container(
                  height: 250,
                  child: Stack(
                    children: [
                      Obx(() => (kambing_c.is_change.value == 0)
                          ? (kambing_c.foto_u.value == "")
                              ? Image(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  image: CachedNetworkImageProvider(
                                      'https://souq.s3-id-jkt-1.kilatstorage.id/available_1654059656.png'))
                              : Image(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  image: CachedNetworkImageProvider(
                                      kambing_c.foto_u.value))
                          : Image(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              image: CachedNetworkImageProvider(
                                  kambing_c.foto_change.value))),
                      kambing_c.foto_u != ""
                          ? Positioned(
                              bottom: 20,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  kambing_c.is_change.value = 1;
                                  kambing_c.foto_change.value =
                                      kambing_c.foto_u.value;
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      width: 64,
                                      height: 64,
                                      image: CachedNetworkImageProvider(
                                          kambing_c.foto_u.value)),
                                ),
                              ))
                          : SizedBox(),
                      kambing_c.foto2_u != ""
                          ? Positioned(
                              bottom: 20,
                              left: 90,
                              child: InkWell(
                                onTap: () {
                                  kambing_c.is_change.value = 1;
                                  kambing_c.foto_change.value =
                                      kambing_c.foto2_u.value;
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      width: 64,
                                      height: 64,
                                      image: CachedNetworkImageProvider(
                                          kambing_c.foto2_u.value)),
                                ),
                              ))
                          : SizedBox(),
                      kambing_c.foto3_u != ""
                          ? Positioned(
                              bottom: 20,
                              left: 160,
                              child: InkWell(
                                onTap: () {
                                  kambing_c.is_change.value = 1;
                                  kambing_c.foto_change.value =
                                      kambing_c.foto3_u.value;
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      width: 64,
                                      height: 64,
                                      image: CachedNetworkImageProvider(
                                          kambing_c.foto3_u.value)),
                                ),
                              ))
                          : SizedBox(),
                      kambing_c.foto4_u != ""
                          ? Positioned(
                              bottom: 20,
                              left: 230,
                              child: InkWell(
                                onTap: () {
                                  kambing_c.is_change.value = 1;
                                  kambing_c.foto_change.value =
                                      kambing_c.foto4_u.value;
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      width: 64,
                                      height: 64,
                                      image: CachedNetworkImageProvider(
                                          kambing_c.foto4_u.value)),
                                ),
                              ))
                          : SizedBox(),
                      kambing_c.video_u != ""
                          ? Positioned(
                              bottom: 20,
                              left: 300,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return VideoApp(
                                      link: kambing_c.video_u.value,
                                    );
                                  }));
                                },
                                child: Image(
                                    height: 64,
                                    width: 64,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/image/preview_video.png")),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),

                Obx(() => kambing_c.is_editable.value == "1"
                    ? Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                // startBarcodeScanStream();

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddNotePageByCattle(
                                    id: d_kandang_model.id,
                                    name: d_kandang_model.cattleName,
                                    id_p: id_problem,
                                  );
                                }));
                              },
                              child: Container(
                                height: 34,
                                decoration: BoxDecoration(
                                    color: Color(0xffEAD065),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                        width: 16,
                                        height: 16,
                                        color: Colors.white,
                                        image: AssetImage(
                                            "assets/image/c_masalah.png")),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Catat Masalah",
                                      style: ThemesCustom.white_12_700,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                // startBarcodeScanStream();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddWeightByCattlePage(
                                    id_kambing: d_kandang_model.id,
                                    id_kandang: id_kandang,
                                    nama_kambing: d_kandang_model.cattleName,
                                    kambing_id: d_kandang_model.cattleId,
                                    berat_kambing: d_kandang_model.weigth,
                                    waktu_kambing: waktu,
                                  );
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
                                        color: Colors.white,
                                        image: AssetImage(
                                            "assets/image/i_catat.png")),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Catat Berat",
                                      style: ThemesCustom.white_12_700,
                                    ),
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                    : Container()),

                // Text(data)

                // d_kandang_model.photo == "" ||
                //         d_kandang_model.photo ==
                //             "https://souq.s3-id-jkt-1.kilatstorage.id/"
                //     ? Image(
                //         height: 180,
                //         width: double.infinity,
                //         fit: BoxFit.cover,
                //         image: AssetImage("assets/image/kambing2.png"))
                //     : Image(
                //         height: 180,
                //         width: double.infinity,
                //         fit: BoxFit.cover,
                //         image:
                //             CachedNetworkImageProvider(d_kandang_model.photo)),
                Padding(
                  padding: EdgeInsets.only(left: 18, right: 18, bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d_kandang_model.cattleName,
                        style: ThemesCustom.black1_18_700,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        d_kandang_model.cattleId,
                        style: ThemesCustom.black_11_700_07,
                      ),
                      SizedBox(
                        height: 4,
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
                            d_kandang_model.gender == 1 ? "Jantan" : "Betina",
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
                            d_kandang_model.weigth + " Kg",
                            style: ThemesCustom.black_12_400,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          d_kandang_model.type == 1
                              ? Expanded(
                                  child: Row(
                                  children: [
                                    Image(
                                        width: 14,
                                        height: 14,
                                        image: AssetImage(
                                            "assets/image/i_kalender.png")),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      d_kandang_model.age,
                                      style: ThemesCustom.black_12_400,
                                    ),
                                  ],
                                ))
                              : Container()
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Kandang",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              d_kandang_model.nama_kandang,
                              maxLines: 1,
                              style: ThemesCustom.black_13_400,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // showModalPindahKandang(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PindahKandang(
                                  id: d_kandang_model.id,
                                );
                              }));
                            },
                            child: Text(
                              "Pindah Kandang",
                              style: ThemesCustom.green_13_700,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              // showModalPindahKandang(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PageRiwayatKandangKambing(
                                  id: widget.id,
                                );
                              }));
                            },
                            child: Text(
                              "Riwayat Kandang",
                              style: ThemesCustom.green_13_700,
                            ),
                          ))
                        ],
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Asal",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            d_kandang_model.type == 1
                                ? "Internal kandang"
                                : "Eksternal Kandang",
                            style: ThemesCustom.black_13_400,
                          )),
                        ],
                      ),
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
                      d_kandang_model.type == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Tanggal Lahir",
                                        style: ThemesCustom.black_13_700,
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      d_kandang_model.birthday,
                                      style: ThemesCustom.black_13_400,
                                    )),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Induk Betina",
                                        style: ThemesCustom.black_13_700,
                                      ),
                                    ),
                                    Expanded(
                                        child: d_kandang_model
                                                    .female_parent_name ==
                                                " - "
                                            ? Text(
                                                "Tidak Diketahui",
                                                style:
                                                    ThemesCustom.black_13_400,
                                              )
                                            : Text(
                                                d_kandang_model
                                                    .female_parent_name,
                                                style:
                                                    ThemesCustom.black_13_400,
                                              )),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Induk Jantan",
                                        style: ThemesCustom.black_13_700,
                                      ),
                                    ),
                                    Expanded(
                                        child: d_kandang_model
                                                    .male_parent_name ==
                                                " - "
                                            ? Text(
                                                "Tidak Diketahui",
                                                style:
                                                    ThemesCustom.black_13_400,
                                              )
                                            : Text(
                                                d_kandang_model
                                                    .male_parent_name,
                                                style:
                                                    ThemesCustom.black_13_400,
                                              )),
                                  ],
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Tanggal Pembelian",
                                        style: ThemesCustom.black_13_700,
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      d_kandang_model.purchaseDate,
                                      style: ThemesCustom.black_13_400,
                                    )),
                                  ],
                                ),
                                d_kandang_model.is_selling == 0
                                    ? Container()
                                    : Column(
                                        children: [
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                child: Text(
                                                  "Harga Jual",
                                                  style:
                                                      ThemesCustom.black_13_700,
                                                ),
                                              ),
                                              Expanded(
                                                child: d_kandang_model.discount !=
                                                        0
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    right: 8),
                                                            child: Text(
                                                                "Rp " +
                                                                    NumberFormat.decimalPattern().format(int.parse(
                                                                        d_kandang_model
                                                                            .selling_price)),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Product Sans",
                                                                    fontSize:
                                                                        11,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    right: 8),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "Rp " +
                                                                        NumberFormat.decimalPattern().format(int.parse(d_kandang_model
                                                                            .final_price)),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Product Sans",
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Colors
                                                                            .black)),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  width: 31,
                                                                  height: 14,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "-" +
                                                                          d_kandang_model
                                                                              .discount
                                                                              .toString() +
                                                                          "%",
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              8,
                                                                          color: Colors
                                                                              .white,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 10,
                                                            bottom: 0),
                                                        child: Text(
                                                            "Rp " +
                                                                NumberFormat
                                                                        .decimalPattern()
                                                                    .format(int.parse(
                                                                        d_kandang_model
                                                                            .selling_price)),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Product Sans",
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Color(
                                                                    0Xff0B276F)))),
                                                //     Text(
                                                //   "Rp. " +
                                                //       NumberFormat.decimalPattern().format(
                                                //           int.parse(d_kandang_model.price)),
                                                //   style: ThemesCustom.black_13_400,
                                                // )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Harga",
                                        style: ThemesCustom.black_13_700,
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      "Rp. " +
                                          NumberFormat.decimalPattern().format(
                                              int.parse(d_kandang_model.price)),
                                      style: ThemesCustom.black_13_400,
                                    )),
                                  ],
                                ),
                              ],
                            )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 7,
                  color: Color(0xffF2F6FF),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Riwayat Berat",
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<_SalesData, String>>[
                            LineSeries<_SalesData, String>(
                                dataSource: data_gr,
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.sales,
                                name: 'Berat',
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),

                      // ini double
                      // SfCartesianChart(
                      //   title: ChartTitle(text: 'Yearly sales analysis'),
                      //   // legend: Legend(isVisible: true),
                      //   tooltipBehavior: _tooltipBehavior,
                      //   series: <ChartSeries<SalesData, String>>[
                      //     LineSeries<SalesData, String>(
                      //         name: 'Sales',
                      //         dataSource: _chartData,
                      //         xValueMapper: (SalesData sales, _) => sales.year,
                      //         yValueMapper: (SalesData sales, _) => sales.sales,
                      //         dataLabelSettings:
                      //             DataLabelSettings(isVisible: true),
                      //         enableTooltip: true)
                      //   ],
                      //   primaryXAxis: NumericAxis(
                      //     edgeLabelPlacement: EdgeLabelPlacement.shift,
                      //   ),
                      //   primaryYAxis: NumericAxis(
                      //     labelFormat: '{value}',
                      //   ),
                      // ),

                      // new
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Text(
                              "Berat Saat Ini",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            d_kandang_model.weigth + " Kg",
                            style: ThemesCustom.black_13_400,
                          )),
                        ],
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Text(
                              "Pertambahan Berat",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            d_kandang_model.total_growth_weigth + " Kg",
                            style: ThemesCustom.black_13_400,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),

                      // old
                      // FutureBuilder(
                      //   future: kambing_c.getRiwayatBerat(widget.id),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Container();
                      //     } else {
                      //       return ListView.builder(
                      //         physics: NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         itemCount:
                      //             kambing_c.listRiwayatPindahBerat.length,
                      //         itemBuilder: (context, index) {
                      //           return Column(
                      //             children: [
                      //               RiwayatKambing(
                      //                 kambing_c.listRiwayatPindahBerat[index]
                      //                     ['date'],
                      //                 kambing_c.listRiwayatPindahBerat[index]
                      //                     ['weigth'],
                      //               ),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //               Container(
                      //                   width: double.infinity,
                      //                   height: 1,
                      //                   color: Color.fromRGBO(35, 31, 32, 0.1)),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageRiwayatBeratKambing(
                              id: widget.id,
                            );
                          }));

                          // showModalBerat(context);
                        },
                        child: Center(
                          child: Text(
                            "Lihat Riwayat Berat",
                            style: ThemesCustom.green_13_700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 7,
                  color: Color(0xffF2F6FF),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Riwayat Makan",
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Text(
                              "Total Pakan",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            d_kandang_model.total_food,
                            style: ThemesCustom.black_13_400,
                          )),
                        ],
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Text(
                              "Total Biaya Pakan",
                              style: ThemesCustom.black_13_700,
                            ),
                          ),
                          // Expanded(
                          //     child: Text(
                          //   "Rp. " + d_kandang_model.total_fee_food,
                          //   style: ThemesCustom.black_13_400,
                          // )),
                          Expanded(
                              child: Text(
                            "Rp. " +
                                NumberFormat.decimalPattern().format(int.parse(
                                    d_kandang_model.total_fee_food == "null"
                                        ? "0"
                                        : d_kandang_model.total_fee_food)),
                            style: ThemesCustom.black_13_400,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),

                      // old
                      // FutureBuilder(
                      //   future: kambing_c.getListRiwayatMakan(widget.id),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Container();
                      //     } else {
                      //       return ListView.builder(
                      //         physics: NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         itemCount: kambing_c.listRiwayatMakan.length,
                      //         itemBuilder: (context, index) {
                      //           return Column(
                      //             children: [
                      //               BoxMakan(
                      //                 kambing_c.listRiwayatMakan[index]
                      //                     ['food_name'],
                      //                 kambing_c.listRiwayatMakan[index]
                      //                     ['weigth'],
                      //                 kambing_c.listRiwayatMakan[index]['date'],
                      //               ),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //               Container(
                      //                   width: double.infinity,
                      //                   height: 1,
                      //                   color: Color.fromRGBO(35, 31, 32, 0.1)),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          // showModalPakan(context);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageRiwayatMakanKambing(
                              id: widget.id,
                            );
                          }));
                        },
                        child: Center(
                          child: Text(
                            "Lihat Riwayat Makan",
                            style: ThemesCustom.green_13_700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   height: 7,
                //   color: Color(0xffF2F6FF),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(18),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Riwayat Pindah Kandang",
                //         style: GoogleFonts.inter(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w700,
                //             color: Colors.black),
                //       ),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       FutureBuilder(
                //         future:
                //             kambing_c.getListRiwayatPindahKandang(widget.id),
                //         builder: (context, snapshot) {
                //           if (snapshot.connectionState ==
                //               ConnectionState.waiting) {
                //             return Container();
                //           } else {
                //             return ListView.builder(
                //               physics: NeverScrollableScrollPhysics(),
                //               shrinkWrap: true,
                //               itemCount:
                //                   kambing_c.listRiwayatPindahKandang.length,
                //               itemBuilder: (context, index) {
                //                 return Column(
                //                   children: [
                //                     BoxPindahKandang(
                //                       kambing_c.listRiwayatPindahKandang[index]
                //                               ['kandang_baru'] ??
                //                           "",
                //                       kambing_c.listRiwayatPindahKandang[index]
                //                               ['birthday'] ??
                //                           "-",
                //                       kambing_c.listRiwayatPindahKandang[index]
                //                               ['description'] ??
                //                           "",
                //                     ),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                     Container(
                //                         width: double.infinity,
                //                         height: 1,
                //                         color: Color.fromRGBO(35, 31, 32, 0.1)),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                   ],
                //                 );
                //               },
                //             );
                //           }
                //         },
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       InkWell(
                //         onTap: () {
                //           // showModalPakan(context);

                //           Navigator.push(context,
                //               MaterialPageRoute(builder: (context) {
                //             return PageRiwayatKandangKambing(
                //               id: widget.id,
                //             );
                //           }));
                //         },
                //         child: Center(
                //           child: Text(
                //             "Lihat Riwayat Pindah Kandang",
                //             style: ThemesCustom.green_13_700,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            );
          }
        },
      )),
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

  void showModalPakan(ctx) {
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
                                "Riwayat Pakan",
                                style: ThemesCustom.black_14_700,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                              icon: Image(
                                  width: 25,
                                  height: 25,
                                  image:
                                      AssetImage("assets/image/filter.png"))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // BoxMakan(),
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
                      // BoxMakan(),
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
                      // BoxMakan(),
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
                  ),
                ),
              ); //whatever you're returning, does not have to be a Container
            }));
  }

  void showModalPindahKandang(ctx) {
    showModalBottomSheet(
        // isScrollControlled: true,
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
                                "Pindah Kandang",
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
                        "Kandang Awal",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jenis Kelamin Boleh Kosong';
                            }
                            return null;
                          },
                          hint: Text("Jenis Kelamin",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.bold)),
                          items: <String>[
                            'Pilih Jenis Kelaim',
                            'Laki Laki',
                            'Perempuan'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (select) {
                            print(select);
                          },
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Kandang Baru",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jenis Kelamin Boleh Kosong';
                            }
                            return null;
                          },
                          hint: Text("Jenis Kelamin",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.bold)),
                          items: <String>[
                            'Pilih Jenis Kelaim',
                            'Laki Laki',
                            'Perempuan'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (select) {
                            print(select);
                          },
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Tanggal Lahir",
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
                        "Catatan",
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
                              "Pindah kandang",
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

  void showModalBerat(ctx) {
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
                                "Riwayat Berat",
                                style: ThemesCustom.black_14_700,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                              icon: Image(
                                  width: 25,
                                  height: 25,
                                  image:
                                      AssetImage("assets/image/filter.png"))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // RiwayatKambing(),
                      // SizedBox(
                      //   height: 7,
                      // ),
                      // RiwayatKambing(),
                      // SizedBox(
                      //   height: 7,
                      // ),
                      // RiwayatKambing(),
                      // SizedBox(
                      //   height: 7,
                      // ),
                      // RiwayatKambing(),
                      // SizedBox(
                      //   height: 14,
                      // ),
                    ],
                  ),
                ),
              ); //whatever you're returning, does not have to be a Container
            }));
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
          // Image(image: AssetImage("assets/image/kambing.png")),
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

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
