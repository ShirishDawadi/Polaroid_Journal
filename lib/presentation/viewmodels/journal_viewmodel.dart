import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'journal_state.dart';

class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    return JournalState(layers: []);
  }

  void addLayer(LayerModel newLayer) {
    state = state.copyWith(
      layers: [...state.layers, newLayer],
    );
  }

  void updateLayer(LayerModel updatedLayer) {
    state = state.copyWith(
      layers: state.layers.map((layer) {
        return layer.id == updatedLayer.id ? updatedLayer : layer;
      }).toList(),
    );
  }
}

final journalProvider = NotifierProvider<JournalNotifier, JournalState>(
  JournalNotifier.new,
);