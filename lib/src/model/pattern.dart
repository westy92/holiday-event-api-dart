import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: dart run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'pattern.g.dart';

/// Information about an Event's Pattern
@JsonSerializable(createToJson: false)
class Pattern extends Equatable {
  const Pattern({
    this.firstYear,
    this.lastYear,
    required this.observed,
    required this.observedHtml,
    required this.observedMarkdown,
    required this.length,
  });

  factory Pattern.fromJson(Map<String, dynamic> json) =>
      _$PatternFromJson(json);

  /// The first year this event is observed (null implies none or unknown)
  @JsonKey(name: 'first_year')
  final int? firstYear;

  /// The last year this event is observed (null implies none or unknown)
  @JsonKey(name: 'last_year')
  final int? lastYear;

  /// A description of how this event is observed (formatted as plain text)
  final String observed;

  /// A description of how this event is observed (formatted as HTML)
  @JsonKey(name: 'observed_html')
  final String observedHtml;

  /// A description of how this event is observed (formatted as Markdown)
  @JsonKey(name: 'observed_markdown')
  final String observedMarkdown;

  /// For how many days this event is celebrated
  final int length;

  @override
  List<Object?> get props =>
      [firstYear, lastYear, observed, observedHtml, observedMarkdown, length];
}
