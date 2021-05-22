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
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }


  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavbarCubit>(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider<JournalBloc>(
          create: (context) => JournalBloc(
              date: "", journalRepository: JournalRepository(), user: user),
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
    );
  }

  Widget childfromindex(int index, User user) {
    switch (index) {
      case 0:
        return JournalView();
        break;
      case 1:
        return BuildingPage();
        break;
      case 2:
        return BlocProvider(
          create: (context) =>
              ChatBloc(chatRepository: ChatRepository(user: user)),
          child: MessageView(),
        );
        break;
      case 3:
        return BlocProvider(
            create: (_) => GoalBloc(goalRepository: GoalRepository(user: user)),
            child: GoalView());
        break;
      default:
        return BuildingPage();
        break;
    }
  }

  Widget titlefromindex(int index, User user) {
    switch (index) {
      case 0:
        return Text("Journal");
        break;
      case 1:
        return Text("Cuisine");
        break;
      case 2:
        return Text("Messages");
        break;
      case 3:
        return Text("Objectifs");
        break;
      default:
        return Text("");
        break;
    }
  }
}
