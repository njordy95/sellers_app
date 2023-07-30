import 'package:flutter/material.dart';
import '../model/items.dart';

class ItemsDesignWidget extends StatefulWidget {

  Items? model;
  BuildContext? context;

  ItemsDesignWidget({super.key, this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (c) => ItemScreen(model: widget.model)));
      },
      splashColor: Colors.white10,
      child: SizedBox(
        height: 265,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: [
            ClipRect(
              child: Image.network(
                widget.model!.thumbnailUrl!,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
                widget.model!.title!
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
                widget.model!.shortInfo!
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
