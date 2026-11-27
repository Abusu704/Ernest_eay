import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journey_models.dart';
import '../providers/journey_provider.dart';

class StaffCheckinScreen extends StatefulWidget {
  const StaffCheckinScreen({super.key});

  @override
  State<StaffCheckinScreen> createState() => _StaffCheckinScreenState();
}

class _StaffCheckinScreenState extends State<StaffCheckinScreen> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final provider = context.read<JourneyProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.confirmVisit(staffNote: _noteCtrl.text);
    if (!mounted) return;
    if (ok) _noteCtrl.clear();
    messenger.showSnackBar(SnackBar(
        content: Text(ok ? 'Visit confirmed' : (provider.statusMessage ?? 'Could not confirm'))));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JourneyProvider>();
    final j = p.activeJourney;
    final confirmed = j.status == JourneyStatus.visitConfirmed;
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
                Text('Final check-in', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text('${j.journeyId} · ${j.travellerName}',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Planned: ${j.plannedDate ?? 'not set'}'
                    ' · Party: ${j.partySize ?? '-'}'),
                if ((j.itineraryNotes ?? '').isNotEmpty)
                  Text('Notes: ${j.itineraryNotes}'),
                const SizedBox(height: 8),
                Chip(label: Text(j.status.label)),
                if (confirmed) ...[
                  const SizedBox(height: 8),
                  Text('Confirmed on ${j.confirmedAt ?? '-'}'),
                  if ((j.staffNote ?? '').isNotEmpty) Text(j.staffNote!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!confirmed)
          Card(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    decoration:
                        const InputDecoration(labelText: 'Additional note (optional)'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _confirm,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Confirm visit'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}