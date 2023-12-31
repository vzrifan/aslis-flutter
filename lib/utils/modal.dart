import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void showModal(String pesan) {
  Get.defaultDialog(
      title: 'Info',
      titleStyle: GoogleFonts.montserrat(
          fontSize: 14, color: Color(0xff333333), fontWeight: FontWeight.bold),
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
            child: Text(pesan,
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.close(0);
            },
            child: Container(
              height: 40,
              width: double.infinity,
              child: Center(
                  child: Text(
                "Ok",
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

void showModalTwo(String pesan) {
  Get.defaultDialog(
      title: 'Berhasil',
      titleStyle: GoogleFonts.montserrat(
          fontSize: 14, color: Color(0xff333333), fontWeight: FontWeight.bold),
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
            child: Text(pesan,
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.close(0);
              // Get.off(NextScreen());

              // Get.offAll(() => NavigationSeller(
              //       pages: 0,
              //     ));

              // Get.to (() => TestPages(
              //       pages: 0,
              //     ));
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
        ],
      ),
      radius: 10.0);
}

void showModalSuccess(String pesan) {
  Get.defaultDialog(
      title: 'Berhasil',
      titleStyle: GoogleFonts.montserrat(
          fontSize: 14, color: Color(0xff333333), fontWeight: FontWeight.bold),
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
            child: Text(pesan,
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.normal)),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.close(0);
              // Get.off(NextScreen());
              // Get.offAll(() => NavigationSeller(
              //       pages: 0,
              //     ));

              // Get.to (() => TestPages(
              //       pages: 0,
              //     ));
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
        ],
      ),
      radius: 10.0);
}
