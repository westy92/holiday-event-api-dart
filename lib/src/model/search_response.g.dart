// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      query: json['query'] as String,
      adult: json['adult'] as bool,
      events: (json['events'] as List<dynamic>)
          .map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      rateLimit: RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
    );
