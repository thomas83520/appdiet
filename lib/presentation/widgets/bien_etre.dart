import 'package:flutter/material.dart';

class BienEtre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 90.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                Icons.mood,
                size: 40.0,
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                "Mon mood du jour",
                style:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
