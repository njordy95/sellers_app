import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sellers_app/global.dart';
import 'package:sellers_app/main_screens/home_screen.dart';
import 'package:sellers_app/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sellers_app/widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;
import 'package:sellers_app/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCurrentLocation();
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl = '';
  String completeAddress = '';
  final CollectionReference _profileList = FirebaseFirestore.instance.collection('dummyweek1');

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
        position!.latitude, position!.longitude);

    Placemark pMark = placeMarks![0];

    completeAddress = '${pMark.subThoroughfare}'
        ' ${pMark.thoroughfare}, ${pMark.subLocality},'
        ' ${pMark.locality}, ${pMark.subAdministrativeArea},'
        '${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> signUpUser() async {
    if (passwordController.text == confirmedPasswordController.text)
    {

      if(confirmedPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
      {
        showDialog(
            context: context,
            builder: (c){
              return const LoadingDialog(message: 'Authenticating');
            }
        );

        authenticateSeller();

        // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        // f_storage.Reference reference = f_storage.FirebaseStorage.instance.ref().child('Sellers').child(fileName);
        // f_storage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        // f_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // await taskSnapshot.ref.getDownloadURL().then((url) {
        //   sellerImageUrl = url;
        //
        //   //save file to firestore
        //   authenticateSeller();
        // });

      }
      else{
        showDialog(
            context: context,
            builder: (c){
              return const ErrorMessage(
                message: 'Please fill in all required fields to complete registration',
              );
            }
        );
      }

    }
    else{
      showDialog(
          context: context,
          builder: (c){
            return const ErrorMessage(
              message: 'Passwords do not match',
            );
          }
      );
    }
  }

  Future<void> signUpComplete() async {
    if (passwordController.text == confirmedPasswordController.text)
    {

      if(confirmedPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
      {
        showDialog(
            context: context,
            builder: (c){
              return const LoadingDialog(message: 'Authenticating');
            }
            );

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        f_storage.Reference reference = f_storage.FirebaseStorage.instance.ref().child('Sellers').child(fileName);
        f_storage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        f_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerImageUrl = url;

          //save file to firestore
          authenticateSeller();
        });

      }
      else{
        showDialog(
            context: context,
            builder: (c){
              return const ErrorMessage(
                message: 'Please fill in all required fields to complete registration',
              );
            }
        );
      }

    }
    else{
      showDialog(
          context: context,
          builder: (c){
            return const ErrorMessage(
              message: 'Passwords do not match',
            );
          }
      );
    }
  }

  Future<void> formValidation() async {
    if (imageXFile == null)
      {
        showDialog(
            context: context,
            builder: (c){
              return const ErrorMessage(
                message: 'Please select an image',
              );
            }
            );

      }
      else{
        if (passwordController.text == confirmedPasswordController.text)
          {

            if(confirmedPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
              {
                showDialog(
                    context: context,
                    builder: (c){
                      return const LoadingDialog(message: 'Authenticating');
                    }
                );
                String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                f_storage.Reference reference = f_storage.FirebaseStorage.instance.ref().child('Seller').child(fileName);
                f_storage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
                f_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                await taskSnapshot.ref.getDownloadURL().then((url) {
                  sellerImageUrl = url;

                  //save file to firestore

                  authenticateSeller();
                });
              }
            else{
              showDialog(
                  context: context,
                  builder: (c){
                    return const ErrorMessage(
                      message: 'Please fill in all required fields to complete registration',
                    );
                  }
              );
            }

          }
        else{
          showDialog(
              context: context,
              builder: (c){
                return const ErrorMessage(
                  message: 'Passwords do not match',
                );
              }
          );
        }
    }
  }

  void authenticateSeller() async{
    User? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()).then((auth) {
          currentUser = auth.user;
    });
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async{
    FirebaseFirestore.instance.collection('Sellers').doc(currentUser.uid).set({
      'sellerUid': currentUser.uid,
      'sellerEmail': currentUser.email,
      'sellerName': nameController.text.trim(),
      'sellerPhone': phoneController.text.trim(),
      'sellerAddress': completeAddress,
      'status': 'enabled',
      'earnings': 0.0,
      'lat': position!.latitude,
      'lng': position!.longitude,
    });

    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('uid', currentUser.uid);
    await sharedPreferences.setString('name', nameController.text.trim());
    await sharedPreferences.setString('email', emailController.text.trim());
    await sharedPreferences.setString('photoUrl', sellerImageUrl);
  }


  // void getDataFromFirestore(){
  //   _firestore.collection('dummyweek1').get();
  // }
  void messageStream() async {
    var streamTest = _firestore.collection('dummyweek1').snapshots();
    print(streamTest);
  }
  Future getUsersList() async {
    List itemsList = [];

  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 4.0,
      radius: const Radius.circular(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * .20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null? null: FileImage(File(imageXFile!.path)),
                child: imageXFile == null ?
                Icon(Icons.add_photo_alternate_outlined,
                color: Colors.deepOrange,
                size: MediaQuery.of(context).size.width * .20,
              ) : null,
            ),
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey, child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: 'name',
                  isObscure: false,
                ),
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
                CustomTextField(
                  data: Icons.lock_person,
                  controller: confirmedPasswordController,
                  hintText: 'Confirm Password',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hintText: 'name',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.my_location,
                  controller: locationController,
                  hintText: 'Restaurant Address',
                  isObscure: false,
                ),
              ],
            ),
            ),

            Row(
              children: [
                const SizedBox(
                  width: 50.0,
                ),
                Container(
                  width: 150,
                  height: 30,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    icon: const Icon(Icons.location_on,
                      color: Colors.deepOrange,),
                    label: const Text('Get location',
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
                Container(
                  width: 150,
                  height: 30,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // messageStream();
                      formValidation();
                    },
                    icon: const Icon(Icons.bookmark_added,
                      color: Colors.deepOrange,),
                    label: const Text('Sign Up',
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
            )

            // Container(
            //   width: 150,
            //   height: 30,
            //   alignment: Alignment.center,
            //   child: ElevatedButton.icon(
            //     onPressed: ()=> print('clicked'),
            //     icon: const Icon(Icons.check_circle,
            //       color: Colors.deepOrange,),
            //     label: const Text('Sign Up',
            //       style: TextStyle(
            //           color: Colors.white
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.black,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         )
            //     ),
            //   ),
            //
            // ),

          ],
        ),
      ),
    );
  }
}
