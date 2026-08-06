import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Eventix'**
  String get app_name;

  /// No description provided for @common_unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get common_unexpected_error;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_title;

  /// No description provided for @login_tagline.
  ///
  /// In en, this message translates to:
  /// **'Watch sports live'**
  String get login_tagline;

  /// No description provided for @login_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email_label;

  /// No description provided for @login_email_hint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get login_email_hint;

  /// No description provided for @login_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password_label;

  /// No description provided for @login_submit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_submit;

  /// No description provided for @login_no_account_prompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_no_account_prompt;

  /// No description provided for @login_go_register.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get login_go_register;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register_title;

  /// No description provided for @register_tagline.
  ///
  /// In en, this message translates to:
  /// **'Join and book your next event'**
  String get register_tagline;

  /// No description provided for @register_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get register_name_label;

  /// No description provided for @register_submit.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register_submit;

  /// No description provided for @register_have_account_prompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_have_account_prompt;

  /// No description provided for @register_go_login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get register_go_login;

  /// No description provided for @events_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi,'**
  String get events_greeting;

  /// No description provided for @events_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get events_search_hint;

  /// No description provided for @events_filter_category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get events_filter_category_all;

  /// No description provided for @events_filter_city_all.
  ///
  /// In en, this message translates to:
  /// **'All cities'**
  String get events_filter_city_all;

  /// No description provided for @events_filter_date_label.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get events_filter_date_label;

  /// No description provided for @events_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get events_clear_filters;

  /// No description provided for @events_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get events_empty_title;

  /// No description provided for @events_empty_message.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find events with those filters. Try another category or city.'**
  String get events_empty_message;

  /// No description provided for @events_error_message.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load events. Check your connection and try again.'**
  String get events_error_message;

  /// No description provided for @events_spots_suffix.
  ///
  /// In en, this message translates to:
  /// **'spots'**
  String get events_spots_suffix;

  /// No description provided for @event_detail_available_spots.
  ///
  /// In en, this message translates to:
  /// **'Available spots'**
  String get event_detail_available_spots;

  /// No description provided for @event_detail_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get event_detail_description;

  /// No description provided for @event_detail_price_prefix.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get event_detail_price_prefix;

  /// No description provided for @event_detail_price_suffix.
  ///
  /// In en, this message translates to:
  /// **'/ ticket'**
  String get event_detail_price_suffix;

  /// No description provided for @event_detail_reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve tickets'**
  String get event_detail_reserve;

  /// No description provided for @event_detail_sold_out.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get event_detail_sold_out;

  /// No description provided for @nav_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get nav_explore;

  /// No description provided for @nav_reservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get nav_reservations;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profile_logout;

  /// No description provided for @profile_toggle_config_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch configuration'**
  String get profile_toggle_config_tooltip;

  /// No description provided for @reservations_title.
  ///
  /// In en, this message translates to:
  /// **'My reservations'**
  String get reservations_title;

  /// No description provided for @reservations_confirmed_section.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get reservations_confirmed_section;

  /// No description provided for @reservations_pending_section.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reservations_pending_section;

  /// No description provided for @reservations_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No reservations yet'**
  String get reservations_empty_title;

  /// No description provided for @reservations_empty_message.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any reservations yet. Explore the available events!'**
  String get reservations_empty_message;

  /// No description provided for @reservations_error_message.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your reservations. Check your connection and try again.'**
  String get reservations_error_message;

  /// No description provided for @reservations_entradas_suffix.
  ///
  /// In en, this message translates to:
  /// **'tickets'**
  String get reservations_entradas_suffix;

  /// No description provided for @reservation_status_pendiente.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reservation_status_pendiente;

  /// No description provided for @reservation_status_confirmada.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get reservation_status_confirmada;

  /// No description provided for @reservation_status_cancelada.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get reservation_status_cancelada;

  /// No description provided for @reservation_detail_title.
  ///
  /// In en, this message translates to:
  /// **'Reservation detail'**
  String get reservation_detail_title;

  /// No description provided for @reservation_detail_entradas_label.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get reservation_detail_entradas_label;

  /// No description provided for @reservation_detail_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reservation_detail_total_label;

  /// No description provided for @reservation_detail_tickets_section.
  ///
  /// In en, this message translates to:
  /// **'Your tickets'**
  String get reservation_detail_tickets_section;

  /// No description provided for @reservation_detail_ticket_label.
  ///
  /// In en, this message translates to:
  /// **'Ticket {index} of {total}'**
  String reservation_detail_ticket_label(int index, int total);

  /// No description provided for @checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm reservation'**
  String get checkout_title;

  /// No description provided for @checkout_quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Number of tickets'**
  String get checkout_quantity_label;

  /// No description provided for @checkout_price_per_ticket.
  ///
  /// In en, this message translates to:
  /// **'Price per ticket'**
  String get checkout_price_per_ticket;

  /// No description provided for @checkout_quantity_row_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get checkout_quantity_row_label;

  /// No description provided for @checkout_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkout_total_label;

  /// No description provided for @checkout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm purchase'**
  String get checkout_confirm;

  /// No description provided for @confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Reservation confirmed!'**
  String get confirmation_title;

  /// No description provided for @confirmation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your spot at {evento} is secured.'**
  String confirmation_subtitle(String evento);

  /// No description provided for @confirmation_tickets_label.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get confirmation_tickets_label;

  /// No description provided for @confirmation_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get confirmation_total_label;

  /// No description provided for @confirmation_view_reservations.
  ///
  /// In en, this message translates to:
  /// **'View my reservations'**
  String get confirmation_view_reservations;

  /// No description provided for @confirmation_back_home.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get confirmation_back_home;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
