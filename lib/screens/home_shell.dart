import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'tools_hub_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CalculatorScreen(scientific: false),
      const CalculatorScreen(scientific: true),
      const ToolsHubScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      appBar: _index < 2
          ? AppBar(
              title: Text(
                'Smart Calculator',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'PLUS',
                        style: GoogleFonts.dmSans(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accent.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate_rounded),
            label: 'Standard',
          ),
          NavigationDestination(
            icon: Icon(Icons.functions_outlined),
            selectedIcon: Icon(Icons.functions_rounded),
            label: 'Scientific',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
