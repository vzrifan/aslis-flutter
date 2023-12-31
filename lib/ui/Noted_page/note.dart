import 'package:aslis_application/controller/catatan_controller.dart';
import 'package:aslis_application/ui/Noted_page/add_note.dart';
import 'package:aslis_application/ui/Noted_page/detail_note.dart';
import 'package:aslis_application/ui/Noted_page/edit_note.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class NotePage extends StatefulWidget {
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // const NotePage({Key? key}) : super(key: key);
  final catat_c = Get.put(CatatanController());

  final RefreshController refreshController = RefreshController();

  ScrollController _scrolC = new ScrollController();

  bool onNotificatin(ScrollNotification notification) {
    if (_scrolC.position.pixels == _scrolC.position.maxScrollExtent) {
      print('End Scroll');
      // dash_c.SearchgetProdukTerbaru();
      catat_c.LoadPakan();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff45B549),
          title: Text(
            "Catatan",
            style: ThemesCustom.black_18_700,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  // showModal(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddNotePage();
                  }));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: NotificationListener(
          onNotification: onNotificatin,
          child: SmartRefresher(
            enablePullUp: false,
            controller: refreshController,
            onRefresh: () {
              print("Oke");
              setState(() {});
              refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              controller: _scrolC,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        onChanged: (value) {
                          catat_c.getCatatan(value);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0XFF71A841), width: 2.0),
                          ),
                          hintText: "Cari Catatan",
                          suffix: Icon(Icons.search),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                      future: catat_c.getCatatan(""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              BoxListShimer(),
                              SizedBox(
                                height: 20,
                              ),
                              BoxListShimer(),
                              SizedBox(
                                height: 20,
                              ),
                              BoxListShimer(),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        } else {
                          return Obx(() => catat_c.listCatatan.length == 0
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Center(
                                      child: Image(
                                          width: 200,
                                          height: 300,
                                          image: AssetImage(
                                              "assets/image/empty.png")),
                                    ),
                                    Text(
                                      "Anda belum memiliki catatan",
                                      style: ThemesCustom.black_18_700,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddNotePage();
                                          }));
                                        },
                                        child: Container(
                                          height: 44,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Color(0xff45B549),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: Text(
                                              "Tambah Catatan",
                                              style: ThemesCustom.green_16_700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Obx(() => ListView.builder(
                                    itemCount: catat_c.listCatatan.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return BoxList(
                                          catat_c.listCatatan[index]['title'],
                                          catat_c.listCatatan[index]['date'],
                                          catat_c.listCatatan[index]['id'],
                                          context);
                                    },
                                  )));
                        }
                      },
                    ),
                    // Text(
                    //   "Melakukan Penimbangan Kandang 15",
                    //   style: ThemesCustom.black_14_400,
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Text(
                    //   "12 Februari 2022",
                    //   style: ThemesCustom.grey_14_400,
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: Color(0xff231F20).withOpacity(0.1))),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BoxListShimer() {
    return InkWell(
      child: Container(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[300]!,
                    period: Duration(seconds: 2),
                    child: Container(
                        width: double.infinity,
                        height: 15,
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
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]!,
                            borderRadius: BorderRadius.circular(14))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[500]!,
              highlightColor: Colors.grey[300]!,
              period: Duration(seconds: 2),
              child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey[400]!,
                      borderRadius: BorderRadius.circular(14))),
            ),
          ],
        ),
      ),
    );
  }

  Widget BoxList(
      String judul, String tanggal, String id, BuildContext context) {
    return InkWell(
      onTap: () {
        Get.off(() => DetailCatatan(
              id: id,
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: ThemesCustom.black_14_400,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  tanggal,
                  style: ThemesCustom.grey_14_400,
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                menuModal(id, context);
              },
              icon: Image(image: AssetImage("assets/image/i_filter2.png")))
        ],
      ),
    );
  }

  void confirm_delete(String id) {
    // warehouseController w_controller = Get.find();
    final catat_c = Get.put(CatatanController());

    Get.defaultDialog(
        title: 'Hapus Kambing',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, bottom: 10),
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Center(
              child: Text("Apakah anda yakin akan hapus produk?",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.normal)),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.close(0);
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Tidak",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffffffff)),
                      )),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.close(0);
                      catat_c.hapuscatatan(id);
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Ya",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffffffff)),
                      )),
                      decoration: BoxDecoration(
                        color: Color(0xff019905),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        radius: 10.0);
  }

  void menuModal(String id, BuildContext context) {
    Get.defaultDialog(
        title: 'Pilih Menu',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.close(0);
                confirm_delete(id);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Hapus Catatan",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xffffffff)),
                )),
                decoration: BoxDecoration(
                  color: Color(0xff019905),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(153, 153, 153, 0.25),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Get.close(0);
                // confirm_delete(id);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditNotePage(
                    id: id,
                  );
                }));
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Edit Catatan",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xffffffff)),
                )),
                decoration: BoxDecoration(
                  color: Color(0xff019905),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(153, 153, 153, 0.25),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        radius: 10.0);
  }

  void showModal(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.75, //set this as you want
            maxChildSize: 0.75, //set this as you want
            minChildSize: 0.75, //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Catatan",
                              style: ThemesCustom.black_14_700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ); //whatever you're returning, does not have to be a Container
            }));
  }
}
