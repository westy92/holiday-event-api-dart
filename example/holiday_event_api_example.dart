import 'package:holiday_event_api/holiday_event_api.dart';

void main() async {
  try {
    // Get a FREE API key from https://apilayer.com/marketplace/checkiday-api#pricing
    final client = HolidayEventApi('<your API key>');

    // Get Events for a given Date
    var events = await client.getEvents(
        // These parameters are the defaults but can be specified:
        // date: 'today',
        // timezone: 'America/Chicago',
        // adult: false,
        );

    print(events);
//    var event = events['events'][0];
    //  print("Today is ${event.name}! Find more information at: ${event.url}.");
    //print("Rate limit remaining: ${events.rateLimit.remainingMonth}/${events.rateLimit.limitMonth} (month).");
/*
    // Get Event Information
    val eventInfo = client.getEventInfo(
        id = event.id,
        // These parameters can be specified to calculate the range of eventInfo.Event.Occurrences
        // start = 2020,
        // end = 2030,
    )

    println("The Event's hashtags are ${eventInfo.event.hashtags}.")

    // Search for Events
    val query = "zucchini"
    val search = client.search(
        query = query,
        // These parameters are the defaults but can be specified:
        // adult = false,
    )

    println("Found ${search.events.size} events, including '${search.events[0].name}', that match the query '${query}'.")*/
  } catch (e) {
    print(e);
  }
}
