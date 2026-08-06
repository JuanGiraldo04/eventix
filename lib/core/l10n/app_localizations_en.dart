// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Eventix';

  @override
  String get common_unexpected_error => 'An unexpected error occurred';

  @override
  String get login_title => 'Sign in';

  @override
  String get login_tagline => 'Watch sports live';

  @override
  String get login_email_label => 'Email';

  @override
  String get login_email_hint => 'email@example.com';

  @override
  String get login_password_label => 'Password';

  @override
  String get login_submit => 'Sign in';

  @override
  String get login_no_account_prompt => 'Don\'t have an account?';

  @override
  String get login_go_register => 'Sign up';

  @override
  String get register_title => 'Create account';

  @override
  String get register_tagline => 'Join and book your next event';

  @override
  String get register_name_label => 'Name';

  @override
  String get register_submit => 'Sign up';

  @override
  String get register_have_account_prompt => 'Already have an account?';

  @override
  String get register_go_login => 'Sign in';

  @override
  String get events_greeting => 'Hi,';

  @override
  String get events_search_hint => 'Search events...';

  @override
  String get events_filter_category_all => 'All';

  @override
  String get events_filter_city_all => 'All cities';

  @override
  String get events_filter_date_label => 'Date';

  @override
  String get events_clear_filters => 'Clear filters';

  @override
  String get events_empty_title => 'No results';

  @override
  String get events_empty_message =>
      'We couldn\'t find events with those filters. Try another category or city.';

  @override
  String get events_error_message =>
      'We couldn\'t load events. Check your connection and try again.';

  @override
  String get events_spots_suffix => 'spots';

  @override
  String get event_detail_available_spots => 'Available spots';

  @override
  String get event_detail_description => 'Description';

  @override
  String get event_detail_price_prefix => 'From';

  @override
  String get event_detail_price_suffix => '/ ticket';

  @override
  String get event_detail_reserve => 'Reserve tickets';

  @override
  String get event_detail_sold_out => 'Sold out';

  @override
  String get nav_explore => 'Explore';

  @override
  String get nav_reservations => 'Reservations';

  @override
  String get nav_profile => 'Profile';

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_logout => 'Sign out';

  @override
  String get profile_toggle_config_tooltip => 'Switch configuration';

  @override
  String get reservations_title => 'My reservations';

  @override
  String get reservations_confirmed_section => 'Confirmed';

  @override
  String get reservations_pending_section => 'Pending';

  @override
  String get reservations_empty_title => 'No reservations yet';

  @override
  String get reservations_empty_message =>
      'You haven\'t made any reservations yet. Explore the available events!';

  @override
  String get reservations_error_message =>
      'We couldn\'t load your reservations. Check your connection and try again.';

  @override
  String get reservations_entradas_suffix => 'tickets';

  @override
  String get reservation_status_pendiente => 'Pending';

  @override
  String get reservation_status_confirmada => 'Confirmed';

  @override
  String get reservation_status_cancelada => 'Cancelled';

  @override
  String get reservation_detail_title => 'Reservation detail';

  @override
  String get reservation_detail_entradas_label => 'Tickets';

  @override
  String get reservation_detail_total_label => 'Total';

  @override
  String get reservation_detail_tickets_section => 'Your tickets';

  @override
  String reservation_detail_ticket_label(int index, int total) {
    return 'Ticket $index of $total';
  }

  @override
  String get checkout_title => 'Confirm reservation';

  @override
  String get checkout_quantity_label => 'Number of tickets';

  @override
  String get checkout_price_per_ticket => 'Price per ticket';

  @override
  String get checkout_quantity_row_label => 'Quantity';

  @override
  String get checkout_total_label => 'Total';

  @override
  String get checkout_confirm => 'Confirm purchase';

  @override
  String get confirmation_title => 'Reservation confirmed!';

  @override
  String confirmation_subtitle(String evento) {
    return 'Your spot at $evento is secured.';
  }

  @override
  String get confirmation_tickets_label => 'Tickets';

  @override
  String get confirmation_total_label => 'Total paid';

  @override
  String get confirmation_view_reservations => 'View my reservations';

  @override
  String get confirmation_back_home => 'Back to home';
}
