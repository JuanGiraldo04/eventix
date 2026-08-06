import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/config/banner_config.dart';
import 'package:eventix/core/config/categoria_config.dart';
import 'package:eventix/core/config/config_icons.dart';
import 'package:eventix/core/errors/failure.dart';
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

// `CategoriaConfig.id` es el identificador estable de cada categoría — el
// que realmente se envía como filtro a Supabase, porque coincide con el
// valor guardado en la columna `events.categoria` (ver supabase/seed.sql).
// `CategoriaConfig.label` es solo el texto visible del chip: cambia según
// el config activo (p. ej. "Fútbol" vs "Soccer"), así que no puede usarse
// como valor de filtro o el toggle rompería la búsqueda contra datos reales.
const Map<String, String> categoriaBackendValueById = <String, String>{
  'futbol': 'Fútbol',
  'baloncesto': 'Baloncesto',
  'tenis': 'Tenis',
  'atletismo': 'Atletismo',
  'natacion': 'Natación',
};

class EventsPage extends ConsumerWidget {
  static const String routePath = '/events';

  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> asyncEvents = ref.watch(eventsProvider);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppConfig config = ref.watch(appConfigProvider).requireValue;
    final List<BannerConfig> activeBanners = config.banners
        .where((BannerConfig b) => b.activo)
        .toList();

    return Scaffold(
      body: Column(
        children: <Widget>[
          const _EventsHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(eventsProvider.future),
              // Banners, título y filtros viven en el mismo scroll que la
              // lista de eventos (en vez de un Column fijo arriba de un
              // Expanded) para que no le resten espacio permanente al
              // contenido: con varios banners activos se van ocultando al
              // bajar, igual que cualquier otro elemento de la lista.
              child: CustomScrollView(
                slivers: <Widget>[
                  if (activeBanners.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            for (final BannerConfig banner
                                in activeBanners) ...<Widget>[
                              AppBanner(
                                title: banner.titulo,
                                message: banner.mensaje,
                                variant: switch (banner.variante) {
                                  'success' => AppBannerVariant.success,
                                  'warning' => AppBannerVariant.warning,
                                  'error' => AppBannerVariant.error,
                                  _ => AppBannerVariant.info,
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        config.eventos.tituloSeccion,
                        style: AppTypography.titleLarge,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _EventFiltersBar(
                        l10n: l10n,
                        categorias: config.eventos.categorias,
                      ),
                    ),
                  ),
                  asyncEvents.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.xxl,
                        ),
                        child: Center(
                          child: AppLoader(size: AppLoaderSize.large),
                        ),
                      ),
                    ),
                    error: (Object error, _) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: AppErrorState(
                          message: switch (error) {
                            Failure(:final String userMessage) => userMessage,
                            _ => l10n.events_error_message,
                          },
                          onRetry: () => ref.invalidate(eventsProvider),
                        ),
                      ),
                    ),
                    data: (List<Event> events) => events.isEmpty
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: AppEmptyState(
                                variant: AppEmptyStateVariant.search,
                                title: config.eventos.estadoVacio.titulo,
                                message: config.eventos.estadoVacio.mensaje,
                                actionLabel: l10n.events_clear_filters,
                                action: () => ref
                                    .read(eventFilterProvider.notifier)
                                    .clear(),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            sliver: SliverList.separated(
                              itemCount: events.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: AppSpacing.md),
                              itemBuilder: (BuildContext context, int i) =>
                                  EventCard(
                                    event: events[i],
                                    onTap: () => context.push(
                                      '/events/${events[i].id}',
                                    ),
                                  ),
                            ),
                          ),
                  ),
                ],
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
    final AppConfig config = ref.watch(appConfigProvider).requireValue;

    return AppHomeHeader(
      greeting:
          '${config.eventos.saludo} ${nombre ?? ''} '
          '${config.eventos.saludoEmoji}',
      title: l10n.app_name,
      onAvatarTap: () => context.go(ProfilePage.routePath),
      searchHint: l10n.events_search_hint,
      onSearchChanged: ref.read(eventFilterProvider.notifier).setQuery,
    );
  }
}

class _EventFiltersBar extends ConsumerWidget {
  const _EventFiltersBar({required this.l10n, required this.categorias});

  final AppLocalizations l10n;
  final List<CategoriaConfig> categorias;

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
              for (final CategoriaConfig categoria in categorias) ...<Widget>[
                AppChip(
                  label: categoria.label,
                  leading: Icon(iconByName(categoria.icono), size: 16),
                  isSelected:
                      filter.categoria ==
                      categoriaBackendValueById[categoria.id],
                  onTap: () {
                    final String? backendValue =
                        categoriaBackendValueById[categoria.id];
                    notifier.setCategoria(
                      filter.categoria == backendValue ? null : backendValue,
                    );
                  },
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
