import 'package:flutter/material.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchActive;
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final VoidCallback onToggleSearch;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final DateTime? selectedDate;

  const HistoryAppBar({
    super.key,
    required this.isSearchActive,
    required this.controller,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.onPickDate,
    required this.onClearDate,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearchActive
          ? TextField(
              controller: controller,
              autofocus: true,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            )
          : const Text('Diagnosis History'),
      actions: [
        IconButton(
          icon: Icon(isSearchActive ? Icons.close : Icons.search),
          onPressed: onToggleSearch,
        ),
        IconButton(
          icon: Icon(selectedDate != null
              ? Icons.event_available
              : Icons.calendar_today),
          onPressed: onPickDate,
        ),
        if (selectedDate != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClearDate,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}