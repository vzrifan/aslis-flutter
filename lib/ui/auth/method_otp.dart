import 'package:aslis_application/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MethodOtpPage extends StatelessWidget {
  const MethodOtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController login_c = Get.find();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return OnboardPage();
                // }));
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "Pilih Metode Verifikasi",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: Color(0XFF011627),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  "Pilih salah satu metode dibawah ini untuk",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Color(0XFF011627),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "mendapatkan kode verifikasi.",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Color(0XFF011627),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    login_c.register(1);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return PageOtp();
                    // }));
                  },
                  child: Container(
                    height: 64,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Color(0XFFE6E9EF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Image(
                              image: AssetImage("assets/image/sms.png"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 14),
                                  Text(
                                    "SMS Ke",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Color(0XFF000000),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    login_c.txt_hp.text,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Color(0XFF011627).withOpacity(0.6),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    login_c.register(0);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return PageOtp();
                    // }));
                  },
                  child: Container(
                    height: 64,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Color(0XFFE6E9EF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            child: Image(
                              image: AssetImage("assets/image/i_wa.png"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 14),
                                  Text(
                                    "WhatsApp Ke",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Color(0XFF000000),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    login_c.txt_hp.text,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Color(0XFF011627).withOpacity(0.6),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
