import 'package:flutter/material.dart';
import 'package:weather_app/core/repository/models/weather.dart' hide Weather;
import 'package:weather_app/presentation/models/weather.dart';

class WeatherAvailable extends StatelessWidget {
  const WeatherAvailable({
    super.key,
    required this.onRefresh,
    required this.weather,
    required this.units,
  });

  final Weather weather;
  final ValueGetter<Future<void>> onRefresh;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _WeatherBackground(condition: weather.condition),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isWide ? 44 : 22,
                      isWide ? 20 : 14,
                      isWide ? 44 : 22,
                      40,
                    ),
                    child: _WeatherContent(
                      weather: weather,
                      units: units,
                      isWide: isWide,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({
    required this.weather,
    required this.units,
    required this.isWide,
  });

  final Weather weather;
  final TemperatureUnits units;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(weather.lastUpdated),
    );

    final summary = _WeatherSummary(weather: weather, units: units);
    final hero = _WeatherHero(condition: weather.condition);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: isWide ? Alignment.centerLeft : Alignment.center,
          child: _UpdatedPill(time: time),
        ),
        SizedBox(height: isWide ? 24 : 34),
        if (isWide)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hero,
              const SizedBox(width: 48),
              Flexible(child: summary),
            ],
          )
        else ...[
          hero,
          const SizedBox(height: 28),
          summary,
        ],
        SizedBox(height: isWide ? 28 : 36),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.thermostat_rounded,
                  label: 'TEMPERATURE',
                  value: units.isCelsius ? 'Celsius' : 'Fahrenheit',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  icon: weather.condition.icon,
                  label: 'CONDITION',
                  value: weather.condition.label,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Text(
              'Pull down to refresh',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpdatedPill extends StatelessWidget {
  const _UpdatedPill({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 15, color: colors.primary),
          const SizedBox(width: 6),
          Text(
            'Updated $time',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _WeatherHero extends StatelessWidget {
  const _WeatherHero({required this.condition});

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 148,
      height: 148,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surface.withValues(alpha: 0.95),
            colors.primaryContainer.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(color: colors.surface.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.09),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Text(condition.toEmoji, style: const TextStyle(fontSize: 72)),
    );
  }
}

class _WeatherSummary extends StatelessWidget {
  const _WeatherSummary({required this.weather, required this.units});

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  weather.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              weather.formattedTemperature(units),
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 88,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            weather.condition.message(weather.location),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 23, color: colors.primary),
          const SizedBox(height: 14),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  const _WeatherBackground({required this.condition});

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tint = condition.tint(colors);
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tint,
                colors.primaryContainer.withValues(alpha: 0.48),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0, 0.48, 1],
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -70,
          child: Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface.withValues(alpha: 0.24),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: -80,
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.secondaryContainer.withValues(alpha: 0.24),
            ),
          ),
        ),
      ],
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    final rounded = temperature.value.roundToDouble();
    final value = (temperature.value - rounded).abs() < 0.05
        ? temperature.value.toStringAsFixed(0)
        : temperature.value.toStringAsFixed(1);
    return '$value°${units.isCelsius ? 'C' : 'F'}';
  }
}

extension on WeatherCondition {
  String get toEmoji => switch (this) {
        WeatherCondition.clear => '☀️',
        WeatherCondition.rainy => '🌧️',
        WeatherCondition.cloudy => '☁️',
        WeatherCondition.snowy => '🌨️',
        WeatherCondition.unknown => '🌤️',
      };

  String get label => switch (this) {
        WeatherCondition.clear => 'Clear',
        WeatherCondition.rainy => 'Rainy',
        WeatherCondition.cloudy => 'Cloudy',
        WeatherCondition.snowy => 'Snowy',
        WeatherCondition.unknown => 'Mixed',
      };

  IconData get icon => switch (this) {
        WeatherCondition.clear => Icons.wb_sunny_outlined,
        WeatherCondition.rainy => Icons.water_drop_outlined,
        WeatherCondition.cloudy => Icons.cloud_outlined,
        WeatherCondition.snowy => Icons.ac_unit_rounded,
        WeatherCondition.unknown => Icons.wb_cloudy_outlined,
      };

  String message(String location) => switch (this) {
        WeatherCondition.clear => 'Clear skies over $location right now.',
        WeatherCondition.rainy => 'Rain is moving through $location.',
        WeatherCondition.cloudy => 'Cloud cover is settled over $location.',
        WeatherCondition.snowy => 'Snowy conditions around $location.',
        WeatherCondition.unknown => 'Mixed conditions around $location.',
      };

  Color tint(ColorScheme colors) => switch (this) {
        WeatherCondition.clear => const Color(0xFFE8ECB8),
        WeatherCondition.rainy => const Color(0xFFD3E3DF),
        WeatherCondition.cloudy => const Color(0xFFDDE3D1),
        WeatherCondition.snowy => const Color(0xFFE3EEEA),
        WeatherCondition.unknown => colors.secondaryContainer,
      };
}
