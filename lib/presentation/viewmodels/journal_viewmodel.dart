import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/layer_model.dart'; // Check this name
import 'journal_state.dart';

class JournalNotifier extends Notifier<JournalState> {
  
  @override
  JournalState build() {
    // Start with an empty list of layers
    return JournalState(layers: []);
  }

  // This is how we will add layers from now on
  void addLayer(LayerModel newLayer) {
    state = state.copyWith(
      layers: [...state.layers, newLayer],
    );
  }
}

// This is the global "address" your UI is looking for
final journalProvider = NotifierProvider<JournalNotifier, JournalState>(
  JournalNotifier.new,
);