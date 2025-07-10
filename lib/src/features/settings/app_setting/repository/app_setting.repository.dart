import 'package:aprs/src/model/model.dart' show PasswordStore;
import 'package:crypt/crypt.dart';
import 'package:flutter/foundation.dart';

class AppSettingRepository {
  static Future<bool> createPassword(String inputPassword) async {
    try {
      final input = Crypt.sha256(inputPassword, rounds: 10, salt: "myRadioApp");
      List<PasswordStore?> passwordStore = await PasswordStore()
          .select()
          .toList();
      if (passwordStore.isNotEmpty) {
        passwordStore[0]?.password = input.toString();
        passwordStore[0]?.saveOrThrow();
      } else {
        PasswordStore(password: input.toString()).saveOrThrow();
      }
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<void> seedPassword() async {
    int passwordCount = await PasswordStore().select().toCount();
    if (passwordCount < 1) {
      final input = Crypt.sha256("123456", rounds: 10, salt: "myRadioApp");
      await PasswordStore(id: 1, password: input.toString()).saveOrThrow();
    }
  }
}
