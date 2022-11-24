
import 'package:get/get.dart';

class ApiController extends GetConnect {
  static final ApiController _instance = ApiController._internal();
  factory ApiController() => _instance;

  ApiController._internal() {
    httpClient.baseUrl = "https://payment.jinom.net";
  }

  transactionDetail(String token) => get("/api/transaction/$token", headers: {
        "Accept": "application/json",
      });

  charge(String token, Map<String, dynamic> body) =>
      post("/api/transaction/$token/charge", body, headers: {
        "Accept": "application/json",
      });

  createSnapToken(Map<String, dynamic> body, String authToken) =>
      post("/api/snap/token", body, headers: {
        "Authorization":
            "Bearer $authToken",
        "Accept": "application/json",
      });

  getStatus(String token) => get("/api/transaction/$token/status", headers: {
        "Accept": "application/json",
      });

      
}
