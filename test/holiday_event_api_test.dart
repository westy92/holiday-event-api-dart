import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/holiday_event_api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

final getEventsDefault =
    File('test/responses/getEvents-default.json').readAsStringSync();

void main() {
  group('constructor tests', () {
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

  group('common functionality tests', () {
    test('passes along API key', () {
      final client = MockClient((request) async {
        expect(request.headers['apikey'], equals('abc123'));
        return Response(getEventsDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        await api.getEvents();
      }, () => client);
    });

    test('passes along user-agent', () {
      final client = MockClient((request) async {
        expect(request.headers['user-agent'],
            equals('HolidayApiDart/1.0.0')); // TODO
        return Response(getEventsDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        await api.getEvents();
      }, () => client);
    });

    test('passes along platform version', () {
      final client = MockClient((request) async {
        expect(request.headers['x-platform-version'], equals(Platform.version));
        return Response(getEventsDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        await api.getEvents();
      }, () => client);
    });

    test('passes along error', () {
      final client = MockClient((request) async {
        return Response(jsonEncode({'error': 'MyError!'}), 401);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.getEvents();
        },
            throwsA(predicate(
                (e) => e is ClientException && e.message == 'MyError!')));
      }, () => client);
    });
  });
}
