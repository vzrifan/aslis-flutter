import 'dart:convert';

import 'package:aslis_application/ui/kambing/detail_kambing.dart';
import 'package:aslis_application/ui/kambing/kambing_tab.dart';
import 'package:aslis_application/ui/kambing/list_kambing.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class KambingController extends GetxController {
  RxInt is_internal = 1.obs;
  TextEditingController tanggal_lahir = TextEditingController();
  RxString id_jenis_kambing = "".obs;
  TextEditingController id_hewan = TextEditingController();
  TextEditingController nama_hewan = TextEditingController();
  RxInt jk = 1.obs;
  RxString induk_jantan = "".obs;
  RxString induk_betian = "".obs;
  TextEditingController harga_eks = TextEditingController();
  TextEditingController berat_hewan = TextEditingController();
  RxString kandang = "".obs;
  // foto 4 video 1;
  RxString foto = "".obs;
  RxString foto2 = "".obs;
  RxString foto3 = "".obs;
  RxString foto4 = "".obs;
  RxString video = "".obs;
  RxString path_name_foto = "".obs;
  RxString path_name_foto2 = "".obs;
  RxString path_name_foto3 = "".obs;
  RxString path_name_foto4 = "".obs;
  RxString path_name_video = "".obs;

  RxString nama_hewan_history = "".obs;

  // edit kandang
  RxInt is_internal_u = 1.obs;
  TextEditingController tanggal_lahir_u = TextEditingController();
  TextEditingController tanggal_beli = TextEditingController();
  RxString id_jenis_kambing_u = "".obs;
  RxString name_jenis_kambing_u = "".obs;
  // RxString foto_u = "".obs;
  TextEditingController id_hewan_u = TextEditingController();
  TextEditingController nama_hewan_u = TextEditingController();
  RxInt jk_u = 1.obs;
  RxString induk_jantan_u = "".obs;
  RxString name_induk_jantan_u = "".obs;
  RxString induk_betian_u = "".obs;
  RxString name_induk_betian_u = "".obs;
  TextEditingController harga_eks_u = TextEditingController();
  TextEditingController berat_hewan_u = TextEditingController();
  RxString kandang_u = "".obs;
  RxString name_kandang_u = "".obs;
  RxString id_kambing = "".obs;

  // image detail
  RxString foto_u = "".obs;
  RxString foto2_u = "".obs;
  RxString foto3_u = "".obs;
  RxString foto4_u = "".obs;
  RxString video_u = "".obs;
  RxString foto_id = "".obs;
  RxString foto2_id = "".obs;
  RxString foto3_id = "".obs;
  RxString foto4_id = "".obs;
  RxString video_id = "".obs;
  // parameter id
  RxInt is_change_foto1 = 0.obs;
  RxInt is_change_foto2 = 0.obs;
  RxInt is_change_foto3 = 0.obs;
  RxInt is_change_foto4 = 0.obs;
  RxInt is_change_video = 0.obs;
  // onchange image
  RxString foto_on_change = "".obs;
  RxString foto2_on_change = "".obs;
  RxString foto3_on_change = "".obs;
  RxString foto4_on_change = "".obs;
  RxString video_on_change = "".obs;

  RxString foto_change = "".obs;
  RxInt is_change = 0.obs;
  // jika
  RxInt is_weight = 0.obs;
  RxInt is_kandang = 0.obs;

  RxList<Map<String, dynamic>> listKambing = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;

  RxList<Map<String, dynamic>> listKambing_kandang =
      <Map<String, dynamic>>[].obs;
  RxInt is_loading_kandang = 0.obs;
  RxInt is_halaman_kandang = 0.obs;
  RxInt all_page_kandang = 0.obs;

  final box = GetStorage();
  RxString kategori_filter = "".obs;
  RxString nama_kategori_filter = "".obs;
  RxString asal_filter = "".obs;
  RxString nama_asal_filter = "Internal".obs;
  RxString gender_filter = "".obs;
  RxString nama_gender_filter = "Jantan".obs;
  RxString kandang_filter = "".obs;
  RxString nama_kandang_filter = "".obs;

  TextEditingController usia_max = TextEditingController();
  TextEditingController usia_min = TextEditingController();
  TextEditingController berat_max = TextEditingController();
  TextEditingController berat_min = TextEditingController();
  TextEditingController cari_hewan = TextEditingController();

  RangeValues currentRangeValues = const RangeValues(2, 10);
  RangeValues currentRangeValues_berat = const RangeValues(2, 10);

  RxInt change_img = 0.obs;
  // filter
  RxString kandang_awal = "".obs;
  RxString kandang_akhir = "".obs;
  TextEditingController tanggal_pindah = TextEditingController();
  TextEditingController catatan_pindah = TextEditingController();
  // pindah kandang

  // riwayat makan
  RxList<Map<String, dynamic>> listRiwayatMakan = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listRiwayatPindahKandang =
      <Map<String, dynamic>>[].obs;
  RxInt is_loading_r_kandang = 0.obs;
  RxInt is_halaman_r_kandang = 0.obs;
  RxInt all_page_r_kandang = 0.obs;

  RxList<Map<String, dynamic>> listRiwayatPindahBerat =
      <Map<String, dynamic>>[].obs;
  RxInt is_loading_r_berat = 0.obs;
  RxInt is_halaman_r_berat = 0.obs;
  RxInt all_page_r_berat = 0.obs;

  RxList<Map<String, dynamic>> listRiwayatMakanByPakan =
      <Map<String, dynamic>>[].obs;
  RxInt is_loading_r_pakan = 0.obs;
  RxInt is_halaman_r_pakan = 0.obs;
  RxInt all_page_r_pakan = 0.obs;

  RxInt is_loading_cattle_pakan = 0.obs;
  RxInt is_halaman_cattle_pakan = 0.obs;
  RxInt all_page_cattle_pakan = 0.obs;

  RxString reason_kambing = "".obs;
  RxString search_hewan_qr = "".obs;

  // by jual kambing
  TextEditingController jual_kambing = TextEditingController();
  TextEditingController diskon_kambing = TextEditingController();

  TextEditingController jual_kambing_u = TextEditingController();
  TextEditingController diskon_kambing_u = TextEditingController();

  RxString is_editable = "".obs;

  Future search_qr(String id) async {
    try {
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/detail");
      var response = await http.post(uri_api,
          body: {"id": id.toString()}, headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body)['data'];
      print(data_respone);
      if (response.statusCode == 200) {
        print("Berhasil");
        Get.to(() => DetailGoatPage(
              id: id,
            ));
        Fluttertoast.showToast(
          msg: "Ternak Di Temukan", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
        );
      } else {
        print("gagal pages");
        Fluttertoast.showToast(
          msg: "Ternak Tidak Ditemukan", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future getRiwayatBerat(String id) async {
    try {
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/weigth_history");
      var response = await http.post(uri_api,
          body: {"id_cattle": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listRiwayatPindahBerat.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        data.forEach((element) {
          print(data_detail);
          print("Tested pages " + is_loading_r_berat.value.toString());
          // print(object)
          is_loading_r_berat.value = 0;
          is_halaman_r_berat.value = 2;
          all_page_r_berat.value = data_detail['last_page'];
          if (element['weigth'] != "0") {
            listRiwayatPindahBerat.add(element);
          }
        });
        print("List Kandang berat sss " +
            listRiwayatPindahBerat.length.toString());
      } else {
        print("gagal pages s");
      }
    } catch (e) {
      print(e);
    }
  }

  Future PaginategetRiwayatBerat(String id) async {
    try {
      print("Loaded " + is_loading_r_berat.value.toString());
      if (is_loading_r_berat.value == 0) {
        is_loading_r_berat.value = 1;
        if (all_page_r_berat.value >= is_halaman_r_berat.value) {
          print("get api" + is_halaman_r_berat.value.toString());
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/cattle/weigth_history?page=" +
              is_halaman_r_berat.toString());
          var response = await http.post(uri_api,
              body: {"id_cattle": id.toString()},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          print(data_respone);
          if (data_respone['code'] == 200) {
            is_loading_r_berat.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_r_berat.value = data_detail['last_page'];
            data.forEach((element) {
              // listRiwayatPindahBerat.add(element);
              if (element['weigth'] != "0") {
                print(element);
                listRiwayatPindahBerat.add(element);
              }
            });
            is_loading_r_berat.value = 0;
            is_halaman_r_berat.value = is_halaman_r_berat.value + 1;
          } else {
            print("Halaman " + is_halaman_r_berat.value.toString());
          }
        } else {
          print("gagal pages" +
              all_page_r_berat.value.toString() +
              " Dari " +
              is_halaman_r_berat.value.toString());
        }
      } else {
        print("gagal loading");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListRiwayatPindahKandang(String id) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/history");
      var response = await http.post(uri_api,
          body: {"id_cattle": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listRiwayatPindahKandang.clear();

      if (data_respone['code'] == 200) {
        is_loading_r_kandang.value = 0;
        is_halaman_r_kandang.value = 2;
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page_r_kandang.value = data_detail['last_page'];

        data.forEach((element) {
          print(element);
          listRiwayatPindahKandang.add(element);
        });
        print("List Kandang" + listRiwayatPindahKandang.length.toString());
      } else {
        print("gagal pages s");
      }
    } catch (e) {
      print(e);
    }
  }

  Future PaginateGetListRiwayatPindahKandang(String id) async {
    try {
      print("Loaded");
      if (is_loading_r_kandang.value == 0) {
        is_loading_r_kandang.value = 1;
        if (all_page_r_kandang.value >= is_halaman_r_kandang.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/shed/history?page=" +
              is_halaman_r_kandang.toString());
          var response = await http.post(uri_api,
              body: {"id_cattle": id.toString()},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading_r_kandang.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_r_kandang.value = data_detail['last_page'];
            data.forEach((element) {
              listRiwayatPindahKandang.add(element);
            });
            is_loading_r_kandang.value = 0;
            is_halaman_r_kandang.value = is_halaman_r_kandang.value + 1;
          } else {
            print("Halaman " + is_halaman_r_kandang.value.toString());
          }
        } else {
          print("gagal pages");
        }
      } else {
        print("gagal loading");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListRiwayatMakan(String id) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/history");
      var response = await http.post(uri_api,
          body: {"id_cattle": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listRiwayatMakan.clear();

      print(data_respone['code']);

      if (data_respone['code'] == 200) {
        is_loading_r_pakan.value = 0;
        is_halaman_r_pakan.value = 2;
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page_r_pakan.value = data_detail['last_page'];
        data.forEach((element) {
          print("okes");
          listRiwayatMakan.add(element);
        });
        print("List Kandang" + listRiwayatMakan.length.toString());
      } else {
        print("gagal pages dd");
      }
    } catch (e) {
      print(e);
    }
  }

  Future PaginategetListRiwayatMakan(String id) async {
    try {
      print("Loaded");
      if (is_loading_r_pakan.value == 0) {
        is_loading_r_pakan.value = 1;
        if (all_page_r_pakan.value >= is_halaman_r_pakan.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/food/history?page=" +
              is_halaman_r_pakan.toString());
          var response = await http.post(uri_api,
              body: {"id_cattle": id.toString()},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading_r_pakan.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_r_pakan.value = data_detail['last_page'];
            data.forEach((element) {
              listRiwayatMakanByPakan.add(element);
            });
            is_loading_r_pakan.value = 0;
            is_halaman_r_pakan.value = is_halaman_r_pakan.value + 1;
          } else {
            print("Halaman " + is_halaman_r_pakan.value.toString());
          }
        } else {
          print("gagal pages");
        }
      } else {
        print("gagal loading");
      }
    } catch (e) {
      print(e);
    }
  }

  getListRiwayatMakanByPakan(String id) async {
    try {
      print("Loaded id " + id);
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/history");
      var response = await http.post(uri_api,
          body: {"id_history": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listRiwayatMakanByPakan.clear();
      print(data_respone);

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        data.forEach((element) {
          print("okes");
          nama_hewan_history.value = element['cattle_name'];
          listRiwayatMakanByPakan.add(element);
        });
        print("List Kandang" + listRiwayatMakanByPakan.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  void pindahKandang(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/move_shed");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id_cattle": id.toString(),
        "id_old_shed": kandang_awal.value,
        "id_new_shed": kandang_akhir.value,
        "date": tanggal_pindah.text,
        "description": catatan_pindah.text
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        Get.off(() => DetailGoatPage(
              id: id,
            ));
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  // simpan kandang
  void getKandnag() async {
    if (is_internal == 1) {
      print("internal toko");
      // internal
      EasyLoading.show(status: 'loading...');
      var postUri = Uri.parse(ApiService.baseUrl + "/cattle/internal/add");
      var is_token = "Bearer " + box.read("token");
      Map<String, String> headers = {"Authorization": is_token};

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);

      request.headers.addAll(headers);
      request.fields["type"] = "1";
      request.fields["id_category"] = id_jenis_kambing.value;
      request.fields["cattle_id"] = id_hewan.text;
      request.fields["cattle_name"] = nama_hewan.text;
      request.fields["gender"] = jk.value.toString();
      request.fields["birthday"] = tanggal_lahir.text.toString();
      request.fields["male_parent"] = induk_jantan.value.toString();
      request.fields["female_parent"] = induk_betian.value.toString();
      request.fields["weigth"] = berat_hewan.text.toString();
      request.fields["id_shed"] = kandang.value.toString();

      if (foto.value != "") {
        http.MultipartFile multipartFile1 =
            await http.MultipartFile.fromPath('photo1', foto.value);
        request.files.add(multipartFile1);
      }

      if (foto2.value != "") {
        http.MultipartFile multipartFile2 =
            await http.MultipartFile.fromPath('photo2', foto2.value);
        request.files.add(multipartFile2);
      }

      if (foto3.value != "") {
        http.MultipartFile multipartFile3 =
            await http.MultipartFile.fromPath('photo3', foto3.value);
        request.files.add(multipartFile3);
      }

      if (foto4.value != "") {
        http.MultipartFile multipartFile4 =
            await http.MultipartFile.fromPath('photo4', foto4.value);
        request.files.add(multipartFile4);
      }

      if (video.value != "") {
        http.MultipartFile multipartFile5 =
            await http.MultipartFile.fromPath('video', video.value);
        request.files.add(multipartFile5);
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print("good");
        // Get.to(() => NavigationSeller());
        // Get.to(() => HomePage());
        id_jenis_kambing.value = "";
        id_hewan.text = "";
        nama_hewan.text = "";
        jk.value = 1;
        tanggal_lahir.text = "";
        harga_eks.text = "";
        induk_jantan.value = "";
        induk_betian.value = "";
        berat_hewan.text = "";
        kandang.value = "";
        foto.value = "";
        foto2.value = "";
        foto3.value = "";
        foto4.value = "";
        video.value = "";

        is_internal.value = 1;
        Get.to(() => TabKambingPage());
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } else {
      print("eksternal toko");
      // convert money to int
      var test = harga_eks.text;
      var harga_2 = test.replaceAll(",", "");
      EasyLoading.show(status: 'loading...');
      var postUri = Uri.parse(ApiService.baseUrl + "/cattle/eksternal/add");
      var is_token = "Bearer " + box.read("token");
      Map<String, String> headers = {"Authorization": is_token};

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);

      request.headers.addAll(headers);
      request.fields["type"] = "2";
      request.fields["id_category"] = id_jenis_kambing.value;
      request.fields["cattle_id"] = id_hewan.text;
      request.fields["cattle_name"] = nama_hewan.text;
      request.fields["gender"] = jk.value.toString();
      request.fields["purchase_date"] = tanggal_lahir.text.toString();
      // request.fields['price'] = harga_eks.text.toString();
      request.fields['price'] = harga_2;
      request.fields["male_parent"] = induk_jantan.value.toString();
      request.fields["female_parent"] = induk_betian.value.toString();
      request.fields["weigth"] = berat_hewan.text.toString();
      request.fields["id_shed"] = kandang.value.toString();

      // http.MultipartFile multipartFile =
      //     await http.MultipartFile.fromPath('photo', foto.value);
      // request.files.add(multipartFile);
      if (foto.value != "") {
        http.MultipartFile multipartFile1 =
            await http.MultipartFile.fromPath('photo1', foto.value);
        request.files.add(multipartFile1);
      }

      if (foto2.value != "") {
        http.MultipartFile multipartFile2 =
            await http.MultipartFile.fromPath('photo2', foto2.value);
        request.files.add(multipartFile2);
      }

      if (foto3.value != "") {
        http.MultipartFile multipartFile3 =
            await http.MultipartFile.fromPath('photo3', foto3.value);
        request.files.add(multipartFile3);
      }

      if (foto4.value != "") {
        http.MultipartFile multipartFile4 =
            await http.MultipartFile.fromPath('photo4', foto4.value);
        request.files.add(multipartFile4);
      }

      if (video.value != "") {
        http.MultipartFile multipartFile5 =
            await http.MultipartFile.fromPath('video', video.value);
        request.files.add(multipartFile5);
      }

      http.StreamedResponse response = await request.send();
      // var data = json.decode(response.);

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print("good");
        id_jenis_kambing.value = "";
        id_hewan.text = "";
        nama_hewan.text = "";
        jk.value = 1;
        tanggal_lahir.text = "";
        harga_eks.text = "";
        induk_jantan.value = "";
        induk_betian.value = "";
        berat_hewan.text = "";
        kandang.value = "";
        foto.value = "";
        foto.value = "";
        foto2.value = "";
        foto3.value = "";
        foto4.value = "";
        video.value = "";
        is_internal.value = 1;
        // Get.to(() => NavigationSeller());
        Get.to(() => TabKambingPage());
      } else {
        EasyLoading.dismiss();
        // print()
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    }
  }

  // list hewan ternak
  Future listHewan(String cari, String type, String id_category, String sorting,
      String id_kandang, String gender, int type_sell) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/index");
      var is_sell = "";
      if (type_sell == 1) {
        is_sell = "1";
      }
      var response = await http.post(uri_api,
          body: {"is_selling": is_sell.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listKambing.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        data.forEach((element) {
          print("okes" + element['photo']);
          listKambing.add(element);
        });
        is_loading.value = 0;
        print("List Kandang" + listKambing.length.toString());
        print("total halaman" + all_page.value.toString());

        cari_hewan.text = "";
        asal_filter.value = "";
        nama_asal_filter.value = "";
        kategori_filter.value = "";
        nama_kategori_filter.value = "";
        kandang_filter.value = "";
        nama_kandang_filter.value = "";
        gender_filter.value = "";
        nama_gender_filter.value = "";
        usia_min.text = "";
        usia_max.text = "";
        berat_min.text = "";
        berat_max.text = "";
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  void filterHewan(int type) async {
    var is_sell = "";
    if (type == 1) {
      is_sell = "1";
    }
    var is_token = "Bearer " + box.read("token");
    var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/index");
    var response = await http.post(uri_api, body: {
      "search": cari_hewan.text,
      "type": asal_filter.value.toString(),
      "id_category": kategori_filter.value.toString(),
      "sorting": "1",
      "id_kandang": kandang_filter.value.toString(),
      "gender": gender_filter.value.toString(),
      "age_min": usia_min.text,
      "age_max": usia_max.text,
      "weigth_min": berat_min.text,
      "weigth_max": berat_max.text,
      "is_selling": is_sell.toString()
    }, headers: {
      "Authorization": is_token
    });
    var data_respone = json.decode(response.body);
    print(data_respone);
    listKambing.clear();

    if (data_respone['code'] == 200) {
      List data =
          (json.decode(response.body) as Map<String, dynamic>)['data']['data'];
      var data_detail = json.decode(response.body)['data'];
      all_page.value = data_detail['last_page'];
      is_halaman.value = 2;
      data.forEach((element) {
        print("okes");
        listKambing.add(element);
      });
      is_loading.value = 0;
      print("List Kandang" + listKambing.length.toString());
    } else {
      listKambing.clear();
      print("gagal pages");
    }
  }

  void loadHewan(int type) async {
    var is_sell = "";
    if (type == 1) {
      is_sell = "1";
    }
    if (is_loading.value == 0) {
      is_loading.value = 1;
      if (all_page.value >= is_halaman.value) {
        print("get api");
        var is_token = "Bearer " + box.read("token");
        var uri_api = Uri.parse(
            ApiService.baseUrl + "/cattle/index?page=" + is_halaman.toString());
        var response = await http.post(uri_api, body: {
          "search": cari_hewan.text,
          "type": asal_filter.value.toString(),
          "id_category": kategori_filter.value.toString(),
          "sorting": "1",
          "id_kandang": kandang_filter.value.toString(),
          "gender": gender_filter.value.toString(),
          "age_min": usia_min.text,
          "age_max": usia_max.text,
          "weigth_min": berat_min.text,
          "weigth_max": berat_max.text,
          "is_selling": is_sell.toString()
        }, headers: {
          "Authorization": is_token
        });
        var data_respone = json.decode(response.body);
        print(data_respone);
        if (data_respone['code'] == 200) {
          List data = (json.decode(response.body)
              as Map<String, dynamic>)['data']['data'];
          var data_detail = json.decode(response.body)['data'];
          all_page.value = data_detail['last_page'];
          // is_halaman.value = 2;
          is_halaman.value = is_halaman.value + 1;
          // listKambing.clear();
          data.forEach((element) {
            print("okes");
            listKambing.add(element);
          });
          is_loading.value = 0;
          print("List Kandang" + listKambing.length.toString());
        } else {
          listKambing.clear();
          print("gagal pages");
        }
      } else {
        print("gagal pages");
      }
    } else {
      print("gagal loading");
    }
  }

  // by kandang
  Future listHewanKandang(String id, String cari) async {
    try {
      print("Loaded  " + id);
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/index");
      // var uri_api = Uri.parse(ApiService.baseUrl + "/shed/history");
      var response = await http.post(uri_api, body: {
        "id_kandang": id.toString(),
        "search": cari.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data_respone = json.decode(response.body);
      listKambing_kandang.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page_kandang.value = data_detail['last_page'];
        is_halaman_kandang.value = 2;
        data.forEach((element) {
          print("okes prot");
          listKambing_kandang.add(element);
        });
        is_loading_kandang.value = 0;
        print("List Kandang" + listKambing_kandang.length.toString());
        print("Lsat Kandang" + data_detail['last_page'].toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future PaginatelistHewanKandang(String id, String cari) async {
    try {
      // RxInt is_loading_kandang = 0.obs;
      // RxInt is_halaman_kandang = 0.obs;
      // RxInt all_page_kandang = 0.obs;

      if (is_loading_kandang.value == 0) {
        is_loading_kandang.value = 1;
        if (all_page_kandang.value >= is_halaman_kandang.value) {
          print("get api");

          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/cattle/index?page=" +
              is_halaman_kandang.toString());
          // var uri_api = Uri.parse(ApiService.baseUrl + "/shed/history");
          var response = await http.post(uri_api, body: {
            "id_kandang": id.toString(),
            "search": cari.toString(),
          }, headers: {
            "Authorization": is_token
          });
          var data_respone = json.decode(response.body);

          if (data_respone['code'] == 200) {
            is_loading_r_pakan.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_kandang.value = data_detail['last_page'];
            is_halaman_kandang.value = is_halaman_kandang.value + 1;
            data.forEach((element) {
              print("okes prot");
              listKambing_kandang.add(element);
            });
            is_loading_kandang.value = 0;
            print("List Kandang" + listKambing_kandang.length.toString());
            print("Lsat Kandang" + data_detail['last_page'].toString());
          } else {
            print("gagal pages");
          }

          // var is_token = "Bearer " + box.read("token");
          // var uri_api = Uri.parse(ApiService.baseUrl +
          //     "/food/history?page=" +
          //     is_halaman_r_pakan.toString());
          // var response = await http.post(uri_api,
          //     body: {"id_cattle": id.toString()},
          //     headers: {"Authorization": is_token});
          // var data_respone = json.decode(response.body);
          // if (data_respone['code'] == 200) {
          //   is_loading_r_pakan.value = 0;
          //   List data = (json.decode(response.body)
          //       as Map<String, dynamic>)['data']['data'];
          //   var data_detail = json.decode(response.body)['data'];
          //   all_page_r_pakan.value = data_detail['last_page'];
          //   data.forEach((element) {
          //     listRiwayatMakanByPakan.add(element);
          //   });
          //   is_loading_r_pakan.value = 0;
          //   is_halaman_r_pakan.value = is_halaman_r_pakan.value + 1;
          // } else {
          //   print("Halaman " + is_halaman_r_pakan.value.toString());
          // }
        } else {
          print("gagal pages");
        }
      } else {
        print("gagal loading");
      }
    } catch (e) {
      print(e);
    }
  }

  // void filterHewanKandang() async {
  //   var is_token = "Bearer " + box.read("token");
  //   var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/index");
  //   var response = await http.post(uri_api, body: {
  //     "search": cari_hewan.text,
  //     "type": asal_filter.value.toString(),
  //     "id_category": kategori_filter.value.toString(),
  //     "sorting": "1",
  //     "id_kandang": kandang_filter.value.toString(),
  //     "gender": gender_filter.value.toString(),
  //     "age_min": usia_min.text,
  //     "age_max": usia_max.text,
  //     "weigth_min": berat_min.text,
  //     "weigth_max": berat_max.text,
  //   }, headers: {
  //     "Authorization": is_token
  //   });
  //   var data_respone = json.decode(response.body);
  //   print(data_respone);
  //   if (data_respone['code'] == 200) {
  //     List data =
  //         (json.decode(response.body) as Map<String, dynamic>)['data']['data'];
  //     var data_detail = json.decode(response.body)['data'];
  //     all_page.value = data_detail['last_page'];
  //     is_halaman.value = 2;
  //     listKambing.clear();
  //     data.forEach((element) {
  //       print("okes");
  //       listKambing.add(element);
  //     });
  //     is_loading.value = 0;
  //     print("List Kandang" + listKambing.length.toString());
  //   } else {
  //     listKambing.clear();
  //     print("gagal pages");
  //   }
  // }

  void loadHewanKandang() async {
    if (is_loading.value == 0) {
      is_loading.value = 1;
      if (all_page.value >= is_halaman.value) {
        print("get api");
        var is_token = "Bearer " + box.read("token");
        var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/index");
        var response = await http.post(uri_api, body: {
          "search": cari_hewan.text,
          "type": asal_filter.value.toString(),
          "id_category": kategori_filter.value.toString(),
          "sorting": "1",
          "id_kandang": kandang_filter.value.toString(),
          "gender": gender_filter.value.toString(),
          "age_min": usia_min.text,
          "age_max": usia_max.text,
          "weigth_min": berat_min.text,
          "weigth_max": berat_max.text,
        }, headers: {
          "Authorization": is_token
        });
        var data_respone = json.decode(response.body);
        print(data_respone);
        if (data_respone['code'] == 200) {
          List data = (json.decode(response.body)
              as Map<String, dynamic>)['data']['data'];
          var data_detail = json.decode(response.body)['data'];
          all_page.value = data_detail['last_page'];
          is_halaman.value = 2;
          listKambing.clear();
          data.forEach((element) {
            print("okes");
            listKambing.add(element);
          });
          is_loading.value = 0;
          print("List Kandang" + listKambing.length.toString());
        } else {
          listKambing.clear();
          print("gagal pages");
        }
      } else {
        print("gagal pages");
      }
    } else {
      print("gagal loading");
    }
  }

  void jualKambing(String id) async {
    try {
      print("Jalanan");
      var harga_2 = jual_kambing.text.replaceAll(",", "");
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/sale");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
        "selling_price": harga_2,
        "discount": diskon_kambing.text
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        listHewan("", "", "", "", "", "", 0);
        jual_kambing.text = "";
        diskon_kambing.text = "";
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void jualKambingUbah(String id) async {
    try {
      print("Jalanan");
      var harga_2 = jual_kambing_u.text.replaceAll(",", "");
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/sale");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
        "selling_price": harga_2,
        "discount": diskon_kambing_u.text
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        listHewan("", "", "", "", "", "", 1);
        jual_kambing.text = "";
        diskon_kambing.text = "";
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void batalJual(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/unsale");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        listHewan("", "", "", "", "", "", 1);
        reason_kambing.value = "";
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void hapuskandang(String id, int type) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/delete");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
        "reason": reason_kambing.value,
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        listHewan("", "", "", "", "", "", type);
        reason_kambing.value = "";
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  // hapus gambar
  void hapusGambarKambing(String id) async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/delete_file");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        print("Good");
      } else {
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void ubahKambing() async {
    try {
      // print(foto_u.value );

      if (is_internal_u == 1) {
        print(change_img.value);
        print(foto_u.value);
        print("internal toko");
        EasyLoading.show(status: 'loading...');
        var postUri = Uri.parse(ApiService.baseUrl + "/cattle/internal/update");
        var is_token = "Bearer " + box.read("token");
        Map<String, String> headers = {"Authorization": is_token};

        http.MultipartRequest request =
            new http.MultipartRequest("POST", postUri);

        request.headers.addAll(headers);
        request.fields['id'] = id_kambing.value;
        request.fields["type"] = "1";
        request.fields["id_category"] = id_jenis_kambing_u.value;
        request.fields["cattle_id"] = id_hewan_u.text;
        request.fields["cattle_name"] = nama_hewan_u.text;
        request.fields["gender"] = jk_u.value.toString();
        request.fields["birthday"] = tanggal_lahir_u.text.toString();
        request.fields["male_parent"] = induk_jantan_u.value.toString();
        request.fields["female_parent"] = induk_betian_u.value.toString();
        request.fields["weigth"] = berat_hewan_u.text.toString();
        request.fields["id_shed"] = kandang_u.value.toString();

        // if (change_img.value == 1) {
        //   http.MultipartFile multipartFile =
        //       await http.MultipartFile.fromPath('photo', foto_u.value);
        //   request.files.add(multipartFile);
        // }
        if (foto_on_change.value != "") {
          http.MultipartFile multipartFile1 =
              await http.MultipartFile.fromPath('photo1', foto_on_change.value);
          request.files.add(multipartFile1);
        }

        if (foto2_on_change.value != "") {
          http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
              'photo2', foto2_on_change.value);
          request.files.add(multipartFile2);
        }

        if (foto3_on_change.value != "") {
          http.MultipartFile multipartFile3 = await http.MultipartFile.fromPath(
              'photo3', foto3_on_change.value);
          request.files.add(multipartFile3);
        }

        if (foto4_on_change.value != "") {
          http.MultipartFile multipartFile4 = await http.MultipartFile.fromPath(
              'photo4', foto4_on_change.value);
          request.files.add(multipartFile4);
        }

        if (video_on_change.value != "") {
          http.MultipartFile multipartFile5 =
              await http.MultipartFile.fromPath('video', video_on_change.value);
          request.files.add(multipartFile5);
        }

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          print("good");
          // Get.to(() => NavigationSeller());
          // Get.to(() => HomePage());
          id_jenis_kambing_u.value = "";
          id_hewan_u.text = "";
          nama_hewan_u.text = "";
          jk_u.value = 1;
          tanggal_lahir_u.text = "";
          harga_eks_u.text = "";
          induk_jantan_u.value = "";
          induk_betian_u.value = "";
          berat_hewan_u.text = "";
          kandang_u.value = "";
          foto_u.value = "";
          is_internal_u.value = 1;
          change_img.value = 0;
          Get.to(() => TabKambingPage());
        } else {
          EasyLoading.dismiss();
          showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
        }
      } else {
        print("eksternal toko");
        var test = harga_eks_u.text;
        var harga_2 = test.replaceAll(",", "");

        EasyLoading.show(status: 'loading...');
        var postUri =
            Uri.parse(ApiService.baseUrl + "/cattle/eksternal/update");
        var is_token = "Bearer " + box.read("token");
        Map<String, String> headers = {"Authorization": is_token};

        http.MultipartRequest request =
            new http.MultipartRequest("POST", postUri);

        request.headers.addAll(headers);
        request.fields['id'] = id_kambing.value;
        request.fields["type"] = "2";
        request.fields["id_category"] = id_jenis_kambing_u.value;
        request.fields["cattle_id"] = id_hewan_u.text;
        request.fields["cattle_name"] = nama_hewan_u.text;
        request.fields["gender"] = jk_u.value.toString();
        request.fields["purchase_date"] = tanggal_beli.text.toString();
        // request.fields['price'] = harga_eks_u.text.toString();
        request.fields['price'] = harga_2;
        request.fields["male_parent"] = induk_jantan_u.value.toString();
        request.fields["female_parent"] = induk_betian_u.value.toString();
        request.fields["weigth"] = berat_hewan_u.text.toString();
        request.fields["id_shed"] = kandang_u.value.toString();

        // if (change_img.value == 1) {
        //   http.MultipartFile multipartFile =
        //       await http.MultipartFile.fromPath('photo', foto_u.value);
        //   request.files.add(multipartFile);
        // }
        if (foto_on_change.value != "") {
          http.MultipartFile multipartFile1 =
              await http.MultipartFile.fromPath('photo1', foto_on_change.value);
          request.files.add(multipartFile1);
        }

        if (foto2_on_change.value != "") {
          http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
              'photo2', foto2_on_change.value);
          request.files.add(multipartFile2);
        }

        if (foto3_on_change.value != "") {
          http.MultipartFile multipartFile3 = await http.MultipartFile.fromPath(
              'photo3', foto3_on_change.value);
          request.files.add(multipartFile3);
        }

        if (foto4_on_change.value != "") {
          http.MultipartFile multipartFile4 = await http.MultipartFile.fromPath(
              'photo4', foto4_on_change.value);
          request.files.add(multipartFile4);
        }

        if (video_on_change.value != "") {
          http.MultipartFile multipartFile5 =
              await http.MultipartFile.fromPath('video', video_on_change.value);
          request.files.add(multipartFile5);
        }

        http.StreamedResponse response = await request.send();
        // var data = json.decode(response.body);

        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });

        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          print("good");
          id_jenis_kambing_u.value = "";
          id_hewan_u.text = "";
          nama_hewan_u.text = "";
          jk_u.value = 1;
          tanggal_lahir_u.text = "";
          harga_eks_u.text = "";
          induk_jantan_u.value = "";
          induk_betian_u.value = "";
          berat_hewan_u.text = "";
          kandang_u.value = "";
          foto_u.value = "";

          is_internal_u.value = 1;
          change_img.value = 0;
          // Get.to(() => NavigationSeller());
          Get.to(() => TabKambingPage());
        } else {
          EasyLoading.dismiss();
          // print()
          showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // hapus gambar

  void SingleUploadByAdd(String path, int type) async {
    print("Uploaded Image");
    var postUri = Uri.parse(ApiService.baseUrl + "/upload_images");
    var is_token = "Bearer " + box.read("token");
    Map<String, String> headers = {"Authorization": is_token};
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('image', path);
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    var responseString = await response.stream.bytesToString();
    var responseJson = json.decode(responseString);

    print(response.statusCode);
    print(path);
    if (response.statusCode == 200) {
      print("good image");
      if (type == 1) {
        foto.value = responseJson['url'];
        path_name_foto = responseJson['name'];
      } else if (type == 2) {
        foto2.value = responseJson['url'];
        path_name_foto2 = responseJson['name'];
      } else if (type == 3) {
        foto3.value = responseJson['url'];
        path_name_foto3 = responseJson['name'];
      } else if (type == 4) {
        foto4.value = responseJson['url'];
        path_name_foto4 = responseJson['name'];
      } else if (type == 5) {
        // kandang_c.foto2.value = picked.path;
        video.value = responseJson['url'];
        path_name_video = responseJson['name'];
      }
    } else {
      print("Not Bad");
    }
  }

  // get detail kambing

}
