import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/holiday_event_api.dart';
import 'package:holiday_event_api/src/model/event_summary.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

final getEventsDefault =
    File('test/responses/getEvents-default.json').readAsStringSync();
final getEventsParameters =
    File('test/responses/getEvents-parameters.json').readAsStringSync();

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
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message, equals('MyError!'));
          return true;
        })));
      }, () => client);
    });

    test('server error', () {
      final client = MockClient((request) async {
        return Response("", 500, reasonPhrase: 'Internal Server Error');
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.getEvents();
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message, equals('Internal Server Error'));
          return true;
        })));
      }, () => client);
    });

    test('server error (unknown)', () {
      final client = MockClient((request) async {
        return Response("", 500);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.getEvents();
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message, equals('500'));
          return true;
        })));
      }, () => client);
    });

    test('server error (malformed response)', () {
      final client = MockClient((request) async {
        return Response("{", 200);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.getEvents();
        }, throwsA(predicate((e) {
          expect(e, isA<FormatException>());
          e as FormatException;
          expect(e.message, equals('Unable to parse response.'));
          return true;
        })));
      }, () => client);
    });

    test('follows redirects', () {
      final client = MockClient((request) async {
        if (request.url.path == '/checkiday/events') {
          return Response('', 302,
              headers: {
                'location': 'https://api.apilayer.com/checkiday/redirected',
              },
              isRedirect: true);
        }
        return Response(getEventsDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        await api.getEvents();
      }, () => client);
    });

    test('reports rate limits', () {
      final client = MockClient((request) async {
        return Response(getEventsDefault, 200, headers: {
          'x-ratelimit-limit-month': '100',
          'x-ratelimit-remaining-month': '88',
        });
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.getEvents();
        expect(result.rateLimit.limitMonth, equals(100));
        expect(result.rateLimit.remainingMonth, equals(88));
      }, () => client);
    });
  });

  group('getEvents', () {
    test('fetches with default parameters', () {
      final client = MockClient((request) async {
        return Response(getEventsDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.getEvents();
        expect(result.adult, equals(false));
        expect(result.timezone, equals('America/Chicago'));
        expect(result.events, hasLength(2));
        expect(result.multidayStarting, hasLength(1));
        expect(result.multidayOngoing, hasLength(2));
        expect(
            result.events[0],
            equals(EventSummary(
                id: 'b80630ae75c35f34c0526173dd999cfc',
                name: 'Cinco de Mayo',
                url:
                    'https://www.checkiday.com/b80630ae75c35f34c0526173dd999cfc/cinco-de-mayo')));
      }, () => client);
    });

    test('fetches with set parameters', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/events'));
        expect(
            request.url.queryParameters,
            equals({
              'adult': 'true',
              'timezone': 'America/New_York',
              'date': '7/16/1992'
            }));

        return Response(getEventsParameters, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.getEvents(
          adult: true,
          timezone: 'America/New_York',
          date: '7/16/1992',
        );
        expect(result.adult, equals(true));
        expect(result.timezone, equals('America/New_York'));
        expect(result.events, hasLength(2));
        expect(result.multidayStarting, hasLength(0));
        expect(result.multidayOngoing, hasLength(1));
        expect(
            result.events[0],
            equals(EventSummary(
                id: '6ebb6fd5e483de2fde33969a6c398472',
                name: 'Get to Know Your Customers Day',
                url:
                    'https://www.checkiday.com/6ebb6fd5e483de2fde33969a6c398472/get-to-know-your-customers-day')));
      }, () => client);
    });
  });
}
