import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/journey_provider.dart';
import '../widgets/food_gallery.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  static const _regions = ['UK', 'North America', 'Europe', 'Africa', 'Other'];
  static const _sources = [
    'Diaspora Friend Referral',
    'Social Media',
    'Search Engine',
    'Community Event',
    'Other',
  ];
  static const _windows = [
    'December in Ghana',
    'Easter',
    'Summer',
    'Flexible',
  ];

  final _nameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _region = _regions.first;
  String _source = _sources.first;
  String _window = _windows.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final provider = context.read<JourneyProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.createJourney(
      travellerName: _nameCtrl.text,
      originRegion: _region,
      discoverySource: _source,
      referralNote: _noteCtrl.text,
      targetWindow: _window,
    );
    if (!mounted) return;
    if (!ok) {
      messenger.showSnackBar(
          SnackBar(content: Text(provider.statusMessage ?? 'Could not start journey')));
      return;
    }
    _nameCtrl.clear();
    _noteCtrl.clear();
    messenger.showSnackBar(
      SnackBar(content: Text('Journey ${provider.activeJourney.journeyId} started')),
    );
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
      ],
      onChanged: (v) {
        if (v != null) setState(() => onChanged(v));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JourneyProvider>();
    final v = p.venue;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text('Hosted by ${v.hostName} · ${v.city}'),
                const SizedBox(height: 12),
                Text(v.summary),
                const SizedBox(height: 12),
                Text(v.communityHighlight,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                if (v.unverifiedItems.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('To be confirmed with venue',
                      style: theme.textTheme.labelLarge),
                  for (final item in v.unverifiedItems) Text('• $item'),
                ],
                if (p.statusMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(p.statusMessage!, style: theme.textTheme.bodySmall),
                ],
                if (p.isLoading) ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const FoodGallery(),
        const SizedBox(height: 16),
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Plan your visit', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Your name'),
                ),
                const SizedBox(height: 12),
                _dropdown('Travelling from', _region, _regions,
                    (x) => _region = x),
                const SizedBox(height: 12),
                _dropdown('How did you find us?', _source, _sources,
                    (x) => _source = x),
                const SizedBox(height: 12),
                _dropdown('When are you visiting?', _window, _windows,
                    (x) => _window = x),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Referral note (optional)'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.flight_land),
                  label: const Text('Start my journey'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}