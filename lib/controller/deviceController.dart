import 'dart:convert';

import 'package:aslis_application/controller/KandangController.dart';
import 'package:aslis_application/ui/device/list_device.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api_helper.dart';

class DeviceController extends GetxController {
  final box = GetStorage();
  TextEditingController id_hewan = TextEditingController();
  TextEditingController nama_device = TextEditingController();
  RxString kandang_c = "".obs;
  // RxList<Map<String, dynamic>> list_device = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> list_device = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  TextEditingController cari_pakan = TextEditingController();

  void upload_device() async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/add_device");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "device_id": id_hewan.text.toString(),
        "device_name": nama_device.text.toString(),
        "id_shed": kandang_c.value.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Get.off(() => DevicePage());
        id_hewan.text = "";
        nama_device.text = "";
        kandang_c.value = "";
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  // load data
  Future getCatatan(String cari) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/get_device");
      var response = await http.post(uri_api,
          body: {"search": cari.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      list_device.clear();

      print(data_respone);

      // if (data_respone['code'] == 200) {
      List data = (json.decode(response.body) as Map<String, dynamic>)['data'];
      // var data_detail = json.decode(response.body)['data'];
      // all_page.value = data_detail['last_page'];
      is_halaman.value = 2;
      data.forEach((element) {
        print("okes");
        Map<String, dynamic> updatedMap = element ?? {};

        updatedMap.forEach((key, value) {
          if (value == null) {
            updatedMap[key] = "";
          }
        });
        list_device.add(updatedMap);
      });
      print(list_device);
      // is_loading.value = 0;
      // } else {
      //   print("gagal pages");
      // }
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
              "/auth/get_device?page=" +
              is_halaman.toString());
          var response = await http.post(uri_api,
              // body: {"search": cari_pakan.text},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page.value = data_detail['last_page'];
            data.forEach((element) {
              list_device.add(element);
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

  void hapusDevice(String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/delete_device");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        showModal(data['message']);
        EasyLoading.dismiss();
        getCatatan("");
        // Get.off(() => DevicePage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }
}
