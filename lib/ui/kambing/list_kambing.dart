import 'dart:convert';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/model/model_jenis_kambing.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/ui/kambing/detail_kambing.dart';
import 'package:aslis_application/ui/kambing/tambah_kambing.dart';
import 'package:aslis_application/ui/kandang/tambah_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ListGoat extends StatefulWidget {
  @override
  State<ListGoat> createState() => _ListGoatState();
}

class _ListGoatState extends State<ListGoat> {
  // const ListGoat({Key? key}) : super(key: key);
  final kandang_c = Get.put(KambingController());

  final box = GetStorage();

  ScrollController _scrolC = new ScrollController();
  final RefreshController refreshController = RefreshController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      kandang_c.loadHewan(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff45B549),
      //   title: Text(
      //     "Hewan Ternak",
      //     style: ThemesCustom.black_18_700,
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           // showModal(context);
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return AddGoat();
      //           }));
      //         },
      //         icon: Icon(Icons.add))
      //   ],
      // ),
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
              padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            onChanged: (value) {
                              kandang_c.filterHewan(0);
                            },
                            controller: kandang_c.cari_hewan,
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
                      InkWell(
                        onTap: () {
                          showModal(context);
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
                  FutureBuilder(
                    future: kandang_c.listHewan("", "1", "", "1", "", "", 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            BoxKambingShimer(),
                            SizedBox(
                              height: 20,
                            ),
                            BoxKambingShimer(),
                            SizedBox(
                              height: 20,
                            ),
                            BoxKambingShimer(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      } else {
                        return Obx(() => kandang_c.listKambing.length == 0
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
                                            "assets/image/empty_ternak.png")),
                                  ),
                                  Text(
                                    "Anda Belum Memiliki Hewan Ternak",
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
                                          return AddGoat();
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
                                            "Tambah Hewan Ternak",
                                            style: ThemesCustom.green_16_700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: kandang_c.listKambing.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          BoxKambing(
                                            context,
                                            kandang_c.listKambing[index]
                                                    ['cattle_name'] ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['category'] ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['gender'] ??
                                                1,
                                            kandang_c.listKambing[index]
                                                    ['weigth'] ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['age'] ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['id'].toString() ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['photo'] ??
                                                "",
                                            kandang_c.listKambing[index]
                                                    ['kandang'] ??
                                                "",
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )));
                      }
                    },
                  )
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // BoxKambing(context),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // BoxKambing(context),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // BoxKambing(context),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showModal(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) => DraggableScrollableSheet(
            initialChildSize: 1, //set this as you want
            maxChildSize: 1, //set this as you want
            minChildSize: 1, //set this as you want
            expand: true,
            builder: (context, scrollController) {
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
                                "Filter",
                                style: ThemesCustom.black_14_700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Jenis",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<JenisKambingModel>(
                        selectedItem: JenisKambingModel(
                            id: kandang_c.kategori_filter.value,
                            name: kandang_c.nama_kategori_filter.value),
                        validator: (value) {
                          if (value == null) {
                            return 'Jenis Kambing tidak valid';
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
                          var uri_api = Uri.parse(
                              ApiService.baseUrl + "/get_data/category_cattle");
                          var is_token = "Bearer " + box.read("token");
                          var respone = await http.get(uri_api,
                              headers: {"Authorization": is_token});
                          print(json.decode(respone.body));
                          // var data = json.decode(respone.body);
                          var data =
                              json.decode(respone.body) as Map<String, dynamic>;
                          var dataProvince = data['data'] as List<dynamic>;
                          var model =
                              JenisKambingModel.fromJsonList(dataProvince);
                          return model;
                        },
                        onChanged: (value) {
                          if (value != null) {
                            // muhib
                            kandang_c.kategori_filter.value = value.id;
                            kandang_c.nama_kategori_filter.value = value.name;
                          }
                        },
                        itemAsString: (item) => item!.name,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text("${item.name}"),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Asal",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                          validator: (value) {
                            if (value == null) {
                              return 'Asal Usul tidak valid';
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
                          popupProps: PopupProps.menu(),
                          items: ["Internal", 'Eksternal'],
                          onChanged: (val) {
                            // print(val);
                            kandang_c.nama_asal_filter.value = val!;
                            if (val == "Internal") {
                              kandang_c.asal_filter.value = "1";
                            } else {
                              kandang_c.asal_filter.value = "2";
                            }
                          },
                          selectedItem: kandang_c.nama_asal_filter.value),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Gender",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                          validator: (value) {
                            if (value == null) {
                              return 'Gender tidak valid';
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
                          popupProps: PopupProps.menu(),
                          items: ["Jantan", 'Betina'],
                          onChanged: (val) {
                            // print(val);
                            kandang_c.nama_gender_filter.value = val!;
                            if (val == "Jantan") {
                              kandang_c.asal_filter.value = "1";
                            } else {
                              kandang_c.asal_filter.value = "2";
                            }
                          },
                          selectedItem: kandang_c.nama_gender_filter.value),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Kandang",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<KandangModel>(
                        selectedItem: KandangModel(
                            id: "",
                            shedName: kandang_c.nama_kandang_filter.value,
                            shedId: "",
                            numberOfCattle: 0,
                            weigthOfCattle: 0),
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
                            kandang_c.nama_kandang_filter.value =
                                value.shedName;
                            kandang_c.kandang_filter.value = value.id;
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Usia Hewan (2 - 13) Tahun",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Usia tidak valid';
                                  }
                                  return null;
                                },
                                controller: kandang_c.usia_min,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0XFF71A841), width: 2.0),
                                  ),
                                  hintText: "Usia Minimun",
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Usia tidak valid';
                                  }
                                  return null;
                                },
                                controller: kandang_c.usia_max,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0XFF71A841), width: 2.0),
                                  ),
                                  hintText: "Usia Maksimum",
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )),
                          )
                        ],
                      ),

                      // RangeSlider(
                      //   values: kandang_c.currentRangeValues,
                      //   max: 100,
                      //   divisions: 1,
                      //   labels: RangeLabels(
                      //     kandang_c.currentRangeValues.start.round().toString(),
                      //     kandang_c.currentRangeValues.end.round().toString(),
                      //   ),
                      //   onChanged: (RangeValues values) {
                      //     // setState(() {
                      //     //   _currentRangeValues = values;
                      //     // });
                      //     print(values);
                      //   },
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Berat Hewan (2 - 13) Tahun",
                        style: ThemesCustom.black_14_700,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Berat tidak valid';
                                  }
                                  return null;
                                },
                                controller: kandang_c.berat_min,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0XFF71A841), width: 2.0),
                                  ),
                                  hintText: "Berat Minimun",
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Berat tidak valid';
                                  }
                                  return null;
                                },
                                controller: kandang_c.berat_max,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0XFF71A841), width: 2.0),
                                  ),
                                  hintText: "Berat Maksimum",
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )),
                          )
                        ],
                      ),
                      // RangeSlider(
                      //   values: kandang_c.currentRangeValues_berat,
                      //   max: 100,
                      //   divisions: 1,
                      //   labels: RangeLabels(
                      //     kandang_c.currentRangeValues_berat.start
                      //         .round()
                      //         .toString(),
                      //     kandang_c.currentRangeValues_berat.end
                      //         .round()
                      //         .toString(),
                      //   ),
                      //   onChanged: (RangeValues values) {
                      //     // setState(() {
                      //     //   _currentRangeValues = values;
                      //     // });
                      //     print(values);
                      //   },
                      // ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          kandang_c.filterHewan(0);
                          Navigator.pop(context);

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
                              "Filter",
                              style: ThemesCustom.white_16_700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ); //whatever you're returning, does not have to be a Container
            }));
  }

  Widget BoxKambing(context, String nama, String kategori, int jk, String berat,
      String umur, String id, String foto, String kandang) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailGoatPage(
            id: id,
          );
        }));
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: ThemesCustom.black_14_700,
                ),
                Text(
                  kandang + " - " + kategori,
                  style: ThemesCustom.black_11_400_07,
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
                      style: ThemesCustom.black_11_400_07,
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
                      style: ThemesCustom.black_11_400_07,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Image(
                    //     width: 14,
                    //     height: 14,
                    //     image: AssetImage("assets/image/i_kalender.png")),
                    // SizedBox(
                    //   width: 4,
                    // ),
                    // Text(
                    //   umur,
                    //   style: ThemesCustom.black_11_400_07,
                    // ),
                  ],
                ),
              ],
            )),
            // menuModal
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {
                menuModal(id);
              },
              icon: Image(image: AssetImage("assets/image/i_filter2.png")),
            )
            // Container(
            //     width: 50,
            //     height: double.infinity,
            //     color: Colors.red,
            //     child: IconButton(
            //       padding: EdgeInsets.zero,
            //       constraints: BoxConstraints(),
            //       onPressed: () {
            //         menuModal(id);
            //       },
            //       icon: Image(image: AssetImage("assets/image/i_filter2.png")),
            //     ))
          ],
        ),
      ),
    );
  }

  Widget BoxKambingShimer() {
    return InkWell(
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
            Shimmer.fromColors(
              baseColor: Colors.grey[500]!,
              highlightColor: Colors.grey[300]!,
              period: Duration(seconds: 2),
              child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                      color: Colors.grey[400]!,
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              width: 10,
            ),
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
                      width: 50,
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

  // konfirmasi hapus
  void confirm_delete(String id) {
    // warehouseController w_controller = Get.find();
    final kandang_c = Get.put(KambingController());

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
            Text("Pilih Alasan Menghapus Ternak",
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
            SizedBox(
              height: 20,
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    hintText: "Pilih",
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              items: [
                "Salah Buat Ternak",
                "Kambing Mati",
                "Kambing Hilang",
                "Terjual Offline"
              ],
              onChanged: (va) {
                print(va);
                if (va != null) {
                  kandang_c.reason_kambing.value = va.toString();
                }
              },
              selectedItem: "Pilih Alasan Hapus",
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
                      if (kandang_c.reason_kambing.value != "") {
                        Get.close(0);
                        kandang_c.hapuskandang(id, 0);
                      }

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

  void confirm_jual(String id) {
    // warehouseController w_controller = Get.find();
    final kandang_c = Get.put(KambingController());

    Get.defaultDialog(
        title: 'Jual Kambing',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text("Masukan Harga Jual",
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak valid';
                  }
                  return null;
                },
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    symbol: "",
                    decimalDigits: 0,
                  )
                ],
                controller: kandang_c.jual_kambing,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0XFF71A841), width: 2.0),
                  ),
                  hintText: "",
                  prefix: Text("Rp. "),
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Text("Diskon (0-100)",
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak valid';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: kandang_c.diskon_kambing,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0XFF71A841), width: 2.0),
                  ),
                  hintText: "",
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // w_controller.hapus(id);
                      if (kandang_c.jual_kambing.value != "") {
                        Get.close(0);
                        kandang_c.jualKambing(id);
                      }

                      // up_controller.hapusProduk(id);
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Jual",
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
                confirm_jual(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Jual Kambing",
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
                confirm_delete(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Hapus Ternak",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xffffffff)),
                )),
                decoration: BoxDecoration(
                  color: Color(0xffD45151),
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
            // SizedBox(
            //   height: 16,
            // ),
          ],
        ),
        radius: 10.0);
  }
}
