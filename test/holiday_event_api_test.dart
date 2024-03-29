import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/holiday_event_api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:test/test.dart';

final pubspec = File('pubspec.yaml').readAsStringSync();
final getEventsDefault =
    File('test/responses/getEvents-default.json').readAsStringSync();
final getEventsParameters =
    File('test/responses/getEvents-parameters.json').readAsStringSync();
final getEventInfoDefault =
    File('test/responses/getEventInfo.json').readAsStringSync();
final getEventInfoParameters =
    File('test/responses/getEventInfo-parameters.json').readAsStringSync();
final searchDefault =
    File('test/responses/search-default.json').readAsStringSync();
final searchParameters =
    File('test/responses/search-parameters.json').readAsStringSync();

void main() {
  group('constructor tests', () {
    test('blank API key', () {
      expect(() => HolidayEventApi(''), throwsA(predicate((e) {
        expect(e, isA<ArgumentError>());
        e as ArgumentError;
        expect(
            e.message,
            equals(
                'Please provide a valid API key. Get one at https://apilayer.com/marketplace/checkiday-api#pricing.'));
        return true;
      })));
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
      final version = Pubspec.parse(pubspec).version?.toString();
      final client = MockClient((request) async {
        expect(
            request.headers['user-agent'], equals('HolidayApiDart/$version'));
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

  group('getEventInfo', () {
    test('fetches with default parameters', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/event'));
        expect(
            request.url.queryParameters,
            equals({
              'id': 'f90b893ea04939d7456f30c54f68d7b4',
            }));

        return Response(getEventInfoDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.getEventInfo(
          id: 'f90b893ea04939d7456f30c54f68d7b4',
        );
        expect(result.event.id, equals('f90b893ea04939d7456f30c54f68d7b4'));
        expect(result.event.hashtags, hasLength(2));
      }, () => client);
    });

    test('fetches with set parameters', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/event'));
        expect(
            request.url.queryParameters,
            equals({
              'id': 'f90b893ea04939d7456f30c54f68d7b4',
              'start': '2002',
              'end': '2003',
            }));

        return Response(getEventInfoParameters, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.getEventInfo(
          id: 'f90b893ea04939d7456f30c54f68d7b4',
          start: 2002,
          end: 2003,
        );
        expect(result.event.occurrences, hasLength(2));
        expect(result.event.occurrences![0],
            equals(Occurrence(date: '08/08/2002', length: 1)));
      }, () => client);
    });

    test('invalid event', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/event'));
        expect(
            request.url.queryParameters,
            equals({
              'id': 'hi',
            }));

        return Response(jsonEncode({'error': 'Event not found.'}), 404);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.getEventInfo(id: 'hi');
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message, equals('Event not found.'));
          return true;
        })));
      }, () => client);
    });

    test('missing id', () {
      expect(() async {
        final api = HolidayEventApi('abc123');
        await api.getEventInfo(id: '');
      }, throwsA(predicate((e) {
        expect(e, isA<ArgumentError>());
        e as ArgumentError;
        expect(e.message, equals('Event id is required.'));
        return true;
      })));
    });
  });

  group('search', () {
    test('fetches with default parameters', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/search'));
        expect(
            request.url.queryParameters,
            equals({
              'query': 'zucchini',
              'adult': 'false',
            }));

        return Response(searchDefault, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.search(
          query: 'zucchini',
        );
        expect(result.adult, equals(false));
        expect(result.query, equals('zucchini'));
        expect(result.events, hasLength(3));
        expect(
            result.events[0],
            equals(EventSummary(
                id: 'cc81cbd8730098456f85f69798cbc867',
                name: 'National Zucchini Bread Day',
                url:
                    'https://www.checkiday.com/cc81cbd8730098456f85f69798cbc867/national-zucchini-bread-day')));
      }, () => client);
    });

    test('fetches with set parameters', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/search'));
        expect(
            request.url.queryParameters,
            equals({
              'query': 'porch day',
              'adult': 'true',
            }));

        return Response(searchParameters, 200);
      });
      return runWithClient(() async {
        final api = HolidayEventApi('abc123');
        final result = await api.search(
          query: 'porch day',
          adult: true,
        );
        expect(result.adult, equals(true));
        expect(result.query, equals('porch day'));
        expect(result.events, hasLength(1));
        expect(
            result.events[0],
            equals(EventSummary(
                id: '61363236f06e4eb8e4e14e5925c2503d',
                name: "Sneak Some Zucchini Onto Your Neighbor's Porch Day",
                url:
                    'https://www.checkiday.com/61363236f06e4eb8e4e14e5925c2503d/sneak-some-zucchini-onto-your-neighbors-porch-day')));
      }, () => client);
    });

    test('query too short', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/search'));
        expect(
            request.url.queryParameters,
            equals({
              'query': 'a',
              'adult': 'false',
            }));

        return Response(
            jsonEncode({'error': 'Please enter a longer search term.'}), 400);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.search(query: 'a');
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message, equals('Please enter a longer search term.'));
          return true;
        })));
      }, () => client);
    });

    test('too many results', () {
      final client = MockClient((request) async {
        expect(request.url.path, equals('/checkiday/search'));
        expect(
            request.url.queryParameters,
            equals({
              'query': 'day',
              'adult': 'false',
            }));

        return Response(
            jsonEncode({
              'error': 'Too many results returned. Please refine your query.'
            }),
            400);
      });
      return runWithClient(() async {
        expect(() async {
          final api = HolidayEventApi('abc123');
          await api.search(query: 'day');
        }, throwsA(predicate((e) {
          expect(e, isA<ClientException>());
          e as ClientException;
          expect(e.message,
              equals('Too many results returned. Please refine your query.'));
          return true;
        })));
      }, () => client);
    });

    test('query empty', () {
      expect(() async {
        final api = HolidayEventApi('abc123');
        await api.search(query: '');
      }, throwsA(predicate((e) {
        expect(e, isA<ArgumentError>());
        e as ArgumentError;
        expect(e.message, equals('Search query is required.'));
        return true;
      })));
    });
  });

  group('model tests', () {
    test('AlternateName', () {
      final a = AlternateName(name: 'a', firstYear: 123, lastYear: 456);
      final a2 = AlternateName(name: 'a', firstYear: 123, lastYear: 456);
      final b = AlternateName(name: 'b', firstYear: 123, lastYear: 456);
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('EventInfo', () {
      final a = EventInfo(
          id: 'a', name: 'b', url: 'c', adult: false, alternateNames: []);
      final a2 = EventInfo(
          id: 'a', name: 'b', url: 'c', adult: false, alternateNames: []);
      final b = EventInfo(
          id: 'A', name: 'b', url: 'c', adult: false, alternateNames: []);
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('EventSummary', () {
      final a = EventSummary(name: 'a', id: '123', url: '456');
      final a2 = EventSummary(name: 'a', id: '123', url: '456');
      final b = EventSummary(name: 'b', id: '123', url: '456');
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('FounderInfo', () {
      final a = FounderInfo(name: 'a', url: '123', date: '456');
      final a2 = FounderInfo(name: 'a', url: '123', date: '456');
      final b = FounderInfo(name: 'b', url: '123', date: '456');
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('GetEventInfoResponse', () {
      final a = GetEventInfoResponse(
          event: EventInfo(
              id: 'a', name: 'b', url: 'c', adult: false, alternateNames: []),
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final a2 = GetEventInfoResponse(
          event: EventInfo(
              id: 'a', name: 'b', url: 'c', adult: false, alternateNames: []),
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final b = GetEventInfoResponse(
          event: EventInfo(
              id: 'A', name: 'B', url: 'C', adult: false, alternateNames: []),
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('GetEventsResponse', () {
      final a = GetEventsResponse(
          adult: true,
          date: 'd',
          timezone: 't',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final a2 = GetEventsResponse(
          adult: true,
          date: 'd',
          timezone: 't',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final b = GetEventsResponse(
          adult: false,
          date: 'd',
          timezone: 't',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('ImageInfo', () {
      final a = ImageInfo(small: 'a', medium: '123', large: '456');
      final a2 = ImageInfo(small: 'a', medium: '123', large: '456');
      final b = ImageInfo(small: 'b', medium: '123', large: '456');
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('Occurrence', () {
      final a = Occurrence(date: 'a', length: 123);
      final a2 = Occurrence(date: 'a', length: 123);
      final b = Occurrence(date: 'b', length: 123);
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('Pattern', () {
      final a = Pattern(
          firstYear: 123,
          lastYear: 456,
          observed: 'txt',
          observedHtml: 'html',
          observedMarkdown: 'md',
          length: 789);
      final a2 = Pattern(
          firstYear: 123,
          lastYear: 456,
          observed: 'txt',
          observedHtml: 'html',
          observedMarkdown: 'md',
          length: 789);
      final b = Pattern(
          firstYear: 999,
          lastYear: 456,
          observed: 'txt',
          observedHtml: 'html',
          observedMarkdown: 'md',
          length: 789);
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('RateLimit', () {
      final a = RateLimit(limitMonth: 123, remainingMonth: 456);
      final a2 = RateLimit(limitMonth: 123, remainingMonth: 456);
      final b = RateLimit(limitMonth: 999, remainingMonth: 456);
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('RichText', () {
      final a = RichText(text: 'txt', markdown: 'md', html: 'html');
      final a2 = RichText(text: 'txt', markdown: 'md', html: 'html');
      final b = RichText(text: 'TXT', markdown: 'md', html: 'html');
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });

    test('SearchResponse', () {
      final a = SearchResponse(
          adult: false,
          query: 'q',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final a2 = SearchResponse(
          adult: false,
          query: 'q',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      final b = SearchResponse(
          adult: false,
          query: 'QUERY2',
          events: [],
          rateLimit: RateLimit(limitMonth: 123, remainingMonth: 456));
      expect(a, equals(a));
      expect(a, equals(a2));
      expect(a, isNot(equals(b)));
    });
  });
}
