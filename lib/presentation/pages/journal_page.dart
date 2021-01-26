import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/presentation/view/journal_view.dart';
import 'package:appdiet/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JournalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
        appBar: AppBar(
          title: Text("Journal"),
          actions: <Widget>[
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
          ],
        ),
        drawer: SideDrawer(),
        body: Container(child: SingleChildScrollView(child: JournalView())));
  }
}


