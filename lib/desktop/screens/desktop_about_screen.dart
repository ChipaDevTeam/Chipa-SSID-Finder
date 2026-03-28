import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DesktopAboutScreen extends StatelessWidget {
  const DesktopAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.satelliteDish,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'SSID Finder Pro',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Version 1.0.0 (Build 2026.02.21)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 400,
            child: Text(
              'A professional tool for extracting Session IDs (SSID) from various trading platforms. Built for traders and developers who need quick and reliable access to their session tokens.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(icon: FontAwesomeIcons.github, url: 'https://github.com/theshadow76', tooltip: 'GitHub'),
              const SizedBox(width: 24),
              _SocialButton(icon: FontAwesomeIcons.globe, url: 'https://chipa.io', tooltip: 'Website'),
              const SizedBox(width: 24),
              _SocialButton(icon: FontAwesomeIcons.twitter, url: 'https://twitter.com/chipa', tooltip: 'Twitter'),
            ],
          ),
          const SizedBox(height: 64),
          Text(
            '© 2026 Chipa Inc. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _SocialButton({required this.icon, required this.url, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon),
      onPressed: () {}, // Open URL
      tooltip: tooltip,
      iconSize: 28,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }
}
