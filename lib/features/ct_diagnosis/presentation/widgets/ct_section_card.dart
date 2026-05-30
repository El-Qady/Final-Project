import 'package:flutter/material.dart';

class CtSectionCard extends StatelessWidget {
  const CtSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.topAccent = false,
  });

  final String title;
  final List<Widget> children;
  final bool topAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Stack(
        children: [
          if (topAccent)
            Positioned(
              top: 0,
              left: 0,
              right: 80,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.secondary
                      : const Color(0xff0F766E),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                ...children,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
