import 'package:appdiet/data/models/wellbeing.dart';
import 'package:flutter/material.dart';

class DetailWellBeingPage extends StatelessWidget {
  static Route route(WellBeing wellBeing) {
    return MaterialPageRoute<void>(
        builder: (_) => DetailWellBeingPage(
              wellBeing: wellBeing,
            ));
  }
  final WellBeing wellBeing;


  const DetailWellBeingPage({Key key, @required this.wellBeing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}