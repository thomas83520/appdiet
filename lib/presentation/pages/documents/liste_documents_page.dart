import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/documents_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/liste_documents_cubit/liste_documents_cubit.dart';
import 'package:appdiet/presentation/pages/documents/document_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListDocumentsPage extends StatelessWidget {
  const ListDocumentsPage({Key? key, required this.titre, required this.type})
      : super(key: key);

  final String titre;
  final String type;

  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => ListeDocumentsCubit(
          documentsRepository: DocumentsRepository(user: user))
        ..loadData(type),
      child: Scaffold(
        appBar: AppBar(
          title: Text(titre),
        ),
        body: BlocBuilder<ListeDocumentsCubit, ListeDocumentsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                  itemBuilder: (context,index) => _DocumentsListItem(doc: state.documents[index]),
                  separatorBuilder: (context,index) => SizedBox(height: 10,),
                  itemCount: state.documents.length),
            );
          },
        ),
      ),
    );
  }
}

class _DocumentsListItem extends StatelessWidget {
  const _DocumentsListItem({required this.doc, Key? key}) : super(key: key);

  final Document doc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80,
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
                doc.extension == '.pdf' ? Icons.picture_as_pdf : Icons.image,
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
                    Flexible(
                      child: Text(
                        doc.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => DocumentView(document: doc,)),
        ),
      ),
    );
  }
}
