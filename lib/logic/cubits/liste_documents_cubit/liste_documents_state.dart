part of 'liste_documents_cubit.dart';

enum ListeDocumentStatus {loading,failure,success}

class ListeDocumentsState extends Equatable {
  const ListeDocumentsState({required this.status,required this.documents});

  final ListeDocumentStatus status;
  final List<Document> documents;

  @override
  List<Object> get props => [documents,status];
}
