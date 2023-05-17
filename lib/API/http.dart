import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

//class which stores the functions responsible for backend communication
class HttpHelpers {
  //signup request returns success message or error message
  //the string can be used for pop-up display etc.
  Future<String> signupRequest(
      String username, String password, String email) async {
    String url = "http://localhost:3000/users";
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email
      }),
    );
    if (response.statusCode == 201) {
      var responseData = convert.jsonDecode(response.body) as String;
      return responseData;
    }
    return 'Request failed with status: ${response.statusCode}.';
  }
}
