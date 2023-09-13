import 'package:equatable/equatable.dart';
import 'package:holiday_event_api/src/model/event_summary.dart';
import 'package:holiday_event_api/src/model/rate_limit.dart';
import 'package:holiday_event_api/src/model/standard_response.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: dart run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'get_events_response.g.dart';

/// The Response returned by getEvents
@JsonSerializable(createToJson: false)
class GetEventsResponse extends StandardResponse with EquatableMixin {
  const GetEventsResponse({
    required this.adult,
    required this.date,
    required this.timezone,
    required this.events,
    this.multidayStarting,
    this.multidayOngoing,
    required RateLimit rateLimit,
  }) : super(rateLimit);

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
  final List<EventSummary>? multidayStarting;

  /// Multi-day Events that are continuing their observance on Date
  @JsonKey(name: 'multiday_ongoing')
  final List<EventSummary>? multidayOngoing;

  @override
  List<Object?> get props =>
      [adult, date, timezone, events, multidayStarting, multidayOngoing];
}
