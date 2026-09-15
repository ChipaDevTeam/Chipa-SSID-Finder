import 'package:flutter/material.dart';
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Boots the CEF runtime on Linux; no-op on every other platform.
  await ChipaSsidFinder.ensureInitialized();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chipa SSID Finder Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const PlatformListScreen(),
    );
  }
}

class PlatformListScreen extends StatelessWidget {
  const PlatformListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final platforms = PlatformConstants.platforms;
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a platform')),
      body: ListView.separated(
        itemCount: platforms.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final p = platforms[i];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(p.colors[0]), Color(p.colors[1])],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.wifi_find, color: Colors.white),
            ),
            title: Text(p.displayName),
            subtitle: Text(p.url),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openExtraction(context, p),
          );
        },
      ),
    );
  }

  void _openExtraction(BuildContext context, TradingPlatform platform) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SsidExtractionScreen(
          platform: platform,
          onExtracted: (ssids) => debugPrint('Extracted from '
              '${platform.displayName}: $ssids'),
        ),
      ),
    );
  }
}
