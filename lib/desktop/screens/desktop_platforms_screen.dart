import 'package:flutter/material.dart';
import '../../models/trading_platform.dart';
import '../widgets/desktop_platform_card.dart'; // I will create this reusable card

class DesktopPlatformsScreen extends StatelessWidget {
  const DesktopPlatformsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Trading Platforms',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search platforms...',
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Desktop wide
                childAspectRatio: 1.4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: PlatformConstants.platforms.length,
              itemBuilder: (context, index) {
                return DesktopPlatformCard(
                  platform: PlatformConstants.platforms[index],
                  onTap: () {
                    // Navigate to Webview
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
