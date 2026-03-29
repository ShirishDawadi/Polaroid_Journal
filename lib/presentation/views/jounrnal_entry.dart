import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/core/utils/tools_enum.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/stickers_bottom_sheet.dart';
import 'package:polaroid_journal/presentation/views/journal_canvas.dart';
import 'package:polaroid_journal/presentation/views/journal_toolbar.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  LayerModel? focusedLayer;

  Color currentTextColor = Colors.black;
  Color currentBrushColor = Colors.black;
  Color? currentColor = Colors.black;
  bool isIgnoring = true;

  bool isErasing = false;
  double strokeWidth = 3;

  bool isOpen = false;
  Tool? selectedTool;
  SubTool? selectedSubTool;

  bool _isPickingImage = false;

  bool _isExporting = false;

  // ─── Layer actions ────────────────────────────────────────────────────────

  void _onPhotoFocused(LayerModel layer) {
    setState(() {
      _bringToTop(layer);
      if (selectedTool != Tool.draw) focusedLayer = layer;
      if (selectedTool != Tool.image) selectedTool = Tool.image;
    });
  }

  void _onTextFocused(LayerModel layer) {
    setState(() {
      _bringToTop(layer);
      if (selectedTool != Tool.draw) focusedLayer = layer;
      if (selectedTool != Tool.text) selectedTool = Tool.text;
    });
  }

  void _onLayerRemoved(LayerModel layer) {
    ref.read(journalProvider.notifier).removeLayer(layer.id);
    setState(() => focusedLayer = null);
  }

  void _onLayerUpdated(LayerModel updatedLayer) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(journalProvider.notifier).updateLayer(updatedLayer);
      setState(() => focusedLayer = updatedLayer);
    });
  }

  void _bringToTop(LayerModel layer) {
    final layers = ref.read(journalProvider).layers;
    if (layers.last != layer) {
      ref.read(journalProvider.notifier).reorderToTop(layer.id);
    }
  }

  // ─── Image picking ────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) {
      _isPickingImage = false;
      return;
    }

    if (selectedSubTool == SubTool.photo) {
      final layer = LayerModel(
        id: UniqueKey().toString(),
        type: LayerType.photo,
        image: FileImage(File(picked.path)),
      );
      setState(() {
        focusedLayer = layer;
        ref.read(journalProvider.notifier).addLayer(layer);
      });
    }

    if (selectedSubTool == SubTool.wallpaper) {
      ref
          .read(journalProvider.notifier)
          .setBackgroundImage(FileImage(File(picked.path)));
    }

    _isPickingImage = false;
  }

  // ─── Text ─────────────────────────────────────────────────────────────────

  void _addTextField() {
    final layer = LayerModel(
      id: UniqueKey().toString(),
      type: LayerType.text,
      text: '',
    );
    setState(() {
      focusedLayer = layer;
      ref.read(journalProvider.notifier).addLayer(layer);
    });
  }

  // ─── Color ────────────────────────────────────────────────────────────────

  void _changeColor(Color? color) {
    if (color != null) {
      if (selectedTool == Tool.draw) currentBrushColor = color;
      if (selectedTool == Tool.text) {
        currentTextColor = color;
        ref
            .read(journalProvider.notifier)
            .updateLayer(focusedLayer!.copyWith(textColor: color));
        setState(() {
          focusedLayer = ref
              .read(journalProvider)
              .layers
              .firstWhere((l) => l.id == focusedLayer!.id);
        });
      }
    }
    if (selectedTool == Tool.background) {
      if (selectedSubTool == SubTool.secondaryBackgroundColor) {
        ref.read(journalProvider.notifier).setSecondaryColor(color);
      } else {
        ref.read(journalProvider.notifier).setPrimaryColor(color);
      }
    }
    setState(() => currentColor = color);
  }

  // ─── Font ─────────────────────────────────────────────────────────────────

  void _changeFont(String font) {
    ref
        .read(journalProvider.notifier)
        .updateLayer(focusedLayer!.copyWith(fontFamily: font));
    setState(() {
      focusedLayer = ref
          .read(journalProvider)
          .layers
          .firstWhere((l) => l.id == focusedLayer!.id);
    });
  }

  // ─── Stickers ─────────────────────────────────────────────────────────────

  void _openStickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return StickersBottomSheet(
          onSelect: (sticker) {
            Navigator.pop(context);
            final layer = LayerModel(
              id: UniqueKey().toString(),
              type: LayerType.photo,
              image: AssetImage(sticker),
            );
            FocusScope.of(context).unfocus();
            setState(() {
              focusedLayer = layer;
              ref.read(journalProvider.notifier).addLayer(layer);
            });
          },
        );
      },
    );
  }

  // ─── Tool selection ───────────────────────────────────────────────────────

  void _onCanvasTapped() {
    FocusScope.of(context).unfocus();
    if (selectedTool != Tool.draw) {
      setState(() {
        selectedTool = null;
        selectedSubTool = null;
        focusedLayer = null;
      });
    }
  }

  void _onSubToolSelected(SubTool selected) async {
    setState(() {
      selectedSubTool = selected;
      if (selected == SubTool.erase) isErasing = !isErasing;
      if (selected == SubTool.secondaryBackgroundColor) {
        currentColor = ref.read(journalProvider).background.secondaryColor;
      }
      if (selected == SubTool.primaryBackgroundColor) {
        currentColor = ref.read(journalProvider).background.primaryColor;
      }
      if (selected == SubTool.add) {
        final l = LayerModel(
          id: UniqueKey().toString(),
          type: LayerType.drawing,
          whiteBoardController: WhiteBoardController(),
        );
        ref.read(journalProvider.notifier).addLayer(l);
        focusedLayer = l;
      }
    });
    if (selected == SubTool.photo) await _pickImage();
    if (selected == SubTool.sticker) _openStickerSheet();
  }

  void _onToolSelected(Tool tool) async {
    setState(() {
      isOpen = false;
      selectedTool = tool;
      if (tool == Tool.draw) {
        isIgnoring = false;
        final layers = ref.read(journalProvider).layers;
        final drawingLayer = layers.lastWhere(
          (l) => l.type == LayerType.drawing,
          orElse: () {
            final l = LayerModel(
              id: UniqueKey().toString(),
              type: LayerType.drawing,
              whiteBoardController: WhiteBoardController(),
            );
            ref.read(journalProvider.notifier).addLayer(l);
            return l;
          },
        );
        focusedLayer = drawingLayer;
      } else {
        isIgnoring = true;
      }
      if (tool == Tool.text) currentColor = currentTextColor;
      if (tool == Tool.background) {
        currentColor = ref.read(journalProvider).background.primaryColor;
      }
    });
    if (tool == Tool.text) _addTextField();
  }


  void _changeStrokeWidth(double width){
    setState(() => strokeWidth = width);
  }
  //  ─── Export ────────────────────────────────────────────────────────────────

  Future<void> _exportCanvas() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Exporting...")));
    }

    try {
      final boundary =
          _canvasKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      await Gal.putImageBytes(pngBytes);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved to gallery")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Export failed")));
    }

    if (mounted) setState(() => _isExporting = false);
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Journal Entry"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportCanvas,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: RepaintBoundary(
          key: _canvasKey,
          child: JournalCanvas(
            focusedLayer: focusedLayer,
            selectedTool: selectedTool,
            isOpen: isOpen,
            isIgnoring: isIgnoring,
            currentBrushColor: currentBrushColor,
            strokeWidth: strokeWidth,
            isErasing: isErasing,
            onCanvasTapped: _onCanvasTapped,
            onPhotoFocused: _onPhotoFocused,
            onTextFocused: _onTextFocused,
            onLayerRemoved: _onLayerRemoved,
            onDismissOverlay: () => setState(() => isOpen = false),
          ),
        ),
      ),
      floatingActionButton: JournalToolbar(
        focusedLayer: focusedLayer,
        selectedTool: selectedTool,
        selectedSubTool: selectedSubTool,
        isOpen: isOpen,
        strokeWidth: strokeWidth,
        currentColor: currentColor,
        currentBrushColor: currentBrushColor,
        onToolSelected: _onToolSelected,
        onSubToolSelected: _onSubToolSelected,
        onLayerUpdated: _onLayerUpdated,
        onColorChanged: _changeColor,
        onFontChanged: _changeFont,
        onStrokeWidthChanged: _changeStrokeWidth,
        onToggle: () => setState(() {
          selectedSubTool = null;
          isOpen = !isOpen;
        }),
        pickImage: _pickImage,
      ),
    );
  }
}
