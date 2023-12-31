import 'package:aslis_application/controller/KambingController.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PageRiwayatMakanKambingByPakan extends StatefulWidget {
  var id;
  PageRiwayatMakanKambingByPakan({required this.id});
  // const PageRiwayatMakanKambingByPakan({Key? key}) : super(key: key);

  @override
  _PageRiwayatMakanKambingByPakanState createState() =>
      _PageRiwayatMakanKambingByPakanState();
}

class _PageRiwayatMakanKambingByPakanState
    extends State<PageRiwayatMakanKambingByPakan> {
  // KambingController kambing_c = Get.find();
  final kambing_c = Get.put(KambingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
              Expanded(
                child: Center(
                  child: Text(
                    "Riwayat Pakan",
                    style: ThemesCustom.black_14_700,
                  ),
                ),
              ),
              // IconButton(
              //     onPressed: () {
              //       // Navigator.pop(context);
              //     },
              //     icon: Image(
              //         width: 25,
              //         height: 25,
              //         image: AssetImage("assets/image/filter.png"))),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: kambing_c.getListRiwayatMakanByPakan(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: kambing_c.listRiwayatMakanByPakan.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        BoxMakan(
                          kambing_c.listRiwayatMakanByPakan[index]
                              ['cattle_name'],
                          kambing_c.listRiwayatMakanByPakan[index]['price_food']
                              .toString(),
                          kambing_c.listRiwayatMakanByPakan[index]['weigth'],
                          kambing_c.listRiwayatMakanByPakan[index]['date'],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: double.infinity,
                            height: 1,
                            color: Color.fromRGBO(35, 31, 32, 0.1)),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget BoxMakan(String kandang, String hargas, String berat, String harga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          harga,
          style: ThemesCustom.black_13_400,
        )),
        Container(
          width: 150,
          child: Text(
            kandang,
            maxLines: 1,
            style: ThemesCustom.black_13_700,
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              berat + " Kg",
              style: ThemesCustom.black_13_700,
            ),
            SizedBox(
              width: 5,
            ),
            // Text(
            //   "Rp. " + NumberFormat.decimalPattern().format(int.parse(hargas)),
            //   style: ThemesCustom.black_13_400,
            // ),
            Text(
              "Rp. " + hargas,
              style: ThemesCustom.black_13_400,
            ),
          ],
        )),
      ],
    );
  }
}
