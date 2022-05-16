import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/presentation/pages/journal/detail_wellbeing_page.dart';
import 'package:appdiet/presentation/pages/journal/list_meal_page.dart';
import 'package:appdiet/presentation/widgets/bien_etre.dart';
import 'package:appdiet/presentation/widgets/calendar.dart';
import 'package:appdiet/presentation/widgets/meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JournalView extends StatelessWidget {
  static MaterialPageRoute route() {
    return MaterialPageRoute<void>(builder: (_) => JournalView());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    //final state = context.select((JournalBloc bloc)=> bloc.state);
    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state.journalStateStatus == JournalStateStatus.modifyWellBeing) {
          Navigator.of(context)
              .push(DetailWellBeingPage.route(state.wellBeing));
        } else if (state.journalStateStatus == JournalStateStatus.fail)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).errorColor,
                content: Text("Une erreur est survenue"),
              ),
          );
      },
      child: Container(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Calendar(),
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
                                date: state.date,
                              ),
                            ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    child: Meals(),
                    onTap: () =>
                        Navigator.of(context).push(ListMealPage.route()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
