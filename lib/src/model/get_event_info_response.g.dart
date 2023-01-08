// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_event_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventInfoResponse _$GetEventInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetEventInfoResponse(
      event: EventInfo.fromJson(json['event'] as Map<String, dynamic>),
      rateLimit: RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
    );
