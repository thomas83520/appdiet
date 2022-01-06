import 'package:appdiet/logic/cubits/config_cubit/config_cubit.dart';
import 'package:appdiet/presentation/pages/NeedUpdate_page.dart';
import 'package:appdiet/presentation/pages/splash_page.dart';
import 'package:appdiet/presentation/routers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repository/authentication_repository.dart';

class UpdateCheck extends StatelessWidget {
  const UpdateCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => ConfigCubit()..initConfig(),
          child: BlocBuilder<ConfigCubit, ConfigState>(
            builder: (context, state) {
              if (state.state == ConfigStateStatus.loading)
                return SplashPage();
              else if (state.needUpdate) {
                return NeedUpdatePage(minimunVersion: state.enforceVersion, currentVersion: state.currentVersion,);
              } else
                return App(
                    authenticationRepository: AuthenticationRepository());
            },
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
