import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/navbar_cubit/navbar_cubit.dart';
import 'package:appdiet/presentation/pages/journal_page.dart';
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
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: Scaffold(
          bottomNavigationBar: NavBar(),
          body: BlocBuilder<NavbarCubit, NavbarState>(
            buildWhen: (previous,current) => previous.index!= current.index,
            builder: (context, state) {
              return childfromindex(state.index,user);
            },
          )),
    );
  }

  Widget childfromindex(int index,User user) {
    switch (index) {
      case 0:
        return BlocProvider(
            create: (_) =>
                JournalBloc(date : "11_12_2020", journalRepository: JournalRepository(), user: user),
            child: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => JournalPage(),
        )));
        break;
      case 1:
        return 
         Container(
          child: Text("screen 2"),
        );
        break;
      case 2:
        return Container(
          child: Text("screen 3"),
        );
        break;
      case 3:
        return Container(
          child: Text("screen 4"),
        );
        break;
      default:
        return Container(
          child: Text("screen 1"),
        );
        break;
    }
  }
}


