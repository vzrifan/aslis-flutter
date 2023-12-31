import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/catatan_controller.dart';
import 'package:aslis_application/controller/deviceController.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/model/model_problem_catatan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../model/model_event_catatatn.dart';

class AddDevicePage extends StatelessWidget {
  // const AddDevicePage({Key? key}) : super(key: key);
  DeviceController d_controller = Get.find();
  final ImagePicker _picker = ImagePicker();
  final _keyForm = GlobalKey<FormState>();

  final box = GetStorage();
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("Your Barcode Is" + barcodeScanRes);
      // kandang_c.id_hewan.text = barcodeScanRes;
      d_controller.id_hewan.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   // _scanBarcode = barcodeScanRes;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Device",
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
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "ID Device",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'id ewan tidak valid';
                        //   }
                        //   return null;
                        // },
                        controller: d_controller.id_hewan,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),
                          hintText: "Contoh : X12333",
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                  ),
                  IconButton(
                      onPressed: () {
                        scanQR();
                      },
                      icon: Image(image: AssetImage("assets/image/i_scan.png")))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Nama Device",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Nama tidak valid';
                    }
                    return null;
                  },
                  controller: d_controller.nama_device,
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
                height: 14,
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
                  var respone = await http
                      .get(uri_api, headers: {"Authorization": is_token});
                  print(json.decode(respone.body));
                  // var data = json.decode(respone.body);
                  var data = json.decode(respone.body) as Map<String, dynamic>;
                  var dataProvince = data['data'] as List<dynamic>;
                  var model = KandangModel.fromJsonList(dataProvince);
                  return model;
                },
                onChanged: (value) {
                  if (value != null) {
                    d_controller.kandang_c.value = value.id;
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (_keyForm.currentState!.validate()) {
                    // catat_c.simpanNote();
                    d_controller.upload_device();
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
                      "Simpan",
                      style: ThemesCustom.white_16_700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
