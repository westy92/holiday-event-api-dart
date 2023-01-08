// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventsResponse _$GetEventsResponseFromJson(Map<String, dynamic> json) =>
    GetEventsResponse(
      adult: json['adult'] as bool? ?? false,
      date: json['date'] as String? ?? 'unknown',
      timezone: json['timezone'] as String? ?? 'unknown',
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      multidayStarting: (json['multiday_starting'] as List<dynamic>?)
              ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      multidayOngoing: (json['multiday_ongoing'] as List<dynamic>?)
              ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rateLimit: json['rateLimit'] == null
          ? const RateLimit()
          : RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
    );
