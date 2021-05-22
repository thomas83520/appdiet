import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/presentation/pages/building_page.dart';
import 'package:appdiet/presentation/pages/photos/photos_page.dart';
import 'package:appdiet/presentation/pages/plan_alimentaire/plan_alimentaire.dart';
import 'package:appdiet/presentation/pages/poids_mesures/poids_mesures_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideDrawer extends StatelessWidget {
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
            leading: Icon(Icons.event),
            title: Text("Rendez-vous"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BuildingPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text("Photos"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PhotosPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.multiline_chart),
            title: Text("Poids et mesures"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PoidsMesuresPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("Plan alimentaire"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PlanAlimentaire()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
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
