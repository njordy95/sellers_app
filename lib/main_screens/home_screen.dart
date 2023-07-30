import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers_app/global.dart';
import 'package:sellers_app/upload_screens/menus_upload.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellers_app/model/menus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';
final CollectionReference _referenceStream = FirebaseFirestore.instance.collection('dummyweek1');
// late Stream<QuerySnapshot> streamStream;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _streamStream = _referenceStream.snapshots();
  // }
  final streamStream = _referenceStream.snapshots();
  List deli = [];
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _referenceStream.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }

  getMessage() async{
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final games = await _firestore.collection('dummyweek1').get();
   for (var game in games.docs){
     print(game.data);
   }
  }

  void nessageStream() async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
     await for (var snap in _firestore.collection('dummyweek1').snapshots()) {
       for (var game in snap.docs) {
         print(game.data);
       }
     }
  }

  Future saveDataOnline() async{
    FirebaseFirestore.instance.collection('dummyweek1').doc().set({

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                CupertinoIcons.bars,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MenuUpload()));
              },
              icon: const Icon(Icons.post_add,
              color: Colors.black,
              ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CupertinoColors.white,
                Colors.white,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
            ),
          ),
        ),
        title: const Text('Burger King',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Merriweather',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      drawer: const MyDrawer(),

      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ListTile(
              title: Text('My Menus'),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Sellers').
              doc(firebaseAuth.currentUser!.uid).
              collection('menus').
              orderBy('publishedDate', descending: true).
              snapshots(),
              builder: (context, snapshot){
                return !snapshot.hasData ?
                SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                ) :
                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Menus model = Menus.fromJson(snapshot.data!.docs[index].
                    data()!
                    as Map<String, dynamic>
                    );
                    return InfoDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              }
          ),
        ],
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: streamStream,
      //   builder: (BuildContext context,AsyncSnapshot snapshot){
      //     if(snapshot.connectionState == ConnectionState.active){
      //       QuerySnapshot querySnapshot = snapshot.data;
      //       List listQueryDocumentSnapshot = querySnapshot.docs;
      //       return ListView.builder(
      //           itemCount: listQueryDocumentSnapshot.length,
      //           itemBuilder: (context, index){
      //             QueryDocumentSnapshot document = listQueryDocumentSnapshot[index];
      //             return Text(document[0]);
      //           });
      //     }
      //
      //     return const Center(
      //       child: (
      //       Text('Shit')
      //       ),
      //     );
      // },
      //   // child: Center(
      //   //   child: Column(
      //   //     children: const [
      //   //       Text('Team 1'),
      //   //       Text('Team 4')
      //   //     ],
      //   //   ),
      //   // ),
      //)
    );
  }
}

// body: StreamBuilder(
//   stream: _referenceStream.snapshots(),
//   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//     if (streamSnapshot.hasData) {
//       return ListView.builder(
//           itemCount: streamSnapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             final DocumentSnapshot documentSnapshot =
//                 streamSnapshot.data!.docs[index];
//             return Card(
//               child: ListTile(
//                 title: Text(documentSnapshot['name']),
//               ),
//             );
//           }
//
//       );
//     }
//   }
// ),