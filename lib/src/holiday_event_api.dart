import 'dart:convert';
import 'dart:io';

import 'package:holiday_event_api/src/model/get_event_info_response.dart';
import 'package:holiday_event_api/src/model/get_events_response.dart';
import 'package:holiday_event_api/src/model/search_response.dart';

class HolidayEventApi {
  HolidayEventApi(String apiKey) {
    if (apiKey.isEmpty) {
      throw ArgumentError(
          'Please provide a valid API key. Get one at https://apilayer.com/marketplace/checkiday-api#pricing.');
    }
    _apiKey = apiKey;
  }

  late final String _apiKey;

  static final HttpClient client = HttpClient();
  static const JsonDecoder decoder = JsonDecoder();
  static final Uri baseUrl = Uri.parse("https://api.apilayer.com/checkiday");

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
    final HttpClientRequest req = await client.getUrl(
      Uri.https(
        'api.apilayer.com',
        '/checkiday/$path',
        params,
      ),
    );

    req.headers.add('apikey', _apiKey);
    req.headers.add('user-agent', 'HolidayApiDart/1.0.0'); // TODO
    req.headers.add('x-platform-version', Platform.version);

    final HttpClientResponse res = await req.close();

    final String body = await res.transform(utf8.decoder).join();

    final Map<String, dynamic> result = decoder.convert(body);

    result['rateLimit'] = {
      'limitMonth':
          int.tryParse(res.headers.value('X-RateLimit-Limit-Month') ?? '0'),
      'remainingMonth':
          int.tryParse(res.headers.value('X-RateLimit-Remaining-Month') ?? '0'),
    };

    return fromJson(result);
  }
}
