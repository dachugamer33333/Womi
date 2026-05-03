import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/models/destination_model.dart';
import '../../domain/models/ride_model.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key});

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> with TickerProviderStateMixin {
  DestinationModel? _selected;
  bool _showConfirm = false;
  late final AnimationController _polylineCtrl;
  final MapController _mapCtrl = MapController();
  final _destinations = DestinationModel.cdmxDestinations();
  static const _origin = DestinationModel.simulatedOrigin;

  @override
  void initState() {
    super.initState();
    _polylineCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _polylineCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  void _selectDestination(DestinationModel dest) {
    setState(() {
      _selected = dest;
      _showConfirm = true;
    });
    _polylineCtrl.forward(from: 0);
    final bounds = LatLngBounds.fromPoints([_origin, dest.location]);
    _mapCtrl.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(AppDimensions.spaceXL * 2),
      ),
    );
  }

  void _showTripSummary() {
    if (_selected == null) return;
    final dist = RideModel.calculateDistance(_selected!.location);
    final mins = RideModel.calculateEstimatedMinutes(dist);
    final cost = RideModel.calculateCost(dist);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSummaryCard(dist, mins, cost),
    );
  }

  Widget _buildSummaryCard(double distKm, int mins, double cost) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textBody.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),
          WomiGradientText(
            text: _selected!.name,
            style: AppTextStyles.displaySmall,
          ),
          SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem(
                  Icons.route_rounded, '${distKm.toStringAsFixed(1)} km'),
              _buildSummaryItem(
                  Icons.timer_rounded, '$mins min'),
              _buildSummaryItem(
                  Icons.monetization_on_rounded, '\$${cost.toStringAsFixed(0)} MXN'),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          SizedBox(
            width: double.infinity,
            child: WomiGradientButton(
              label: 'Buscar conductora',
              icon: Icons.search_rounded,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.searchingDriver);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppDimensions.iconL),
        SizedBox(height: AppDimensions.spaceS),
        Text(text, style: AppTextStyles.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _buildMap()),
          _buildBackButton(),
          _buildDestinationCard(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: _origin,
        initialZoom: 13.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.womi.app',
        ),
        if (_selected != null) _buildAnimatedRoute(),
      ],
    );
  }

  Widget _buildAnimatedRoute() {
    return AnimatedBuilder(
      animation: _polylineCtrl,
      builder: (context, _) {
        final progress = _polylineCtrl.value;
        final curvedPoints = _generateCurvedPoints(progress);
        return Stack(
          children: [
            PolylineLayer(
              polylines: [
                Polyline(
                  points: curvedPoints,
                  strokeWidth: 4,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _origin,
                  width: 40,
                  height: 40,
                  child: _buildMarkerPin(AppColors.success, 'Origen'),
                ),
                if (_selected != null)
                  Marker(
                    point: curvedPoints.last,
                    width: 40,
                    height: 40,
                    child: _buildMarkerPin(
                      AppColors.accent,
                      _selected!.name,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<LatLng> _generateCurvedPoints(double progress) {
    final targetCount = (20 * progress).ceil().clamp(2, 20);
    final points = <LatLng>[];
    final dest = _selected!.location;
    final curveOffset = (dest.longitude - _origin.longitude) * 0.15;
    final midLat = _origin.latitude + (dest.latitude - _origin.latitude) * 0.5;

    for (int i = 0; i < targetCount; i++) {
      final t = i / (targetCount - 1);
      final curvedT = _quadraticBezier(t);
      final lat = _origin.latitude + (dest.latitude - _origin.latitude) * t;
      final lng =
          _origin.longitude + (dest.longitude - _origin.longitude) * t;
      final curvedLat = midLat + (lat - midLat) * curvedT;
      double curvedLng;
      if (t < 0.5) {
        curvedLng = lng + curveOffset * (1 - curvedT * 2);
      } else {
        curvedLng = lng - curveOffset * (1 - (1 - curvedT) * 2);
      }
      points.add(LatLng(curvedLat, curvedLng));
    }
    return points;
  }

  double _quadraticBezier(double t) {
    return 2 * (1 - t) * t;
  }

  Widget _buildMarkerPin(Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceXS,
            vertical: AppDimensions.spaceXS / 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            boxShadow: AppShadows.card,
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceXS),
        Icon(Icons.location_on_rounded, color: color, size: 20),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: AppDimensions.spaceXL + MediaQuery.of(context).padding.top,
      left: AppDimensions.spaceM,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft,
          ),
          child: Icon(Icons.arrow_back_rounded,
              color: AppColors.onSurface, size: AppDimensions.iconM),
        ),
      ),
    );
  }

  Widget _buildDestinationCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_showConfirm) ...[
              Container(
                padding: EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusL),
                  ),
                  boxShadow: AppShadows.medium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textBody.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceM),
                    Text('¿A dónde vamos?',
                        style: AppTextStyles.headline),
                    SizedBox(height: AppDimensions.spaceM),
                    ..._destinations.map((dest) => _buildDestItem(dest)),
                  ],
                ),
              ),
            ],
            if (_showConfirm && _selected != null) ...[
              Container(
                padding: EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusL),
                  ),
                  boxShadow: AppShadows.medium,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textBody.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceM),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Icon(Icons.location_on_rounded,
                              color: AppColors.secondary,
                              size: AppDimensions.iconM),
                        ),
                        SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selected!.name,
                                  style: AppTextStyles.titleMedium),
                              Text(_selected!.address,
                                  style: AppTextStyles.labelSmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spaceM),
                    SizedBox(
                      width: double.infinity,
                      child: WomiGradientButton(
                        label: 'Confirmar viaje',
                        icon: Icons.check_rounded,
                        onPressed: _showTripSummary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDestItem(DestinationModel dest) {
    final isSelected = _selected?.name == dest.name;
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: Material(
        color: isSelected ? AppColors.lavenderLight : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          onTap: () => _selectDestination(dest),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spaceS),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lavenderLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Center(
                    child: Text(
                      dest.iconLabel.isNotEmpty
                          ? dest.iconLabel
                          : dest.name[0],
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dest.name, style: AppTextStyles.bodyMedium),
                      Text(dest.address, style: AppTextStyles.labelSmall),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.iconInactive,
                    size: AppDimensions.iconM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
