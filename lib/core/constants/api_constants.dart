class ApiConstants {
  static const String baseUrl = 'https://api.mfapi.in';
  static const String schemes = '/mf';
  static String schemeDetails(int schemeCode) => '/mf/$schemeCode';
}
