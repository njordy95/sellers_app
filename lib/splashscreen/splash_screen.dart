import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {


  startTimer() {
    Timer(const Duration(seconds: 3), () async{
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.yellow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/i chef.png',
              ),
              const SizedBox(height: 10),
              const Text('Sellers Paradise',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
