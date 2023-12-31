import 'package:aslis_application/controller/notifikasi_controller.dart';
import 'package:aslis_application/ui/kandang/detail_kandang.dart';
import 'package:aslis_application/ui/pakan/edit_pakan.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class NotifikasiPage extends StatelessWidget {
  // const NotifikasiPage({Key? key}) : super(key: key);
  final notif_c = Get.put(NotifikasiController());
  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      notif_c.LoadPakan();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff45B549),
        title: Text(
          "Notifikasi",
          style: ThemesCustom.black_18_700,
        ),
        centerTitle: true,
      ),
      body: NotificationListener(
        onNotification: onNotificatin,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              controller: _scrolC,
              child: FutureBuilder(
                future: notif_c.getNotif(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        shimmerBox(),
                        SizedBox(
                          height: 10,
                        ),
                        shimmerBox(),
                        SizedBox(
                          height: 10,
                        ),
                        shimmerBox(),
                        SizedBox(
                          height: 10,
                        ),
                        shimmerBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } else {
                    return notif_c.listNotif.length == 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 80,
                              ),
                              Center(
                                child: Image(
                                    width: 200,
                                    height: 300,
                                    image:
                                        AssetImage("assets/image/empty.png")),
                              ),
                              Text(
                                "Anda belum memiliki notifikasi",
                                style: ThemesCustom.black_18_700,
                              )
                            ],
                          )
                        : ListView.builder(
                            itemCount: notif_c.listNotif.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return boxNotif(
                                notif_c.listNotif[index]['title'],
                                "-",
                                notif_c.listNotif[index]['text'],
                                notif_c.listNotif[index]['tipe'],
                                notif_c.listNotif[index]['id'],
                                notif_c.listNotif[index]['id_detail'],
                              );
                            },
                          );
                  }
                },
              )),
        ),
      ),
    );
  }

  Widget boxNotif(String judul, String jam, String desk, String type, String id,
      String id_detail) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          Get.to(() => EditPakanPage(
                id: id_detail,
              ));
        } else {
          Get.to(() => DetailKandang(
                id: id_detail,
              ));
        }

        // hapus notifikasi
        notif_c.hapusNotif(id);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          height: 133,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: ThemesCustom.black_14_700,
              ),
              Text(
                "3 Hours Ago",
                style: ThemesCustom.black_10_400_07,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                desk,
                maxLines: 2,
                style: ThemesCustom.black_12_400,
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1.5, color: Color(0xffF2F6FF))),
        ),
      ),
    );
  }

  Widget shimmerBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            period: Duration(seconds: 2),
            child: Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.grey[400]!,
                    borderRadius: BorderRadius.circular(14))),
          ),
          SizedBox(
            height: 5,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            period: Duration(seconds: 2),
            child: Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.grey[400]!,
                    borderRadius: BorderRadius.circular(14))),
          ),
          SizedBox(
            height: 8,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            period: Duration(seconds: 2),
            child: Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.grey[400]!,
                    borderRadius: BorderRadius.circular(14))),
          ),
          SizedBox(
            height: 2,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            period: Duration(seconds: 2),
            child: Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.grey[400]!,
                    borderRadius: BorderRadius.circular(14))),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1.5, color: Color(0xffF2F6FF))),
    );
  }
}
