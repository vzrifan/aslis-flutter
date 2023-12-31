import 'dart:convert';

import 'package:aslis_application/ui/beriPakan/list_%20feed.dart';
import 'package:aslis_application/ui/pakan/list_pakan.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PakanController extends GetxController {
  RxList<Map<String, dynamic>> listpakan = <Map<String, dynamic>>[].obs;
  RxInt is_loading = 0.obs;
  RxInt is_halaman = 0.obs;
  RxInt all_page = 0.obs;
  TextEditingController cari_pakan = TextEditingController();
  final box = GetStorage();

  RxList<Map<String, dynamic>> listpakanKategori = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listkandangKategori =
      <Map<String, dynamic>>[].obs;

  // riwayat pakan
  RxList<Map<String, dynamic>> listriwayat = <Map<String, dynamic>>[].obs;
  RxInt is_loading_riwayat = 0.obs;
  RxInt is_halaman_riwayat = 0.obs;
  RxInt all_page_riwayat = 0.obs;
  TextEditingController cari_pakan_riwayat = TextEditingController();

  // riwayat pakan by kategori
  RxList<Map<String, dynamic>> listriwayat_by = <Map<String, dynamic>>[].obs;
  RxInt is_loading_riwayat_by = 0.obs;
  RxInt is_halaman_riwayat_by = 0.obs;
  RxInt all_page_riwayat_by = 0.obs;

  // tambah data
  TextEditingController id_pakan = TextEditingController();
  TextEditingController nama_pakan = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController berat = TextEditingController();
  TextEditingController harga = TextEditingController();
  RxString jenis_pakan = "".obs;
  // edit data
  TextEditingController id_pakan_u = TextEditingController();
  TextEditingController nama_pakan_u = TextEditingController();
  TextEditingController tanggal_u = TextEditingController();
  TextEditingController berat_u = TextEditingController();
  TextEditingController harga_u = TextEditingController();
  RxString jenis_pakan_u = "".obs;
  RxString name_jenis_pakan_u = "".obs;
  RxString id_pakan_update = "".obs;

  // tambah beri pakan
  RxString pakan_beri = "".obs;
  RxString kandang_beri = "".obs;
  TextEditingController tanggal_beri = TextEditingController();
  TextEditingController berat_beri = TextEditingController();

  void beriPakan() async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/cattle/give_food");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id_shed": kandang_beri.value.toString(),
        "id_food": pakan_beri.value.toString(),
        "weigth": berat_beri.text.toString(),
        "date": tanggal_beri.text.toString(),
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        Get.off(() => ListFeed());
        kandang_beri.value = "";
        pakan_beri.value = "";
        berat_beri.text = "";
        tanggal_beri.text = "";
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListPakan() async {
    try {
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/get_data/food");
      var response =
          await http.get(uri_api, headers: {"Authorization": is_token});
      listpakanKategori.clear();

      if (response.statusCode == 200) {
        List data =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        data.forEach((element) {
          print("okes");
          listpakanKategori.add(element);
        });
        print("List Kandang" + listpakanKategori.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListKandang() async {
    try {
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/get_data/shed");
      var response =
          await http.get(uri_api, headers: {"Authorization": is_token});
      listkandangKategori.clear();

      if (response.statusCode == 200) {
        List data =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        data.forEach((element) {
          print("okes");
          listkandangKategori.add(element);
        });
        print("List Kandang" + listkandangKategori.length.toString());
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future GetKandang(String cari) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/index");
      var response = await http.post(uri_api,
          body: {"search": cari.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listpakan.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page.value = data_detail['last_page'];
        is_halaman.value = 2;
        data.forEach((element) {
          print("okes");
          listpakan.add(element);
        });
        is_loading.value = 0;
        print("List Kandang" + listpakan.length.toString());
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
          var uri_api = Uri.parse(
              ApiService.baseUrl + "/food/index?page=" + is_halaman.toString());
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
              listpakan.add(element);
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

  void simpanPakan() async {
    try {
      var test = harga.text;
      var harga_2 = test.replaceAll(",", "");
      print(harga_2);
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/add");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "food_id": id_pakan.text.toString(),
        "food_name": nama_pakan.text.toString(),
        "id_category": jenis_pakan.value.toString(),
        "stock": berat.text.toString(),
        "date": tanggal.text.toString(),
        "capital_price": harga_2,
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        Get.off(() => PakanPage());
        id_pakan.text = "";
        nama_pakan.text = "";
        jenis_pakan.value = "";
        berat.text = "";
        tanggal.text = "";
        harga.text = "";
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void hapusPakan(id) async {
    try {
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/delete");
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

  void ubahPakan() async {
    try {
      var test = harga_u.text;
      var harga_2 = test.replaceAll(",", "");
      EasyLoading.show(status: 'loading...');
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/update");
      var is_token = "Bearer " + box.read("token");
      var response = await http.post(uri_api, body: {
        "id": id_pakan_update.value.toString(),
        "food_id": id_pakan_u.text.toString(),
        "food_name": nama_pakan_u.text.toString(),
        "id_category": jenis_pakan_u.value.toString(),
        "stock": berat_u.text.toString(),
        "date": tanggal_u.text.toString(),
        "capital_price": harga_2,
      }, headers: {
        "Authorization": is_token
      });
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showModal(data['message']);
        Get.off(() => PakanPage());
        id_pakan.text = "";
        nama_pakan.text = "";
        jenis_pakan.value = "";
        berat.text = "";
        tanggal.text = "";
        harga.text = "";
      } else {
        EasyLoading.dismiss();
        showModal(data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  // riwayat beri pakan
  Future getRiwayatPakan(String cari) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/history_shed");
      var response = await http.post(uri_api,
          body: {"search": cari.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);

      listriwayat.clear();

      if (data_respone['code'] == 200) {
        print("Masuknnn");
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page_riwayat.value = data_detail['last_page'];
        is_halaman_riwayat.value = 2;
        data.forEach((element) {
          print(element);
          listriwayat.add(element);
        });
        is_loading_riwayat.value = 0;
        print("List Kandang" + data_detail['last_page']);
      } else {
        print("gagal pages Pakan");
        print(data_respone);
      }
    } catch (e) {
      print(e);
    }
  }

  Future LoadRiwayatPakan() async {
    try {
      print("Loaded");
      if (is_loading_riwayat.value == 0) {
        is_loading_riwayat.value = 1;
        if (all_page_riwayat.value >= is_halaman_riwayat.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/food/history?page=" +
              is_halaman_riwayat.toString());
          var response = await http.post(uri_api,
              body: {"search": cari_pakan_riwayat.text},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            // print();
            is_loading_riwayat.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_riwayat.value = data_detail['last_page'];
            data.forEach((element) {
              listriwayat.add(element);
            });
            is_loading_riwayat.value = 0;
            is_halaman_riwayat.value = is_halaman_riwayat.value + 1;
          } else {
            print("Halaman " + is_halaman_riwayat.value.toString());
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

  Future getRiwayatPakanBykategori(String id) async {
    try {
      print("Loaded");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/food/history");
      var response = await http.post(uri_api,
          body: {"id_food": id.toString()},
          headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body);
      listriwayat_by.clear();

      if (data_respone['code'] == 200) {
        List data = (json.decode(response.body) as Map<String, dynamic>)['data']
            ['data'];
        var data_detail = json.decode(response.body)['data'];
        all_page_riwayat_by.value = data_detail['last_page'];
        is_halaman_riwayat_by.value = 2;
        data.forEach((element) {
          print(element);
          listriwayat_by.add(element);
        });
        is_loading_riwayat_by.value = 0;
        print("List Kandang" + listriwayat_by.length.toString());
      } else {
        listriwayat_by.clear();
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  Future LoadRiwayatPakanByKategori(String id) async {
    try {
      print("Loaded");
      if (is_loading_riwayat_by.value == 0) {
        is_loading_riwayat_by.value = 1;
        if (all_page_riwayat_by.value >= is_halaman_riwayat_by.value) {
          print("get api");
          var is_token = "Bearer " + box.read("token");
          var uri_api = Uri.parse(ApiService.baseUrl +
              "/food/history?page=" +
              is_halaman_riwayat_by.toString());
          var response = await http.post(uri_api,
              body: {"id_food": id.toString()},
              headers: {"Authorization": is_token});
          var data_respone = json.decode(response.body);
          if (data_respone['code'] == 200) {
            is_loading_riwayat_by.value = 0;
            List data = (json.decode(response.body)
                as Map<String, dynamic>)['data']['data'];
            var data_detail = json.decode(response.body)['data'];
            all_page_riwayat_by.value = data_detail['last_page'];
            data.forEach((element) {
              listriwayat_by.add(element);
            });
            is_loading_riwayat_by.value = 0;
            is_halaman_riwayat_by.value = is_halaman_riwayat_by.value + 1;
          } else {
            print("Halaman " + is_halaman_riwayat_by.value.toString());
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
