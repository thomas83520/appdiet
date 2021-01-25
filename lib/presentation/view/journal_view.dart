import 'package:appdiet/presentation/pages/list_meal_page.dart';
import 'package:appdiet/presentation/widgets/bien_etre.dart';
import 'package:appdiet/presentation/widgets/meals.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';

class JournalView extends StatelessWidget {
  static MaterialPageRoute route() {
    return MaterialPageRoute<void>(builder: (_) => JournalView());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CalendarStrip(
            startDate: DateTime.now().subtract(Duration(days: 21)),
            endDate: DateTime.now(),
            selectedDate: DateTime.now(),
            onDateSelected: (data) {print("Selected Date -> $data");},
            iconColor: Colors.red,
            rightIcon: Icon(Icons.arrow_forward),
            leftIcon: Icon(Icons.arrow_back),
            addSwipeGesture: true,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              child: Meals(),
              onTap: () => Navigator.of(context).push(ListMealPage.route()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              child: BienEtre(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              child: Container()//Comments(),
            ),
          ),
        ],
      ),
    );
  }
}
