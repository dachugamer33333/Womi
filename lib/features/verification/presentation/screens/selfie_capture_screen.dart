import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';

class SelfieCaptureScreen extends StatefulWidget {
  const SelfieCaptureScreen({super.key});

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  CameraController? _controller;
  bool _initialized = false;
  bool _captured = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _controller = CameraController(front, ResolutionPreset.high);
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
      Navigator.pushReplacementNamed(
          context, AppRoutes.verificationProcessing);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14159),
            child: CameraPreview(_controller!),
          ),
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
          if (!_captured)
            CustomPaint(
              painter: _FaceOverlayPainter(
                cutoutRect: Rect.fromCenter(
                  center: Offset(size.width / 2, size.height * 0.42),
                  width: size.width * 0.55,
                  height: size.width * 0.55 * 1.2,
                ),
              ),
            ),
          if (!_captured)
            Positioned(
              top: AppDimensions.spaceXL * 4 + MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Text(
                'Mira al frente y sonríe',
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

class _FaceOverlayPainter extends CustomPainter {
  final Rect cutoutRect;
  _FaceOverlayPainter({required this.cutoutRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addOval(cutoutRect),
      ),
      paint,
    );
    final cornerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(cutoutRect, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
