// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventsResponse _$GetEventsResponseFromJson(Map<String, dynamic> json) =>
    GetEventsResponse(
      adult: json['adult'] as bool,
      date: json['date'] as String,
      timezone: json['timezone'] as String,
      events: (json['events'] as List<dynamic>)
          .map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      multidayStarting: (json['multiday_starting'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      multidayOngoing: (json['multiday_ongoing'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      rateLimit: RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
    );
