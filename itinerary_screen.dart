import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journey_models.dart';
import '../providers/journey_provider.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JourneyProvider>();
    final journey = p.activeJourney;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              initialValue: journey.journeyId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Journey'),
              items: [
                for (final j in p.journeys)
                  DropdownMenuItem(
                    value: j.journeyId,
                    child: Text('${j.journeyId} · ${j.travellerName}'),
                  ),
              ],
              onChanged: (id) {
                if (id != null) context.read<JourneyProvider>().selectJourney(id);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(journey.travellerName, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${journey.originRegion} · ${journey.targetWindow}'),
                const SizedBox(height: 8),
                Chip(label: Text(journey.status.label)),
                if (journey.referralNote.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(journey.referralNote),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Keyed so the form re-initialises when another journey is selected.
        _ItineraryForm(key: ValueKey(journey.journeyId), journey: journey),
      ],
    );
  }
}

class _ItineraryForm extends StatefulWidget {
  final DiasporaJourney journey;
  const _ItineraryForm({super.key, required this.journey});

  @override
  State<_ItineraryForm> createState() => _ItineraryFormState();
}

class _ItineraryFormState extends State<_ItineraryForm> {
  late final TextEditingController _dateCtrl;
  late final TextEditingController _notesCtrl;
  late int _partySize;

  @override
  void initState() {
    super.initState();
    _dateCtrl = TextEditingController(text: widget.journey.plannedDate ?? '');
    _notesCtrl = TextEditingController(text: widget.journey.itineraryNotes ?? '');
    _partySize = widget.journey.partySize ?? 1;
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_dateCtrl.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _dateCtrl.text = _fmt(picked));
  }

  Future<void> _save() async {
    if (_dateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick a planned date first')));
      return;
    }
    final provider = context.read<JourneyProvider>();
    final messenger = ScaffoldMessenger.of(context);
    await provider.saveToItinerary(
      plannedDate: _dateCtrl.text,
      partySize: _partySize,
      itineraryNotes: _notesCtrl.text.trim(),
    );
    messenger.showSnackBar(const SnackBar(content: Text('Saved to itinerary')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Itinerary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _dateCtrl,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Planned date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Party size'),
                const Spacer(),
                IconButton(
                  onPressed:
                      _partySize > 1 ? () => setState(() => _partySize--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_partySize'),
                IconButton(
                  onPressed: () => setState(() => _partySize++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.bookmark_add),
              label: const Text('Save to itinerary'),
            ),
          ],
        ),
      ),
    );
  }
}
