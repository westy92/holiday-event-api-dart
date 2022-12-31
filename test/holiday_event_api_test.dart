import 'package:holiday_event_api/holiday_event_api.dart';
import 'package:test/test.dart';

void main() {
  group('Test constructor', () {
    test('blank API key', () {
      expect(
          () => HolidayEventApi(''),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Please provide a valid API key. Get one at https://apilayer.com/marketplace/checkiday-api#pricing.')));
    });

    test('constructor success', () {
      expect(HolidayEventApi('abc123'), isA<HolidayEventApi>());
    });
  });
}
