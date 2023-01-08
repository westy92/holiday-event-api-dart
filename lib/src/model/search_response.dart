import 'package:holiday_event_api/src/model/event_summary.dart';
import 'package:holiday_event_api/src/model/rate_limit.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'search_response.g.dart';

/// The Response returned by search
@JsonSerializable(createToJson: false)
class SearchResponse {
  const SearchResponse({
    this.query = 'unknown',
    this.adult = false,
    this.events = const [],
    this.rateLimit = const RateLimit(),
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  /// The search query
  final String query;

  /// Whether Adult entries can be included
  final bool adult;

  /// The found Events
  final List<EventSummary> events;

  /// TODO inherit and docs
  final RateLimit rateLimit;
}
