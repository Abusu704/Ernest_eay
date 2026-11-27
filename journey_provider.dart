import 'package:flutter/foundation.dart';
import '../models/journey_models.dart';
import '../services/api_client.dart';

class JourneyProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  // VENUE INFORMATION
  VenueInfo _venue = const VenueInfo(
    name: 'De Klinic Food Corner',
    hostName: 'Portia Boateng',
    city: 'Accra, Ghana',
    summary:
        'Local food and pub experience welcoming diaspora travellers in the UK, North America, Europe, and across Africa planning visits to Accra.',
    communityHighlight:
        'Community hospitality — including meals bought by a supporter for five followers.',
    unverifiedItems: [
      'Current menu & live prices (to be confirmed with venue)',
      'Delivery coverage & radius (to be confirmed with venue)',
      'Group booking & event terms (to be confirmed with venue)',
    ],
  );

  // INITIAL JOURNEYS
  List<DiasporaJourney> _journeys = [
    const DiasporaJourney(
      journeyId: 'DK-DEC-101',
      travellerName: 'Kwame Mensah',
      originRegion: 'UK',
      discoverySource: 'Diaspora Friend Referral',
      referralNote:
          'Recommended by cousin in Accra ahead of December trip',
      targetWindow: 'December in Ghana',
      plannedDate: '2026-12-27',
      partySize: 4,
      itineraryNotes:
          'Evening local food & pub stop with friends flying in',
      status: JourneyStatus.savedToItinerary,
    ),
  ];

  // STATE VARIABLES
  String _activeJourneyId = 'DK-DEC-101';

  int _localIdCounter = 102;

  bool _isLoading = false;

  String? _statusMessage;

  // GETTERS
  VenueInfo get venue => _venue;

  List<DiasporaJourney> get journeys =>
      List.unmodifiable(_journeys);

  bool get isLoading => _isLoading;

  String? get statusMessage => _statusMessage;

  DiasporaJourney get activeJourney => _journeys.firstWhere(
        (j) => j.journeyId == _activeJourneyId,
        orElse: () => _journeys.first,
      );

  // SELECT JOURNEY
  void selectJourney(String id) {
    if (!_journeys.any((j) => j.journeyId == id)) {
      return;
    }

    _activeJourneyId = id;
    notifyListeners();
  }

  // SYNC WITH BACKEND
  Future<void> syncFromBackend() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedVenue = await _api.fetchVenue();

      final fetchedJourneys = await _api.fetchJourneys();

      _venue = fetchedVenue;

      if (fetchedJourneys.isNotEmpty) {
        _journeys = List<DiasporaJourney>.of(fetchedJourneys);

        if (!_journeys.any(
          (j) => j.journeyId == _activeJourneyId,
        )) {
          _activeJourneyId = _journeys.first.journeyId;
        }
      }

      _statusMessage = 'Synced with API';

    } catch (e) {
      debugPrint('Backend sync error: $e');

      _statusMessage = 'Offline/local demo mode active';

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE NEW JOURNEY
  Future<bool> createJourney({
    required String travellerName,
    required String originRegion,
    required String discoverySource,
    required String referralNote,
    required String targetWindow,
  }) async {
    final cleanName = travellerName.trim().isEmpty
        ? 'Diaspora Guest'
        : travellerName.trim();

    final cleanNote = referralNote.trim().isEmpty
        ? 'Discovered ahead of trip to Accra'
        : referralNote.trim();

    try {
      final created = await _api.startJourney(
        travellerName: cleanName,
        originRegion: originRegion,
        discoverySource: discoverySource,
        referralNote: cleanNote,
        targetWindow: targetWindow,
      );

      _journeys.insert(0, created);

      _activeJourneyId = created.journeyId;

      _statusMessage = 'Journey created successfully';

    } catch (e) {
      debugPrint('Create journey error: $e');

      // OFFLINE FALLBACK
      final fallback = DiasporaJourney(
        journeyId: 'DK-${_localIdCounter++}',
        travellerName: cleanName,
        originRegion: originRegion,
        discoverySource: discoverySource,
        referralNote: cleanNote,
        targetWindow: targetWindow,
        status: JourneyStatus.discovered,
      );

      _journeys.insert(0, fallback);

      _activeJourneyId = fallback.journeyId;

      _statusMessage = 'Journey created locally';
    }

    notifyListeners();

    return true;
  }

  // SAVE JOURNEY TO ITINERARY
  Future<bool> saveToItinerary({
    required String plannedDate,
    required int partySize,
    required String itineraryNotes,
  }) async {
    final current = activeJourney;

    try {
      final updated = await _api.saveItinerary(
        journeyId: current.journeyId,
        plannedDate: plannedDate,
        partySize: partySize,
        itineraryNotes: itineraryNotes,
      );

      _replaceJourney(updated);

      _statusMessage = 'Itinerary saved successfully';

    } catch (e) {
      debugPrint('Save itinerary error: $e');

      // OFFLINE FALLBACK
      _replaceJourney(
        DiasporaJourney(
          journeyId: current.journeyId,
          travellerName: current.travellerName,
          originRegion: current.originRegion,
          discoverySource: current.discoverySource,
          referralNote: current.referralNote,
          targetWindow: current.targetWindow,
          plannedDate: plannedDate,
          partySize: partySize,
          itineraryNotes: itineraryNotes,
          status: current.status == JourneyStatus.visitConfirmed
              ? JourneyStatus.visitConfirmed
              : JourneyStatus.savedToItinerary,
          confirmedAt: current.confirmedAt,
          staffNote: current.staffNote,
        ),
      );

      _statusMessage = 'Itinerary saved locally';
    }

    notifyListeners();

    return true;
  }

  // CONFIRM VISIT
  Future<bool> confirmVisit({String? staffNote}) async {
    final current = activeJourney;

    try {
      final updated = await _api.confirmVisit(
        journeyId: current.journeyId,
        staffNote: staffNote,
      );

      _replaceJourney(updated);

      _statusMessage = 'Visit confirmed successfully';

    } catch (e) {
      debugPrint('Confirm visit error: $e');

      // OFFLINE FALLBACK
      _replaceJourney(
        DiasporaJourney(
          journeyId: current.journeyId,
          travellerName: current.travellerName,
          originRegion: current.originRegion,
          discoverySource: current.discoverySource,
          referralNote: current.referralNote,
          targetWindow: current.targetWindow,
          plannedDate: current.plannedDate,
          partySize: current.partySize,
          itineraryNotes: current.itineraryNotes,
          status: JourneyStatus.visitConfirmed,
          confirmedAt: current.confirmedAt ??
              DateTime.now().toIso8601String().split('T').first,
          staffNote: (staffNote == null ||
                  staffNote.trim().isEmpty)
              ? 'Arrived in Accra & confirmed by venue staff'
              : staffNote.trim(),
        ),
      );

      _statusMessage = 'Visit confirmed locally';
    }

    notifyListeners();

    return true;
  }

  // REPLACE EXISTING JOURNEY
  void _replaceJourney(DiasporaJourney updated) {
    final idx = _journeys.indexWhere(
      (j) => j.journeyId == updated.journeyId,
    );

    if (idx != -1) {
      _journeys[idx] = updated;
    }
  }
}