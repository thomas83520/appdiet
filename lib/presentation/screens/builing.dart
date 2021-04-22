import 'package:flutter/material.dart';

class BuildingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Building"),
      ),
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/building.png',
            key: const Key('building_page_image'),
            width: 450,
          ),
        ),
      ),
    );
  }
}
