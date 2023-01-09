import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/src/model/get_event_info_response.dart';
import 'package:holiday_event_api/src/model/get_events_response.dart';
import 'package:holiday_event_api/src/model/search_response.dart';
import 'package:http/http.dart';

class HolidayEventApi {
  HolidayEventApi(String apiKey) {
    if (apiKey.isEmpty) {
      throw ArgumentError(
          'Please provide a valid API key. Get one at https://apilayer.com/marketplace/checkiday-api#pricing.');
    }
    _apiKey = apiKey;
  }

  late final String _apiKey;

  static const JsonDecoder decoder = JsonDecoder();

  /// Gets the Events for the provided Date
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

  /// Gets the Event Info for the provided Event
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

  /// Searches for Events with the given criteria
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
      response = await get(
          Uri.https(
            'api.apilayer.com',
            '/checkiday/$path',
            params,
          ),
          headers: {
            'apikey': _apiKey,
            'user-agent': 'HolidayApiDart/1.0.0', // TODO
            'x-platform-version': Platform.version,
          });

      result = decoder.convert(response.body);

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
      // TODO exception type
      throw ClientException(
          result?['error'] ?? response?.reasonPhrase ?? response?.statusCode);
    }
  }
}
