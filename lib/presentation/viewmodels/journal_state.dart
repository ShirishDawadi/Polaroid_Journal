import '../../data/models/layer_model.dart';

class JournalState {
  final List<LayerModel> layers;

  // We use "final" because in professional MVVM, 
  // we don't "change" data, we "replace" it with a new version.
  JournalState({required this.layers});

  // This helper makes it easy to update the list later
  JournalState copyWith({List<LayerModel>? layers}) {
    return JournalState(
      layers: layers ?? this.layers,
    );
  }
}