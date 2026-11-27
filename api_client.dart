import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/journey_models.dart';

/// The server answered with an error (as opposed to being unreachable).
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

/// Thin REST client for the FastAPI backend in /backend.
///
/// Base URL: `--dart-define=API_BASE_URL=...`, otherwise the Android emulator
/// uses 10.0.2.2 and everything else uses localhost. Staff key:
/// `--dart-define=STAFF_KEY=...` (must match the server's STAFF_KEY).
class ApiClient {
  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const String staffKey =
      String.fromEnvironment('STAFF_KEY', defaultValue: 'deklinic-staff');
  static const Duration _timeout = Duration(seconds: 8);

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  final http.Client _http;

  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  Uri _uri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  Map<String, String> get _headers => const {'Content-Type': 'application/json'};

  dynamic _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      var msg = 'Server error (${res.statusCode})';
      try {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        if (body is Map && body['detail'] is String) {
          msg = body['detail'] as String;
        } else if (res.statusCode == 422) {
          msg = 'Please check the details you entered';
        }
      } catch (_) {}
      throw ApiException(res.statusCode, msg);
    }
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  Future<VenueInfo> fetchVenue() async {
    final res = await _http.get(_uri('/venue')).timeout(_timeout);
    return VenueInfo.fromJson(_decode(res) as Map<String, dynamic>);
  }

  Future<List<DiasporaJourney>> fetchJourneys() async {
    final res = await _http.get(_uri('/journeys')).timeout(_timeout);
    final data = _decode(res) as List;
    return data
        .map((e) => DiasporaJourney.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DiasporaJourney> startJourney({
    required String travellerName,
    required String originRegion,
    required String discoverySource,
    required String referralNote,
    required String targetWindow,
  }) async {
    final res = await _http
        .post(
          _uri('/journeys'),
          headers: _headers,
          body: jsonEncode({
            'travellerName': travellerName,
            'originRegion': originRegion,
            'discoverySource': discoverySource,
            'referralNote': referralNote,
            'targetWindow': targetWindow,
          }),
        )
        .timeout(_timeout);
    return DiasporaJourney.fromJson(_decode(res) as Map<String, dynamic>);
  }

  Future<DiasporaJourney> saveItinerary({
    required String journeyId,
    required String plannedDate,
    required int partySize,
    required String itineraryNotes,
  }) async {
    final res = await _http
        .put(
          _uri('/journeys/$journeyId/itinerary'),
          headers: _headers,
          body: jsonEncode({
            'plannedDate': plannedDate,
            'partySize': partySize,
            'itineraryNotes': itineraryNotes,
          }),
        )
        .timeout(_timeout);
    return DiasporaJourney.fromJson(_decode(res) as Map<String, dynamic>);
  }

  Future<DiasporaJourney> confirmVisit({
    required String journeyId,
    String? staffNote,
  }) async {
    final res = await _http
        .post(
          _uri('/journeys/$journeyId/confirm'),
          headers: {..._headers, 'X-Staff-Key': staffKey},
          body: jsonEncode({'staffNote': staffNote}),
        )
        .timeout(_timeout);
    return DiasporaJourney.fromJson(_decode(res) as Map<String, dynamic>);
  }
}