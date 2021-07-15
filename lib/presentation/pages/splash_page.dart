import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/logo_7.svg',
          key: const Key('splash_bloc_image'),
          width: 200,
        ),
      ),
    );
  }
}
