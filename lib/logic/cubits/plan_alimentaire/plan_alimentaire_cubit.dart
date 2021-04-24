import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:appdiet/data/repository/plan_alimentaire_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'plan_alimentaire_state.dart';

class PlanAlimentaireCubit extends Cubit<PlanAlimentaireState> {
  PlanAlimentaireCubit(
      {@required PlanAlimentaireRepository planAlimentaireRepository})
      : assert(planAlimentaireRepository != null),
        _planAlimentaireRepository = planAlimentaireRepository,
        super(PlanAlimentaireInitial());

  final PlanAlimentaireRepository _planAlimentaireRepository;

  Future<void> loadDocument() async {
    emit(PlanAlimentaireLoadInProgress());
    try{
      PDFDocument document= await _planAlimentaireRepository.loadDocument();
    emit(PlanAlimentaireLoadSuccess(document: document));}
    catch (e) {
      emit(PlanAlimentaireLoadFailure());
    }
  }
}
