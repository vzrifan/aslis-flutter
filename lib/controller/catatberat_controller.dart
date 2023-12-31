import 'dart:convert';

import 'package:aslis_application/ui/CatatanBerat/weight_page.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CatatBeratController extends GetxController {
  final box = GetStorage();

  RxString id_kategori = "".obs;
  TextEditingController tanggal = TextEditingController();
  RxList list_kambing_array = [].obs;

  // update
  RxString id_kategori_u = "".obs;
  TextEditingController tanggal_u = TextEditingController();
  RxList list_kambing_array_u = [].obs;
  RxString id_catatan = "".obs;

  RxList<Map<String, dynamic>> list_berat = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  TextEditingController cari = TextEditingController();

  // single upload
  TextEditingController tanggal_singgle = TextEditingController();
  TextEditingController weight_singgle = TextEditingController();

  // get search
  RxList<Map<String, dynamic>> listKambing = <Map<String, dynamic>>[].obs;

  void getKambing(String id_kandang, String cari) async {
    try {
      String ids = "";
      if (id_kandang == "") {
        ids = id_kategori.value;
      } else {
        ids = id_kandang;
      }
      print("Tested" + id_kandang);
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/search");
      var response = await http.post(uri_api, body: {
        "id_shed": ids.toString(),
        "search": cari.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data_respone = json.decode(response.body);
      listKambing.clear();
      list_kambing_array.clear();
      if (data_respone['code'] == 200) {
        List data =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        var data_detail = json.decode(response.body)['data'];

        data.forEach((element) {
          // print("Tested " + element['id']);
          listKambing.add(element);
          list_kambing_array.add(
            {
              "id_cattle": element['id'],
              "photo": "kowey.jpeg",
              "weight": "",
            },
          );
        });
        print("Total Data" + listKambing.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  void uploadBerat() async {
    try {
      print("Loaded");
      List change_berat = [];
      list_kambing_array.forEach((element) {
        // print(element);
        change_berat.add({
          "id_cattle": element['id_cattle'],
          "photo": element['photo'],
          "weigth": element['weight'] == "" ? "" : element['weight'],
        });
      });

      Map data = {
        'id_shed': id_kategori.value,
        'date': tanggal.text,
        'catatan': change_berat,
      };
      //encode Map to JSON
      var body = json.encode(data);
      print(body);

      var postUri = Uri.parse(ApiService.baseUrl + "/cattle/weigth_noted");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(postUri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": is_token
          },
          body: body);
      print("${response.statusCode}");
      print("${response.body}");
      list_kambing_array.clear();
      listKambing.clear();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        getData("");
        Get.to(() => WeightPage());
        id_kategori.value = "";
        tanggal.text = "";

        showModalTwo("Tambah Berat Berhasil");

        print("good joob");
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }

  void uploadBeratSingle(String id_cattle, String id_sheed) async {
    try {
      print("Loaded");

      Map data = {
        'id_cattle': id_cattle,
        'id_shed': id_sheed,
        'weigth': weight_singgle.text,
        'date': tanggal_singgle.text
      };
      //encode Map to JSON
      var body = json.encode(data);
      print(body);

      var postUri =
          Uri.parse(ApiService.baseUrl + "/cattle/weigth_noted_from_scan");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(postUri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": is_token
          },
          body: body);
      print("${response.statusCode}");
      print("${response.body}");
      list_kambing_array.clear();
      listKambing.clear();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        getData("");
        // Get.to(() => WeightPage());
        Get.back();
        weight_singgle.text = "";
        tanggal_singgle.text = "";
        showModalTwo("Tambah Berat Berhasil");
        print("good joob");
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }

  void updateBerat() async {
    try {
      print("Loaded");
      List change_berat = [];
      list_kambing_array_u.forEach((element) {
        // print(element);
        change_berat.add({
          "id_cattle": element['ids'],
          "photo": element['photo'],
          "weigth": element['weight'],
        });
      });

      print(change_berat);

      Map data = {
        'id': id_catatan.value,
        'id_shed': id_kategori_u.value,
        'date': tanggal_u.text,
        'catatan': change_berat,
      };
      //encode Map to JSON
      var body = json.encode(data);
      print(body);

      var postUri =
          Uri.parse(ApiService.baseUrl + "/cattle/update_weigth_history");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(postUri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": is_token
          },
          body: body);
      print("${response.statusCode}");
      print("${response.body}");
      list_kambing_array_u.clear();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        getData("");
        Get.to(() => WeightPage());
        id_kategori_u.value = "";
        tanggal_u.text = "";
        id_catatan.value = "";
        showModalTwo("Ubah Berat Berhasil");

        print("good joob");
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }

  // get data
  Future getData(String id) async {
    try {
      print("Loaded" + id);
      list_kambing_array.clear();
      listKambing.clear();
      var is_token = "Bearer " + box.read("token");
      var uri_api =
          Uri.parse(ApiService.baseUrl + "/cattle/weigth_history_shed");
      var response = await http.post(uri_api,
          body: {"search": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      list_berat.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        data.forEach((element) {
          print("okes");
          list_berat.add(element);
        });
        is_loading.value = 0;
        print("List Kandang" + list_berat.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  void hapusCatat(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api =
          Uri.parse(ApiService.baseUrl + "/cattle/delete_weigth_history");
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
        getData("");
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future loadData() async {
    try {
      print("Loaded");
      if (is_loading.value == 0) {
        is_loading.value = 1;
        if (all_page.value >= is_halaman.value) {
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/cattle/weigth_history_shed?page=" +
              is_halaman.toString());
          var response = await http.post(uri_api,
              body: {"search": cari.toString()},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page.value = data_detail['last_page'];
            data.forEach((element) {
              list_berat.add(element);
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
