import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 249, 255),
      child: const Center(
        child: SizedBox(
          height: 35.0,
          width: 35.0,
          child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 91, 170, 255),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 184, 218, 255)),
              strokeWidth: 8),
        ),
      ),
    );
  }
}

class NoticeDialog extends StatelessWidget {
  final String content;
  const NoticeDialog({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Notice',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Text(content),
      actions: [
        TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}

class LoadingComment extends StatelessWidget {
  const LoadingComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 249, 255),
      child: const Center(
        child: SizedBox(
          height: 35.0,
          width: 35.0,
          child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 91, 170, 255),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 184, 218, 255)),
              strokeWidth: 8),
        ),
      ),
    );
  }
}
