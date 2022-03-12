import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/chat_repository.dart';
import 'package:appdiet/data/repository/goal_repository.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/chat_bloc/chat_bloc.dart';
import 'package:appdiet/logic/blocs/goal_bloc/goal_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/navbar_cubit/navbar_cubit.dart';
import 'package:appdiet/presentation/pages/building_page.dart';
import 'package:appdiet/presentation/view/goal_view.dart';
import 'package:appdiet/presentation/view/journal_view.dart';
import 'package:appdiet/presentation/view/messages_view.dart';
import 'package:appdiet/presentation/widgets/drawer.dart';
import 'package:appdiet/presentation/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }


  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavbarCubit>(
            create: (context) => NavbarCubit(),
          ),
          BlocProvider<JournalBloc>(
            create: (context) => JournalBloc(
                date: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day), journalRepository: JournalRepository(), user: user),
          )
        ],
        child: Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: BlocBuilder<NavbarCubit, NavbarState>(
                  buildWhen: (previous, current) =>
                      previous.index != current.index,
                  builder: (context, state) {
                    return titlefromindex(state.index, user);
                  },
                ),
                //backgroundColor: Theme.of(context).primaryColor,
              ),
              drawer: SideDrawer(),
              bottomNavigationBar: NavBar(),
              body: BlocBuilder<NavbarCubit, NavbarState>(
                buildWhen: (previous, current) => previous.index != current.index,
                builder: (context, state) {
                  return childfromindex(state.index, user);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget childfromindex(int index, User user) {
    switch (index) {
      case 0:
        return JournalView();
      /*case 1:
        return BuildingPage();*/
      case 1:
        return BlocProvider(
          create: (context) =>
              ChatBloc(chatRepository: ChatRepository(user: user)),
          child: MessageView(),
        );
      case 2:
        return BlocProvider(
            create: (_) => GoalBloc(goalRepository: GoalRepository(user: user)),
            child: GoalView());
      default:
        return BuildingPage();
    }
  }

  Widget titlefromindex(int index, User user) {
    switch (index) {
      case 0:
        return Text("Journal");
      /*case 1:
        return Text("Cuisine");*/
      case 1:
        return Text("Messages");
      case 2:
        return Text("Objectifs");
      default:
        return Text("");
    }
  }
}
