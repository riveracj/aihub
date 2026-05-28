import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 48, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Profile',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to track your AI conversations',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            icon: Icons.light_mode,
            label: 'Light',
            selected: currentTheme == AppThemeMode.light,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.light),
          ),
          const SizedBox(height: 8),
          _ThemeOption(
            icon: Icons.dark_mode,
            label: 'Dark',
            selected: currentTheme == AppThemeMode.dark,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.dark),
          ),
          const SizedBox(height: 8),
          _ThemeOption(
            icon: Icons.settings_brightness,
            label: 'System',
            selected: currentTheme == AppThemeMode.system,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.system),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _MenuTile(
            icon: Icons.bookmark_outline,
            label: 'Saved AI Hubs',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.history,
            label: 'Chat History',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryPurple.withValues(alpha: isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primaryPurple
                : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.primaryPurple : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? AppColors.primaryPurple : null,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check_circle, size: 20, color: AppColors.primaryPurple),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey[600]),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.grey[600] : Colors.grey[400]),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
