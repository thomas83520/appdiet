import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/documents_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'liste_documents_state.dart';

class ListeDocumentsCubit extends Cubit<ListeDocumentsState> {
  ListeDocumentsCubit({required this.documentsRepository})
      : super(ListeDocumentsState(
            documents: [], status: ListeDocumentStatus.loading));

  final DocumentsRepository documentsRepository;

  Future<void> loadData(String type) async {
    try{
      List<Document> documents= await documentsRepository.loadData(type);
      emit(ListeDocumentsState(status: ListeDocumentStatus.success,documents: documents));

    }catch(e){
      emit(ListeDocumentsState(documents: [],status: ListeDocumentStatus.failure));
    }
  }
}
