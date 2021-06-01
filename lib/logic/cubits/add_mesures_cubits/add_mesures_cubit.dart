import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'add_mesures_state.dart';

class AddMesuresCubit extends Cubit<AddMesuresState> {
  AddMesuresCubit(this._photosRepository, this._poidsMesuresRepository)
      : assert(_photosRepository != null),
        assert(_poidsMesuresRepository != null),
        super(AddMesuresState());

  final PoidsMesuresRepository _poidsMesuresRepository;
  final PhotosRepository _photosRepository;

  void dateChange(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void fileChanged(PickedFile file) {
    emit(state.copyWith(file: file));
  }

  void poidsChanged(String poids) {
    emit(state.copyWith(poids: stringToDouble(poids)));
  }

  void tailleChanged(String taille) {
    emit(state.copyWith(taille: stringToDouble(taille)));
  }

  void ventreChanged(String ventre) {
    emit(state.copyWith(ventre: stringToDouble(ventre)));
  }

  void hanchesChanged(String hanches) {
    emit(state.copyWith(hanches: stringToDouble(hanches)));
  }

  void cuissesChanged(String cuisses) {
    emit(state.copyWith(cuisses: stringToDouble(cuisses)));
  }

  void brasChanged(String bras) {
    emit(state.copyWith(bras: stringToDouble(bras)));
  }

  void poitrineChanged(String poitrine) {
    emit(state.copyWith(poitrine: stringToDouble(poitrine)));
  }

  Future<void> addMesures() async {
    Map<String, dynamic> map = mapState();
    try{
      emit(state.copyWith(formState: AddMesureFormState.loadInProgress));
      String url = "";
      if(state.file!=null)
        url = await _photosRepository.uploadPhoto(state.file.path, state.date.toString());
      _poidsMesuresRepository.addPoidsMesures(map,url);
      emit(state.copyWith(formState: AddMesureFormState.complete));
    }catch (e){
      emit(state.copyWith(formState: AddMesureFormState.error));
    }
  }

  Map<String, dynamic> mapState() {
    Map<String, dynamic> map = {};
    Map<String, dynamic> mapMesures = {};
    if (state.poids != 0) map.putIfAbsent("poids", () => state.poids);
    if (state.taille != 0) mapMesures.putIfAbsent("taille", () => state.taille);
    if (state.hanches != 0)
      mapMesures.putIfAbsent("hanches", () => state.hanches);
    if (state.cuisses != 0)
      mapMesures.putIfAbsent("cuisses", () => state.cuisses);
    if (state.bras != 0) mapMesures.putIfAbsent("bras", () => state.bras);
    if (state.poitrine != 0)
      mapMesures.putIfAbsent("poitrine", () => state.poitrine);

    map.putIfAbsent("mesures", () => mapMesures);
    map.putIfAbsent("date", () => state.date);
    return map;
  }

  double stringToDouble(String string) {
    int length = string.length;
    if (string.contains(",")) string = string.replaceAll(",", ".");
    while (string.lastIndexOf(".") != string.indexOf(".")) {
      string = string.substring(0, string.lastIndexOf(".")) +
          "0" +
          string.substring(string.lastIndexOf(".") + 1);
    }

    if (string.contains(".")) if (length > string.indexOf(".") + 3)
      string = string.substring(0, string.indexOf(".") + 3);
    if (string.indexOf(".") == 0) string = "0" + string;

    return double.parse(string);
  }
}
