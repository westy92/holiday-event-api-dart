import 'package:holiday_event_api/src/model/rate_limit.dart';

/// The API's standard response
abstract class StandardResponse {
  const StandardResponse(
    this.rateLimit,
  );

  /// The API plan's current rate limit and status
  final RateLimit rateLimit;
}
