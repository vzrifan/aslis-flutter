import 'dart:convert';

import 'package:aslis_application/controller/pakan_controller.dart';
import 'package:aslis_application/model/model_jenis_pakan.dart';
import 'package:aslis_application/model/model_kategori_makanan.dart';
import 'package:aslis_application/model/model_provinsi.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditPakanPage extends StatefulWidget {
  // const EditPakanPage({Key? key}) : super(key: key);
  var id;
  EditPakanPage({required this.id});

  @override
  State<EditPakanPage> createState() => _EditPakanPageState();
}

class _EditPakanPageState extends State<EditPakanPage> {
  final box = GetStorage();

  final _keyForm = GlobalKey<FormState>();

  PakanController pakan_c = Get.find();

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  Future getDetailPakan() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/detail");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api,
          body: {"id": widget.id}, headers: {"Authorization": is_token});
      var data = json.decode(response.body)['data'];
      print(data);
      if (response.statusCode == 200) {
        // nama_kandang = data['shed_name'];
        pakan_c.id_pakan_u.text = data['food_id'];
        pakan_c.nama_pakan_u.text = data['food_name'];
        pakan_c.jenis_pakan_u.value = data['id_category'];
        pakan_c.name_jenis_pakan_u.value = data['category_name'];
        pakan_c.tanggal_u.text = data['date'];
        pakan_c.berat_u.text = data['stock'];
        // pakan_c.harga_u.text = data['capital_price'];
        pakan_c.harga_u.text = NumberFormat.decimalPattern()
            .format(int.parse(data['capital_price']));
        pakan_c.id_pakan_update.value = data['id'];
      } else {
        print("Not Good");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Pakan",
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getDetailPakan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ID Pakan",
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
                                  return 'pakan tidak valid';
                                }
                                return null;
                              },
                              controller: pakan_c.id_pakan_u,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                hintText: "Contoh : #1232123",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Nama Pakan",
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
                                  return 'nama pakan tidak valid';
                                }
                                return null;
                              },
                              controller: pakan_c.nama_pakan_u,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                hintText: "Contoh : pakan ABC",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Jenis Pakan",
                            style: ThemesCustom.black_14_700,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownSearch<JenisPakanModel>(
                            selectedItem: JenisPakanModel(
                                id: pakan_c.jenis_pakan_u.value,
                                name: pakan_c.name_jenis_pakan_u.value),
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
                              var uri_api = Uri.parse(ApiService.baseUrl +
                                  "/get_data/category_food");
                              var is_token = "Bearer " + box.read("token");
                              var respone = await http.get(uri_api,
                                  headers: {"Authorization": is_token});
                              print(json.decode(respone.body));
                              // var data = json.decode(respone.body);
                              var data = json.decode(respone.body)
                                  as Map<String, dynamic>;
                              var dataProvince = data['data'] as List<dynamic>;
                              var model =
                                  JenisPakanModel.fromJsonList(dataProvince);
                              return model;
                            },
                            onChanged: (value) {
                              if (value != null) {
                                pakan_c.jenis_pakan_u.value =
                                    value.id.toString();
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
                            "Tanggal",
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
                            // controller: kandang_c.tanggal_lahir,
                            autofocus: false,
                            controller: pakan_c.tanggal_u,
                            keyboardType: TextInputType.number,
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              String dateShow = "";
                              // if (pakan_c.tanggal_u.text != "") {
                              dateShow = pakan_c.tanggal_u.text;
                              // } else {
                              //   dateShow = "1990-01-01";
                              // }
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.parse(pakan_c.tanggal_u.text),
                                  firstDate: DateTime(
                                      1970), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);
                                pakan_c.tanggal_u.text =
                                    formattedDate.toString();
                                //formatted date output using intl package =>  2021-03-16
                                // kandang_c.tanggal_lahir.text =
                                //     formattedDate.toString();
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
                            "Berat ",
                            style: ThemesCustom.black_14_700,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Berat tidak valid';
                                }
                                return null;
                              },
                              enabled: false,
                              controller: pakan_c.berat_u,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                hintText: "",
                                suffix: Text("Kg"),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Modal",
                            style: ThemesCustom.black_14_700,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Modal tidak valid';
                                }
                                return null;
                              },
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                  symbol: "",
                                  decimalDigits: 0,
                                )
                              ],
                              controller: pakan_c.harga_u,
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
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              if (_keyForm.currentState!.validate()) {
                                pakan_c.ubahPakan();
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
}
