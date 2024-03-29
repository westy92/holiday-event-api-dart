import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: dart run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'occurrence.g.dart';

/// Information about an Event's Occurrence
@JsonSerializable(createToJson: false)
class Occurrence extends Equatable {
  const Occurrence({
    required this.date,
    required this.length,
  });

  factory Occurrence.fromJson(Map<String, dynamic> json) =>
      _$OccurrenceFromJson(json);

  /// The date or timestamp the Event occurs
  final String date;

  /// The length (in days) of the Event occurrence
  final int length;

  @override
  List<Object?> get props => [date, length];
}
