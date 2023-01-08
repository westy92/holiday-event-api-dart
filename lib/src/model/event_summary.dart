import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'event_summary.g.dart';

/// A summary of an Event
@JsonSerializable(createToJson: false)
class EventSummary {
  const EventSummary({
    this.id = 'unknown',
    this.name = 'unknown',
    this.url = 'unknown',
  });

  factory EventSummary.fromJson(Map<String, dynamic> json) =>
      _$EventSummaryFromJson(json);

  /// The Event Id
  final String id;

  /// The Event Name
  final String name;

  // The Event URL
  final String url;
}
