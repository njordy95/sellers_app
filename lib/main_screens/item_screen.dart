import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/upload_screens/items_upload_screen.dart';
import '../global.dart';
import '../model/items.dart';
import '../model/menus.dart';
import '../upload_screens/menus_upload.dart';
import '../widgets/info_design.dart';
import '../widgets/item_design_widget.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';

class ItemScreen extends StatefulWidget {
  final Menus? model;
  ItemScreen({this.model});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
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
              Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsUploadScreen(model: widget.model)));
            },
            icon: const Icon(Icons.library_add_outlined,
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
        automaticallyImplyLeading: true,
      ),
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Sellers')
                  .doc(firebaseAuth.currentUser!.uid).
                  collection('menus').
                  doc(widget.model!.menuID).
                  collection('items').snapshots(),
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
                    Items model = Items.fromJson(snapshot.data!.docs[index].
                    data()!
                    as Map<String, dynamic>
                    );
                    return ItemsDesignWidget(
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
    );
  }
}
