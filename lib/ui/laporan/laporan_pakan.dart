import 'dart:convert';

import 'package:aslis_application/utils/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class LaporanPakanPage extends StatelessWidget {
  const LaporanPakanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String link = "";
    String links = "https://kandidat.id/";
    final box = GetStorage();
    Future getData() async {
      try {
        var uri_api = Uri.parse(ApiService.baseUrl + "/laporan_pakan");
        var is_token = "Bearer " + box.read("token");
        var response =
            await http.get(uri_api, headers: {"Authorization": is_token});
        if (response.statusCode == 200) {
          var data_de = json.decode(response.body);
          var data_respone = json.decode(response.body);
          print("response");
          print(data_respone);
          links = data_respone['data'];
        } else {
          print("Gagal Oage");
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Center(
                  child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.green,
                        strokeWidth: 10,
                      )),
                ),
              ],
            );
          } else {
            return WebViewWidget(
                controller: WebViewController()
                  // TODO initial url
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(links)));

            // return WebView(
            //   initialUrl: links,
            //   javascriptMode: JavascriptMode.unrestricted,
            // );
          }
        },
      ),
    );
  }
}
