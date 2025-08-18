import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:drr_radio_tracker/src/helpers/theme.dart' show inputDecoration;
import 'package:drr_radio_tracker/src/model/model.dart' show PasswordStore;

class PasswordScreen extends StatefulWidget {
  final Future Function()? onValidate;
  final String actionDescription;
  const PasswordScreen({
    super.key,
    this.onValidate,
    required this.actionDescription,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(
    text: "",
  );

  void close(bool value) {
    Navigator.pop(context, value);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.onValidate != null) {
        await widget.onValidate!();
      }
      close(true);
    }
  }

  PasswordStore? password;

  Future<void> loadPassword() async {
    List<PasswordStore> passwords = await PasswordStore().select().toList();
    if (passwords.isNotEmpty) {
      password = passwords.first;
    }
  }

  @override
  void initState() {
    if (mounted) {
      loadPassword();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticate"),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => close(false),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.actionDescription,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _passwordController,
                obscureText: false,
                autofocus: true,
                decoration: inputDecoration("Access password").copyWith(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    // maxHeight: 55,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a valid password';
                  }
                  if (password == null) {
                    if (value != "123456") {
                      return "Enter a valid password";
                    }
                  } else {
                    final input = Crypt.sha256(
                      value,
                      rounds: 10,
                      salt: "myRadioApp",
                    );
                    bool isMatch =
                        password?.password.toString() == input.toString();
                    if (!isMatch) {
                      return 'Incorrect password';
                    }
                  }

                  return null;
                },
              ),
              RichText(
                text: TextSpan(
                  text: 'Default password: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: const <TextSpan>[
                    TextSpan(
                      text: '123456',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: _submit,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    minHeight: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      "Validate",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
