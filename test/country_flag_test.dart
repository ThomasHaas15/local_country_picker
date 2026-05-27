import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:local_country_picker/local_country_picker.dart';

void main() {
  group('countryFlagAssetPath', () {
    test('uppercases the code and defaults to the round shape', () {
      expect(countryFlagAssetPath('it'), 'assets/flags/round/IT.png');
      expect(countryFlagAssetPath('IT'), 'assets/flags/round/IT.png');
    });

    test('uses the rect directory for the rect shape', () {
      expect(
        countryFlagAssetPath('it', shape: CountryFlagShape.rect),
        'assets/flags/rect/IT.png',
      );
    });
  });

  group('countryFlagImage', () {
    test('builds an AssetImage scoped to the package', () {
      final image = countryFlagImage('it');
      expect(image, isA<AssetImage>());
      expect(image.assetName, 'assets/flags/round/IT.png');
      expect(image.package, 'local_country_picker');
    });
  });

  group('isKnownCountryCode', () {
    test('returns true for known codes (case-insensitive)', () {
      expect(isKnownCountryCode('IT'), isTrue);
      expect(isKnownCountryCode('it'), isTrue);
      expect(isKnownCountryCode('NL'), isTrue);
    });

    test('returns false for a bogus code', () {
      expect(isKnownCountryCode('ZZ'), isFalse);
      expect(isKnownCountryCode('XX'), isFalse);
    });
  });

  group('CountryFlag widget', () {
    testWidgets('renders an Image for a known code', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CountryFlag('IT')),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders the fallback for an unknown code', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CountryFlag('ZZ')),
      );
      // No asset lookup is attempted, so no Image is built and nothing throws.
      expect(find.byType(Image), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders the provided errorWidget for an unknown code', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CountryFlag(
            'ZZ',
            errorWidget: Text('no flag'),
          ),
        ),
      );
      expect(find.byType(Image), findsNothing);
      expect(find.text('no flag'), findsOneWidget);
    });
  });
}
