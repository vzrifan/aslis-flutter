import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/ProfileController.dart';
import 'package:aslis_application/model/model_provinsi.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  // const UpdateProfilePage({Key? key}) : super(key: key);
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  ProfileController p_controller = Get.find();
  int change_provinsi = 0;
  int change_kota = 0;
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: () {
              if (_keyForm.currentState!.validate()) {
                p_controller.simpanProfile();
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Ubah Profile",
            style: ThemesCustom.black1_18_700,
          ),
        ),
        body: FutureBuilder(
          future: p_controller.getProfile(),
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
              return Form(
                key: _keyForm,
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => p_controller.change_img.value == 0
                              ? p_controller.foto_p.value == ""
                                  ? Center(
                                      child: Image(
                                          width: 84,
                                          height: 84,
                                          image: AssetImage(
                                              "assets/image/empty_profile.png")))
                                  : Center(
                                      child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              p_controller.foto_p.value)),
                                    ))
                              : Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      File(p_controller.foto_p.value),
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            XFile? picked = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (picked != null) {
                              p_controller.change_img.value = 1;
                              p_controller.foto_p.value = picked.path;
                            }
                          },
                          child: Center(
                            child: Text(
                              "Ganti Foto",
                              style: ThemesCustom.black_14_400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Nama Lengkap",
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
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.nama,
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
                          height: 11,
                        ),
                        Text(
                          "Nama Peternakan",
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
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.peternakan,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Nama Peternak",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        SizedBox(
                          height: 11,
                        ),
                        Text(
                          "Email",
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
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.email,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Email",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        SizedBox(
                          height: 11,
                        ),
                        // Text(
                        //   "Nomor Telepone",
                        //   style: ThemesCustom.black_14_700,
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.only(right: 10),
                        //       width: 86,
                        //       height: 44,
                        //       decoration: BoxDecoration(
                        //           color: Color.fromRGBO(35, 31, 32, 0.16),
                        //           borderRadius: BorderRadius.circular(50)),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Image(
                        //               image: AssetImage(
                        //                   "assets/image/indonesia.png")),
                        //           SizedBox(
                        //             width: 10,
                        //           ),
                        //           Text(
                        //             "+62",
                        //             style: ThemesCustom.black1_16_700,
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //         child: TextFormField(
                        //             validator: (value) {
                        //               if (value == null ||
                        //                   value.isEmpty ||
                        //                   value.length < 6) {
                        //                 return 'Password tidak valid';
                        //               }
                        //               return null;
                        //             },
                        //             decoration: InputDecoration(
                        //               focusedBorder: OutlineInputBorder(
                        //                 borderSide: const BorderSide(
                        //                     color: Color(0XFF71A841), width: 2.0),
                        //               ),
                        //               hintText: "0812345678",
                        //               contentPadding: EdgeInsets.all(12),
                        //               border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(8.0),
                        //               ),
                        //             )))
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 11,
                        // ),
                        Text(
                          "NIK",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 16) {
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.nik,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Masukan NIK",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        SizedBox(
                          height: 11,
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
                                    groupValue:
                                        p_controller.jenis_kelamin.value,
                                    onChanged: (val) {
                                      if (val != null) {
                                        p_controller.jenis_kelamin.value =
                                            val as int;
                                      }
                                    }),
                                Text(
                                  "Pria",
                                  style: ThemesCustom.black1_16_700,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Radio(
                                    value: 2,
                                    groupValue:
                                        p_controller.jenis_kelamin.value,
                                    onChanged: (val) {
                                      if (val != null) {
                                        p_controller.jenis_kelamin.value =
                                            val as int;
                                      }
                                    }),
                                Text(
                                  "Wanita",
                                  style: ThemesCustom.black1_16_700,
                                )
                              ],
                            )),
                        SizedBox(
                          height: 11,
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
                            if (value == null || value.isEmpty) {
                              return 'Tanggal Lahir Tidak Boleh Kosong';
                            }
                            return null;
                          },
                          controller: p_controller.tanggal_lahir,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            String dateShow = "";
                            if (p_controller.tanggal_lahir.text != null) {
                              dateShow = p_controller.tanggal_lahir.text;
                            } else {
                              dateShow = "1990-01-01";
                            }
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    p_controller.tanggal_lahir.text == ""
                                        ? DateTime.now()
                                        : DateTime.parse(
                                            p_controller.tanggal_lahir.text),
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
                              //you can implement different kind of Date Format here according to your requirement
                              p_controller.tanggal_lahir.text =
                                  formattedDate.toString();
                              // setState(() {
                              //   dateinput.text =
                              //       formattedDate; //set output date to TextField value.
                              // });
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

                        // TextFormField(
                        //     validator: (value) {
                        //       if (value == null ||
                        //           value.isEmpty ||
                        //           value.length < 6) {
                        //         return 'Password tidak valid';
                        //       }
                        //       return null;
                        //     },
                        //     decoration: InputDecoration(
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: const BorderSide(
                        //             color: Color(0XFF71A841), width: 2.0),
                        //       ),
                        //       hintText: "*************",
                        //       contentPadding: EdgeInsets.all(12),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        //     )),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Negara",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Indonesia",
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

                        Obx(() => DropdownSearch<ProvinceModel>(
                              selectedItem: ProvinceModel(
                                  id: 1,
                                  name: p_controller.nama_provinsi.value),
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
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                              asyncItems: (text) async {
                                var uri_api = Uri.parse(ApiService.baseUrl +
                                    "/get_data/address/province");
                                var is_token = "Bearer " + box.read("token");
                                var respone = await http.get(uri_api,
                                    headers: {"Authorization": is_token});
                                print(json.decode(respone.body));
                                // var data = json.decode(respone.body);
                                var data = json.decode(respone.body)
                                    as Map<String, dynamic>;
                                var dataProvince =
                                    data['data'] as List<dynamic>;
                                var model =
                                    ProvinceModel.fromJsonList(dataProvince);
                                return model;
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  p_controller.id_provinsi.value =
                                      value.id.toString();
                                  p_controller.nama_provinsi.value =
                                      value.name.toString();

                                  p_controller.id_kota.value = "0";
                                  p_controller.nama_kota.value = "";

                                  p_controller.change_provinsi.value = 1;
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
                            )),
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
                        Obx(() => DropdownSearch<ProvinceModel>(
                              selectedItem: ProvinceModel(
                                  id: 1, name: p_controller.nama_kota.value),
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
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                              
                              asyncItems: (text) async {
                                var uri_api = Uri.parse(ApiService.baseUrl +
                                    "/get_data/address/city/" +
                                    p_controller.id_provinsi.value.toString());
                                var is_token = "Bearer " + box.read("token");
                                var respone = await http.get(uri_api,
                                    headers: {"Authorization": is_token});
                                print(json.decode(respone.body));

                                // var data = json.decode(respone.body);
                                var data = json.decode(respone.body)
                                    as Map<String, dynamic>;
                                var dataProvince =
                                    data['data'] as List<dynamic>;
                                var model =
                                    ProvinceModel.fromJsonList(dataProvince);
                                return model;
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  print(value.name);
                                  // setState(() {
                                  p_controller.id_kota.value =
                                      value.id.toString();
                                  p_controller.nama_kota.value =
                                      value.name.toString();
                                  p_controller.change_provinsi.value = 0;

                                  // });
                                }
                              },
                              itemAsString: (item) {
                                if (p_controller.change_provinsi.value == 1) {
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
                            )),
                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "Kode Pos",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 4) {
                                return 'Kode Pos tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.kode_pos,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Kode Pos",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        SizedBox(
                          height: 11,
                        ),

                        Text(
                          "Jalan",
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
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            controller: p_controller.jalan,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "Masukan Nama Jalan",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
