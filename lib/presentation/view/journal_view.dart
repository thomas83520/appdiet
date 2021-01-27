import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/presentation/pages/detail_wellbeing_page.dart';
import 'package:appdiet/presentation/pages/list_day_comments_page.dart';
import 'package:appdiet/presentation/pages/list_meal_page.dart';
import 'package:appdiet/presentation/widgets/bien_etre.dart';
import 'package:appdiet/presentation/widgets/comments.dart';
import 'package:appdiet/presentation/widgets/meals.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JournalView extends StatelessWidget {
  static MaterialPageRoute route() {
    return MaterialPageRoute<void>(builder: (_) => JournalView());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state.journalStateStatus == JournalStateStatus.modifyWellBeing) {
          Navigator.of(context)
              .push(DetailWellBeingPage.route(state.wellBeing));
        }
      },
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CalendarStrip(
              startDate: DateTime.now().subtract(Duration(days: 21)),
              endDate: DateTime.now(),
              onWeekSelected: (_) => null,
              selectedDate: DateTime.now(),
              onDateSelected: (data) {
                print("Selected Date -> ");
              },
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
              child: BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  return InkWell(
                    child: BienEtre(),
                    onTap: () => context.read<JournalBloc>().add(
                          WellBeingClicked(
                            journal: state.journal,
                            user: user,
                            wellBeing: state.journal.wellBeing,
                          ),
                        ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                child: Comments(),
                onTap: () =>
                    Navigator.of(context).push(ListDayCommentsPage.route()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
