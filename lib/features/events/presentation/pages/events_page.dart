import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/presentation/providers/current_user_provider.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/presentation/providers/event_filter_provider.dart';
import 'package:eventix/features/events/presentation/providers/events_provider.dart';
import 'package:eventix/features/events/presentation/widgets/event_card.dart';
import 'package:eventix/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventsPage extends ConsumerWidget {
  static const String routePath = '/events';

  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> asyncEvents = ref.watch(eventsProvider);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const _EventsHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: _EventFiltersBar(l10n: l10n),
          ),
          Expanded(
            child: asyncEvents.when(
              loading: () => const Center(
                child: AppLoader(size: AppLoaderSize.large),
              ),
              error: (Object error, _) => AppErrorState(
                message: switch (error) {
                  Failure(:final String userMessage) => userMessage,
                  _ => l10n.events_error_message,
                },
                onRetry: () => ref.invalidate(eventsProvider),
              ),
              data: (List<Event> events) => events.isEmpty
                  ? AppEmptyState(
                      variant: AppEmptyStateVariant.search,
                      title: l10n.events_empty_title,
                      message: l10n.events_empty_message,
                      actionLabel: l10n.events_clear_filters,
                      action: () =>
                          ref.read(eventFilterProvider.notifier).clear(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.refresh(eventsProvider.future),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: events.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (BuildContext context, int i) => EventCard(
                          event: events[i],
                          onTap: () => context.push('/events/${events[i].id}'),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsHeader extends ConsumerWidget {
  const _EventsHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? nombre = ref.watch(currentUserProvider).value?.nombre;

    return ColoredBox(
      color: context.colorScheme.secondary,
      child: SafeArea(
        bottom: false,
        child: Theme(
          data: AppTheme.dark(),
          child: Builder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${l10n.events_greeting} ${nombre ?? ''} 👋',
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            l10n.app_name,
                            style: AppTypography.headlineSmall.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.go(ProfilePage.routePath),
                        child: const AppAvatar(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    hint: l10n.events_search_hint,
                    leading: const Icon(Icons.search),
                    onChanged: ref.read(eventFilterProvider.notifier).setQuery,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventFiltersBar extends ConsumerWidget {
  const _EventFiltersBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EventFilter filter = ref.watch(eventFilterProvider);
    final EventFilterNotifier notifier = ref.read(
      eventFilterProvider.notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              AppChip(
                label: l10n.events_filter_category_all,
                isSelected: filter.categoria == null,
                onTap: () => notifier.setCategoria(null),
              ),
              const SizedBox(width: AppSpacing.sm),
              for (final String categoria in kEventCategories) ...<Widget>[
                AppChip(
                  label: categoria,
                  isSelected: filter.categoria == categoria,
                  onTap: () => notifier.setCategoria(
                    filter.categoria == categoria ? null : categoria,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: AppDropdown<String>(
                items: kEventCities,
                itemLabel: (String ciudad) => ciudad,
                value: filter.ciudad,
                hint: l10n.events_filter_city_all,
                onChanged: notifier.setCiudad,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppDateField(
                value: filter.fecha,
                hint: l10n.events_filter_date_label,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onChanged: (DateTime? picked) {
                  if (picked != null) notifier.setFecha(picked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
