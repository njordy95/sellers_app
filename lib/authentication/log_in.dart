import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global.dart';
import '../main_screens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  logInUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(
            message: 'Checking credentials.',
          );
        }
    );
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorMessage(
              message: error.toString(),
            );
          }
      );
    });
    readDataSaveLocally(currentUser!);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
    // if(currentUser != null)
    //   {
    //     readDataSaveLocally(currentUser!).then((value) =>{
    //       Navigator.pop(context),
    //       Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()))
    //     });
    //   }
  }
  Future readDataSaveLocally(User currentUser) async{
    await FirebaseFirestore.instance.collection('Sellers')
        .doc(currentUser.uid).get().then((snapshot) async {
      // ignore: unnecessary_null_comparison
      if(snapshot.exists)
      {
        await sharedPreferences!.setString('uid', currentUser.uid);
        await sharedPreferences!.setString('email', snapshot.data()!['sellerEmail']);
        await sharedPreferences!.setString('name', snapshot.data()!['sellerName']);
      }
      // await sharedPreferences!.setString('email', snapshot.data()!['riderEmail']);
    });
  }

  saveDataLocally() {}
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset('images/chefyy.jpg'),
              ),
            ),
            Form(key: _formKey, child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'email',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObscure: true,
                ),
                Container(
                  width: 150,
                  height: 30,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      logInUser();
                    },
                    icon: const Icon(Icons.login,
                      color: Colors.deepOrange,),
                    label: const Text('Sign In',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                    ),
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
