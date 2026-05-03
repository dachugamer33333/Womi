import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/ride_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({super.key});

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}

class _RideCompletedScreenState extends State<RideCompletedScreen>
    with TickerProviderStateMixin {
  int _rating = 5;
  late final AnimationController _checkCtrl;
  late final Animation<double> _checkAnim;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _checkAnim = CurvedAnimation(
      parent: _checkCtrl,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spaceL),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimensions.spaceXL),
                      _buildCheckIcon(),
                      SizedBox(height: AppDimensions.spaceL),
                      WomiGradientText(
                        text: '¡Viaje completado!',
                        style: AppTextStyles.displayMedium,
                      ),
                      SizedBox(height: AppDimensions.spaceXL),
                      _buildSummaryCard(),
                      SizedBox(height: AppDimensions.spaceXL),
                      _buildRatingSection(),
                      SizedBox(height: AppDimensions.spaceXL),
                      _buildHomeButton(),
                      SizedBox(height: AppDimensions.spaceL),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckIcon() {
    return ScaleTransition(
      scale: _checkAnim,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          gradient: AppGradients.brand,
          shape: BoxShape.circle,
          boxShadow: AppShadows.medium,
        ),
        child: Icon(Icons.check_rounded,
            color: AppColors.surface, size: AppDimensions.iconXL),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return WomiCard(
      padding: EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        children: [
          _buildSummaryRow(
            Icons.location_on_rounded,
            'Zócalo CDMX',
            'Antara Polanco',
          ),
          SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(Icons.timer_rounded, '14 min', 'Duración'),
              _buildSummaryItem(Icons.monetization_on_rounded, '\$65 MXN',
                  'Costo total'),
              _buildSummaryItem(
                  Icons.route_rounded, '6.2 km', 'Distancia'),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          Divider(color: AppColors.lavenderLight),
          SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.lavenderLight,
                child: Text(
                  'AM',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spaceM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ana Martínez', style: AppTextStyles.titleSmall),
                  Text('⭐ 4.9 · Conductora verificada',
                      style: AppTextStyles.labelSmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String origin, String dest) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppDimensions.iconM),
        SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(origin, style: AppTextStyles.bodySmall),
              SizedBox(height: AppDimensions.spaceXS),
              Text(dest, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppDimensions.iconL),
        SizedBox(height: AppDimensions.spaceXS),
        Text(value, style: AppTextStyles.titleSmall),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      children: [
        Text(
          'Califica a tu conductora',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppDimensions.spaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return GestureDetector(
              onTap: () => setState(() => _rating = i + 1),
              child: AnimatedScale(
                duration: AppDurations.fast,
                scale: _rating > i ? 1.2 : 1.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceXS,
                  ),
                  child: Icon(
                    _rating > i ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: _rating > i ? AppColors.warning : AppColors.iconInactive,
                    size: 40,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHomeButton() {
    return SizedBox(
      width: double.infinity,
      child: WomiGradientButton(
        label: 'Volver al inicio',
        icon: Icons.home_rounded,
        onPressed: () {
          final ride = context.read<RideProvider>().currentRide;
          context.read<RideProvider>().completeRide();
          if (ride != null) {
            final auth = context.read<AuthProvider>();
            final destinations = auth.repository.getRecentDestinations();
            final destEntry = {
              'name': ride.destination.name,
              'address': ride.destination.address,
            };
            final exists = destinations.any((d) => d['name'] == destEntry['name']);
            if (!exists) {
              destinations.insert(0, destEntry);
              if (destinations.length > 5) destinations.removeLast();
              auth.repository.saveRecentDestinations(destinations);
            }
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        },
      ),
    );
  }
}
