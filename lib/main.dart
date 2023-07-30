import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/splashscreen/splash_screen.dart';

// void main() {
//   runApp(const SellerApp());
// }
//
// class SellerApp extends StatefulWidget {
//   const SellerApp({Key? key}) : super(key: key);
//
//   @override
//   State<SellerApp> createState() => _SellerAppState();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const SellerApp());

}

class SellerApp extends StatelessWidget {
  const SellerApp({Key? key}) : super(key: key);


// class _SellerAppState extends State<SellerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller App',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.deepOrange)
        )
      ),
      home: MySplashScreen(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     centerTitle: true,
      //     title: Text('Welcome Page',
      //     textAlign: TextAlign.center,),
      //     backgroundColor: Colors.black,
      //   ),
      //   backgroundColor: Colors.yellow,
      // )
    );
  }
}
