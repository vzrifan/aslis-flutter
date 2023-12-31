import 'dart:ui';

import 'package:aslis_application/controller/auth_controller.dart';
import 'package:aslis_application/ui/auth/forgot_password.dart';
import 'package:aslis_application/ui/auth/register.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  final box = GetStorage();
  LoginController login_c = Get.find();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 80),
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
                    "Login",
                    style: ThemesCustom.black_22_800,
                  ),
                  Text(
                    "Masukan nomer HP aktif anda untuk masuk",
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
                                    value.length <= 7) {
                                  return 'Nomor tidak valid';
                                }
                                return null;
                              },
                              controller: login_c.txt_hp_login,
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
                    height: 150,
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
                  //         borderSide:
                  //             const BorderSide(color: Color(0XFF71A841), width: 2.0),
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
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //       return ForgotPasswordPage();
                  //     }));
                  //   },
                  //   child: Text(
                  //     "Lupa Kata Sandi?",
                  //     style: ThemesCustom.green_16_700,
                  //   ),
                  // ),
                  SizedBox(
                    height: 150,
                  ),
                  InkWell(
                    onTap: () {
                      if (_keyForm.currentState!.validate()) {
                        login_c.sendLogin();
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return HomePage();
                      // }));
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Color(0xff45B549),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          "Login",
                          style: ThemesCustom.white_16_700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      }));
                    },
                    child: Center(
                      child: Text(
                        "Saya belum punya akun",
                        style: ThemesCustom.green_16_700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
