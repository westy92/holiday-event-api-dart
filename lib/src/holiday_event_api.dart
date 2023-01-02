import 'dart:convert';
import 'dart:io';

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

  // TODO return type
  Future<dynamic> getEvents(
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

    return _request('events', params);
  }

  // TODO return type
  Future<dynamic> search({required String query, bool adult = false}) async {
    if (query.isEmpty) {
      throw ArgumentError("Search query is required.");
    }
    var params = <String, String>{
      'query': query,
      'adult': adult.toString(),
    };

    return _request('search', params);
  }

  Future<dynamic> _request(String path, Map<String, String> params) async {
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

    //return GetEventsResult.fromJson(
    //    decoder.convert(body) as Map<String, dynamic>);
    return decoder.convert(body);
  }
}
