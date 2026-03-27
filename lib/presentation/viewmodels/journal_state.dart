import 'package:flutter/material.dart';
import '../../data/models/layer_model.dart';

class BackgroundConfig {
  final Color? primaryColor;
  final Color? secondaryColor;
  final ImageProvider? image;
  final double opacity;
  final double blur;

  const BackgroundConfig({
    this.primaryColor = Colors.white,
    this.secondaryColor,
    this.image,
    this.opacity = 1.0,
    this.blur = 0.0,
  });

  BackgroundConfig copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    ImageProvider? image,
    double? opacity,
    double? blur,
    bool clearImage = false,
    bool clearSecondaryColor = false,
  }) {
    return BackgroundConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: clearSecondaryColor ? null : secondaryColor ?? this.secondaryColor,
      image: clearImage ? null : image ?? this.image,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
    );
  }
}

class JournalState {
  final List<LayerModel> layers;
  final BackgroundConfig background;

  const JournalState({
    required this.layers,
    this.background = const BackgroundConfig(),
  });

  JournalState copyWith({
    List<LayerModel>? layers,
    BackgroundConfig? background,
  }) {
    return JournalState(
      layers: layers ?? this.layers,
      background: background ?? this.background,
    );
  }
}