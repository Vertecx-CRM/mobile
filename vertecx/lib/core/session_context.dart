class SessionContext {
  static List<String> permissions = const <String>[];
  static String? accessToken;
  static String? refreshToken;

  static void setTokens({required String access, required String refresh}) {
    accessToken = access;
    refreshToken = refresh;
  }

  static void clearAuth() {
    accessToken = null;
    refreshToken = null;
  }

  static void clearAll() {
    permissions = const <String>[];
    clearAuth();
  }
}
