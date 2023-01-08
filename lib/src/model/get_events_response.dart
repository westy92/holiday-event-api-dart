import 'package:holiday_event_api/src/model/event_summary.dart';
import 'package:holiday_event_api/src/model/rate_limit.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'get_events_response.g.dart';

/// The Response returned by getEvents
@JsonSerializable(createToJson: false)
class GetEventsResponse {
  const GetEventsResponse({
    this.adult = false,
    this.date = 'unknown',
    this.timezone = 'unknown',
    this.events = const [],
    this.multidayStarting = const [],
    this.multidayOngoing = const [],
    this.rateLimit = const RateLimit(),
  });

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventsResponseFromJson(json);

  /// Whether Adult entries can be included
  final bool adult;

  /// The Date string
  final String date;

  /// The Timezone used to calculate the Date's Events
  final String timezone;

  /// The Date's Events
  final List<EventSummary> events;

  /// Multi-day Events that start on Date
  @JsonKey(name: 'multiday_starting')
  final List<EventSummary> multidayStarting;

  /// Multi-day Events that are continuing their observance on Date
  @JsonKey(name: 'multiday_ongoing')
  final List<EventSummary> multidayOngoing;

  /// TODO inherit and docs
  final RateLimit rateLimit;
}
