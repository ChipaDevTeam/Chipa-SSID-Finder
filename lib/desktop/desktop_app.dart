import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'desktop_theme.dart';
import 'providers/navigation_provider.dart';
import 'widgets/desktop_sidebar.dart';
import 'screens/desktop_dashboard_screen.dart';
import 'screens/desktop_platforms_screen.dart';
import 'screens/desktop_history_screen.dart';
import 'screens/desktop_settings_screen.dart';
import 'screens/desktop_about_screen.dart';

class DesktopApp extends StatelessWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'SSID Finder Pro',
        theme: DesktopTheme.lightTheme,
        darkTheme: DesktopTheme.darkTheme, // We can toggle this later
        themeMode: ThemeMode.dark, // Default to Dark for "Pro" look
        debugShowCheckedModeBanner: false,
        home: const DesktopScaffold(),
      ),
    );
  }
}

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          const DesktopSidebar(),
          Expanded(
            child: Column(
              children: [
                // Window Title Bar (Draggable)
                DragToMoveArea(
                  child: Container(
                    height: 32,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Window controls would go here if we hide title bar
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _buildContent(nav.currentScreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DesktopScreen screen) {
    switch (screen) {
      case DesktopScreen.dashboard:
        return const DesktopDashboardScreen();
      case DesktopScreen.platforms:
        return const DesktopPlatformsScreen();
      case DesktopScreen.history:
        return const DesktopHistoryScreen();
      case DesktopScreen.settings:
        return const DesktopSettingsScreen();
      case DesktopScreen.about:
        return const DesktopAboutScreen();
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }
}
