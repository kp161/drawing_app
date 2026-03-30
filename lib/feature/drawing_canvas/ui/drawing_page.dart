import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_page_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _colorController = ColorSelectionController();
    _drawingController = DrawingController();
    _controller = DrawingPageController(_colorController, _drawingController);
  }

  @override
  void dispose() {
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
                child: BottomToolbar(
                  bottomInset: isLandscape
                      ? 0
                      : MediaQuery.of(context).padding.bottom,
                  selectedTool: _controller.selectedTool,
                  onToolSelected: (tool) {
                    setState(() {
                      _controller.selectedTool = tool;
                    });
                    _handleToolSelection(tool);
                  },
                  strokeWidth: _controller.strokeWidth,
                  onStrokeWidthChanged: (v) {
                    setState(() {
                      _controller.strokeWidth = v;
                    });
                  },
                  colorController: _colorController,
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
        selectedStyle: _controller.brushStyle,
        strokeWidth: _controller.strokeWidth,
        opacity: _controller.opacity,
        onStyleChanged: (s) => setState(() => _controller.brushStyle = s),
        onStrokeWidthChanged: (v) =>
            setState(() => _controller.strokeWidth = v),
        onOpacityChanged: (v) => setState(() => _controller.opacity = v),
      );
    } else if (tool == DrawingToolType.shape) {
      showShapesBottomSheet(
        context: context,
        selectedShape: _controller.shapeType,
        strokeWidth: _controller.shapeStrokeWidth,
        isFilled: _controller.shapeFilled,
        onShapeChanged: (s) => setState(() => _controller.shapeType = s),
        onStrokeWidthChanged: (v) =>
            setState(() => _controller.shapeStrokeWidth = v),
        onFillChanged: (v) => setState(() => _controller.shapeFilled = v),
      );
    }
  }
}
