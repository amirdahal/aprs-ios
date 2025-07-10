import 'package:aprs/src/features/settings/app_setting/repository/app_setting.repository.dart';
import 'package:aprs/src/helpers/theme.dart' show inputDecoration;
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(
    text: '',
  );

  void showMessage(String message, {bool error = false}) {
    showToast(
      context: context,
      title: 'App setting',
      description: message,
      type: error ? ToastificationType.error : ToastificationType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Setting')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _passwordController,
                decoration: inputDecoration('Set authentication password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (value.length < 6) {
                    return "At least 6 characters required";
                  }
                  return null;
                },
                onFieldSubmitted: (value) async {
                  if (_formKey.currentState!.validate()) {
                    if (_passwordController.text.trim().isNotEmpty) {
                      bool res = await AppSettingRepository.createPassword(
                        _passwordController.text.trim(),
                      );
                      if (res) {
                        _passwordController.clear();
                        showMessage('Password updated');
                      } else {
                        showMessage('Password update failed', error: true);
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
