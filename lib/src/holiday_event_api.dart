import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/src/model/get_event_info_response.dart';
import 'package:holiday_event_api/src/model/get_events_response.dart';
import 'package:holiday_event_api/src/model/search_response.dart';
import 'package:http/http.dart';

/// The Official Holiday and Event API for Dart and Flutter.
class HolidayEventApi {
  /// Creates a [HolidayEventApi] using the provided [apiKey].
  /// 
  /// Get one at https://apilayer.com/marketplace/checkiday-api#pricing.
  HolidayEventApi(String apiKey) {
    if (apiKey.isEmpty) {
      throw ArgumentError(
          'Please provide a valid API key. Get one at https://apilayer.com/marketplace/checkiday-api#pricing.');
    }
    _apiKey = apiKey;
  }

  late final String _apiKey;

  static const String version = '1.0.1';
  static const JsonDecoder _decoder = JsonDecoder();
  static const int _maxRedirects = 5;

  /// Gets the Events for the provided [date].
  ///
  /// You can optionally specify a [date] (defaults to today), whether you wish to include
  /// NSFW Events with [adult], and the [timezone] context for the given [date] (defaults
  /// to America/Chicago).
  ///
  /// ```dart
  /// getEvents(date: 'today', adult: false, timezone: 'America/Chicago')
  /// ```
  Future<GetEventsResponse> getEvents(
      {String? date, bool adult = false, String? timezone}) async {
    var params = <String, String>{
      'adult': adult.toString(),
    };

    if (date != null) {
      params['date'] = date;
    }
    if (timezone != null) {
      params['timezone'] = timezone;
    }

    return _request('events', params, GetEventsResponse.fromJson);
  }

  /// Gets the Event Info for the provided Event [id].
  ///
  /// You can optionally sepcify the [start] and [end] year(s)
  /// to configure the range of the returned [Occurrence]s.
  ///
  /// ```dart
  /// getEventInfo(id: 'f90b893ea04939d7456f30c54f68d7b4', start: 2020, end: 2030)
  /// ```
  Future<GetEventInfoResponse> getEventInfo(
      {required String id, int? start, int? end}) async {
    if (id.isEmpty) {
      throw ArgumentError('Event id is required.');
    }
    var params = <String, String>{
      'id': id,
    };

    if (start != null) {
      params['start'] = start.toString();
    }
    if (end != null) {
      params['end'] = end.toString();
    }

    return _request('event', params, GetEventInfoResponse.fromJson);
  }

  /// Searches for Events with the given criteria.
  ///
  /// The search [query] is required, and you can specify [adult] to
  /// determine if the results include NSFW Events.
  ///
  /// ```dart
  /// search(query: 'taco', adult: false)
  /// ```
  Future<SearchResponse> search(
      {required String query, bool adult = false}) async {
    if (query.isEmpty) {
      throw ArgumentError("Search query is required.");
    }
    var params = <String, String>{
      'query': query,
      'adult': adult.toString(),
    };

    return _request('search', params, SearchResponse.fromJson);
  }

  Future<T> _request<T>(String path, Map<String, String> params,
      T Function(Map<String, dynamic>) fromJson) async {
    Response? response;
    Map<String, dynamic>? result;
    try {
      final headers = {
        'apikey': _apiKey,
        'user-agent': 'HolidayApiDart/$version',
        'x-platform-version': Platform.version,
      };
      response = await get(
        Uri.https(
          'api.apilayer.com',
          '/checkiday/$path',
          params,
        ),
        headers: headers,
      );

      int redirects = 0;
      while (response!.isRedirect && redirects++ < _maxRedirects) {
        response = await get(Uri.parse(response.headers['location']!),
            headers: headers);
      }

      result = _decoder.convert(response.body);

      result!['rateLimit'] = {
        'limitMonth':
            int.tryParse(response.headers['x-ratelimit-limit-month'] ?? '0'),
        'remainingMonth': int.tryParse(
            response.headers['x-ratelimit-remaining-month'] ?? '0'),
      };

      return fromJson(result);
    } catch (err) {
      if (response?.statusCode == HttpStatus.ok) {
        throw FormatException('Unable to parse response.');
      }
      throw ClientException(result?['error'] ??
          response?.reasonPhrase ??
          response?.statusCode.toString());
    }
  }
}
