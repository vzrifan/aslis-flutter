import 'dart:convert';
import 'dart:io';

import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/model/model_jenis_kambing.dart';
import 'package:aslis_application/model/model_kandang.dart';
import 'package:aslis_application/model/model_kandung_kambing.dart';
import 'package:aslis_application/ui/kambing/player_video.dart';
import 'package:aslis_application/ui/kandang/tambah_kandang.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddGoat extends StatefulWidget {
  @override
  State<AddGoat> createState() => _AddGoatState();
}

class _AddGoatState extends State<AddGoat> {
  // const AddGoat({Key? key}) : super(key: key);
  KambingController kandang_c = Get.find();
  final kan_controller = Get.put(KandangController());
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("Loaded");
    kan_controller.GetKandang("");

    print("Kosong");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 30), () {
        if (kan_controller.listKandang.length == 0) {
          showModalTwo(context);
        }
      });

      //  displaySheet();
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("Your Barcode Is" + barcodeScanRes);
      kandang_c.id_hewan.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   // _scanBarcode = barcodeScanRes;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Hewan",
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
          child: FutureBuilder(
        future: kan_controller.GetKandang(""), //TODO
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            // if (kan_controller.listKandang.length == 0) {
            //   print("Kosong");
            //   showModalTwo();
            // }
            return Form(
              key: _keyForm,
              child: Column(
                children: [
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
                              // XFile? picked = await _picker.pickImage(
                              //     source: ImageSource.gallery);
                              // if (picked != null) {
                              //   kandang_c.foto.value = picked.path;
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 8, bottom: 10),
                              child: Obx(() => kandang_c.foto.value == ""
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
                                  :
                                  // Image(
                                  //     fit: BoxFit.cover,
                                  //     width: double.infinity,
                                  //     height: 130,
                                  //     image: CachedNetworkImageProvider(
                                  //         kandang_c.foto.value)),
                                  Image.file(
                                      File(kandang_c.foto.value),
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                menuModal(1);
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
                              menuModal(2);
                              // XFile? picked = await _picker.pickImage(
                              //     source: ImageSource.gallery);
                              // if (picked != null) {
                              //   kandang_c.foto.value = picked.path;
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 8, bottom: 10),
                              child: Obx(() => kandang_c.foto2.value == ""
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
                                  :
                                  // Image(
                                  //     fit: BoxFit.cover,
                                  //     width: double.infinity,
                                  //     height: 130,
                                  //     image: CachedNetworkImageProvider(
                                  //         kandang_c.foto2.value)),
                                  Image.file(
                                      File(kandang_c.foto2.value),
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
                              child: Obx(() => kandang_c.foto3.value == ""
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
                                  :
                                  // Image(
                                  //       fit: BoxFit.cover,
                                  //       width: double.infinity,
                                  //       height: 130,
                                  //       image: CachedNetworkImageProvider(
                                  //           kandang_c.foto3.value)),
                                  Image.file(
                                      File(kandang_c.foto3.value),
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
                              child: Obx(() => kandang_c.foto4.value == ""
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
                                  :
                                  // Image(
                                  //     fit: BoxFit.cover,
                                  //     width: double.infinity,
                                  //     height: 130,
                                  //     image: CachedNetworkImageProvider(
                                  //         kandang_c.foto4.value)),
                                  Image.file(
                                      File(kandang_c.foto4.value),
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
                              child: Obx(() => kandang_c.video.value == ""
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
                                                      fontFamily:
                                                          "Product Sans",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w100,
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return VideoApp(
                                            link: kandang_c.video.value,
                                          );
                                        }));
                                      },
                                      child: Image(
                                          height: 70,
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
                                  controller: kandang_c.id_hewan,
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
                                icon: Image(
                                    image:
                                        AssetImage("assets/image/i_scan.png")))
                          ],
                        ),
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
                            controller: kandang_c.nama_hewan,
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
                          "Jenis hewan",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownSearch<JenisKambingModel>(
                          validator: (value) {
                            if (value == null) {
                              return 'Jenis hewan tidak valid';
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
                                "/get_data/category_cattle");
                            var is_token = "Bearer " + box.read("token");
                            var respone = await http.get(uri_api,
                                headers: {"Authorization": is_token});
                            print(json.decode(respone.body));
                            // var data = json.decode(respone.body);
                            var data = json.decode(respone.body)
                                as Map<String, dynamic>;
                            var dataProvince = data['data'] as List<dynamic>;
                            var model =
                                JenisKambingModel.fromJsonList(dataProvince);
                            return model;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              // muhib
                              kandang_c.id_jenis_kambing.value = value.id;
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
                                  groupValue: kandang_c.jk.value,
                                  onChanged: (val) {
                                    kandang_c.jk.value = val as int;
                                  },
                                ),
                                Text("Jantan"),
                                SizedBox(
                                  width: 10,
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: kandang_c.jk.value,
                                  onChanged: (val) {
                                    kandang_c.jk.value = val as int;
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
                                kandang_c.is_internal.value = 1;
                              } else {
                                kandang_c.is_internal.value = 2;
                              }
                            },
                            selectedItem: "Internal"),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(() => kandang_c.is_internal.value == 1
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
                                    controller: kandang_c.tanggal_lahir,
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
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: kandang_c
                                                          .tanggal_lahir.text ==
                                                      ""
                                                  ? DateTime.now()
                                                  : DateTime.parse(kandang_c
                                                      .tanggal_lahir.text),
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
                                        kandang_c.tanggal_lahir.text =
                                            formattedDate.toString();
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },

                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                  DropdownSearch<ParentKambingModel>(
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
                                      // var data = json.decode(respone.body);
                                      var data = json.decode(respone.body)
                                          as Map<String, dynamic>;
                                      var dataProvince =
                                          data['data'] as List<dynamic>;
                                      print("Tested");
                                      print(dataProvince);
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
                                        kandang_c.induk_jantan.value = value.id;
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
                                  ),
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
                                  DropdownSearch<ParentKambingModel>(
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
                                        // muhib
                                        kandang_c.induk_betian.value = value.id;
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
                                  ),
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
                                    controller: kandang_c.tanggal_lahir,
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
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: kandang_c
                                                          .tanggal_lahir.text ==
                                                      ""
                                                  ? DateTime.now()
                                                  : DateTime.parse(kandang_c
                                                      .tanggal_lahir.text),
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
                                        kandang_c.tanggal_lahir.text =
                                            formattedDate.toString();
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },

                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      controller: kandang_c.harga_eks,
                                      inputFormatters: [
                                        CurrencyTextInputFormatter(
                                          symbol: "",
                                          decimalDigits: 0,
                                        )
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0XFF71A841),
                                              width: 2.0),
                                        ),
                                        hintText: "",
                                        prefix: Text("Rp. "),
                                        contentPadding: EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                        TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Berat tidak valid';
                              }
                              return null;
                            },
                            controller: kandang_c.berat_hewan,
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
                              // muhib
                              kandang_c.kandang.value = value.id;
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
                              // login_c.sendLogin();
                              kandang_c.getKandnag();
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
            );
          }
        },
      )),
    );
  }

  // box pilih by camera or phone
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
                try {
                  XFile? picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    if (type == 1) {
                      kandang_c.foto.value = picked.path;
                    } else if (type == 2) {
                      kandang_c.foto2.value = picked.path;
                    } else if (type == 3) {
                      kandang_c.foto3.value = picked.path;
                    } else if (type == 4) {
                      kandang_c.foto4.value = picked.path;
                    } else if (type == 5) {
                      // kandang_c.foto2.value = picked.path;
                    }
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(), // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.BOTTOM, // location
                  );
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
                try {
                  XFile? picked =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    // upload nanti
                    if (type == 1) {
                      kandang_c.foto.value = picked.path;
                    } else if (type == 2) {
                      kandang_c.foto2.value = picked.path;
                    } else if (type == 3) {
                      kandang_c.foto3.value = picked.path;
                    } else if (type == 4) {
                      kandang_c.foto4.value = picked.path;
                    } else if (type == 5) {
                      // kandang_c.foto2.value = picked.path;
                    }
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(), // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.BOTTOM, // location
                  );
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
                  kandang_c.SingleUploadByAdd(picked.path, type);
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
                  kandang_c.video.value = picked.path;
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
