import 'package:aslis_application/controller/ProfileController.dart';
import 'package:aslis_application/controller/auth_controller.dart';
import 'package:aslis_application/controller/home_controller.dart';
import 'package:aslis_application/ui/profile/update_profile.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  // const ProfilePage({Key? key}) : super(key: key);

  LoginController login_c = Get.find();
  HomeController home_c = Get.find();
  final profile_c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
          onTap: () {
            login_c.logout();
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
                color: Color(0xffD9434B),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                "Keluar",
                style: ThemesCustom.white_16_700,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Profile",
                    style: ThemesCustom.black_22_800,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Obx(() => home_c.foto_user.value == ""
                          ? Image(
                              width: 64,
                              height: 64,
                              image:
                                  AssetImage("assets/image/empty_profile.png"))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      home_c.foto_user.value)),
                            )),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: home_c.getData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  "-",
                                  style: ThemesCustom.black_18_700,
                                );
                              } else {
                                return Text(
                                  home_c.nama_user.value,
                                  style: ThemesCustom.black_18_700,
                                );
                              }
                            },
                          ),
                          // Text(
                          //   "Bapak Sunyoto",
                          //   style: ThemesCustom.black_18_700,
                          // ),
                          Row(
                            children: [
                              Image(
                                  image:
                                      AssetImage("assets/image/i_lokasi.png")),
                              SizedBox(
                                width: 4,
                              ),
                              FutureBuilder(
                                future: home_c.getAlamat(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "-",
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Color(0XFF011627),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      home_c.lokasi.value,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Color(0XFF011627),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                },
                              ),
                              // Text(
                              //   "Surabaya - Pasuruan - Malang",
                              //   style: ThemesCustom.black_11_700_07,
                              // )
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 7,
              color: Color(0xffF2F6FF),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UpdateProfilePage();
                      }));
                    },
                    child: Row(
                      children: [
                        Image(image: AssetImage("assets/image/i_profile.png")),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Text(
                          "Ubah Profile",
                          style: ThemesCustom.black2_15_400,
                        )),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: double.infinity,
                      height: 1,
                      color: Color.fromRGBO(35, 31, 32, 0.1)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image(image: AssetImage("assets/image/keuntungan.png")),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                        "Keuntungan Pakai ANGKIT AGRO - Aslis",
                        style: ThemesCustom.black2_15_400,
                      )),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: double.infinity,
                      height: 1,
                      color: Color.fromRGBO(35, 31, 32, 0.1)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image(image: AssetImage("assets/image/syarat.png")),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                        "Syarat Dan Ketentuan",
                        style: ThemesCustom.black2_15_400,
                      )),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: double.infinity,
                      height: 1,
                      color: Color.fromRGBO(35, 31, 32, 0.1)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image(image: AssetImage("assets/image/kebijakan.png")),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                        "Kebijakan Privasi",
                        style: ThemesCustom.black2_15_400,
                      )),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   width: double.infinity,
            //   height: 7,
            //   color: Color(0xffF2F6FF),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(18.0),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           SizedBox(
            //             width: 12,
            //           ),
            //           Expanded(
            //               child: Text(
            //             "Master Jenis Pakan",
            //             style: ThemesCustom.black2_15_400,
            //           )),
            //           Icon(Icons.chevron_right)
            //         ],
            //       ),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Container(
            //           width: double.infinity,
            //           height: 1,
            //           color: Color.fromRGBO(35, 31, 32, 0.1)),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Row(
            //         children: [
            //           SizedBox(
            //             width: 12,
            //           ),
            //           Expanded(
            //               child: Text(
            //             "Master Jenis Hewan",
            //             style: ThemesCustom.black2_15_400,
            //           )),
            //           Icon(Icons.chevron_right)
            //         ],
            //       ),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Container(
            //           width: double.infinity,
            //           height: 1,
            //           color: Color.fromRGBO(35, 31, 32, 0.1)),
            //       SizedBox(
            //         height: 15,
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
