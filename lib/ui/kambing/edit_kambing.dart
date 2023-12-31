import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/model/model_jenis_kambing.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/model/model_kandung_kambing.dart';
import 'package:aslis_application/ui/kambing/player_video.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EditGoat extends StatelessWidget {
  // const EditGoat({Key? key}) : super(key: key);
  KambingController kandang_c = Get.find();
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Hewan",
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
            children: [
              // image multiple
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          menuModal(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 10),
                          child: Obx(() => kandang_c.foto_u.value == ""
                              ? DottedBorder(
                                  radius: Radius.circular(50),
                                  color: Colors.black,
                                  dashPattern: [8, 4],
                                  strokeWidth: 2,
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Tambah",
                                            style: TextStyle(
                                                fontFamily: "Product Sans",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w100,
                                                color: Color(0xff323338)))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                )
                              : (kandang_c.is_change_foto1.value == 0)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 70,
                                      image: CachedNetworkImageProvider(
                                          kandang_c.foto_u.value))
                                  : Image.file(
                                      File(kandang_c.foto_u.value),
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            menuModal(1);
                          },
                          child: Center(child: Text("Pilih Foto"))),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          menuModal(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 10),
                          child: Obx(() => kandang_c.foto2_u.value == ""
                              ? DottedBorder(
                                  radius: Radius.circular(50),
                                  color: Colors.black,
                                  dashPattern: [8, 4],
                                  strokeWidth: 2,
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Tambah",
                                            style: TextStyle(
                                                fontFamily: "Product Sans",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w100,
                                                color: Color(0xff323338)))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                )
                              : (kandang_c.is_change_foto2.value == 0)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 70,
                                      image: CachedNetworkImageProvider(
                                          kandang_c.foto2_u.value))
                                  : Image.file(
                                      File(kandang_c.foto2_u.value),
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            menuModal(2);
                            // XFile? picked = await _picker.pickImage(
                            //     source: ImageSource.gallery);
                            // if (picked != null) {
                            //   kandang_c.foto.value = picked.path;
                            // }
                          },
                          child: Center(child: Text("Pilih Foto"))),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          menuModal(3);
                          // XFile? picked = await _picker.pickImage(
                          //     source: ImageSource.gallery);
                          // if (picked != null) {
                          //   kandang_c.foto.value = picked.path;
                          // }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 10),
                          child: Obx(() => kandang_c.foto3_u.value == ""
                              ? DottedBorder(
                                  radius: Radius.circular(50),
                                  color: Colors.black,
                                  dashPattern: [8, 4],
                                  strokeWidth: 2,
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Tambah",
                                            style: TextStyle(
                                                fontFamily: "Product Sans",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w100,
                                                color: Color(0xff323338)))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                )
                              : (kandang_c.is_change_foto3.value == 0)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 70,
                                      image: CachedNetworkImageProvider(
                                          kandang_c.foto3_u.value))
                                  : Image.file(
                                      File(kandang_c.foto3_u.value),
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            menuModal(3);
                            // XFile? picked = await _picker.pickImage(
                            //     source: ImageSource.gallery);
                            // if (picked != null) {
                            //   kandang_c.foto.value = picked.path;
                            // }
                          },
                          child: Center(child: Text("Pilih Foto"))),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          menuModal(4);
                          // XFile? picked = await _picker.pickImage(
                          //     source: ImageSource.gallery);
                          // if (picked != null) {
                          //   kandang_c.foto.value = picked.path;
                          // }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 10),
                          child: Obx(() => kandang_c.foto4_u.value == ""
                              ? DottedBorder(
                                  radius: Radius.circular(50),
                                  color: Colors.black,
                                  dashPattern: [8, 4],
                                  strokeWidth: 2,
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Tambah",
                                            style: TextStyle(
                                                fontFamily: "Product Sans",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w100,
                                                color: Color(0xff323338)))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                )
                              : (kandang_c.is_change_foto4.value == 0)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 70,
                                      image: CachedNetworkImageProvider(
                                          kandang_c.foto4_u.value))
                                  : Image.file(
                                      File(kandang_c.foto4_u.value),
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            menuModal(4);
                            // XFile? picked = await _picker.pickImage(
                            //     source: ImageSource.gallery);
                            // if (picked != null) {
                            //   kandang_c.foto.value = picked.path;
                            // }
                          },
                          child: Center(child: Text("Pilih Foto"))),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 10),
                          child: Obx(() => kandang_c.video_u.value == ""
                              ? InkWell(
                                  onTap: () {
                                    menuModalVideo(5);
                                  },
                                  child: DottedBorder(
                                    radius: Radius.circular(50),
                                    color: Colors.black,
                                    dashPattern: [8, 4],
                                    strokeWidth: 2,
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Tambah",
                                              style: TextStyle(
                                                  fontFamily: "Product Sans",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w100,
                                                  color: Color(0xff323338)))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return VideoApp(
                                        link: kandang_c.video_u.value,
                                      );
                                    }));
                                  },
                                  child: Image(
                                      height: 60,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/image/preview_video.png"))))),
                      InkWell(
                          onTap: () async {
                            menuModalVideo(5);

                            // XFile? picked = await _picker.pickImage(
                            //     source: ImageSource.gallery);
                            // if (picked != null) {
                            //   kandang_c.video.value = picked.path;
                            // }
                          },
                          child: Center(child: Text("Pilih Video"))),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 40, right: 40, top: 8, bottom: 10),
              //   child: Obx(() => kandang_c.change_img.value == 1
              //       ? Image.file(
              //           File(kandang_c.foto_u.value),
              //           height: 130,
              //           fit: BoxFit.cover,
              //         )
              //       : (kandang_c.foto_u.value != "" ||
              //               kandang_c.foto_u.value !=
              //                   "https://souq.s3-id-jkt-1.kilatstorage.id/")
              //           ? Image(
              //               width: double.infinity,
              //               height: 130,
              //               fit: BoxFit.cover,
              //               image: CachedNetworkImageProvider(
              //                   kandang_c.foto_u.value))
              //           : Image(
              //               width: double.infinity,
              //               height: 130,
              //               fit: BoxFit.cover,
              //               image: AssetImage("assets/image/kambing2.png"))),
              // ),
              // InkWell(
              //     onTap: () async {
              //       XFile? picked =
              //           await _picker.pickImage(source: ImageSource.gallery);
              //       if (picked != null) {
              //         kandang_c.foto_u.value = picked.path;
              //         kandang_c.change_img.value = 1;
              //       }
              //     },
              //     child: Center(child: Text("Pilih Foto"))),
              Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ID Hewan",
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
                            return 'Id Peternak tidak valid';
                          }
                          return null;
                        },
                        controller: kandang_c.id_hewan_u,
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Nama Hewan",
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
                            return 'Hewan tidak valid';
                          }
                          return null;
                        },
                        controller: kandang_c.nama_hewan_u,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),
                          hintText: "Contoh : Hewan ABC",
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Jenis Kambing",
                      style: ThemesCustom.black_14_700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownSearch<JenisKambingModel>(
                      selectedItem: JenisKambingModel(
                          id: kandang_c.id_jenis_kambing_u.value,
                          name: kandang_c.name_jenis_kambing_u.value),
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
                        var respone = await http
                            .get(uri_api, headers: {"Authorization": is_token});
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
                          kandang_c.id_jenis_kambing_u.value = value.id;
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
                      "Jenis Kelamin",
                      style: ThemesCustom.black_14_700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: kandang_c.jk_u.value,
                              onChanged: (val) {
                                kandang_c.jk_u.value = val as int;
                              },
                            ),
                            Text("Jantan"),
                            SizedBox(
                              width: 10,
                            ),
                            Radio(
                              value: 2,
                              groupValue: kandang_c.jk_u.value,
                              onChanged: (val) {
                                kandang_c.jk_u.value = val as int;
                              },
                            ),
                            Text("Betina")
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 7,
                color: Color(0xffF2F6FF),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Asal Usul",
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
                          if (val == "Internal") {
                            kandang_c.is_internal_u.value = 1;
                          } else {
                            kandang_c.is_internal_u.value = 2;
                          }
                        },
                        selectedItem: kandang_c.is_internal_u.value == 1
                            ? "Internal"
                            : "Eksternal"),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => kandang_c.is_internal_u.value == 1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal Lahir",
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
                                controller: kandang_c.tanggal_lahir_u,
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
                                      initialDate: kandang_c
                                                  .tanggal_lahir_u.text ==
                                              ""
                                          ? DateTime.now()
                                          : DateTime.parse(
                                              kandang_c.tanggal_lahir_u.text),
                                      firstDate: DateTime(
                                          1970), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    kandang_c.tanggal_lahir_u.text =
                                        formattedDate.toString();
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
                                "Induk Jantan",
                                style: ThemesCustom.black_14_700,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Obx(() => DropdownSearch<ParentKambingModel>(
                                    selectedItem: ParentKambingModel(
                                        id: kandang_c.induk_jantan_u.value,
                                        cattleId: "",
                                        cattleName: kandang_c
                                                    .name_induk_jantan_u
                                                    .value ==
                                                " - "
                                            ? "Tidak Diketahui"
                                            : kandang_c
                                                .name_induk_jantan_u.value),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Induk tidak valid';
                                      }
                                      return null;
                                    },
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          hintText: "Pilih",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 1, horizontal: 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                    ),
                                    asyncItems: (text) async {
                                      var uri_api = Uri.parse(
                                          ApiService.baseUrl +
                                              "/get_data/male_parent");
                                      var is_token =
                                          "Bearer " + box.read("token");
                                      var respone = await http.get(uri_api,
                                          headers: {"Authorization": is_token});
                                      print(json.decode(respone.body));
                                      // var data = json.decode(respone.body);
                                      var data = json.decode(respone.body)
                                          as Map<String, dynamic>;
                                      var dataProvince =
                                          data['data'] as List<dynamic>;
                                      dataProvince.add({
                                        "id": "",
                                        "cattle_name": "Tidak Diketahui",
                                        "cattle_id": "-"
                                      });
                                      var model =
                                          ParentKambingModel.fromJsonList(
                                              dataProvince);
                                      return model;
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        // muhib
                                        kandang_c.induk_jantan_u.value =
                                            value.id;
                                        kandang_c.name_induk_jantan_u.value =
                                            value.cattleName;
                                      }
                                    },
                                    itemAsString: (item) => item!.cattleName,
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      itemBuilder: (context, item, isSelected) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text("${item.cattleName}"),
                                        );
                                      },
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Induk Betina",
                                style: ThemesCustom.black_14_700,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Obx(() => DropdownSearch<ParentKambingModel>(
                                    selectedItem: ParentKambingModel(
                                        id: kandang_c.induk_betian_u.value,
                                        cattleId: "",
                                        cattleName: kandang_c
                                                    .name_induk_betian_u
                                                    .value ==
                                                " - "
                                            ? "Tidak Diketahui"
                                            : kandang_c
                                                .name_induk_betian_u.value),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Induk tidak valid';
                                      }
                                      return null;
                                    },
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          hintText: "Pilih",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 1, horizontal: 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                    ),
                                    asyncItems: (text) async {
                                      var uri_api = Uri.parse(
                                          ApiService.baseUrl +
                                              "/get_data/female_parent");
                                      var is_token =
                                          "Bearer " + box.read("token");
                                      var respone = await http.get(uri_api,
                                          headers: {"Authorization": is_token});
                                      print(json.decode(respone.body));
                                      // var data = json.decode(respone.body);
                                      var data = json.decode(respone.body)
                                          as Map<String, dynamic>;
                                      var dataProvince =
                                          data['data'] as List<dynamic>;
                                      dataProvince.add({
                                        "id": "",
                                        "cattle_name": "Tidak Diketahui",
                                        "cattle_id": "-"
                                      });
                                      var model =
                                          ParentKambingModel.fromJsonList(
                                              dataProvince);
                                      return model;
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        kandang_c.induk_betian_u.value =
                                            value.id;
                                        kandang_c.name_induk_betian_u.value =
                                            value.cattleName;
                                      }
                                    },
                                    itemAsString: (item) => item!.cattleName,
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      itemBuilder: (context, item, isSelected) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text("${item.cattleName}"),
                                        );
                                      },
                                    ),
                                  )),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal Pembelian",
                                style: ThemesCustom.black_14_700,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tanggal Pembelian Tidak Boleh Kosong';
                                  }
                                  return null;
                                },
                                controller: kandang_c.tanggal_beli,
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
                                      initialDate:
                                          kandang_c.tanggal_beli.text == ""
                                              ? DateTime.parse("1990-01-01")
                                              : DateTime.parse(
                                                  kandang_c.tanggal_beli.text),
                                      firstDate: DateTime(
                                          1970), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    kandang_c.tanggal_beli.text =
                                        formattedDate.toString();
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
                                "Harga",
                                style: ThemesCustom.black_14_700,
                              ),
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
                                  controller: kandang_c.harga_eks_u,
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
                          ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 7,
                color: Color(0xffF2F6FF),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Berat",
                      style: ThemesCustom.black_14_700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    kandang_c.is_weight.value != 0
                        ? TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Berat tidak valid';
                              }
                              return null;
                            },
                            controller: kandang_c.berat_hewan_u,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Contoh : Peternakan ABC",
                              suffix: Text("Kg"),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Kandang",
                      style: ThemesCustom.black_14_700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    kandang_c.is_kandang.value != 0
                        ? DropdownSearch<KandangModel>(
                            enabled: true,
                            selectedItem: KandangModel(
                                id: kandang_c.kandang_u.value,
                                numberOfCattle: 0,
                                shedId: "",
                                shedName: kandang_c.name_kandang_u.value,
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
                              var uri_api = Uri.parse(
                                  ApiService.baseUrl + "/get_data/shed");
                              var is_token = "Bearer " + box.read("token");
                              var respone = await http.get(uri_api,
                                  headers: {"Authorization": is_token});
                              print(json.decode(respone.body));
                              // var data = json.decode(respone.body);
                              var data = json.decode(respone.body)
                                  as Map<String, dynamic>;
                              var dataProvince = data['data'] as List<dynamic>;
                              var model =
                                  KandangModel.fromJsonList(dataProvince);
                              return model;
                            },
                            onChanged: (value) {
                              if (value != null) {
                                // muhib
                                kandang_c.kandang_u.value = value.id;
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
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (_keyForm.currentState!.validate()) {
                          // login_c.sendLogin();
                          kandang_c.ubahKambing();
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void menuModal(
    int type,
  ) {
    Get.defaultDialog(
        title: 'Pilih Gambar',
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
              onTap: () async {
                Get.close(0);
                XFile? picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  // upload langsung ke data
                  // kandang_c.SingleUploadByAdd(picked.path, type);

                  // upload terlambant
                  if (type == 1) {
                    kandang_c.foto_u.value = picked.path;
                    kandang_c.is_change_foto1.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto_id.value);
                    kandang_c.foto_on_change.value = picked.path;
                  } else if (type == 2) {
                    kandang_c.foto2_u.value = picked.path;
                    kandang_c.is_change_foto2.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto2_id.value);
                    kandang_c.foto2_on_change.value = picked.path;
                  } else if (type == 3) {
                    kandang_c.foto3_u.value = picked.path;
                    kandang_c.is_change_foto3.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto3_id.value);
                    kandang_c.foto3_on_change.value = picked.path;
                  } else if (type == 4) {
                    kandang_c.foto4_u.value = picked.path;
                    kandang_c.is_change_foto4.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto4_id.value);
                    kandang_c.foto4_on_change.value = picked.path;
                  } else if (type == 5) {
                    // kandang_c.foto2.value = picked.path;
                  }
                }
                // confirm_delete(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Dari Galeri",
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
              onTap: () async {
                Get.close(0);
                XFile? picked =
                    await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  // kandang_c.foto.value = picked.path;
                  // upload langsung ke cloud
                  // kandang_c.SingleUploadByAdd(picked.path, type);

                  // upload nanti
                  if (type == 1) {
                    kandang_c.foto_u.value = picked.path;
                    kandang_c.is_change_foto1.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto_id.value);
                    kandang_c.foto_on_change.value = picked.path;
                    print(kandang_c.foto_on_change.value);
                  } else if (type == 2) {
                    kandang_c.foto2_u.value = picked.path;
                    kandang_c.is_change_foto2.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto2_id.value);
                    kandang_c.foto2_on_change.value = picked.path;
                  } else if (type == 3) {
                    kandang_c.foto3_u.value = picked.path;
                    kandang_c.is_change_foto3.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto3_id.value);
                    kandang_c.foto3_on_change.value = picked.path;
                  } else if (type == 4) {
                    kandang_c.foto4_u.value = picked.path;
                    kandang_c.is_change_foto4.value = 1;
                    kandang_c.hapusGambarKambing(kandang_c.foto4_id.value);
                    kandang_c.foto4_on_change.value = picked.path;
                  } else if (type == 5) {
                    // kandang_c.foto2.value = picked.path;
                  }
                }
                // confirm_delete(id);
                // Get.to(() => EditPakanPage(
                //       id: id,
                //     ));
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Dari Camera",
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
          ],
        ),
        radius: 10.0);
  }

  void menuModalVideo(
    int type,
  ) {
    Get.defaultDialog(
        title: 'Pilih Gambar',
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
              onTap: () async {
                Get.close(0);
                XFile? picked =
                    await _picker.pickVideo(source: ImageSource.gallery);
                if (picked != null) {
                  kandang_c.video_u.value = picked.path;
                  kandang_c.hapusGambarKambing(kandang_c.video_id.value);
                  kandang_c.video_on_change.value = picked.path;
                  // kandang_c.SingleUploadByAdd(picked.path, type);
                  print(picked.path);
                  // if (type == 1) {
                  //   kandang_c.foto.value = picked.path;
                  // } else if (type == 2) {
                  //   kandang_c.foto2.value = picked.path;
                  // } else if (type == 3) {
                  //   kandang_c.foto3.value = picked.path;
                  // } else if (type == 4) {
                  //   kandang_c.foto4.value = picked.path;
                  // } else if (type == 5) {
                  //   // kandang_c.foto2.value = picked.path;
                  // }
                }
                // confirm_delete(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Dari Galeri",
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
              onTap: () async {
                print("Kosong tesggg");
                Get.close(0);
                XFile? picked =
                    await _picker.pickVideo(source: ImageSource.camera);
                if (picked != null) {
                  kandang_c.video_u.value = picked.path;
                  kandang_c.hapusGambarKambing(kandang_c.video_id.value);
                  kandang_c.video_on_change.value = picked.path;
                  // kandang_c.SingleUploadByAdd(picked.path, type);
                  // print(picked.path);

                  // if (type == 1) {
                  //   kandang_c.foto.value = picked.path;
                  // } else if (type == 2) {
                  //   kandang_c.foto2.value = picked.path;
                  // } else if (type == 3) {
                  //   kandang_c.foto3.value = picked.path;
                  // } else if (type == 4) {
                  //   kandang_c.foto4.value = picked.path;
                  // } else if (type == 5) {
                  //   // kandang_c.foto2.value = picked.path;
                  // }
                }
                // confirm_delete(id);
                // Get.to(() => EditPakanPage(
                //       id: id,
                //     ));
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Dari Camera ",
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
          ],
        ),
        radius: 10.0);
  }
}
