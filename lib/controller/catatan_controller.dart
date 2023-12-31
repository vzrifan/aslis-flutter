import 'dart:convert';

import 'package:aslis_application/ui/Noted_page/note.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CatatanController extends GetxController {
  RxList<Map<String, dynamic>> listCatatan = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  TextEditingController cari_pakan = TextEditingController();
  final box = GetStorage();

  // tambah note
  TextEditingController judul = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController deksripsi = TextEditingController();
  RxString img = "".obs;
  RxString id_masalah = "".obs;
  RxString id_event = "".obs;

  // ubah data
  TextEditingController judul_u = TextEditingController();
  TextEditingController tanggal_u = TextEditingController();
  TextEditingController deksripsi_u = TextEditingController();
  RxString img_u = "".obs;
  RxInt changeImage = 0.obs;
  RxString id_u = "".obs;
  RxString id_masalah_u = "".obs;
  RxString name_masalah = "".obs;
  RxString id_event_U = "".obs;
  RxString name_event = "".obs;
  RxList<String> listProblemSelected_u = <String>[].obs;
  RxList<String> listProblemSelected_name_u = <String>[].obs;
  RxInt changeList_u = 0.obs;
  RxInt is_edited = 1.obs;

  RxInt changeList = 0.obs;

  RxList<String> list_name_pakan = <String>[].obs;
  RxList<Map<String, dynamic>> list_id_pakan = <Map<String, dynamic>>[].obs;

  RxList<String> list_name_hewan = <String>[].obs;
  RxList<Map<String, dynamic>> list_id_hewan = <Map<String, dynamic>>[].obs;

  RxList<String> list_name_kandang = <String>[].obs;
  RxList<Map<String, dynamic>> list_id_kandang = <Map<String, dynamic>>[].obs;

  RxList<String> listProblemSelected = <String>[].obs;

  RxInt is_edit_note = 1.obs;

  Future getListKandang() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/get_data/shed");
      var is_token = "Bearer " + box.read("token");
      var respone =
          await http.get(uri_api, headers: {"Authorization": is_token});
      list_name_kandang.clear();
      list_id_kandang.clear();
      if (respone.statusCode == 200) {
        var data = json.decode(respone.body) as Map<String, dynamic>;
        var dataProvince = data['data'] as List<dynamic>;
        dataProvince.forEach((element) {
          list_name_kandang
              .add("(" + element['shed_id'] + ") " + element['shed_name']);
          list_id_kandang.add(element);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListHewan() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/get_data/cattle");
      var is_token = "Bearer " + box.read("token");
      var respone =
          await http.get(uri_api, headers: {"Authorization": is_token});
      list_name_hewan.clear();
      list_id_hewan.clear();
      if (respone.statusCode == 200) {
        var data = json.decode(respone.body) as Map<String, dynamic>;
        var dataProvince = data['data'] as List<dynamic>;
        dataProvince.forEach((element) {
          list_name_hewan
              .add("(" + element['cattle_id'] + ") " + element['cattle_name']);
          list_id_hewan.add(element);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListPakan() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/get_data/food");
      var is_token = "Bearer " + box.read("token");
      var respone =
          await http.get(uri_api, headers: {"Authorization": is_token});
      list_name_pakan.clear();
      list_id_pakan.clear();
      if (respone.statusCode == 200) {
        var data = json.decode(respone.body) as Map<String, dynamic>;
        var dataProvince = data['data'] as List<dynamic>;
        dataProvince.forEach((element) {
          print(element);
          list_name_pakan
              .add("(" + element['food_id'] + ") " + element['food_name']);
          list_id_pakan.add(element);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void hapuscatatan(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/notes/delete");
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
        getCatatan("");
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void simpanNote() async {
    try {
      print(listProblemSelected);
      EasyLoading.show(status: 'loading...');
      var postUri = Uri.parse(ApiService.baseUrl + "/notes/add");
      var is_token = "Bearer " + box.read("token");
      Map<String, String> headers = {"Authorization": is_token};

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);

      request.headers.addAll(headers);
      request.fields["title"] = judul.text;
      request.fields["date"] = tanggal.text;
      request.fields["description"] = deksripsi.text;
      request.fields["id_event"] = id_event.value;
      request.fields["id_problem"] = id_masalah.value;
      request.fields["is_edited"] = is_edit_note.value.toString();

      if (changeList.value == 1) {
        for (int i = 0; i < listProblemSelected.length; i++) {
          request.fields["id_hewan[$i]"] = listProblemSelected[i];
        }
      } else if (changeList.value == 2) {
        for (int i = 0; i < listProblemSelected.length; i++) {
          request.fields["id_makanan[$i]"] = listProblemSelected[i];
        }
      } else if (changeList.value == 3) {
        for (int i = 0; i < listProblemSelected.length; i++) {
          request.fields["id_kandang[$i]"] = listProblemSelected[i];
        }
      }

      // request.fields["id_problem"] = id_masalah.value;

      if (img.value != "") {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('photo', img.value);
        request.files.add(multipartFile);
      }

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print("good");
        judul.text = "";
        tanggal.text = "";
        deksripsi.text = "";
        img.value = "";
        // Get.to(() => NavigationSeller());
        Get.to(() => NotePage());
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }

  void ubahNote() async {
    try {
      EasyLoading.show(status: 'loading...');
      var postUri = Uri.parse(ApiService.baseUrl + "/notes/update");
      var is_token = "Bearer " + box.read("token");
      Map<String, String> headers = {"Authorization": is_token};

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);

      request.headers.addAll(headers);
      request.fields["id"] = id_u.value;
      request.fields["title"] = judul_u.text;
      request.fields["date"] = tanggal_u.text;
      request.fields["description"] = deksripsi_u.text;
      request.fields["id_event"] = id_event_U.value;
      request.fields["id_problem"] = id_masalah_u.value;

      if (changeList_u.value == 1) {
        for (int i = 0; i < listProblemSelected_u.length; i++) {
          request.fields["id_kandang[$i]"] = listProblemSelected_u[i];
        }
      } else if (changeList_u.value == 2) {
        for (int i = 0; i < listProblemSelected_u.length; i++) {
          request.fields["id_hewan[$i]"] = listProblemSelected_u[i];
        }
      } else if (changeList_u.value == 3) {
        for (int i = 0; i < listProblemSelected_u.length; i++) {
          request.fields["id_makanan[$i]"] = listProblemSelected_u[i];
        }
      }

      if (changeImage.value == 1) {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('photo', img_u.value);
        request.files.add(multipartFile);
      }

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      if (response.statusCode == 200) {
        changeImage.value = 0;
        EasyLoading.dismiss();
        print("good");
        judul_u.text = "";
        tanggal_u.text = "";
        deksripsi_u.text = "";
        img_u.value = "";

        // Get.to(() => NavigationSeller());
        Get.to(() => NotePage());
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCatatan(String cari) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/notes/index");
      var response = await http.post(uri_api,
          body: {"search": cari.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listCatatan.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        data.forEach((element) {
          print("okes");
          listCatatan.add(element);
        });
        is_loading.value = 0;
        changeList.value = 0;
        print("List Kandang" + listCatatan.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future LoadPakan() async {
    try {
      print("Loaded");
      if (is_loading.value == 0) {
        is_loading.value = 1;
        if (all_page.value >= is_halaman.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/notes/index?page=" +
              is_halaman.toString());
          var response = await http.post(uri_api,
              body: {"search": cari_pakan.text},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page.value = data_detail['last_page'];
            data.forEach((element) {
              listCatatan.add(element);
            });
            is_loading.value = 0;
            is_halaman.value = is_halaman.value + 1;
          } else {
            print("Halaman " + is_halaman.value.toString());
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
}
