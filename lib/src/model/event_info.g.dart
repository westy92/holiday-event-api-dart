// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventInfo _$EventInfoFromJson(Map<String, dynamic> json) => EventInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      adult: json['adult'] as bool,
      alternateNames: (json['alternate_names'] as List<dynamic>)
          .map((e) => AlternateName.fromJson(e as Map<String, dynamic>))
          .toList(),
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      image: json['image'] == null
          ? null
          : ImageInfo.fromJson(json['image'] as Map<String, dynamic>),
      sources:
          (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList(),
      description: json['description'] == null
          ? null
          : RichText.fromJson(json['description'] as Map<String, dynamic>),
      howToObserve: json['how_to_observe'] == null
          ? null
          : RichText.fromJson(json['how_to_observe'] as Map<String, dynamic>),
      patterns: (json['patterns'] as List<dynamic>?)
          ?.map((e) => Pattern.fromJson(e as Map<String, dynamic>))
          .toList(),
      founders: (json['founders'] as List<dynamic>?)
          ?.map((e) => FounderInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      occurrences: (json['occurrences'] as List<dynamic>?)
          ?.map((e) => Occurrence.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
