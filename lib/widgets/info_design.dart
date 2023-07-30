import 'package:flutter/material.dart';
import 'package:sellers_app/model/menus.dart';
import '../main_screens/item_screen.dart';

class InfoDesignWidget extends StatefulWidget {

  Menus? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemScreen(model: widget.model)));
      },
      splashColor: Colors.white10,
      child: Container(
        height: 265,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children:[
            ClipRect(
              child: Image.network(
                widget.model!.thumbnailUrl!,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Text(
                widget.model!.menuTitle!
            ),
            Text(
                widget.model!.menuInfo!
            ),
            const Divider(
              height: 4,
              thickness: 3,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
