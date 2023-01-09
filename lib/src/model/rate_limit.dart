import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'rate_limit.g.dart';

/// Your API plan's current Rate Limit and status. Upgrade to increase these limits.
@JsonSerializable(createToJson: false)
class RateLimit extends Equatable {
  const RateLimit({
    required this.limitMonth,
    required this.remainingMonth,
  });

  factory RateLimit.fromJson(Map<String, dynamic> json) =>
      _$RateLimitFromJson(json);

  /// The amount of requests allowed this month
  final int limitMonth;

  /// The amount of requests remaining this month
  final int remainingMonth;

  @override
  List<Object?> get props => [limitMonth, remainingMonth];
}
