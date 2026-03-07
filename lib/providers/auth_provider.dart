import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/class_rep_service.dart';
import '../models/class_rep.dart';

/// ----- Auth State -----
class AuthState {
  final bool isLoading;
  final String? error;
  final ClassRep? rep;

  AuthState({this.isLoading = false, this.error, this.rep});

  AuthState copyWith({bool? isLoading, String? error, ClassRep? rep}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      rep: rep ?? this.rep,
    );
  }
}

/// ----- Providers -----
final classRepServiceProvider = Provider<ClassRepService>((ref) {
  return ClassRepService();
});

final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final service = ref.watch(classRepServiceProvider);
  return AuthNotifier(service);
});

/// ----- Auth Notifier -----
class AuthNotifier extends ChangeNotifier {
  final ClassRepService _service;

  AuthNotifier(this._service) {
    _loadCachedRep();
  }

  AuthState _state = AuthState();
  AuthState get state => _state;

  final TextEditingController codeController = TextEditingController();

  /// Load cached class rep from SharedPreferences
  Future<void> _loadCachedRep() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('loggedRepId');
    final name = prefs.getString('loggedRepName');
    final code = prefs.getString('loggedRepCode');

    if (id != null && name != null && code != null) {
      _state = _state.copyWith(
        rep: ClassRep(
            id: id,
            name: name,
            uniqueCode: code,
            department: '',
            school: '',
            isActive: true,
            createdAt: DateTime.now()),
      );
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _state = _state.copyWith(isLoading: v, error: null);
    notifyListeners();
  }

  void _setError(String err) {
    _state = _state.copyWith(isLoading: false, error: err);
    notifyListeners();
  }

  /// ----- Login using class rep unique code -----
  Future<void> login(BuildContext context) async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      _setError('Please enter the login code.');
      return;
    }

    _setLoading(true);

    try {
      final rep = await _service.getByCode(code);
      if (rep == null) {
        _setError('Invalid login code.');
        return;
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedRepId', rep.id);
      await prefs.setString('loggedRepName', rep.name);
      await prefs.setString('loggedRepCode', rep.uniqueCode);

      _state = _state.copyWith(isLoading: false, rep: rep);
      notifyListeners();

      // Navigate to home
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e, st) {
      _setError('Login failed. Try again.');
      debugPrint('Login error: $e\n$st');
    } finally {
      _setLoading(false);
    }
  }

  /// ----- Logout -----
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedRepId');
    await prefs.remove('loggedRepName');
    await prefs.remove('loggedRepCode');

    _state = AuthState();
    notifyListeners();

    Navigator.of(context).pushReplacementNamed('/login');
  }
}
