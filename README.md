# The Official Holiday and Event API for Dart and Flutter

<!-- pub.dev version -->
[![Build Status](https://github.com/westy92/holiday-event-api-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/westy92/holiday-event-api-dart/actions)
[![Code Coverage](https://codecov.io/gh/westy92/holiday-event-api-dart/branch/main/graph/badge.svg)](https://codecov.io/gh/westy92/holiday-event-api-dart)
[![Funding Status](https://img.shields.io/github/sponsors/westy92)](https://github.com/sponsors/westy92)

Industry-leading Holiday and Event API for Dart and Flutter. Over 5,000 holidays and thousands of descriptions. Trusted by the World’s leading companies. Built by developers for developers since 2011.

## Supported Dart and Flutter Versions

The latest version of the the Holiday and Event API is compatible with the [latest version of Dart](https://dart.dev/) but may work with older verions.

## Authentication

Access to the Holiday and Event API requires an API Key. You can get for one for FREE [here](https://apilayer.com/marketplace/checkiday-api#pricing), no credit card required! Note that free plans are limited. To access more data and have more requests, a paid plan is required.

## Installation

The recommended way to install the Holiday and Event API is through [Pub](https://pub.dev/).

```bash
flutter pub add holiday_event_api
```

or

```bash
dart pub add holiday_event_api
```

## Example

```dart
import 'package:holiday_event_api/holiday_event_api.dart';

void main() async {
  try {
    // Get a FREE API key from https://apilayer.com/marketplace/checkiday-api#pricing
    final client = HolidayEventApi('<your API key>');

    // Get Events for a given Date
    final events = await client.getEvents(
        // These parameters are the defaults but can be specified:
        // date: 'today',
        // timezone: 'America/Chicago',
        // adult: false,
        );

    final event = events.events[0];
    print("Today is ${event.name}! Find more information at: ${event.url}.");
    print(
        "Rate limit remaining: ${events.rateLimit.remainingMonth}/${events.rateLimit.limitMonth} (month).");

    // Get Event Information
    final eventInfo = await client.getEventInfo(
      id: event.id,
      // These parameters can be specified to calculate the range of eventInfo.event.occurrences
      // start: 2020,
      // end: 2030,
    );

    print("The Event's hashtags are ${eventInfo.event.hashtags}.");

    // Search for Events
    final query = 'zucchini';
    final search = await client.search(
      query: query,
      // These parameters are the defaults but can be specified:
      // adult: false,
    );

    print(
        "Found ${search.events.length} events, including '${search.events[0].name}', that match the query '$query'.");
  } catch (e) {
    print(e);
  }
}

```

## License

The Holiday and Event API is made available under the MIT License (MIT). Please see the [License File](LICENSE) for more information.
