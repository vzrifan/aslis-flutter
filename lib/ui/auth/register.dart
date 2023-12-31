import 'dart:ui';
import 'package:aslis_application/controller/auth_controller.dart';
import 'package:aslis_application/ui/auth/method_otp.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  // const RegisterPage({Key? key}) : super(key: key);
  LoginController login_c = Get.find();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              if (_keyForm.currentState!.validate()) {
                // print("Oke");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MethodOtpPage();
                }));
              }
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  color: Color(0xff45B549),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  "Daftar",
                  style: ThemesCustom.white_16_700,
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                      width: 72,
                      height: 72,
                      image: AssetImage('assets/image/logo_polos.png')),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Daftar",
                    style: ThemesCustom.black_22_800,
                  ),
                  Text(
                    "Mohon lengkapi isian di bawah ini",
                    style: ThemesCustom.black_16_400_07,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Nomor Telepon",
                    style: ThemesCustom.black_14_700,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 86,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(35, 31, 32, 0.16),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image:
                                    AssetImage("assets/image/indonesia.png")),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "+62",
                              style: ThemesCustom.black1_16_700,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return 'Nomor tidak valid';
                                }
                                return null;
                              },
                              controller: login_c.hp_reg,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0XFF71A841), width: 2.0),
                                ),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )))
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Nama Lengkap",
                    style: ThemesCustom.black_14_700,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Nama tidak valid';
                        }
                        return null;
                      },
                      controller: login_c.nama_reg,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFF71A841), width: 2.0),
                        ),
                        hintText: "Contoh : Suryoto",
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      )),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Nama Peternakan",
                    style: ThemesCustom.black_14_700,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Peternak tidak valid';
                        }
                        return null;
                      },
                      controller: login_c.peternakan_reg,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFF71A841), width: 2.0),
                        ),
                        hintText: "Contoh : Peternakan ABC",
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      )),
                  SizedBox(
                    height: 14,
                  ),
                  // Text(
                  //   "Kata Sandi",
                  //   style: ThemesCustom.black_14_700,
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty || value.length < 6) {
                  //         return 'Password tidak valid';
                  //       }
                  //       return null;
                  //     },
                  //     decoration: InputDecoration(
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //             color: Color(0XFF71A841), width: 2.0),
                  //       ),
                  //       hintText: "*************",
                  //       contentPadding: EdgeInsets.all(12),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 14,
                  // ),
                  // Text(
                  //   "Ulangi Sandi",
                  //   style: ThemesCustom.black_14_700,
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty || value.length < 6) {
                  //         return 'Password tidak valid';
                  //       }
                  //       return null;
                  //     },
                  //     decoration: InputDecoration(
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //             color: Color(0XFF71A841), width: 2.0),
                  //       ),
                  //       hintText: "*************",
                  //       contentPadding: EdgeInsets.all(12),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 24,
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
