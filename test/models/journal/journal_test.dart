import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Journal', () {
    List<Repas> repas = [Repas.empty];
    List<DayComments> daycomments = [DayComments.empty];
    WellBeing wellBeing = WellBeing.empty;
    String date = "12/12/1212";

    test('Journal instance', () {
      expect(
        Journal(
            mapCommentaires: daycomments,
            mapRepas: repas,
            wellBeing: wellBeing,
            date: date),
        Journal(
            mapRepas: repas,
            mapCommentaires: daycomments,
            wellBeing: wellBeing,
            date: date),
      );
    });

    test('Journal empty', () {
      expect(Journal.empty,Journal(mapCommentaires: [],mapRepas: [],wellBeing: WellBeing.empty,date: 'idk'));
    });
  });
}
