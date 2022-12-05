enum AppLocale {
  en(languageCode: "en"),
  ptBR(languageCode: "pt_BR");

  // because enum consts must be in camelcase and my brazilian friend
  // is insistent about the portuguese being brazilian i have to do this
  final String languageCode;

  const AppLocale({required this.languageCode});

  static AppLocale defaultLocale = AppLocale.en;

  @override
  String toString() => name;

  /// i18n translation key
  String get nameKey => "settings.locale.language.options.$languageCode";
}
