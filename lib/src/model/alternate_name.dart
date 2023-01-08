import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'alternate_name.g.dart';

/// Information about an Event's Alternate Name
@JsonSerializable(createToJson: false)
class AlternateName {
  const AlternateName({
    required this.name,
    this.firstYear,
    this.lastYear,
  });

  factory AlternateName.fromJson(Map<String, dynamic> json) =>
      _$AlternateNameFromJson(json);

  /// An Event's Alternate Name
  final String name;

  /// The first year this Alternate Name was in effect (null implies none or unknown)
  @JsonKey(name: 'first_year')
  final int? firstYear;

  /// The last year this Alternate Name was in effect (null implies none or unknown)
  @JsonKey(name: 'last_year')
  final int? lastYear;
}
