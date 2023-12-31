import 'dart:convert';

import 'package:aslis_application/ui/kandang/kandang_list.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class KandangController extends GetxController {
  TextEditingController id_kandang = TextEditingController();
  TextEditingController nama_kandang = TextEditingController();
  TextEditingController alamat_kandang = TextEditingController();
  TextEditingController kapasitas_kandang = TextEditingController();
  TextEditingController jarak_pengiriman = TextEditingController();
  TextEditingController harga_pengiriman = TextEditingController();

  RxString id_provinsi = "".obs;
  RxString id_kota = "".obs;

  TextEditingController id_kandang_u = TextEditingController();
  TextEditingController nama_kandang_u = TextEditingController();
  TextEditingController alamat_kandang_u = TextEditingController();
  TextEditingController kapasitas_kandang_u = TextEditingController();
  TextEditingController jarak_pengiriman_u = TextEditingController();
  TextEditingController harga_pengiriman_u = TextEditingController();

  RxInt id_provinsi_u = 0.obs;
  RxInt id_kota_u = 0.obs;
  RxString name_provinsi_u = "".obs;
  RxString name_kota_u = "".obs;
  RxString kandang_id = "".obs;

  RxList<Map<String, dynamic>> listKandang = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  TextEditingController cari_kandang = TextEditingController();

  RxInt change_provinsi = 0.obs;
  final box = GetStorage();

  void tambah_kandang() async {
    try {
      // convert
      var test = harga_pengiriman.text;
      var harga_2 = test.replaceAll(",", "");

      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/add");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "shed_id": id_kandang.text.toString(),
        "shed_name": nama_kandang.text.toString(),
        "id_province": id_provinsi.value.toString(),
        "id_city": id_kota.value.toString(),
        "address": alamat_kandang.text.toString(),
        "capacity": kapasitas_kandang.text.toString(),
        "delivery_fee": harga_2,
        "maximum_distance": jarak_pengiriman.text,
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        id_kandang.text = "";
        nama_kandang.text = "";
        alamat_kandang.text = "";
        kapasitas_kandang.text = "";
        harga_pengiriman.text = "";
        jarak_pengiriman.text = "";
        showModal(data['message']);
        Get.off(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  // get lis kandang
  Future GetKandang(String cari) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/index");
      var response = await http.post(uri_api,
          body: {"search": cari.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      print(data_respone);
      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        listKandang.clear();
        data.forEach((element) {
          print(element);
          listKandang.add(element);
        });
        is_loading.value = 0;
        print("List Kandang" + listKandang.length.toString());
      } else {
        listKandang.clear();
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future LoadGetKandang() async {
    try {
      print("Loaded");
      if (is_loading.value == 0) {
        is_loading.value = 1;
        if (all_page.value >= is_halaman.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(
              ApiService.baseUrl + "/shed/index?page=" + is_halaman.toString());
          var response = await http.post(uri_api,
              body: {"search": cari_kandang.text},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page.value = data_detail['last_page'];
            data.forEach((element) {
              listKandang.add(element);
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

  // update kandang
  void updateKandang() async {
    try {
      var test = harga_pengiriman_u.text;
      var harga_2 = test.replaceAll(",", "");
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/update");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": kandang_id.value.toString(),
        "shed_id": id_kandang_u.text.toString(),
        "shed_name": nama_kandang_u.text.toString(),
        "id_province": id_provinsi_u.value.toString(),
        "id_city": id_kota_u.value.toString(),
        "address": alamat_kandang_u.text.toString(),
        "capacity": kapasitas_kandang_u.text.toString(),
        "delivery_fee": harga_2,
        "maximum_distance": jarak_pengiriman_u.text,
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        Get.off(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void hapuskandang(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/shed/delete");
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
        GetKandang("");
        // Get.to(() => KandangPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }
}
