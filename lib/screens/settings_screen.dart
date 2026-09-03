import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../constants.dart';
import '../provider/theme_provider.dart';
import '../services/storage_service.dart';
 
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
 
  Future<void> _signOut(
    BuildContext context,
  ) async {
    await StorageService.clearAuthUser();
 
    if (!context.mounted) return;
 
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final themeProvider =
        context.watch<ThemeProvider>();
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: fbPrimary,
        foregroundColor: Colors.white,
      ),
 
      body: ListView(
        children: [
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: const Text('Dark Mode'),
            subtitle: Text(
              themeProvider.isDarkMode
                  ? 'Dark theme enabled'
                  : 'Light theme enabled',
            ),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              context
                  .read<ThemeProvider>()
                  .toggleTheme(value);
            },
          ),
 
          const Divider(),
 
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title:
                        const Text('Logout'),
                    content: const Text(
                      'Are you sure you want to logout?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                        child:
                            const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                          _signOut(context);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}