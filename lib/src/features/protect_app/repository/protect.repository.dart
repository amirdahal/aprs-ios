import 'package:aprs/src/model/model.dart' show PasswordStore;
import 'package:crypt/crypt.dart';

class ProtectRepository {
  static Future<bool> validatePassword(String inputPassword) async {
    PasswordStore? passwordStore = await PasswordStore().getById(1);
    if (passwordStore != null) {
      final input = Crypt.sha256(inputPassword, rounds: 10, salt: "myRadioApp");
      if (passwordStore.password == input.toString()) {
        return true;
      }
    } else {
      return inputPassword.trim() == "123456";
    }
    return false;
  }
}
