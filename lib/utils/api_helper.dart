import 'package:http/http.dart' as http;

class ApiService {
  static final client = http.Client();
  static const int timeout = 240000;
  // static String baseUrl = "https://api-aslis.angkitagro.com/api";
  // static String baseUrl = "http://10.0.2.2:8000/api";
  static String baseUrl = "http://103.93.56.213:81/api";
}
