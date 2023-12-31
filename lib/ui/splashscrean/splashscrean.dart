import 'dart:async';

import 'package:aslis_application/controller/auth_controller.dart';
import 'package:aslis_application/ui/auth/login.dart';
import 'package:aslis_application/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final box = GetStorage();
  final login_c = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    void goLogin() {
      Timer(Duration(seconds: 2), () {
        print(" This line is execute after 5 seconds");
        print(" My Token " + box.read("token").toString());

        if (box.read("token") == null) {
          print("Kosong");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        } else {
          print("Ada");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        }

        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) {
        //   return LoginPage();
        // }));
      });
    }

    goLogin();
    return Scaffold(
      body: Center(
        child: Image(
            width: 174,
            height: 136,
            image: AssetImage("assets/image/logo.png")),
      ),
    );
  }
}
