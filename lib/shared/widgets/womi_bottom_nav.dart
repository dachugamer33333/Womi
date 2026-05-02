import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';

class WomiBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const WomiBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isActive = currentIndex == index;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isActive)
                    Container(
                      width: AppDimensions.bottomNavActiveCircle,
                      height: AppDimensions.bottomNavActiveCircle,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.brand,
                        boxShadow: AppShadows.soft,
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.surface,
                        size: AppDimensions.bottomNavIconSize,
                      ),
                    )
                  else
                    Icon(
                      item.icon,
                      color: AppColors.iconInactive,
                      size: AppDimensions.bottomNavIconSize,
                    ),
                  SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 11,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.secondary
                          : AppColors.iconInactive,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;

  const _NavItem({required this.label, required this.icon});
}

const _navItems = [
  _NavItem(label: AppStrings.home, icon: Icons.home_rounded),
  _NavItem(label: AppStrings.activity, icon: Icons.receipt_long_rounded),
  _NavItem(label: AppStrings.wallet, icon: Icons.account_balance_wallet_rounded),
  _NavItem(label: AppStrings.profile, icon: Icons.person_rounded),
];
