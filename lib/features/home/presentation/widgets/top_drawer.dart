import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTopDrawer extends StatelessWidget {
  const CustomTopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<HomeCubit>().getUserData(),
      builder: (context, snapshot) {
        final Gradient lightGradient = const LinearGradient(
          colors: [
            Color.fromARGB(255, 87, 138, 227),
            Color(0xffc1e1fd),
            Color(0xffc8e4fe),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        final Gradient darkGradient = LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        final Gradient dynamicGradient = theme.brightness == Brightness.dark
            ? darkGradient
            : lightGradient;

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container(
            height: h * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(gradient: dynamicGradient),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final userData = snapshot.data;
        final String name = userData?['name'] ?? 'User';
        final String? imageUrl = userData?['profileImageUrl'];
        final bool isDark = theme.brightness == Brightness.dark;
        final Color cardColor = isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.74);
        final Color primaryTextColor = isDark
            ? theme.colorScheme.onSurface
            : Colors.black87;
        final Color secondaryTextColor = isDark
            ? theme.colorScheme.onSurface.withOpacity(0.72)
            : Colors.black54;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
          decoration: BoxDecoration(gradient: dynamicGradient),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              await Navigator.pushNamed(context, '/accountSettingsView');
              if (context.mounted) {
                context.read<HomeCubit>().refreshUserData();
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.white.withOpacity(0.92),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.95),
                            theme.colorScheme.primary.withOpacity(0.38),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(imageUrl)
                            : const AssetImage(
                                    'assets/images/doctor_avatar.png',
                                  )
                                  as ImageProvider,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your Profile',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: constraints.maxWidth,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: secondaryTextColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
