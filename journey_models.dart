enum JourneyStatus {
  discovered,
  savedToItinerary,
  visitConfirmed;

  static JourneyStatus fromString(String? value) {
    switch (value) {
      case 'savedToItinerary':
      case 'saved_to_itinerary':
        return JourneyStatus.savedToItinerary;
      case 'visitConfirmed':
      case 'visit_confirmed':
        return JourneyStatus.visitConfirmed;
      default:
        return JourneyStatus.discovered;
    }
  }

  String get label {
    switch (this) {
      case JourneyStatus.discovered:
        return 'Discovered';
      case JourneyStatus.savedToItinerary:
        return 'Saved to itinerary';
      case JourneyStatus.visitConfirmed:
        return 'Visit confirmed';
    }
  }
}

class VenueInfo {
  final String name;
  final String hostName;
  final String city;
  final String summary;
  final String communityHighlight;
  final List<String> unverifiedItems;

  const VenueInfo({
    required this.name,
    required this.hostName,
    required this.city,
    required this.summary,
    required this.communityHighlight,
    this.unverifiedItems = const [],
  });

  factory VenueInfo.fromJson(Map<String, dynamic> json) => VenueInfo(
        name: (json['name'] ?? '') as String,
        hostName: (json['hostName'] ?? json['host_name'] ?? '') as String,
        city: (json['city'] ?? '') as String,
        summary: (json['summary'] ?? '') as String,
        communityHighlight: (json['communityHighlight'] ??
            json['community_highlight'] ??
            '') as String,
        unverifiedItems: ((json['unverifiedItems'] ??
                    json['unverified_items'] ??
                    const <dynamic>[]) as List)
            .map((e) => e.toString())
            .toList(),
      );
}

class DiasporaJourney {
  final String journeyId;
  final String travellerName;
  final String originRegion;
  final String discoverySource;
  final String referralNote;
  final String targetWindow;
  final String? plannedDate;
  final int? partySize;
  final String? itineraryNotes;
  final JourneyStatus status;
  final String? confirmedAt;
  final String? staffNote;

  const DiasporaJourney({
    required this.journeyId,
    required this.travellerName,
    required this.originRegion,
    required this.discoverySource,
    required this.referralNote,
    required this.targetWindow,
    this.plannedDate,
    this.partySize,
    this.itineraryNotes,
    required this.status,
    this.confirmedAt,
    this.staffNote,
  });

  factory DiasporaJourney.fromJson(Map<String, dynamic> json) {
    String? s(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v != null) return v.toString();
      }
      return null;
    }

    return DiasporaJourney(
      journeyId: s(['journeyId', 'journey_id']) ?? '',
      travellerName: s(['travellerName', 'traveller_name']) ?? '',
      originRegion: s(['originRegion', 'origin_region']) ?? '',
      discoverySource: s(['discoverySource', 'discovery_source']) ?? '',
      referralNote: s(['referralNote', 'referral_note']) ?? '',
      targetWindow: s(['targetWindow', 'target_window']) ?? '',
      plannedDate: s(['plannedDate', 'planned_date']),
      partySize: int.tryParse(s(['partySize', 'party_size']) ?? ''),
      itineraryNotes: s(['itineraryNotes', 'itinerary_notes']),
      status: JourneyStatus.fromString(s(['status'])),
      confirmedAt: s(['confirmedAt', 'confirmed_at']),
      staffNote: s(['staffNote', 'staff_note']),
    );
  }
}