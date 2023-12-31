import 'package:aslis_application/utils/theme.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Setel ulang kata sandi",
                  style: ThemesCustom.black_22_800,
                ),
                Text(
                  "Masukkan nomor HP yang telah terdaftar di ANGKIT AGRO agar kami dapat mengirimkan link untuk mengganti kata sandi anda",
                  style: ThemesCustom.black_16_400_07,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Nomor Telepone",
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
                              image: AssetImage("assets/image/indonesia.png")),
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
                                return 'Password tidak valid';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0XFF71A841), width: 2.0),
                              ),
                              hintText: "0812345678",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )))
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                      color: Color(0xff45B549),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      "Reset kata sandi",
                      style: ThemesCustom.white_16_700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ));
  }
}
