import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DesktopSettingsScreen extends StatelessWidget {
  const DesktopSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          
          // --- Category 1: Appearance ---
          _SettingsSection(
            title: 'Appearance',
            icon: Icons.palette,
            children: [
              _SettingsTile(
                title: 'Dark Mode',
                subtitle: 'Use a darker color scheme for low light environments',
                trailing: Switch(value: true, onChanged: (_) {}), // Mocked state
              ),
              const Divider(),
              _SettingsTile(
                title: 'Accent Color',
                subtitle: 'Choose your preferred accent color',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ColorChoice(color: Colors.purple, selected: true),
                    _ColorChoice(color: Colors.blue, selected: false),
                    _ColorChoice(color: Colors.green, selected: false),
                    _ColorChoice(color: Colors.amber, selected: false),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // --- Category 2: Behavior ---
          _SettingsSection(
            title: 'Behavior',
            icon: FontAwesomeIcons.sliders,
            children: [
              _SettingsTile(
                title: 'Auto-Copy SSID',
                subtitle: 'Automatically copy SSID to clipboard upon extraction',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              const Divider(),
              _SettingsTile(
                title: 'Auto-Refresh Platforms',
                subtitle: 'Automatically refresh platform status every 5 minutes',
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Category 3: Updates ---
          _SettingsSection(
            title: 'Updates',
            icon: FontAwesomeIcons.cloudArrowDown,
            children: [
              _SettingsTile(
                title: 'Check for Updates',
                subtitle: 'Current Version: v1.0.0',
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Check Now'),
                ),
              ),
              const Divider(),
              _SettingsTile(
                title: 'Auto-Update',
                subtitle: 'Download updates in the background',
                trailing: Checkbox(value: true, onChanged: (_) {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({required this.title, required this.subtitle, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  final Color color;
  final bool selected;

  const _ColorChoice({required this.color, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: selected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)] : [],
      ),
    );
  }
}
