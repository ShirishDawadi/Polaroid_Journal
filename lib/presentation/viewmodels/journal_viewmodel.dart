import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'journal_state.dart';

class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    return const JournalState(layers: []);
  }

  // ─── Layer operations ─────────────────────────────────────────────────────

  void addLayer(LayerModel newLayer) {
    state = state.copyWith(layers: [...state.layers, newLayer]);
  }

  void updateLayer(LayerModel updatedLayer) {
    state = state.copyWith(
      layers: state.layers
          .map((l) => l.id == updatedLayer.id ? updatedLayer : l)
          .toList(),
    );
  }

  void removeLayer(String id) {
    state = state.copyWith(
      layers: state.layers.where((l) => l.id != id).toList(),
    );
  }

  void reorderToTop(String id) {
    final layer = state.layers.firstWhere((l) => l.id == id);
    final rest = state.layers.where((l) => l.id != id).toList();
    state = state.copyWith(layers: [...rest, layer]);
  }

  // ─── Background operations ────────────────────────────────────────────────

  void updateBackground(BackgroundConfig config) {
    state = state.copyWith(background: config);
  }

  void setPrimaryColor(Color? color) {
    state = state.copyWith(
      background: state.background.copyWith(primaryColor: color),
    );
  }

  void setSecondaryColor(Color? color) {
    state = state.copyWith(
      background: color == null
          ? state.background.copyWith(clearSecondaryColor: true)
          : state.background.copyWith(secondaryColor: color),
    );
  }

  void setBackgroundImage(ImageProvider? image) {
    state = state.copyWith(
      background: image == null
          ? state.background.copyWith(clearImage: true)
          : state.background.copyWith(image: image),
    );
  }

  void setOpacity(double opacity) {
    state = state.copyWith(
      background: state.background.copyWith(opacity: opacity),
    );
  }

  void setBlur(double blur) {
    state = state.copyWith(
      background: state.background.copyWith(blur: blur),
    );
  }
}

final journalProvider = NotifierProvider<JournalNotifier, JournalState>(
  JournalNotifier.new,
);