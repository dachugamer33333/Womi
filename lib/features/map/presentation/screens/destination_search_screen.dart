import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/geocoding_service.dart';
import '../../domain/models/place_result.dart';
import '../../../ride/domain/models/destination_model.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focus = FocusNode();
  final _service = GeocodingService();
  Timer? _debounce;
  bool _loading = false;
  String? _error;
  List<PlaceResult> _results = [];

  @override
  void initState() {
    super.initState();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 3) {
      setState(() {
        _results = [];
        _loading = false;
        _error = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _service.search(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Sin conexión. Mostrando destinos guardados.';
        _loading = false;
        _results = [];
      });
    }
  }

  void _selectResult(PlaceResult place) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.destinationSelection,
      arguments: place,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _searchCtrl.text.trim().length < 3;
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            boxShadow: AppShadows.card,
          ),
          child: TextField(
            controller: _searchCtrl,
            focusNode: _focus,
            onChanged: _onChanged,
            autofocus: true,
            cursorColor: AppColors.accent,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: '¿A dónde vamos?',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppColors.accent, size: AppDimensions.iconM),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: AppDimensions.spaceS + 2),
            ),
          ),
        ),
      ),
      body: _buildBody(isEmpty),
    );
  }

  Widget _buildBody(bool isEmpty) {
    if (isEmpty) {
      return _buildDefaultDestinations();
    }
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }
    if (_error != null) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimensions.spaceM),
            child: Text(_error!, style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textBody.withValues(alpha: 0.6),
            )),
          ),
          Expanded(child: _buildDefaultDestinations()),
        ],
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No encontramos ese lugar.\nIntenta con otra búsqueda.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textBody.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final r = _results[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              onTap: () => _selectResult(r),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceS),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lavenderLight,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Icon(Icons.location_on_rounded,
                          color: AppColors.accent,
                          size: AppDimensions.iconM),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.shortName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600)),
                          Text(r.displayName,
                              style: AppTextStyles.labelSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultDestinations() {
    final destinations = DestinationModel.cdmxDestinations();
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Destinos frecuentes', style: AppTextStyles.titleMedium),
          SizedBox(height: AppDimensions.spaceM),
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final d = destinations[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                      onTap: () => _selectResult(PlaceResult(
                        displayName: d.address,
                        shortName: d.name,
                        latitude: d.location.latitude,
                        longitude: d.location.longitude,
                      )),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.spaceS),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.lavenderLight,
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusS),
                              ),
                              child: Center(
                                child: Text(
                                  d.iconLabel.isNotEmpty
                                      ? d.iconLabel
                                      : d.name[0],
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
                                  Text(d.name,
                                      style: AppTextStyles.bodyMedium),
                                  Text(d.address,
                                      style: AppTextStyles.labelSmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
