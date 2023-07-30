import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {

  CustomTextField({super.key, this.data, this.controller, this.hintText, this.enabled, this.isObscure});

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObscure = true;
  bool? enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(10),
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            obscureText: isObscure!,
            cursorColor: Theme.of(context).primaryColorDark,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                data,
                color: Colors.black,
              ),
              // focusColor: Colors.black,
            ),
          ),
        );
  }
}
