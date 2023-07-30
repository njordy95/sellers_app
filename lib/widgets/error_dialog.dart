import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {

  final String? message;
  const ErrorMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}
