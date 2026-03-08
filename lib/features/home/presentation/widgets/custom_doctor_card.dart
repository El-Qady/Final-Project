import 'package:final_project/features/home/data/models/doctors_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CustomDoctorCard extends StatelessWidget {
  const CustomDoctorCard({super.key, required this.doctor});
  final DoctorsModel doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        // ✅ نحافظ على ألوان الـ Light الأصلية
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest,
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffE8F1FD), Colors.white],
              ),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isDark
              ? theme.colorScheme.primary.withOpacity(0.15)
              : const Color(0xffE0EDFF),
          child: Icon(Icons.person, color: theme.colorScheme.primary, size: 30),
        ),

        title: Text(
          doctor.name!,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    doctor.address!,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Icon(Icons.call, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  doctor.phone!,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ],
        ),

        trailing: IconButton(
          icon: Icon(Icons.call, color: theme.colorScheme.primary),
          onPressed: () async {
            await FlutterPhoneDirectCaller.callNumber(doctor.phone!);
          },
        ),
      ),
    );
  }
}
