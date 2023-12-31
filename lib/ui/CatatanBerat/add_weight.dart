import 'dart:convert';

import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/controller/catatberat_controller.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/ui/kandang/tambah_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddWeightPage extends StatefulWidget {
  @override
  State<AddWeightPage> createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage> {
  // const AddWeightPage({Key? key}) : super(key: key);
  final box = GetStorage();
  final kan_controller = Get.put(KandangController());

  @override
  void initState() {
    super.initState();
    print("Loaded");
    kan_controller.GetKandang("");

    print("Kosong");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  displaySheet();
      Future.delayed(Duration(seconds: 20), () {
        if (kan_controller.listKandang.length == 0) {
          showModalTwo(context);
        }
      });

      //
    });
  }

  CatatBeratController cb_controller = Get.find();

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
          onTap: () {
            if (_keyForm.currentState!.validate()) {
              cb_controller.uploadBerat();

              // var check_price = cb_controller.list_kambing_array
              //     .where((element) => element['weight'] == "");
              // if (check_price.isNotEmpty) {
              //   // is_empty = 1;
              //   showModal("Berat Tidak Boleh Kosong");
              // } else {
              //   // showModal("Bisa Di Upload");
              //   cb_controller.uploadBerat();
              // }
            }
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
                color: Color(0xff45B549),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                "Simpan",
                style: ThemesCustom.white_16_700,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Catat Berat",
          style: ThemesCustom.black1_18_700,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        var respone = await http
                            .get(uri_api, headers: {"Authorization": is_token});
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
                          cb_controller.getKambing(value.id, "");
                          cb_controller.id_kategori.value = value.id;
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
                      height: 20,
                    ),
                    Text(
                      "Tanggal Penimbangan",
                      style: ThemesCustom.black_14_700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal Tidak Boleh Kosong';
                        }
                        return null;
                      },
                      controller: cb_controller.tanggal,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        String dateShow = "";
                        // if (p_controller.tanggal_lahir.text != null) {
                        //   dateShow = p_controller.tanggal_lahir.text;
                        // } else {
                        dateShow = "1990-01-01";
                        // }
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: cb_controller.tanggal.text == ""
                                ? DateTime.now()
                                : DateTime.parse(cb_controller.tanggal.text),
                            firstDate: DateTime(
                                1970), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          cb_controller.tanggal.text = formattedDate.toString();
                        } else {
                          print("Date is not selected");
                        }
                      },

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity, height: 7, color: Color(0xffF2F6FF)),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        cb_controller.getKambing("", value);
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
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),

                    Obx(() => ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cb_controller.listKambing.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                BoxListKambing(
                                  cb_controller.listKambing[index]['id'] ?? "",
                                  cb_controller.listKambing[index]['photo'] ??
                                      "",
                                  cb_controller.listKambing[index]
                                          ['cattle_name'] ??
                                      "",
                                  cb_controller.listKambing[index]
                                          ['cattle_id'] ??
                                      "",
                                  index,
                                  cb_controller.listKambing[index]['weigth'] ??
                                      "",
                                  cb_controller.listKambing[index]
                                          ['date_off_weigth'] ??
                                      "",
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          },
                        ))

                    // BoxListKambing(),
                    // SizedBox(
                    //   height: 13,
                    // ),
                    // BoxListKambing(),
                    // SizedBox(
                    //   height: 13,
                    // ),
                    // BoxListKambing(),
                    // SizedBox(
                    //   height: 13,
                    // ),
                    // BoxListKambing(),
                    // SizedBox(
                    //   height: 13,
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container BoxListKambing(String id, String foto, String nama, String kategori,
      int index, String berat, String waktu) {
    CatatBeratController cb_controller = Get.find();
    return Container(
      width: double.infinity,
      height: 110,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.5, color: Color(0xffF2F6FF)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Image(
              width: 64,
              height: 54,
              image: AssetImage("assets/image/empty_aslis.png")),

          // foto == ""
          //     ? Image(
          //         width: 64,
          //         height: 54,
          //         image: AssetImage("assets/image/empty_kambing.png"))
          //     : Image(
          //         width: 64,
          //         height: 54,
          //         image: CachedNetworkImageProvider(foto)),
          // Image(image: AssetImage("assets/image/kambing.png")),
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
                maxLines: 1,
                style: ThemesCustom.black_12_700,
              ),
              SizedBox(
                height: 4,
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
                  SizedBox(
                    width: 3,
                  ),
                  Image(
                      width: 14,
                      height: 14,
                      image: AssetImage("assets/image/i_ukuran.png")),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Terakhir: " + berat + " Kg",
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Image(
                      width: 18,
                      height: 18,
                      image: AssetImage("assets/image/i_kalender.png")),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Terakhir: " + waktu,
                    style: ThemesCustom.black_12_400,
                  ),
                ],
              )
            ],
          )),
          Container(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Berat",
                  style: ThemesCustom.black_12_700,
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 54,
                  height: 40,
                  child: TextFormField(
                    onChanged: (value) {
                      cb_controller.list_kambing_array[index]['weight'] = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      // suffix: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showModalTwo(BuildContext ctx) {
    Get.defaultDialog(
        title: '',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 2, color: Color(0xff333333), fontWeight: FontWeight.bold),
        content: Container(
          width: MediaQuery.of(ctx).size.width,
          height: MediaQuery.of(ctx).size.height - 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Image(
                      width: 200,
                      height: 300,
                      image: AssetImage("assets/image/empty_kandang.png")),
                ),
                Text(
                  "Buat Kandang Terlebih Dahulu",
                  style: ThemesCustom.black_14_700,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: InkWell(
                    onTap: () {
                      Get.close(0);
                      Navigator.push(ctx, MaterialPageRoute(builder: (context) {
                        return TambahKandang();
                      }));
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xff45B549), width: 1),
                          borderRadius: BorderRadius.circular(50)),
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
            ),
          ),
        ),
        radius: 10.0);
  }
}
