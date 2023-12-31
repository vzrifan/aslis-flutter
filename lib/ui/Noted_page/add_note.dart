import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/catatan_controller.dart';
import 'package:aslis_application/model/model_problem_catatan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../model/model_event_catatatn.dart';

class AddNotePage extends StatelessWidget {
  // const AddNotePage({Key? key}) : super(key: key);
  CatatanController catat_c = Get.find();
  final ImagePicker _picker = ImagePicker();
  final _keyForm = GlobalKey<FormState>();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catatan",
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
                "Judul",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Judul tidak valid';
                    }
                    return null;
                  },
                  controller: catat_c.judul,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0XFF71A841), width: 2.0),
                    ),
                    hintText: "Contoh : Judul ABC",
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
              SizedBox(
                height: 14,
              ),
              Text(
                "Jenis Event",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownSearch<EventModel>(
                validator: (value) {
                  if (value == null) {
                    return 'Event tidak valid';
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
                      Uri.parse(ApiService.baseUrl + "/get_data/master_events");
                  var is_token = "Bearer " + box.read("token");
                  var respone = await http
                      .get(uri_api, headers: {"Authorization": is_token});
                  print(json.decode(respone.body));
                  // var data = json.decode(respone.body);
                  var data = json.decode(respone.body) as Map<String, dynamic>;
                  var dataProvince = data['data'] as List<dynamic>;
                  var model = EventModel.fromJsonList(dataProvince);
                  return model;
                },
                onChanged: (value) {
                  if (value != null) {
                    // muhib
                    catat_c.id_event.value = value.id;
                    // kandang_c.id_jenis_kambing.value = value.id;
                  }
                },
                itemAsString: (item) => item!.eventName,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text("${item.eventName}"),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Masalah",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownSearch<ProblemNoteModel>(
                validator: (value) {
                  if (value == null) {
                    return 'Masalah tidak valid';
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
                      ApiService.baseUrl + "/get_data/master_problems");
                  var is_token = "Bearer " + box.read("token");
                  var respone = await http
                      .get(uri_api, headers: {"Authorization": is_token});
                  print(json.decode(respone.body));
                  // var data = json.decode(respone.body);
                  var data = json.decode(respone.body) as Map<String, dynamic>;
                  var dataProvince = data['data'] as List<dynamic>;
                  var model = ProblemNoteModel.fromJsonList(dataProvince);
                  return model;
                },
                onChanged: (value) {
                  if (value != null) {
                    // muhib
                    catat_c.id_masalah.value = value.id;
                    if (value.problem == "Hewan Ternak") {
                      catat_c.changeList.value = 1;
                    } else if (value.problem == "Pakan") {
                      catat_c.changeList.value = 2;
                    } else if (value.problem == "Kandang") {
                      catat_c.changeList.value = 3;
                    }
                    // kandang_c.id_jenis_kambing.value = value.id;
                  }
                },
                itemAsString: (item) => item!.problem,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text("${item.problem}"),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 14,
              ),

              // kosong

              // hewan
              Obx(() => catat_c.changeList.value == 1
                  ? FutureBuilder(
                      future: catat_c.getListHewan(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hewan Ternak",
                                style: ThemesCustom.black_14_700,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownSearch<String>.multiSelection(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Kategori tidak valid';
                                  }
                                  return null;
                                },
                                popupProps:
                                    PopupPropsMultiSelection.bottomSheet(
                                        showSelectedItems: true),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: "Pilih",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0XFF71A841),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffE6E9EF)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ),

                                items: catat_c.list_name_hewan,
                                onChanged: (index) {
                                  // print(index);
                                  catat_c.listProblemSelected.clear();
                                  index.forEach((element) {
                                    print(element);
                                    print("Okejek");
                                    print(catat_c.list_id_hewan);
                                    final item =
                                        catat_c.list_id_hewan.firstWhere(
                                      (e) => e['cattle_name'] == element,
                                      orElse: () => {"id": null},
                                    );

                                    if (item['id'] != null) {
                                      catat_c.listProblemSelected
                                          .add(item['id']);
                                    }
                                  });
                                },
                                // selectedItems: upload_c.name_kategori_produk.value,
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Container()),

              // pakan
              Obx(() => catat_c.changeList.value == 2
                  ? FutureBuilder(
                      future: catat_c.getListPakan(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pakan",
                                style: ThemesCustom.black_14_700,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownSearch<String>.multiSelection(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Kategori tidak valid';
                                  }
                                  return null;
                                },
                                popupProps:
                                    PopupPropsMultiSelection.bottomSheet(
                                        showSelectedItems: true),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: "Pilih",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0XFF71A841),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffE6E9EF)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ),

                                items: catat_c.list_name_pakan,
                                onChanged: (index) {
                                  // print(index);
                                  catat_c.listProblemSelected.clear();
                                  index.forEach((element) {
                                    final item =
                                        catat_c.list_id_pakan.firstWhere(
                                      (e) => e['food_name'] == element,
                                      orElse: () => {"id": null},
                                    );
                                    if (item['id'] != null) {
                                      catat_c.listProblemSelected
                                          .add(item['id']);
                                    }
                                  });
                                },
                                // selectedItems: upload_c.name_kategori_produk.value,
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Container()),

              // kandang

              Obx(() => catat_c.changeList.value == 3
                  ? FutureBuilder(
                      future: catat_c.getListKandang(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return Column(
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
                              DropdownSearch<String>.multiSelection(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Kategori tidak valid';
                                  }
                                  return null;
                                },
                                popupProps:
                                    PopupPropsMultiSelection.bottomSheet(
                                        showSelectedItems: true),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: "Pilih",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0XFF71A841),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffE6E9EF)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ),

                                items: catat_c.list_name_kandang,
                                onChanged: (index) {
                                  print(index);
                                  catat_c.listProblemSelected.clear();
                                  index.forEach((element) {
                                    final item =
                                        catat_c.list_id_kandang.firstWhere(
                                      (e) => e['shed_name'] == element,
                                      orElse: () => {"id": null},
                                    );
                                    if (item['id'] != null) {
                                      catat_c.listProblemSelected
                                          .add(item['id']);
                                    }
                                  });
                                },
                                // selectedItems: upload_c.name_kategori_produk.value,
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Container()),

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
                controller: catat_c.tanggal,
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
                    catat_c.tanggal.text = formattedDate.toString();
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
                height: 14,
              ),
              Text(
                "Deskripsi",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                // <--- SizedBox
                height: 200,
                child: TextField(
                  controller: catat_c.deksripsi,
                  cursorColor: Colors.red,
                  maxLines: 200 ~/ 20, // <--- maxLines
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0XFF71A841), width: 2.0),
                    ),
                    hintText: "Contoh : Peternakan ABC",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Foto Catatan Tidak Wajib",
                style: ThemesCustom.black_14_700,
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => catat_c.img.value != ""
                  ? Image.file(
                      File(catat_c.img.value),
                      height: 130,
                      fit: BoxFit.cover,
                    )
                  : Container()),
              InkWell(
                onTap: () async {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return HomePage();
                  // }));
                  XFile? picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    catat_c.img.value = picked.path;
                    // kandang_c.foto.value = picked.path;
                  }
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Color(0xff45B549)),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      "Pilih Foto",
                      style: ThemesCustom.green_16_700,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (_keyForm.currentState!.validate()) {
                    catat_c.simpanNote();
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
