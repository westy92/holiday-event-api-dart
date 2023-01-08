import 'package:holiday_event_api/src/model/alternate_name.dart';
import 'package:holiday_event_api/src/model/founder_info.dart';
import 'package:holiday_event_api/src/model/image_info.dart';
import 'package:holiday_event_api/src/model/occurrence.dart';
import 'package:holiday_event_api/src/model/pattern.dart';
import 'package:holiday_event_api/src/model/rich_text.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'event_info.g.dart';

/// Information about an Event
@JsonSerializable(createToJson: false)
class EventInfo {
  const EventInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.adult,
    required this.alternateNames,
    this.hashtags,
    this.image,
    this.sources,
    this.description,
    this.howToObserve,
    this.patterns,
    this.founders,
    this.occurrences,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) =>
      _$EventInfoFromJson(json);

  /// The Event Id
  final String id;

  /// The Event Name
  final String name;

  // The Event URL
  final String url;

  /// Whether this Event is unsafe for children or viewing at work
  final bool adult;

  /// The Event's Alternate Names
  @JsonKey(name: 'alternate_names')
  final List<AlternateName> alternateNames;

  /// The Event's hashtags
  final List<String>? hashtags;

  /// The Event's images
  final ImageInfo? image;

  /// The Event's sources
  final List<String>? sources;

  /// The Event's description
  final RichText? description;

  /// How to observe the Event
  @JsonKey(name: 'how_to_observe')
  final RichText? howToObserve;

  /// Patterns defining when the Event is observed
  final List<Pattern>? patterns;

  /// The Event's founders
  final List<FounderInfo>? founders;

  /// The Event Occurrences (when it occurs)
  final List<Occurrence>? occurrences;
}
