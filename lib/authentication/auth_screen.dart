import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/log_in.dart';
import 'package:sellers_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  // late final TabController _tabController = TabController(length: 2, vsync:this);
  // TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange,
              Colors.deepOrange,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: const Text('Food'),
      backgroundColor: Colors.orange,
      bottom: const TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.lock, color: Colors.black),
            text: 'Login',
          ),
          Tab(
            icon: Icon(Icons.person, color: Colors.black),
            text: 'Register',
          )
        ],
        indicatorColor: Colors.black,
        indicatorWeight: 3,
      ),
        ),
        body: Container(
          color: Colors.grey,
          child: const TabBarView(
            children: [
              LogIn(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
