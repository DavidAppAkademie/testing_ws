import 'package:flutter_test/flutter_test.dart';
import 'package:testing_ws/funcs.dart';

void main() {
  group(
    'calculate hit rate tests',
    () {
      test('Normalfall: 8 Treffer, 16 Versuche', () {
        expect(calculateHitRate(8, 16), 0.5);
      });

      test('Normalfall: 10 Treffer, 50 Versuche', () {
        expect(calculateHitRate(10, 50), 0.2);
      });

      test('Sonderfall: 10 Treffer, 10 Versuche', () {
        expect(calculateHitRate(10, 10), 1);
      });

      test('Sonderfall: 0 Treffer, 0 Versuche', () {
        expect(calculateHitRate(0, 0), 0);
      });

      test('Sonderfall: 0 Treffer, 10 Versuche', () {
        expect(calculateHitRate(0, 10), 0);
      });

      test('Sonderfall: 11 Treffer, 10 Versuche', () {
        expect(calculateHitRate(11, 10), 1);
      });

      test('Sonderfall: 1 Treffer, 3 Versuche', () {
        expect(calculateHitRate(1, 3), 1 / 3);
      });
    },
  );

  group(
    'calculate score tests',
    () {
      test('Normalfall: 5 Hits, 0.5', () {
        expect(calculateScore(5, 0.5), 75);
      });

      test('Normalfall: 10 Hits, 0.25', () {
        expect(calculateScore(10, 0.25), 125);
      });

      test('Sonderfall: 5 Hits, 1', () {
        expect(calculateScore(5, 1), 100);
      });

      test('Sonderfall: 0 Hits, 0', () {
        expect(calculateScore(0, 0), 0);
      });

      test('Sonderfall: 1 Hits, 1', () {
        expect(calculateScore(1, 1), 20);
      });

      test('Sonderfall: 10 Hits, 2', () {
        expect(calculateScore(10, 2), 200);
      });

      test('Sonderfall: 5 Hits, 1/3', () {
        expect(calculateScore(5, 1 / 3), 67);
      });
    },
  );

  group(
    'getRankTitle tests',
    () {
      test(
        'god rank',
        () {
          expect(getRankTitle(499), 'Legend');
          expect(getRankTitle(500), 'God');
          expect(getRankTitle(501), 'God');
        },
      );
      test(
        'legend rank',
        () {
          expect(getRankTitle(399), 'Pro');
          expect(getRankTitle(400), 'Legend');
          expect(getRankTitle(401), 'Legend');
        },
      );
      test(
        'pro rank',
        () {
          expect(getRankTitle(349), 'Sharpshooter');
          expect(getRankTitle(350), 'Pro');
          expect(getRankTitle(399), 'Pro');
        },
      );
      test(
        'sharpshooter rank',
        () {
          expect(getRankTitle(299), 'Good Shot');
          expect(getRankTitle(300), 'Sharpshooter');
          expect(getRankTitle(349), 'Sharpshooter');
        },
      );
      test(
        'good shot rank',
        () {
          expect(getRankTitle(199), 'Average');
          expect(getRankTitle(200), 'Good Shot');
          expect(getRankTitle(299), 'Good Shot');
        },
      );
      test(
        'average rank',
        () {
          expect(getRankTitle(99), 'Needs Practice');
          expect(getRankTitle(100), 'Average');
          expect(getRankTitle(199), 'Average');
        },
      );
      test(
        'needs practice rank',
        () {
          expect(getRankTitle(0), 'Needs Practice');
          expect(getRankTitle(50), 'Needs Practice');
          expect(getRankTitle(99), 'Needs Practice');
        },
      );
    },
  );
}
