enum AppLocale {
  en,
  pt_BR; // no dart, fuck you. i do what i want

  static AppLocale defaultLocale = AppLocale.en;

  @override
  String toString() => name;
}