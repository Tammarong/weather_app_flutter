import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals/signals_flutter.dart';
import 'package:weather_app/presentation/city_search.dart';
import 'package:weather_app/presentation/stores/weather_state.dart';
import 'package:weather_app/presentation/stores/weather_store.dart';
import 'package:weather_app/presentation/ui/setting_screen.dart';
import 'package:weather_app/presentation/ui/widgets/weather_available.dart';

import 'widgets/weather_empty.dart';
import 'widgets/weather_error.dart';
import 'widgets/weather_loading.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final xCity = useState('');

    Future<void> openCitySearch() async {
      final city = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const CitySearchScreen()),
      );
      if (city == null || city.trim().isEmpty) return;
      xCity.value = city.trim();
      await weatherStore.fetchWeather(xCity.value);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.cloud_outlined, size: 25),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR FORECAST',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  'Weather',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
        actions: [
          _HeaderAction(
            tooltip: 'Search city',
            icon: Icons.search_rounded,
            onPressed: openCitySearch,
          ),
          _HeaderAction(
            tooltip: 'Settings',
            icon: Icons.tune_rounded,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _HomeBackground(),
          Watch((BuildContext context) {
            final state = weatherStore.weatherState;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: switch (state.status) {
                WeatherStatus.initial => WeatherEmpty(
                    key: const ValueKey('weather-empty'),
                    onSearch: openCitySearch,
                  ),
                WeatherStatus.loading => const WeatherLoading(
                    key: ValueKey('weather-loading'),
                  ),
                WeatherStatus.success => WeatherAvailable(
                    key: const ValueKey('weather-available'),
                    onRefresh: weatherStore.refreshWeather,
                    weather: state.weather,
                    units: state.temperatureUnits,
                  ),
                WeatherStatus.failure => WeatherError(
                    key: const ValueKey('weather-error'),
                    onPressed: () => weatherStore.fetchWeather(xCity.value),
                    onSearch: openCitySearch,
                  ),
              },
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryContainer.withValues(alpha: 0.32),
            Theme.of(context).scaffoldBackgroundColor,
            colors.secondaryContainer.withValues(alpha: 0.22),
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
