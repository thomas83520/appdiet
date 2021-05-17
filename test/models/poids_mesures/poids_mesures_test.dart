import 'package:appdiet/data/models/poids_mesures/poids_mesures.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  DateTime date= DateTime.now();
  group('Poids Mesures', () {
    test('Mesures',(){
      expect(Mesures(date: date,mesure: 12.0), Mesures(date: date,mesure: 12.0));
    });

    test('Poids',(){
      expect(Poids(date: date,poids: 12.0),Poids(date: date,poids: 12.0));
    });
    test('PoidsMesure', () {
      Map<MesureType, List<Mesures>> mesures = {
        MesureType.bras: [Mesures(date: date, mesure: 12.0)]
      };
      List<Poids> poids = [Poids(date: date, poids: 12.0)];
      Map<DateTime, List<String>> photos = {
        DateTime.now(): ["Url Photo", "url2"],
      };
      expect(PoidsMesures(mesures: mesures, poids: poids, photos: photos),
          PoidsMesures(mesures: mesures, poids: poids, photos: photos));
    });

    
  });
}
