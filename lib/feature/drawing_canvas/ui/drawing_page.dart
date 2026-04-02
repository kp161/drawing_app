import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_page_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/sections/canvas_section.dart';
import 'package:drawing_app/feature/drawing_canvas/sections/brush_bottom_sheet.dart';
import 'package:drawing_app/feature/drawing_canvas/sections/shape_bottom_sheet.dart';
import 'package:drawing_app/feature/drawing_canvas/services/image_saver_service.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/bottom_toolbar.dart';
import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/drawing_actions.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/drawing_tools.dart';
import 'package:drawing_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';

class DrawingPage extends StatefulWidget {
  final ImageProvider? backgroundImage;

  const DrawingPage({super.key, this.backgroundImage});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late final ColorSelectionController _colorController;
  late final DrawingController _drawingController;
  late final DrawingPageController _controller;

  final GlobalKey _canvasKey = GlobalKey();
  late final ValueNotifier<DrawingToolType> _selectedToolNotifier;
  late final ValueNotifier<double> _strokeWidthNotifier;
  late final ValueNotifier<BrushStyleType> _brushStyleNotifier;
  late final ValueNotifier<double> _opacityNotifier;
  late final ValueNotifier<ShapeType> _shapeTypeNotifier;
  late final ValueNotifier<bool> _shapeFilledNotifier;
  late final ValueNotifier<double> _shapeStrokeWidthNotifier;

  @override
  void initState() {
    super.initState();
    _colorController = ColorSelectionController();
    _drawingController = DrawingController();
    _controller = DrawingPageController(_colorController, _drawingController);
    _selectedToolNotifier = ValueNotifier<DrawingToolType>(_controller.selectedTool);
    _strokeWidthNotifier = ValueNotifier<double>(_controller.strokeWidth);
    _brushStyleNotifier = ValueNotifier<BrushStyleType>(_controller.brushStyle);
    _opacityNotifier = ValueNotifier<double>(_controller.opacity);
    _shapeTypeNotifier = ValueNotifier<ShapeType>(_controller.shapeType);
    _shapeFilledNotifier = ValueNotifier<bool>(_controller.shapeFilled);
    _shapeStrokeWidthNotifier = ValueNotifier<double>(_controller.shapeStrokeWidth);
  }

  @override
  void dispose() {
    _selectedToolNotifier.dispose();
    _strokeWidthNotifier.dispose();
    _brushStyleNotifier.dispose();
    _opacityNotifier.dispose();
    _shapeTypeNotifier.dispose();
    _shapeFilledNotifier.dispose();
    _shapeStrokeWidthNotifier.dispose();
    _colorController.dispose();
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: const CustomLogo(),
        actions: [
          DrawingActionButton(
            icon: 'assets/icons/undo.svg',
            onTap: () => _drawingController.undo(),
          ),
          DrawingActionButton(
            icon: 'assets/icons/redo.svg',
            onTap: () => _drawingController.redo(),
          ),
          DrawingActionButton(
            icon: 'assets/icons/upload.svg',
            onTap: () => ImageSaverService.save(_canvasKey, context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;

          return Flex(
            direction: isLandscape ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                child: RepaintBoundary(
                  key: _canvasKey,
                  child: CanvasSection(
                    drawingController: _drawingController,
                    colorController: _colorController,
                    backgroundImage: widget.backgroundImage,
                    onPanStart: _controller.onPanStart,
                    onPanUpdate: (p, _) => _controller.onPanUpdate(p),
                    onPanEnd: _controller.onPanEnd,
                  ),
                ),
              ),
              SizedBox(
                width: isLandscape ? 130 : double.infinity,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _selectedToolNotifier,
                    _strokeWidthNotifier,
                  ]),
                  builder: (context, _) {
                    return BottomToolbar(
                      bottomInset: isLandscape
                          ? 0
                          : MediaQuery.of(context).padding.bottom,
                      selectedTool: _selectedToolNotifier.value,
                      onToolSelected: (tool) {
                        _selectedToolNotifier.value = tool;
                        _controller.selectedTool = tool;
                        _handleToolSelection(tool);
                      },
                      strokeWidth: _strokeWidthNotifier.value,
                      onStrokeWidthChanged: (v) {
                        _strokeWidthNotifier.value = v;
                        _controller.strokeWidth = v;
                      },
                      colorController: _colorController,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleToolSelection(DrawingToolType tool) {
    if (tool == DrawingToolType.brush) {
      showBrushBottomSheet(
        context: context,
        selectedStyle: _brushStyleNotifier.value,
        strokeWidth: _strokeWidthNotifier.value,
        opacity: _opacityNotifier.value,
        onStyleChanged: (s) {
          _brushStyleNotifier.value = s;
          _controller.brushStyle = s;
        },
        onStrokeWidthChanged: (v) {
          _strokeWidthNotifier.value = v;
          _controller.strokeWidth = v;
        },
        onOpacityChanged: (v) {
          _opacityNotifier.value = v;
          _controller.opacity = v;
        },
      );
    } else if (tool == DrawingToolType.shape) {
      showShapesBottomSheet(
        context: context,
        selectedShape: _shapeTypeNotifier.value,
        strokeWidth: _shapeStrokeWidthNotifier.value,
        isFilled: _shapeFilledNotifier.value,
        onShapeChanged: (s) {
          _shapeTypeNotifier.value = s;
          _controller.shapeType = s;
        },
        onStrokeWidthChanged: (v) {
          _shapeStrokeWidthNotifier.value = v;
          _controller.shapeStrokeWidth = v;
        },
        onFillChanged: (v) {
          _shapeFilledNotifier.value = v;
          _controller.shapeFilled = v;
        },
      );
    }
  }
}
