import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/presentation/view/journal_view.dart';
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
        drawer: _Drawer(),
        body: Container(child: SingleChildScrollView(child: JournalView())));
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.completeName,
                  style: TextStyle(color: Colors.black, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Rendez-vous"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Photos"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Poids et mesures"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Plan alimentaire"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text(
              "Se déconnecter ",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          ),
        ],
      ),
    );
  }
}
