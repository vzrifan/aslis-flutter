import 'dart:convert';

import 'package:aslis_application/ui/Noted_page/edit_note.dart';
import 'package:aslis_application/ui/Noted_page/note.dart';
import 'package:aslis_application/utils/api_helper.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DetailCatatan extends StatefulWidget {
  // const DetailCatatan({Key? key}) : super(key: key);
  var id;
  DetailCatatan({required this.id});

  @override
  _DetailCatatanState createState() => _DetailCatatanState();
}

class _DetailCatatanState extends State<DetailCatatan> {
  String judul_u = "";
  String tanggal_u = "";
  String deksripsi_u = "";
  String img_u = "";
  String jenis = "";
  String masalah = "";
  List<String> detail_masalah = <String>[];
  String sub_jenis = "";
  final box = GetStorage();

  Future getData() async {
    try {
      print("Jalan");
      var is_token = "Bearer " + box.read("token");
      var uri_api = Uri.parse(ApiService.baseUrl + "/notes/detail");
      var response = await http.post(uri_api,
          body: {"id": widget.id}, headers: {"Authorization": is_token});
      var data_respone = json.decode(response.body)['data'];
      var data_respone_2 = json.decode(response.body);
      print(data_respone_2);
      if (response.statusCode == 200) {
        // print("Muhib" + data_respone['photo']);
        judul_u = data_respone['title'] ?? "";
        tanggal_u = data_respone['date'] ?? "";
        deksripsi_u = data_respone['description'] ?? "";
        img_u = data_respone['photo'] ?? "";
        jenis = data_respone['event_name'] ?? "";
        masalah = data_respone['problem_name'] ?? "";
        List data_problem = (json.decode(response.body)
            as Map<String, dynamic>)['data']['data_problem'];
        detail_masalah.clear();
        data_problem.forEach((element) {
          detail_masalah.add(element['name']);
          if (element['type'] == 1) {
            sub_jenis = "Kandang";
          } else if (element['type'] == 2) {
            sub_jenis = "Hewan Ternal";
          }
          if (element['type'] == 3) {
            sub_jenis = "Pakan";
          }
        });
      } else {
        print("gagal pages");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return NotePage();
                    }));
                  },
                  icon: Icon(Icons.close)),
              Expanded(
                child: Center(
                  child: Text(
                    "Detail Catatan",
                    style: ThemesCustom.black_14_700,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditNotePage(
                      id: widget.id,
                    );
                  }));
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return EdtiKandang();
                  // }));
                },
                child: Text("Edit"),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
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
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul_u,
                          style: ThemesCustom.black_12_700,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          tanggal_u,
                          style: ThemesCustom.black_12_700,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          deksripsi_u,
                          style: ThemesCustom.black_12_400,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        img_u != ""
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Foto Catatan",
                                    style: ThemesCustom.black_14_700,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image(
                                      width: double.infinity,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(img_u)),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          "Jenis",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          jenis,
                          style: ThemesCustom.black_12_400,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Masalah",
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          masalah,
                          style: ThemesCustom.black_12_400,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          sub_jenis,
                          style: ThemesCustom.black_14_700,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: detail_masalah.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                detail_masalah[index],
                                style: ThemesCustom.black_12_400,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
