import 'package:flutter/material.dart';

import '../widgets/all_buttons.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,title: Text("Smart Car App",style: TextStyle(color: Colors.white)),),
        body: const Align(alignment: Alignment.center,child: AllButtons()),
        );
    }
}