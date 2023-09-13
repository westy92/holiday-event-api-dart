import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: dart run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'image_info.g.dart';

/// Information about an Event image
@JsonSerializable(createToJson: false)
class ImageInfo extends Equatable {
  const ImageInfo({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) =>
      _$ImageInfoFromJson(json);

  /// A small image
  final String small;

  /// A medium image
  final String medium;

  /// A large image
  final String large;

  @override
  List<Object?> get props => [small, medium, large];
}
