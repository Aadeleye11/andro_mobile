// user_store.dart
// Holds all registered users in memory for the session.
// Place at: lib/ui/user_store.dart

class UserStore {
  static final List<Map<String, String>> _users = [];

  static void addUser({
    required String name,
    required String email,
    required String password,
  }) {
    _users.add({
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
    });
  }

  static bool emailExists(String email) {
    for (final user in _users) {
      if (user['email'] == email.toLowerCase()) return true;
    }
    return false;
  }

  static Map<String, String>? findUser({
    required String email,
    required String password,
  }) {
    for (final user in _users) {
      if (user['email'] == email.toLowerCase() &&
          user['password'] == password) {
        return user;
      }
    }
    return null;
  }
}
