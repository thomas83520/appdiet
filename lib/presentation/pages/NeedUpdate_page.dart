import 'package:appdiet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedUpdatePage extends StatelessWidget {
  const NeedUpdatePage({Key? key,required this.currentVersion,required this.minimunVersion}) : super(key: key);

  final String currentVersion;
  final String minimunVersion;
  @override
  Widget build(BuildContext context) {
    const String iosURL = 'https://apps.apple.com/fr/app/dietup/id1576122128';
    const String androidUrl = 'https://play.google.com/store/apps/details?id=fr.dietup.mobileapp';
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: Text(
                "Une mise à jour de l'application est nécessaire avant de pouvoir y accéder",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10,),
            Text('Version actuelle : ' + currentVersion),
            Text('Version minimum requise : ' + minimunVersion),

            SizedBox(
              height: 10,
            ),
            appleSignInAvailable.isAvailable
                ? InkWell(
                    onTap: () async {
                      if (await canLaunch(iosURL))
                        await launch(
                          iosURL,
                          forceSafariVC: false,
                        );
                      else
                        throw 'Could not launch url';
                    },
                    child: SvgPicture.asset(
                      'assets/AppStoreBadge.svg',
                      height: 60,
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      if (await canLaunch(androidUrl))
                        await launch(androidUrl);
                      else
                        throw 'Could not launch url';
                    },
                    child: Image.asset(
                      'assets/GooglePlayBadge.png',
                      width: 200,
                      height: 100,
                    ),
                  )
          ],
        ),
      ],
    ));
  }
}
