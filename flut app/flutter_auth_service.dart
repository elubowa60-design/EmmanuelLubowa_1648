import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'api_service.dart';

// ==================== PROVIDERS ====================

/// API Service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Current user state
final currentUserProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserNotifier(apiService);
});

/// Authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});

// ==================== NOTIFIERS ====================

/// User state notifier
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService _apiService;

  UserNotifier(this._apiService) : super(const AsyncValue.data(null)) {
    _loadCurrentUser();
  }

  /// Load current user
  Future<void> _loadCurrentUser() async {
    try {
      state = const AsyncValue.loading();
      final isAuth = await _apiService.isAuthenticated();
      
      if (isAuth) {
        final user = await _apiService.getCurrentUser();
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Register new user
  Future<bool> register({
    required String phone,
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final request = RegisterRequest(
        phone: phone,
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
      
      final user = await _apiService.register(request);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile(Farmer farmer) async {
    try {
      // Call API to update
      await _apiService.updateFarmerProfile(
        FarmerProfileRequest(
          location: farmer.location,
          district: farmer.district,
          crops: farmer.crops,
          farmSizeAcres: farmer.farmSizeAcres,
        ),
      );
      
      // Reload user
      await _loadCurrentUser();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _apiService.logout();
    state = const AsyncValue.data(null);
  }
}

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(const AsyncValue.data(false)) {
    _checkAuthStatus();
  }

  /// Check if user is authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _apiService.isAuthenticated();
      state = AsyncValue.data(isAuth);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Login user
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final request = LoginRequest(phone: phone, password: password);
      await _apiService.login(request);
      
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiService.logout();
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Refresh token
  Future<void> refreshToken() async {
    try {
      await _apiService.refreshToken();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// ==================== PEST REPORTS STATE ====================

/// Pest reports provider
final pestReportsProvider = FutureProvider<List<PestReport>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPestReports();
});

/// Submit pest report provider
final submitPestReportProvider =
    FutureProvider.family<PestReport, PestReportRequest>((ref, request) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.submitPestReport(request);
});

// ==================== CROP PRICES STATE ====================

/// Crop prices provider
final cropPricesProvider = FutureProvider.family<List<CropPrice>, String>(
  (ref, location) async {
    final apiService = ref.watch(apiServiceProvider);
    return apiService.getCropPrices(location: location);
  },
);

// ==================== APP STATE ====================

/// Overall app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(ref);
});

class AppState {
  final bool isAuthenticated;
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  AppState({
    this.isAuthenticated = false,
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  AppState copyWith({
    bool? isAuthenticated,
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  final Ref _ref;

  AppStateNotifier(this._ref) : super(AppState()) {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final isAuth = _ref.read(authStateProvider).value ?? false;
      final user = _ref.read(currentUserProvider).value;
      
      state = state.copyWith(
        isAuthenticated: isAuth,
        currentUser: user,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await _ref.read(authStateProvider.notifier).login(
        phone: phone,
        password: password,
      );
      
      final user = await _ref.read(apiServiceProvider).getCurrentUser();
      
      state = state.copyWith(
        isAuthenticated: true,
        currentUser: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _ref.read(authStateProvider.notifier).logout();
      state = AppState();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> register({
    required String phone,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await _ref.read(currentUserProvider.notifier).register(
        phone: phone,
        email: email,
        password: password,
        fullName: fullName,
        role: UserRole.farmer,
      );
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}

// ==================== LOCAL STORAGE ====================

import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service for offline data
class LocalStorageService {
  static const String _farmerKey = 'farmer_profile';
  static const String _pricesKey = 'crop_prices';

  static Future<void> saveFarmerProfile(Farmer farmer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_farmerKey, farmer.toString());
  }

  static Future<Farmer?> getFarmerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_farmerKey);
    // Parse farmer data
    return null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
