import 'dart:convert';

import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final box = GetStorage();
// update data
  RxString foto_p = "".obs;
  TextEditingController nama = TextEditingController();
  TextEditingController peternakan = TextEditingController();
  TextEditingController nik = TextEditingController();
  RxInt jenis_kelamin = 1.obs;
  TextEditingController tanggal_lahir = TextEditingController();
  RxString id_provinsi = "".obs;
  RxString nama_provinsi = "".obs;
  RxString id_kota = "".obs;
  RxString nama_kota = "".obs;
  TextEditingController jalan = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController kode_pos = TextEditingController();

  RxInt change_img = 0.obs;
  RxInt change_provinsi = 0.obs;

  Future getProfile() async {
    try {
      change_provinsi.value = 0;
      change_img.value = 0;
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/get_data_profile");
      var is_token = "Bearer " + box.read("token");
      var response =
          await http.get(uri_api, headers: {"Authorization": is_token});
      var data = json.decode(response.body)['data'];
      print(data);
      if (response.statusCode == 200) {
        print("Nama Saya " + data['user_name'].toString());
        foto_p.value = data['profile'] ?? "";
        nama.text = data['user_name'] ?? "";
        peternakan.text = data['farmer_name'];
        nik.text = data['user_nik'] ?? "";
        jenis_kelamin.value = data['gender'] ?? 0;
        tanggal_lahir.text = data['birthday'] ?? "";
        id_provinsi.value = data['id_province'] ?? 0;
        id_kota.value = data['id_city'] ?? 0;
        nama_provinsi.value = data['province'] ?? "";
        nama_kota.value = data['city'] ?? "";
        jalan.text = data['address'] ?? "";
        email.text = data['user_email'] ?? "";
        kode_pos.text = data['pos_code'] ?? "";
      } else {
        showModal("Terjadi Kesalahan");
      }
    } catch (e) {
      print(e);
    }
  }

  void simpanProfile() async {
    try {
      EasyLoading.show(status: 'loading...');
      var postUri = Uri.parse(ApiService.baseUrl + "/auth/update_profile");
      var is_token = "Bearer " + box.read("token");
      Map<String, String> headers = {"Authorization": is_token};

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);

      request.headers.addAll(headers);
      request.fields["user_name"] = nama.text;
      request.fields["farmer_name"] = peternakan.text;
      request.fields["user_email"] = email.text;
      request.fields["birthday"] = tanggal_lahir.text;
      request.fields["gender"] = jenis_kelamin.value.toString();
      request.fields["user_nik"] = nik.text.toString();
      request.fields["id_province"] = id_provinsi.value.toString();
      request.fields["id_city"] = id_kota.value.toString();
      request.fields["pos_code"] = kode_pos.text.toString();
      request.fields["address"] = jalan.text.toString();

      if (change_img == 1) {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('profile', foto_p.value);
        request.files.add(multipartFile);
      }

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print("good");
        // Get.to(() => NavigationSeller());
        Get.to(() => HomePage());
      } else {
        EasyLoading.dismiss();
        showModal("Terjadi Kesalahan, Silahkan Coba Beberapa Saat Lagi");
      }
    } catch (e) {
      print(e);
    }
  }
}
