import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  ToastificationType type = ToastificationType.success,
  required String title,
  required String description,
}) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 3),
    title: title,
    description: description,
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    icon: const Icon(Icons.check),
    primaryColor: Colors.green,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
  );
}

void showSnackBar({
  required BuildContext context,
  required String content,
  bool error = false,
  String? actionLabel,
  VoidCallback? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      content: Text(content),
      backgroundColor: error ? Colors.red : Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Colors.white,
        label: actionLabel ?? '',
        onPressed: action ?? () {},
      ),
    ),
  );
}
