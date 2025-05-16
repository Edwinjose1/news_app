// lib/presentation/screens/settings_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_reader/core/theme/app_colors.dart';
import 'package:news_reader/core/theme/theme_provider.dart';
import 'package:news_reader/presentation/widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              color: theme.colorScheme.primary.withOpacity(0.08),
              child: Column(
                children: [
                  Icon(
                    Icons.settings,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Appearance',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  
                  // Theme Mode Section
                  Text(
                    'THEME MODE',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildThemeOption(
                          context: context,
                          title: 'System',
                          subtitle: 'Follow system settings',
                          icon: Icons.brightness_auto,
                          isSelected: themeProvider.themeMode == ThemeMode.system,
                          onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                          isFirst: true,
                        ),
                        Divider(height: 1, indent: 56, color: theme.dividerColor.withOpacity(0.5)),
                        _buildThemeOption(
                          context: context,
                          title: 'Light',
                          subtitle: 'Bright theme',
                          icon: Icons.light_mode,
                          isSelected: themeProvider.themeMode == ThemeMode.light,
                          onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                        ),
                        Divider(height: 1, indent: 56, color: theme.dividerColor.withOpacity(0.5)),
                        _buildThemeOption(
                          context: context,
                          title: 'Dark',
                          subtitle: 'Dark theme',
                          icon: Icons.dark_mode,
                          isSelected: themeProvider.themeMode == ThemeMode.dark,
                          onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Color Scheme Section
                  Text(
                    'COLOR SCHEME',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ThemeSelector(
                      colorSchemes: AppColors.availableColorSchemes,
                      onColorSchemeSelected: (index) {
                        themeProvider.setColorScheme(index);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // About Section
                  Text(
                    'ABOUT',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
                          title: const Text('Version'),
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(color: theme.colorScheme.secondary),
                          ),
                        ),
                        Divider(height: 1, indent: 20, endIndent: 20, color: theme.dividerColor.withOpacity(0.5)),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          leading: Icon(Icons.code, color: theme.colorScheme.primary),
                          title: const Text('Open Source Libraries'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                       
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          onTap: () {
                            // Navigate to open source libraries screen
                          },
                        ),
                        Divider(height: 1, indent: 20, endIndent: 20, color: theme.dividerColor.withOpacity(0.5)),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          leading: Icon(Icons.mail_outline, color: theme.colorScheme.primary),
                          title: const Text('Send Feedback'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          onTap: () {
                            // Send feedback action
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save and Return',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 12 : 0),
        bottom: Radius.circular(isLast ? 12 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
        
                color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : theme.dividerColor.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}