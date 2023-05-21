import 'package:ichthyolog/main.dart';

class Helpers {
  Future<String> checkJwt() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt != null) {
      return jwt;
    } else {
      return '';
    }
  }
}
