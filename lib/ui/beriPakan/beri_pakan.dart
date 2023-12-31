import 'dart:convert';

import 'package:aslis_application/controller/pakan_controller.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/model/model_kategori_makanan.dart';
import 'package:aslis_application/ui/kandang/tambah_kandang.dart';
import 'package:aslis_application/ui/pakan/tambah_pakan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BeriPakan extends StatelessWidget {
  // const BeriPakan({Key? key}) : super(key: key);
  final box = GetStorage();
  final pakan_c = Get.put(PakanController());
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                    "Beri Pakan",
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
                  "Pakan",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),

                FutureBuilder(
                  future: pakan_c.getListPakan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return InkWell(
                        onTap: () {
                          // print("Kurang");
                          showModalTwo("Pesan", context);
                        },
                        child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Pilih",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                      );
                    } else {
                      if (pakan_c.listpakanKategori.length == 0) {
                        return InkWell(
                          onTap: () {
                            // print("Kurang");
                            showModalTwo("Pesan", context);
                          },
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Pilih",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                        );
                      } else {
                        return DropdownSearch<KategoriMakananModel>(
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
                            var uri_api = Uri.parse(
                                ApiService.baseUrl + "/get_data/food");
                            var is_token = "Bearer " + box.read("token");
                            var respone = await http.get(uri_api,
                                headers: {"Authorization": is_token});
                            print(json.decode(respone.body));
                            // var data = json.decode(respone.body);
                            var data = json.decode(respone.body)
                                as Map<String, dynamic>;
                            var dataProvince = data['data'] as List<dynamic>;
                            var model =
                                KategoriMakananModel.fromJsonList(dataProvince);
                            return model;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              pakan_c.pakan_beri.value = value.id;
                            }
                          },
                          itemAsString: (item) => item!.foodName,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            itemBuilder: (context, item, isSelected) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Text("${item.foodName}"),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),

                // InputDecorator(
                //   decoration: InputDecoration(
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 1, horizontal: 20),
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8))),
                //   child: DropdownButtonHideUnderline(
                //       child: DropdownButtonFormField<String>(
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Jenis Kelamin Boleh Kosong';
                //       }
                //       return null;
                //     },
                //     hint: Text("Jenis Kelamin",
                //         style: GoogleFonts.montserrat(
                //             fontSize: 12,
                //             color: Color(0xff999999),
                //             fontWeight: FontWeight.bold)),
                //     items: <String>[
                //       'Pilih Jenis Kelaim',
                //       'Laki Laki',
                //       'Perempuan'
                //     ].map((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     onChanged: (select) {
                //       print(select);
                //     },
                //   )),
                // ),
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

                // DropdownSearch<KandangModel>(
                //   validator: (value) {
                //     if (value == null) {
                //       return 'Kandang tidak valid';
                //     }
                //     return null;
                //   },
                //   dropdownSearchDecoration: InputDecoration(
                //       hintText: "Pilih",
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 1, horizontal: 20),
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8))),
                //   onFind: (text) async {
                //     var uri_api =
                //         Uri.parse(ApiService.baseUrl + "/get_data/shed");
                //     var is_token = "Bearer " + box.read("token");
                //     var respone = await http
                //         .get(uri_api, headers: {"Authorization": is_token});
                //     print(json.decode(respone.body));
                //     // var data = json.decode(respone.body);
                //     var data =
                //         json.decode(respone.body) as Map<String, dynamic>;
                //     var dataProvince = data['data'] as List<dynamic>;
                //     var model = KandangModel.fromJsonList(dataProvince);
                //     return model;
                //   },
                //   onChanged: (value) {
                //     if (value != null) {
                //       pakan_c.kandang_beri.value = value.id;
                //       // kandang_c.kandang.value = value.id;
                //     }
                //   },
                //   itemAsString: (item) => item!.shedName,
                //   showSearchBox: true,
                //   popupItemBuilder: (context, item, isSelected) {
                //     return Container(
                //       padding: EdgeInsets.all(10),
                //       child: Text("${item.shedName}"),
                //     );
                //   },
                // ),

                FutureBuilder(
                  future: pakan_c.getListKandang(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return InkWell(
                        onTap: () {
                          // print("Kurang");
                          showModalKandang("Pesan", context);
                        },
                        child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Pilih",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                      );
                    } else {
                      if (pakan_c.listkandangKategori.length == 0) {
                        return InkWell(
                          onTap: () {
                            // print("Kurang");
                            showModalKandang("Pesan", context);
                          },
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Pilih",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                        );
                      } else {
                        return DropdownSearch<KandangModel>(
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
                            var model = KandangModel.fromJsonList(dataProvince);
                            return model;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              pakan_c.kandang_beri.value = value.id;
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
                        );
                      }
                    }
                  },
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
                  controller: pakan_c.tanggal_beri,
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
                      pakan_c.tanggal_beri.text = formattedDate.toString();
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
                  "Berat",
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
                    controller: pakan_c.berat_beri,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffix: Text("Kg"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0XFF71A841), width: 2.0),
                      ),
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
                      pakan_c.beriPakan();
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
                        "Beri Pakan",
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

  // modal ketika pakan kosong
  void showModalTwo(String pesan, BuildContext ctx) {
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
                      image: AssetImage("assets/image/empty_pakan.png")),
                ),
                Text(
                  "Buat Pakan Terlebih Dahulu",
                  style: ThemesCustom.black_14_700,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: InkWell(
                    onTap: () {
                      Get.close(0);
                      Navigator.push(ctx, MaterialPageRoute(builder: (context) {
                        return TambahPakanPage();
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
                          "Tambah Pakan",
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

  void showModalKandang(String pesan, BuildContext ctx) {
    // showDialog(
    //     context: ctx,
    //     builder: (context) {
    //       Future.delayed(Duration(seconds: 1000), () {
    //         Navigator.of(context).pop(true);
    //       });
    //       return AlertDialog(
    //           insetPadding: EdgeInsets.all(8.0),
    //           title: Text(
    //             "Time to go pro!",
    //             textAlign: TextAlign.center,
    //           ),
    //           content: Container(
    //             width: MediaQuery.of(context).size.width,
    //             child: Text("Teste"),
    //             //   child: BuySheet(
    //             //       applePayEnabled: applePayEnabled,
    //             //       googlePayEnabled: googlePayEnabled,
    //             //       applePayMerchantId: applePayMerchantId,
    //             //       squareLocationId: squareLocationId),
    //             // ),
    //           ));
    //     });

    Get.defaultDialog(
        title: '',
        // backgroundColor: Colors.red,
        // contentPadding: EdgeInsets.all(200),

        titleStyle: GoogleFonts.montserrat(
            fontSize: 2, color: Color(0xff333333), fontWeight: FontWeight.bold),
        content: Container(
          width: MediaQuery.of(ctx).size.width,
          height: MediaQuery.of(ctx).size.height - 300,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Image(
                    width: 200,
                    height: 300,
                    image: AssetImage("assets/image/empty_kandang_2.png")),
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
                        border: Border.all(color: Color(0xff45B549), width: 1),
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
        radius: 10.0);
  }
}
