import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/main_screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage_ref;
import '../global.dart';
import '../widgets/loading_dialog.dart';

class MenuUpload extends StatefulWidget {
  const MenuUpload({Key? key}) : super(key: key);

  @override
  State<MenuUpload> createState() => _MenuUploadState();
}

class _MenuUploadState extends State<MenuUpload> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  // String downloadUrl = '';
  String uniqueID = DateTime.now().millisecondsSinceEpoch.toString();


  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();

  defaultScreen() {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [
          CupertinoColors.white, Colors.white,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
             ),
            ),
          ),
          title: const Text('Menu Upload',
          style: TextStyle(
          color: Colors.black, fontFamily: 'Merriweather',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          fontSize: 25,
            ),
          ),
          centerTitle: true,
        automaticallyImplyLeading: true,
           leading: IconButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
             },
             icon: const Icon(Icons.arrow_back_ios,
             color: Colors.black,
             ),
           ),
       ),
        body: Container(
          color: Colors.white10,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Icon(Icons.shop_2_outlined,
                color: Colors.black,
                size: 180,
                ),
                ElevatedButton(
                    onPressed: (){
                      takeImage(context);
                    },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                    child: const Text(
                      'Add New Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                )
              ],
            ),
          ),
        ),
    );
  }

  captureWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  pickFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Menu Image',
              textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.black
            ),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Capture with Camera',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  captureWithCamera();
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Select from Gallery',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  pickFromGallery();
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  clearMenuUpload() {
    setState(() {
      shortInfoController.clear();
      titleInfoController.clear();
      imageXFile = null;
    });
  }

  uploadImage(mImageFile) async {
    storage_ref.Reference reference = storage_ref.FirebaseStorage.instance
        .ref().child('menus');

    storage_ref.UploadTask uploadTask = reference.child(
      '$uniqueID.jpg'
    ).putFile(mImageFile);

    storage_ref.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance.collection('Sellers').
    doc(firebaseAuth.currentUser!.uid).collection('menus');

    ref.doc(uniqueID).set({
      'menuID': uniqueID,
      'sellerUID': firebaseAuth.currentUser!.uid,
      'menuInfo': shortInfoController.text.toString(),
      'menuTitle': titleInfoController.text.toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    });

    clearMenuUpload();

    setState(() {
      uniqueID = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });

  }

  validateUploadScreen() async {

    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty && titleInfoController.text.isNotEmpty) {
        // Upload image to firebase
        setState(() {
          uploading = true;
        });
        // Upload Image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //Save info to firestore
        saveInfo(downloadUrl);
      }

      else {
        showDialog(
            context: context,
            builder: (c){
              return const LoadingDialog(message: 'Please fill in the fields');
            }
        );
      }
    }

    else {
      showDialog(
          context: context,
          builder: (c){
            return const LoadingDialog(message: 'Please pick a menu image');
          }
      );
    }
  }

  menuUploadScreen() {
    return Scaffold(
        appBar: AppBar(
         flexibleSpace: Container(
         decoration: const BoxDecoration(
         gradient: LinearGradient(
         colors: [
         CupertinoColors.white, Colors.white,
         ],
         begin: FractionalOffset(0.0, 0.0),
         end: FractionalOffset(1.0, 0.0),
         stops: [0.0, 1.0],
          ),
         ),
        ),
         title: const Text('Uploaded Menu Item',
         style: TextStyle(
         color: Colors.black, fontFamily: 'Merriweather',
         fontStyle: FontStyle.normal,
         fontWeight: FontWeight.w600,
         fontSize: 25,
         ),
        ),
         centerTitle: true,
         automaticallyImplyLeading: true,
         leading: IconButton(
         onPressed: () {

           clearMenuUpload();
           // Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
         },
         icon: const Icon(Icons.arrow_back_ios,
         color: Colors.black,
             ),
         ),
         actions: [
           TextButton(
               onPressed: uploading ? null : ()=> validateUploadScreen(),
               child: const Text(
                 'Add',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 18,
                 ),
               ),
           )
         ],
        ),
      body: ListView(
        children: [
          uploading == true ? const LinearProgressIndicator() : const Text(''),
          SizedBox(
            height: 280,
            width: MediaQuery.of(context).size.width * .8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                          File(imageXFile!.path)
                        ),
                      fit: BoxFit.cover,
                       ),
                    ),
                  ),
                ),
              ),
            ),
          ListTile(
            leading: const Icon(
              Icons.title_sharp,
              color: Colors.black,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: 'Menu Title',
                  hintStyle: TextStyle(
                      color: Colors.grey
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // const Divider(
          //   color: Colors.grey,
          //   thickness: 1,
          // ),
          ListTile(
            leading: const Icon(
                Icons.perm_device_info,
                color: Colors.black,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: titleInfoController,
                decoration: const InputDecoration(
                  hintText: 'Menu Info',
                  hintStyle: TextStyle(
                    color: Colors.grey
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menuUploadScreen();
  }
}
