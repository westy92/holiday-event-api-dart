// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      query: json['query'] as String? ?? 'unknown',
      adult: json['adult'] as bool? ?? false,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rateLimit: json['rateLimit'] == null
          ? const RateLimit()
          : RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
    );
