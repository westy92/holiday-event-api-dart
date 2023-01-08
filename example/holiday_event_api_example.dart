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
