import 'dart:convert';

import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/model/model_provinsi.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_helper.dart';

class TambahKandang extends StatefulWidget {
  @override
  State<TambahKandang> createState() => _TambahKandangState();
}

class _TambahKandangState extends State<TambahKandang> {
  // const TambahKandang({Key? key}) : super(key: key);
  final kandang_c = Get.put(KandangController());

  final box = GetStorage();
  final _keyForm = GlobalKey<FormState>();

  int change_provinsi = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (_keyForm.currentState!.validate()) {
              // login_c.sendLogin();
              kandang_c.tambah_kandang();
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
          "Tambah Kandang",
          style: ThemesCustom.black1_18_700,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ID Kandang",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Peternak tidak valid';
                      }
                      return null;
                    },
                    controller: kandang_c.id_kandang,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "Contoh: #12345",
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nama Kandang",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Peternak tidak valid';
                      }
                      return null;
                    },
                    controller: kandang_c.nama_kandang,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "Contoh: Kandang ABC",
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Provinsi",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownSearch<ProvinceModel>(
                  validator: (value) {
                    if (value == null) {
                      return 'Provinsi tidak valid';
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
                    print(box.read("token"));
                    print("this is async item");
                    var uri_api = Uri.parse(
                        ApiService.baseUrl + "/get_data/address/province");
                    print("Loaded uri");
                    var is_token = "Bearer " + box.read("token");
                    print("Loaded token");
                    var respone = await http
                        .get(uri_api, headers: {"Authorization": is_token});
                    print("Loaded response");
                    print(json.decode(respone.body));
                    // var data = json.decode(respone.body);
                    var data =
                        json.decode(respone.body) as Map<String, dynamic>;
                    var dataProvince = data['data'] as List<dynamic>;
                    var model = ProvinceModel.fromJsonList(dataProvince);
                    return model;
                  },
                  onChanged: (value) {
                    if (value != null) {
                      kandang_c.id_provinsi.value = value.id.toString();
                      kandang_c.id_kota.value = "0";
                      change_provinsi = 1;
                      setState(() {});
                      print(value.name);
                      // setState(() {});
                      // setState(() {
                      // warehouse_c.id_provinsi.value = value.id.toString();
                      // warehouse_c.id_kota.value = "";
                      // });
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
                  height: 20,
                ),
                Text(
                  "Kabupaten/Kota",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownSearch<ProvinceModel>(
                  validator: (value) {
                    if (value == null) {
                      return 'Provinsi tidak valid';
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
                    var uri_api = Uri.parse(ApiService.baseUrl +
                        "/get_data/address/city/" +
                        kandang_c.id_provinsi.value.toString());
                    print("ID CITY NYA " +
                        kandang_c.id_provinsi.value.toString());
                    var is_token = "Bearer " + box.read("token");
                    var respone = await http
                        .get(uri_api, headers: {"Authorization": is_token});
                    print(json.decode(respone.body));

                    // var data = json.decode(respone.body);
                    var data =
                        json.decode(respone.body) as Map<String, dynamic>;
                    var dataProvince = data['data'] as List<dynamic>;
                    var model = ProvinceModel.fromJsonList(dataProvince);
                    return model;
                  },
                  onChanged: (value) {
                    if (value != null) {
                      print(value.name);
                      // setState(() {
                      kandang_c.id_kota.value = value.id.toString();
                      change_provinsi = 0;

                      // });
                    }
                  },
                  itemAsString: (item) {
                    if (change_provinsi == 1) {
                      return "pilih";
                    } else {
                      return item!.name;
                    }
                  },
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
                  height: 20,
                ),
                Text(
                  "Alamat",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: kandang_c.alamat_kandang,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "",
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Kapasitas Kandang",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Peternak tidak valid';
                      }
                      return null;
                    },
                    controller: kandang_c.kapasitas_kandang,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "",
                      suffix: Text("Ekor"),
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.grey[200],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Maksimum Jarak Pengiriman (Optional)",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: kandang_c.jarak_pengiriman,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "",
                      suffix: Text("Km"),
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Biaya Pengiriman (Optional)",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        symbol: "",
                        decimalDigits: 0,
                      )
                    ],
                    controller: kandang_c.harga_pengiriman,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
                      hintText: "",
                      prefix: Text("Rp. "),
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
