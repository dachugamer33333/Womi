import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/models/destination_model.dart';
import '../../domain/models/driver_model.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen>
    with TickerProviderStateMixin {
  late final AnimationController _carCtrl;
  late final AnimationController _etaCtrl;
  late final AnimationController _sosPulseCtrl;
  final MapController _mapCtrl = MapController();

  static const _origin = DestinationModel.simulatedOrigin;
  static const _destination = LatLng(19.4408, -99.2073); // Antara Polanco
  final _etaMinutes = 12;
  int _currentEta = 12;

  List<LatLng> get _routePoints => _generateRoutePoints();

  @override
  void initState() {
    super.initState();
    _carCtrl = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    );
    _etaCtrl = AnimationController(
      duration: const Duration(seconds: 48),
      vsync: this,
    );
    _sosPulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _setupEtaListener();
    _startRide();
  }

  void _setupEtaListener() {
    _etaCtrl.addListener(() {
      final newEta = (_etaMinutes * (1 - _etaCtrl.value)).ceil();
      if (newEta != _currentEta && newEta >= 0) {
        setState(() => _currentEta = newEta);
      }
    });
  }

  void _startRide() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _carCtrl.forward();
        _etaCtrl.forward();
      }
    });
  }

  void _centerRoute() {
    final bounds = LatLngBounds.fromPoints([_origin, _destination]);
    _mapCtrl.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(AppDimensions.spaceXL),
      ),
    );
  }

  @override
  void dispose() {
    _carCtrl.dispose();
    _etaCtrl.dispose();
    _sosPulseCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  void _showSosDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded,
                color: AppColors.surface, size: AppDimensions.iconL),
            SizedBox(width: AppDimensions.spaceS),
            Text('¿Activar emergencia?',
                style: AppTextStyles.headline.copyWith(color: AppColors.surface)),
          ],
        ),
        content: Text(
          'Se notificará a tus contactos de confianza y al equipo de Womi.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface)),
          ),
          WomiGradientButton(
            label: 'Confirmar SOS',
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Emergencia activada. Hemos notificado a tus contactos y a Womi.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _buildMap()),
          Positioned(
            top: AppDimensions.spaceXL + MediaQuery.of(context).padding.top,
            right: AppDimensions.spaceM,
            child: GestureDetector(
              onTap: _centerRoute,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(Icons.my_location_rounded,
                    color: AppColors.secondary, size: AppDimensions.iconM),
              ),
            ),
          ),
          Positioned(
            top: AppDimensions.spaceXL + MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceM,
                  vertical: AppDimensions.spaceS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                  boxShadow: AppShadows.soft,
                ),
                child: Text(
                  'En viaje',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: _origin,
        initialZoom: 12.5,
        backgroundColor: AppColors.lavenderLight,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all ^ InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.womi.app',
        ),
        _buildStaticRoute(),
        _buildAnimatedCar(),
        _buildMarkers(),
      ],
    );
  }

  Widget _buildStaticRoute() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: _routePoints,
          strokeWidth: 4,
          color: AppColors.secondary.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildAnimatedCar() {
    return AnimatedBuilder(
      animation: _carCtrl,
      builder: (context, _) {
        final point = _interpolatePosition(_carCtrl.value);
        return MarkerLayer(
          markers: [
            Marker(
              point: point,
              width: 44,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(Icons.local_taxi_rounded,
                    color: AppColors.secondary, size: AppDimensions.iconM),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMarkers() {
    return MarkerLayer(
      markers: [
        Marker(
          point: _origin,
          width: 32,
          height: 32,
          child: Icon(Icons.location_on_rounded, color: AppColors.success, size: 32),
        ),
        Marker(
          point: _destination,
          width: 32,
          height: 32,
          child: Icon(Icons.location_on_rounded, color: AppColors.accent, size: 32),
        ),
      ],
    );
  }

  LatLng _interpolatePosition(double t) {
    if (t >= 1.0) return _routePoints.last;
    if (t <= 0.0) return _routePoints.first;
    final totalSegments = _routePoints.length - 1;
    final exactIndex = t * totalSegments;
    final index = exactIndex.floor();
    final fraction = exactIndex - index;
    final p1 = _routePoints[index];
    final p2 = _routePoints[index + 1];
    return LatLng(
      p1.latitude + (p2.latitude - p1.latitude) * fraction,
      p1.longitude + (p2.longitude - p1.longitude) * fraction,
    );
  }

  List<LatLng> _generateRoutePoints() {
    const count = 30;
    final points = <LatLng>[];
    final dLat = _destination.latitude - _origin.latitude;
    final dLng = _destination.longitude - _origin.longitude;
    final curveLng = dLng * 0.12;

    for (int i = 0; i <= count; i++) {
      final t = i / count;
      final lat = _origin.latitude + dLat * t;
      double lng;
      if (t < 0.5) {
        lng = _origin.longitude + dLng * t + curveLng * sin(t * pi * 2);
      } else {
        lng = _origin.longitude + dLng * t - curveLng * sin((1 - t) * pi * 2);
      }
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  Widget _buildBottomSheet() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.spaceM,
          AppDimensions.spaceS,
          AppDimensions.spaceM,
          AppDimensions.spaceL + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildEtaSection(),
            SizedBox(height: AppDimensions.spaceM),
            _buildDriverCard(),
            SizedBox(height: AppDimensions.spaceM),
            _buildSafetySection(),
            SizedBox(height: AppDimensions.spaceM),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.textBody.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
    );
  }

  Widget _buildEtaSection() {
    return Column(
      children: [
        Text(
          'Llegando en',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textBody.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: AppDimensions.spaceXS),
        WomiGradientText(
          text: '$_currentEta min',
          style: AppTextStyles.displayLarge.copyWith(fontSize: 40),
        ),
      ],
    );
  }

  Widget _buildDriverCard() {
    const driver = DriverModel.anaMartinez;
    return WomiCard(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.lavenderLight,
            child: Text(
              driver.initials,
              style: AppTextStyles.headline.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driver.name, style: AppTextStyles.titleMedium),
                SizedBox(height: AppDimensions.spaceXS / 2),
                Text(
                  '⭐ ${driver.rating} (${driver.totalTrips} viajes)',
                  style: AppTextStyles.labelSmall,
                ),
                Text(
                  '${driver.carModel} · ${driver.licensePlate}',
                  style: AppTextStyles.labelSmall,
                ),
                Row(
                  children: [
                    Icon(Icons.verified_rounded,
                        color: AppColors.accent, size: 14),
                    SizedBox(width: AppDimensions.spaceXS / 2),
                    Text(
                      'Verificada por Womi',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildSmallCircleButton(Icons.call_rounded, 'Llamar'),
              SizedBox(height: AppDimensions.spaceS),
              _buildSmallCircleButton(Icons.chat_rounded, 'Chat'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCircleButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lavenderLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: AppColors.secondary, size: AppDimensions.iconM),
      ),
    );
  }

  Widget _buildSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu seguridad',
          style: AppTextStyles.labelLarge.copyWith(fontSize: 14),
        ),
        SizedBox(height: AppDimensions.spaceS),
        Row(
          children: [
            Expanded(child: _buildSafetyAction(
              Icons.share_rounded,
              'Compartir viaje',
              AppColors.lavenderLight,
              AppColors.secondary,
              () {},
            )),
            SizedBox(width: AppDimensions.spaceS),
            Expanded(child: _buildSafetyAction(
              Icons.people_rounded,
              'Contactos',
              AppColors.lavenderLight,
              AppColors.secondary,
              () {},
            )),
            SizedBox(width: AppDimensions.spaceS),
            Expanded(child: _buildSosButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetyAction(
      IconData icon, String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.spaceS,
          horizontal: AppDimensions.spaceXS,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: fg, size: AppDimensions.iconM),
            SizedBox(height: AppDimensions.spaceXS),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSosButton() {
    return AnimatedBuilder(
      animation: _sosPulseCtrl,
      builder: (context, _) {
        final scale = 1.0 + _sosPulseCtrl.value * 0.05;
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: _showSosDialog,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.spaceS,
                horizontal: AppDimensions.spaceXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                children: [
                  Icon(Icons.warning_rounded,
                      color: AppColors.surface, size: AppDimensions.iconM),
                  SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    'SOS',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.rideCompleted);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
        ),
        child: Text(
          'Finalizar viaje',
          style: AppTextStyles.button.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }
}
