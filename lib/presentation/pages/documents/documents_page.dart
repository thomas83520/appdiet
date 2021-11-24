import 'package:appdiet/presentation/pages/documents/liste_documents_page.dart';
import 'package:flutter/material.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: _DocumentsItem(
                title: "Mes documents",
                icon: Icons.folder,
                description:
                    "Vos documents personalisés partagés par votre diététicien\u00B7ne ",
                clicked: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListDocumentsPage(
                        titre: 'Mes documents', type: 'patient'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: _DocumentsItem(
                title: "Documents partagés",
                icon: Icons.folder_shared,
                description:
                    "Documents que votre diététicien\u00B7ne partage avec tous ses patients",
                clicked: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListDocumentsPage(
                        titre: 'Documents partagés', type: 'partage'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentsItem extends StatelessWidget {
  const _DocumentsItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.icon,
      required this.clicked})
      : super(key: key);

  final String title;
  final String description;
  final IconData icon;
  final Function() clicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 50,
                color: theme.primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18),
                    ),
                    Flexible(
                      child: Text(
                        description,
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: clicked,
      ),
    );
  }
}
