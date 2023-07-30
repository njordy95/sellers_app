import 'package:flutter/material.dart';
import 'package:sellers_app/global.dart';
import 'package:flutter/cupertino.dart';
import '../authentication/auth_screen.dart';
import '../main_screens/home_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: const [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10),
                Text('User Name',
                  // sharedPreferences!.getString('name')!,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w400,
                    fontSize: 30.0,
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.black,
                  thickness: 2,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
                  },
                  leading: const Icon(CupertinoIcons.home,
                    size: 20,
                    color: Colors.black),
                  title: const Text('Home',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Merriweather',
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Colors.black,
                  thickness: 2,
                ),
                const ListTile(
                  leading: Icon(Icons.monetization_on_outlined,
                      color: Colors.black),
                  title: Text('My Earnings',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Colors.black,
                  thickness: 2,
                ),
                const ListTile(
                  leading: Icon(CupertinoIcons.cube_box,
                      color: Colors.black),
                  title: Text('New Orders',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(CupertinoIcons.clock,
                      color: Colors.black),
                  title: Text('History',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app_outlined,
                      color: Colors.black),
                  title: const Text('Log Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    firebaseAuth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
