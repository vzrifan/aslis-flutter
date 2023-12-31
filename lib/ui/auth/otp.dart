import 'package:aslis_application/controller/auth_controller.dart';
import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class OtpPage extends StatelessWidget {
  // const OtpPage({Key? key}) : super(key: key);
  FocusNode txt1 = FocusNode();
  FocusNode txt2 = FocusNode();
  FocusNode txt3 = FocusNode();
  FocusNode txt4 = FocusNode();
  FocusNode txt5 = FocusNode();
  LoginController login_c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: () {
              login_c.loginByOtp();
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  color: Color(0xff45B549),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  "Verifikasi",
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
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
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
                  "Sebentar lagi selesai",
                  style: ThemesCustom.black_22_800,
                ),
                Text(
                  "Cukup masukkan kode 6 digit yang kami kirimkan melalui SMS ke nomor telepon anda +62" +
                      login_c.hp_reg.text +
                      " " +
                      login_c.txt_hp_login.text,
                  style: ThemesCustom.black_16_400_07,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Masukan Kode OTP",
                  style: ThemesCustom.black_14_700,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).requestFocus(txt2);
                            }
                          },
                          maxLength: 1,
                          focusNode: txt1,
                          controller: login_c.otp_field_1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).requestFocus(txt3);
                            }
                          },
                          maxLength: 1,
                          focusNode: txt2,
                          controller: login_c.otp_field_2,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).requestFocus(txt4);
                            }
                          },
                          maxLength: 1,
                          focusNode: txt3,
                          controller: login_c.otp_field_3,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).requestFocus(txt5);
                            }
                          },
                          maxLength: 1,
                          focusNode: txt4,
                          controller: login_c.otp_field_4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              login_c.loginByOtp();
                              // FocusScope.of(context).requestFocus(txt6);
                            }
                          },
                          maxLength: 1,
                          focusNode: txt5,
                          controller: login_c.otp_field_5,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }
}
