import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';

class IneCaptureScreen extends StatefulWidget {
  const IneCaptureScreen({super.key});

  @override
  State<IneCaptureScreen> createState() => _IneCaptureScreenState();
}

class _IneCaptureScreenState extends State<IneCaptureScreen> {
  CameraController? _controller;
  bool _initialized = false;
  bool _captured = false;
  String? _side;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _side = ModalRoute.of(context)?.settings.arguments as String? ?? 'front';
      _initCamera();
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _controller = CameraController(back, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() => _initialized = true);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _capture() async {
    if (_controller == null || !_initialized || _captured) return;
    try {
      await _controller!.takePicture();
      setState(() => _captured = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      if (_side == 'front') {
        Navigator.pushNamed(context, AppRoutes.ineCapture, arguments: 'back');
      } else {
        Navigator.pushNamed(context, AppRoutes.selfieCapture);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }
    final size = MediaQuery.of(context).size;
    final rectW = size.width * 0.85;
    final rectH = rectW / 1.586;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          if (_captured)
            Container(
              color: AppColors.success.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded,
                      color: AppColors.surface, size: AppDimensions.iconXL),
                ),
              ),
            ),
          // Dark overlay with cutout
          if (!_captured)
            CustomPaint(
              painter: _OverlayPainter(
                cutoutRect: Rect.fromCenter(
                  center: Offset(size.width / 2, size.height * 0.45),
                  width: rectW,
                  height: rectH,
                ),
              ),
            ),
          if (!_captured)
            Positioned(
              top: rectH * 0.35 + AppDimensions.spaceXXL * 2,
              left: 0,
              right: 0,
              child: Text(
                _side == 'front'
                    ? 'Coloca el frente de tu INE'
                    : 'Coloca el reverso de tu INE',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.surface),
                textAlign: TextAlign.center,
              ),
            ),
          Positioned(
            top: AppDimensions.spaceL + MediaQuery.of(context).padding.top,
            left: AppDimensions.spaceM,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded,
                    color: AppColors.onSurface, size: AppDimensions.iconM),
              ),
            ),
          ),
          if (!_captured)
            Positioned(
              bottom: AppDimensions.spaceXL * 2,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _capture,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(
                        color: AppColors.primary, width: 4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect cutoutRect;
  _OverlayPainter({required this.cutoutRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12))),
      ),
      paint,
    );
    // White corners
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final r = cutoutRect;
    const cornerLen = 24.0;
    canvas.drawLine(Offset(r.left, r.top + cornerLen), Offset(r.left, r.top), cornerPaint);
    canvas.drawLine(Offset(r.left, r.top), Offset(r.left + cornerLen, r.top), cornerPaint);
    canvas.drawLine(Offset(r.right, r.top + cornerLen), Offset(r.right, r.top), cornerPaint);
    canvas.drawLine(Offset(r.right, r.top), Offset(r.right - cornerLen, r.top), cornerPaint);
    canvas.drawLine(Offset(r.left, r.bottom - cornerLen), Offset(r.left, r.bottom), cornerPaint);
    canvas.drawLine(Offset(r.left, r.bottom), Offset(r.left + cornerLen, r.bottom), cornerPaint);
    canvas.drawLine(Offset(r.right, r.bottom - cornerLen), Offset(r.right, r.bottom), cornerPaint);
    canvas.drawLine(Offset(r.right, r.bottom), Offset(r.right - cornerLen, r.bottom), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
