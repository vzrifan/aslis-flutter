import 'dart:convert';

import 'package:aslis_application/ui/auth/login.dart';
import 'package:aslis_application/ui/auth/otp.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // register
  TextEditingController txt_hp = TextEditingController();
  TextEditingController txt_hp_login = TextEditingController();
  TextEditingController otp_field_1 = TextEditingController();
  TextEditingController otp_field_2 = TextEditingController();
  TextEditingController otp_field_3 = TextEditingController();
  TextEditingController otp_field_4 = TextEditingController();
  TextEditingController otp_field_5 = TextEditingController();
  RxString kode_otp = "".obs;
  RxInt type_hp = 0.obs;
  RxString id_user = "".obs;
  final box = GetStorage();

  // regisred
  TextEditingController hp_reg = TextEditingController();
  TextEditingController nama_reg = TextEditingController();
  TextEditingController peternakan_reg = TextEditingController();
  RxInt kode = 0.obs;

  void cekOtp() async {
    try {
      EasyLoading.show(status: 'loading...');
      String otp_input = otp_field_1.text +
          otp_field_2.text +
          otp_field_3.text +
          otp_field_4.text +
          otp_field_5.text;
      // kirim data
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/otp_validation");
      var response = await http.post(uri_api, body: {
        "otp": otp_input.toString(),
        "id": id_user.toString(),
      });
      var data = json.decode(json.encode(response.body));
      print("THIS ID DATA TOKEN");
      print(data['token']);
      if (response.statusCode == 200) {
        // token
        otp_field_1.text = "";
        otp_field_2.text = "";
        otp_field_3.text = "";
        otp_field_4.text = "";
        otp_field_5.text = "";
        box.write("token", data['token']);
        // Get.off(() => PageFormName());
        EasyLoading.dismiss();
      } else {
        showModal(data['message']);
        EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
    }
    // print("OTP" + otp_input);
  }

  void refreshOtp() async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/send_otp");
      var response =
          await http.post(uri_api, body: {"id": id_user.value.toString()});
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        otp_field_1.text = "";
        otp_field_2.text = "";
        otp_field_3.text = "";
        otp_field_4.text = "";
        otp_field_5.text = "";
        EasyLoading.dismiss();
        showModal(data['message']);
        // Get.to(() => PageOtp());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void sendLogin() async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/login");
      var response = await http.post(uri_api,
          body: {"post": txt_hp_login.text, "code_phone": "+62"});
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        otp_field_1.text = "";
        otp_field_2.text = "";
        otp_field_3.text = "";
        otp_field_4.text = "";
        otp_field_5.text = "";
        // kode_otp.value = data['code'];
        id_user.value = data['id'].toString();
        Get.off(() => OtpPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void loginByOtp() async {
    try {
      EasyLoading.show(status: 'loading...');

      String otp_input = otp_field_1.text +
          otp_field_2.text +
          otp_field_3.text +
          otp_field_4.text +
          otp_field_5.text;
      // kirim data
      print("id saya " + id_user.toString());
      print("otp saya " + otp_input.toString());
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/otp_validation");
      var response = await http.post(uri_api, body: {
        "otp": otp_input.toString(),
        "id": id_user.toString(),
      });
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        otp_field_1.text = "";
        otp_field_2.text = "";
        otp_field_3.text = "";
        otp_field_4.text = "";
        otp_field_5.text = "";
        // token
        box.write("token", data['token']);
        Get.off(() => HomePage());
        EasyLoading.dismiss();
      } else {
        showModal(data['message']);
        EasyLoading.dismiss();
      }
      Get.off(() => HomePage());
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    box.remove("token");
    Get.off(() => LoginPage());
    print("Remove token");
  }

  void register(int type_otp) async {
    try {
      EasyLoading.show(status: 'loading...');

      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/register");
      var response = await http.post(uri_api, body: {
        "type": type_otp.toString(),
        "post": hp_reg.text,
        "code_phone": "+62",
        "user_name": nama_reg.text,
        "farmer_name": peternakan_reg.text,
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        otp_field_1.text = "";
        otp_field_2.text = "";
        otp_field_3.text = "";
        otp_field_4.text = "";
        otp_field_5.text = "";
        // kode_otp.value = data['code'];
        id_user.value = data['id'].toString();
        // Get.off(() => PageOtp());
        Get.off(() => OtpPage());
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
      Get.off(() => OtpPage());
    } catch (e) {
      print(e);
    }
  }
}
