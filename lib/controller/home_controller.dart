import 'dart:convert';

import 'package:aslis_application/utils/api_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxString nama_user = "".obs;
  RxString foto_user = "".obs;
  RxString total_ternak = "0".obs;
  RxString persen_total_ternak = "0".obs;
  RxString growth = "0".obs;
  RxString persen_growth = "0".obs;
  RxString berat = "0".obs;
  RxString persen_berat = "0".obs;
  RxString lokasi = "".obs;
  RxDouble berat_double = 0.0.obs;

  final box = GetStorage();

  Future getData() async {
    try {
      var uri_api = Uri.parse(ApiService.baseUrl + "/auth/get_data_profile");
      var is_token = "Bearer " + box.read("token");
      var response =
          await http.get(uri_api, headers: {"Authorization": is_token});
      var data = json.decode(response.body)['data'];
      print(data);
      if (response.statusCode == 200) {
        print("Nama Saya " + data['user_name'].toString());
        nama_user.value = data['user_name'] ?? "";
        foto_user.value = data['profile'] ?? "";
        // get data dash
        getDashboard();
      } else {
        print("Bad Request");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getAlamat() async {
    try {
      LocationPermission per = await Geolocator.checkPermission();
      if (per == LocationPermission.denied ||
          per == LocationPermission.deniedForever) {
        print("permission denied");
        LocationPermission per1 = await Geolocator.requestPermission();
      } else {
        Position currentLoc = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        print("long " + currentLoc.longitude.toString());
        print("lat " + currentLoc.latitude.toString());

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              currentLoc.latitude.toDouble(), currentLoc.longitude.toDouble());
          Placemark placeMark = placemarks[0];
          String subLocality = placeMark.subLocality.toString();
          String locality = placeMark.locality.toString();
          String administrativeArea =
              placeMark.subAdministrativeArea.toString();
          lokasi.value = "${administrativeArea}";
          print("My Lokasi" + lokasi.value);
        } catch (e) {
          print(e);
          lokasi.value = "-";
        }

        // print("My Id" + id_device);
      }
    } catch (e) {
      print(e);
    }
  }

  void getDashboard() async {
    try {
      var date = new DateTime.now().toString();
      var dateParse = DateTime.parse(date);
      var uri_api_2 = Uri.parse(ApiService.baseUrl + "/home");
      var is_token_2 = "Bearer " + box.read("token");
      var response_2 = await http.post(uri_api_2, body: {
        "month": dateParse.month.toString(),
        "year": dateParse.year.toString(),
      }, headers: {
        "Authorization": is_token_2
      });
      var data_2 = json.decode(response_2.body)['data'];
      print(data_2);
      if (response_2.statusCode == 200) {
        total_ternak.value = data_2['cattle_number'].toString();
        persen_total_ternak.value = data_2['cattle_number_progress'].toString();
        growth.value = data_2['grouwth'].toString();
        persen_growth.value = data_2['grouwth_progress'].toString();
        berat.value = data_2['weigth'].toString();
        berat_double.value = double.parse(data_2['weigth'].toString());
        persen_berat.value = data_2['weigth_progress'].toString();
      } else {
        print("Bad Request");
      }
    } catch (e) {
      print(e);
    }
  }
}
