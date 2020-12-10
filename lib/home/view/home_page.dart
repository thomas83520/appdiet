import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdiet/authentication/authentication.dart';
//import 'package:appdiet/home/home.dart';
import 'package:appdiet/navBar/navBar.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
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
          bottomNavigationBar: NavBar(),
          body: BlocBuilder<NavbarCubit, NavbarState>(
            builder: (context, state) {
              return childfromindex(state.index);
            },
          )),
    );
  }

  Widget childfromindex(int index) {
    switch (index) {
      case 0:
        return Container(
          child: Text("screen 1"),
        );
        break;
      case 1:
        return Container(
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
            onTap: () =>  context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
          ),
        ],
      ),
    );
  }
}
