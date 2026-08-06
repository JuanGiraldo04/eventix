// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'Eventix';

  @override
  String get common_unexpected_error => 'Ocurrió un error inesperado';

  @override
  String get login_title => 'Iniciar sesión';

  @override
  String get login_tagline => 'Vive el deporte en vivo';

  @override
  String get login_email_label => 'Correo electrónico';

  @override
  String get login_email_hint => 'correo@ejemplo.com';

  @override
  String get login_password_label => 'Contraseña';

  @override
  String get login_submit => 'Iniciar sesión';

  @override
  String get login_no_account_prompt => '¿No tienes cuenta?';

  @override
  String get login_go_register => 'Regístrate';

  @override
  String get register_title => 'Crear cuenta';

  @override
  String get register_tagline => 'Únete y reserva tu próximo evento';

  @override
  String get register_name_label => 'Nombre completo';

  @override
  String get register_submit => 'Crear cuenta';

  @override
  String get register_have_account_prompt => '¿Ya tienes cuenta?';

  @override
  String get register_go_login => 'Inicia sesión';

  @override
  String get events_greeting => 'Hola,';

  @override
  String get events_search_hint => 'Buscar eventos...';

  @override
  String get events_filter_category_all => 'Todos';

  @override
  String get events_filter_city_all => 'Todas las ciudades';

  @override
  String get events_filter_date_label => 'Fecha';

  @override
  String get events_clear_filters => 'Limpiar filtros';

  @override
  String get events_empty_title => 'Sin resultados';

  @override
  String get events_empty_message =>
      'No encontramos eventos con esos filtros. Prueba con otra categoría o ciudad.';

  @override
  String get events_error_message =>
      'No pudimos cargar los eventos. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get events_spots_suffix => 'cupos';

  @override
  String get event_detail_available_spots => 'Cupos disponibles';

  @override
  String get event_detail_description => 'Descripción';

  @override
  String get event_detail_price_prefix => 'Desde';

  @override
  String get event_detail_price_suffix => '/ entrada';

  @override
  String get event_detail_reserve => 'Reservar entradas';

  @override
  String get event_detail_sold_out => 'Agotado';

  @override
  String get nav_explore => 'Explorar';

  @override
  String get nav_reservations => 'Reservas';

  @override
  String get nav_profile => 'Perfil';

  @override
  String get profile_title => 'Perfil';

  @override
  String get profile_logout => 'Cerrar sesión';

  @override
  String get profile_toggle_config_tooltip => 'Cambiar configuración';

  @override
  String get reservations_title => 'Mis reservas';

  @override
  String get reservations_confirmed_section => 'Confirmadas';

  @override
  String get reservations_pending_section => 'Pendientes';

  @override
  String get reservations_empty_title => 'Aún no tienes reservas';

  @override
  String get reservations_empty_message =>
      'Todavía no has hecho ninguna reserva. ¡Explora los eventos disponibles!';

  @override
  String get reservations_error_message =>
      'No pudimos cargar tus reservas. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get reservations_entradas_suffix => 'entradas';

  @override
  String get reservation_status_pendiente => 'Pendiente';

  @override
  String get reservation_status_confirmada => 'Confirmada';

  @override
  String get reservation_status_cancelada => 'Cancelada';

  @override
  String get reservation_detail_title => 'Detalle de reserva';

  @override
  String get reservation_detail_entradas_label => 'Entradas';

  @override
  String get reservation_detail_total_label => 'Total';

  @override
  String get reservation_detail_tickets_section => 'Tus tickets';

  @override
  String reservation_detail_ticket_label(int index, int total) {
    return 'Ticket $index de $total';
  }

  @override
  String get checkout_title => 'Confirmar reserva';

  @override
  String get checkout_quantity_label => 'Cantidad de entradas';

  @override
  String get checkout_price_per_ticket => 'Precio por entrada';

  @override
  String get checkout_quantity_row_label => 'Cantidad';

  @override
  String get checkout_total_label => 'Total';

  @override
  String get checkout_confirm => 'Confirmar compra';

  @override
  String get confirmation_title => '¡Reserva confirmada!';

  @override
  String confirmation_subtitle(String evento) {
    return 'Tu lugar en $evento está asegurado.';
  }

  @override
  String get confirmation_tickets_label => 'Entradas';

  @override
  String get confirmation_total_label => 'Total pagado';

  @override
  String get confirmation_view_reservations => 'Ver mis reservas';

  @override
  String get confirmation_back_home => 'Volver al inicio';
}
