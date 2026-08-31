import 'package:flutter/material.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 34),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.65),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.06),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: colors.primary,
                    backgroundColor: colors.primaryContainer,
                  ),
                ),
                const Text('⛅', style: TextStyle(fontSize: 38)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Reading the skies', style: theme.textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(
              'Fetching the latest conditions…',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
