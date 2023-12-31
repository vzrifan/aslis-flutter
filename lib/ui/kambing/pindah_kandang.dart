import 'dart:convert';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PindahKandang extends StatefulWidget {
  // const PindahKandang({Key? key}) : super(key: key);
  var id;
  PindahKandang({required this.id});

  @override
  _PindahKandangState createState() => _PindahKandangState();
}

class _PindahKandangState extends State<PindahKandang> {
  final box = GetStorage();
  final _keyForm = GlobalKey<FormState>();
  KambingController kambing_c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20),
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
                    "Pindah Kandang",
                    style: ThemesCustom.black_14_700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kandang Awal",
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
                      kambing_c.kandang_awal.value = value.id;
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
                  "Kandang Baru",
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
                      kambing_c.kandang_akhir.value = value.id;
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
                  "Tanggal",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal Lahir Tidak Boleh Kosong';
                    }
                    return null;
                  },
                  controller: kambing_c.tanggal_pindah,
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
                        initialDate: DateTime.now(),
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
                      kambing_c.tanggal_pindah.text = formattedDate.toString();
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
                      if (value == null || value.isEmpty) {
                        return 'Catattan tidak valid';
                      }
                      return null;
                    },
                    controller: kambing_c.catatan_pindah,
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
                    if (_keyForm.currentState!.validate()) {
                      // login_c.sendLogin();
                      kambing_c.pindahKandang(widget.id);
                    }
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
      ),
    );
  }
}
