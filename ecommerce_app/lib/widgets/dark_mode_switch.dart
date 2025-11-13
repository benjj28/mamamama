import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch(
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        themeProvider.toggleTheme(value);
      },
    );
  }
}
