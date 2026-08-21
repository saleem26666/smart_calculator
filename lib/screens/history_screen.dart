import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/history_store.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final items = HistoryStore.instance.items;
    final fmt = DateFormat('MMM d · HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () async {
                await HistoryStore.instance.clear();
                setState(() {});
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No calculations yet.\nSolve something on Standard or Scientific.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: AppColors.textMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = items[i];
                return Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: item.result));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Result copied')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceHigh,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.tag.toUpperCase(),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                fmt.format(item.timestamp),
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.expression,
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '= ${item.result}',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
