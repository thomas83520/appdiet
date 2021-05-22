import 'package:flutter/material.dart';

class BuildingPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => BuildingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('En construction'),
      ),
      body: Center(
        child: Image.asset(
          'assets/building.png',
          key: const Key('building_page_image'),
          width: 450,
        ),
      ),
    );
  }
}