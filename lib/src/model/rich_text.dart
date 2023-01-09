import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'rich_text.g.dart';

/// Formatted Text
@JsonSerializable(createToJson: false)
class RichText extends Equatable {
  const RichText({
    this.text,
    this.html,
    this.markdown,
  });

  factory RichText.fromJson(Map<String, dynamic> json) =>
      _$RichTextFromJson(json);

  /// Formatted as plain text
  final String? text;

  /// Formatted as HTML
  final String? html;

  /// Formatted as Markdown
  final String? markdown;

  @override
  List<Object?> get props => [text, html, markdown];
}
