import 'package:appdiet/data/repository/account_repository.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:appdiet/presentation/pages/documents/documents_page.dart';
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
          /*ListTile(
                leading: Icon(Icons.event),
                title: Text("Rendez-vous"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BuildingPage()));
                },
              ),*/
          ListTile(
            leading: Icon(Icons.multiline_chart),
            title: Text("Poids et mesures"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PoidsMesuresPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_open),
            title: Text("Documents"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DocumentsPage()));
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
          BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  "Supprimer mon compte",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  bool? accept = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Faire une demande de suppression de compte ?",
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Cette demande est irréversible."),
                              Text(
                                  "Toute vos données seront effacé, vous n'aurez plus accès à l'application."),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Annuler')),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Supprimer',
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  );
                  if (accept!) {
                  await context
                        .read<DeleteAccountCubit>()
                        .deleteAccount();
                  } else
                    print("not delete");
                },
              );
            },
          )
        ],
      ),
    );
  }
}
