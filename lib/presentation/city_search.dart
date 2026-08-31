import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CitySearchScreen extends HookWidget {
  const CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final colors = Theme.of(context).colorScheme;

    void submit([String? value]) {
      final city = (value ?? textController.text).trim();
      if (city.isNotEmpty) Navigator.of(context).pop(city);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a city')),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primaryContainer.withValues(alpha: 0.38),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 62,
                  height: 62,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Icon(
                    Icons.travel_explore_rounded,
                    size: 30,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Where are you headed?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Search any city to see its current weather and conditions.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.75),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.06),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.search,
                  onSubmitted: submit,
                  decoration: InputDecoration(
                    hintText: 'Search Bangkok, London…',
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: colors.primary,
                    ),
                    suffixIcon: IconButton(
                      key: const Key('searchPage_search_iconButton'),
                      tooltip: 'Search',
                      onPressed: submit,
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'POPULAR CITIES',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final city in const [
                    'Bangkok',
                    'London',
                    'Tokyo',
                    'New York',
                  ])
                    ActionChip(
                      avatar: const Icon(Icons.north_east_rounded, size: 16),
                      label: Text(city),
                      onPressed: () => submit(city),
                      side: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: 0.75),
                      ),
                      backgroundColor: colors.surface.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
