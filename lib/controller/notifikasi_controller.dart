import 'dart:convert';

import 'package:aslis_application/utils/api_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotifikasiController extends GetxController {
  RxList<Map<String, dynamic>> listNotif = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  final box = GetStorage();
  Future getNotif() async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/notification/index");
      var response =
          await http.post(uri_api, headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listNotif.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        data.forEach((element) {
          print("okes");
          listNotif.add(element);
        });
        is_loading.value = 0;
        print("List Kandang" + listNotif.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  void hapusNotif(String id) async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/notification/delete");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id_notification": id.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        print("Good");
        // Get.to(() => KandangPage());
      } else {
        print("notGood");
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
              "/notification/index?page=" +
              is_halaman.toString());
          var response =
              await http.post(uri_api, headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page.value = data_detail['last_page'];
            data.forEach((element) {
              listNotif.add(element);
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
