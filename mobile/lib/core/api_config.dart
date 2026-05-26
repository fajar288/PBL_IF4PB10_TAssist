class ApiConfig {
  // Karena kamu run Flutter di Chrome
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Isi dengan Web Client ID dari Google Cloud
  static const String googleClientId =
      '170232690367-0a18spgd9sr6lc8o6usdeipplqc1u252.apps.googleusercontent.com';

  // Untuk backend verification, boleh pakai Web Client ID yang sama
  static const String googleServerClientId =
      '170232690367-0a18spgd9sr6lc8o6usdeipplqc1u252.apps.googleusercontent.com';
}