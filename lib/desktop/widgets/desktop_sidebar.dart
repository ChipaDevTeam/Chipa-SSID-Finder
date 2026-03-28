import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../desktop/providers/navigation_provider.dart';

class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    
    return Container(
      width: 250,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.wifi_find,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHIPA',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0EA5E9),
                        letterSpacing: 2.0,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'SSID Finder',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          _NavItem(
            icon: FontAwesomeIcons.chartLine,
            label: 'Dashboard',
            selected: nav.currentScreen == DesktopScreen.dashboard,
            onTap: () => nav.navigateTo(DesktopScreen.dashboard),
          ),
          _NavItem(
            icon: FontAwesomeIcons.layerGroup,
            label: 'Platforms',
            selected: nav.currentScreen == DesktopScreen.platforms,
            onTap: () => nav.navigateTo(DesktopScreen.platforms),
          ),
          _NavItem(
            icon: FontAwesomeIcons.clockRotateLeft,
            label: 'History',
            selected: nav.currentScreen == DesktopScreen.history,
            onTap: () => nav.navigateTo(DesktopScreen.history),
          ),
          const Spacer(),
          const Divider(),
          _NavItem(
            icon: FontAwesomeIcons.gear,
            label: 'Settings',
            selected: nav.currentScreen == DesktopScreen.settings,
            onTap: () => nav.navigateTo(DesktopScreen.settings),
          ),
          _NavItem(
            icon: FontAwesomeIcons.circleInfo,
            label: 'About',
            selected: nav.currentScreen == DesktopScreen.about,
            onTap: () => nav.navigateTo(DesktopScreen.about),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).iconTheme.color!.withOpacity(0.7);
    final isSelected = widget.selected;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? activeColor.withOpacity(0.15) 
                : (_hovered ? Theme.of(context).hoverColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: isSelected 
                ? Border.all(color: activeColor.withOpacity(0.3)) 
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              FaIcon(
                widget.icon,
                size: 18,
                color: isSelected ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? activeColor : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
