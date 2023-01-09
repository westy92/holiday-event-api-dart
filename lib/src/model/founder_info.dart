import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'founder_info.g.dart';

/// Information about an Event Founder
@JsonSerializable(createToJson: false)
class FounderInfo extends Equatable {
  const FounderInfo({
    required this.name,
    this.url,
    this.date,
  });

  factory FounderInfo.fromJson(Map<String, dynamic> json) =>
      _$FounderInfoFromJson(json);

  /// The Founder's name
  final String name;

  /// A link to the Founder
  final String? url;

  /// The date the Event was founded
  final String? date;

  @override
  List<Object?> get props => [name, url, date];
}
