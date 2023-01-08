import 'package:holiday_event_api/src/model/event_info.dart';
import 'package:holiday_event_api/src/model/rate_limit.dart';
import 'package:holiday_event_api/src/model/standard_response.dart';
import 'package:json_annotation/json_annotation.dart';

// Generated with: flutter packages pub run build_runner build
// Each class needs:
//   factory <CLASSNAME>.fromJson(Map<String, dynamic> json) => _$<CLASSNAME>FromJson(json);
part 'get_event_info_response.g.dart';

/// The Response returned by getEventInfo
@JsonSerializable(createToJson: false)
class GetEventInfoResponse extends StandardResponse {
  const GetEventInfoResponse({
    required this.event,
    required RateLimit rateLimit,
  }) : super(rateLimit);

  factory GetEventInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventInfoResponseFromJson(json);

  /// The Event Info
  final EventInfo event;
}
