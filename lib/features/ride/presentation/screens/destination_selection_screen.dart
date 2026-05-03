import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
    extends State<DestinationSelectionScreen> {
  DestinationModel? _selected;
  bool _showConfirm = false;
  final MapController _mapCtrl = MapController();
  final _destinations = DestinationModel.cdmxDestinations();
  static const _origin = DestinationModel.simulatedOrigin;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  void _selectDestination(DestinationModel dest) {
    setState(() {
      _selected = dest;
      _showConfirm = true;
    });
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
        backgroundColor: AppColors.lavenderLight,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.womi.app',
        ),
        if (_selected != null) _buildAnimatedRoute(),
      ],
    );
  }

  Widget _buildAnimatedRoute() {
    final dest = _selected!.location;
    return Stack(
      children: [
        PolylineLayer(
          polylines: [
            Polyline(
              points: [_origin, dest],
              strokeWidth: 5,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _origin,
              width: 32,
              height: 32,
              child: _buildMarkerPin(AppColors.success, 'Origen'),
            ),
            Marker(
              point: dest,
              width: 32,
              height: 32,
              child: _buildMarkerPin(
                AppColors.accent,
                _selected!.name,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkerPin(Color color, String label) {
    return Icon(Icons.location_on_rounded, color: color, size: 32);
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final maxCardHeight = MediaQuery.of(context).size.height * 0.5;
    return Positioned(
      bottom: bottomPadding,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        constraints: BoxConstraints(maxHeight: maxCardHeight),
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_showConfirm) ...[
              Flexible(
                child: Container(
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
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: _destinations
                                .map((dest) => _buildDestItem(dest))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
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
