import 'package:flutter/material.dart';
void main() {
  runApp(const TryOut());
}
class TryOut extends StatefulWidget {
  const TryOut({Key? key}) : super(key: key);

  @override
  State<TryOut> createState() => _TryOutState();
}

class _TryOutState extends State<TryOut> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Try'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tab 1', icon: Icon(Icons.hail),),
              Tab(text: 'Tab 2', icon: Icon(Icons.handshake),),
              Tab(text: 'Tab 3', icon: Icon(Icons.snowing),)
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Tab1'),)
          ],
        ),
      ),
    );
  }
}
