// lib/utils/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
// Initialize the Supabase client
final supabase = Supabase.instance.client;

class SupabaseService {
  // --- AUTHENTICATION & SIGN UP ---
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String location,
    required String role,
  }) async {
    final AuthResponse response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      await supabase.from('profiles').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'farm_location': location, 
        'role': role,
      });
    }

    return response;
  }

  // --- LOGIN ---
  Future<AuthResponse> signIn({required String email, required String password}) {
    return supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // --- ROLE MANAGEMENT ---
  Future<String> getUserRole(String userId) async {
    final List<Map<String, dynamic>> response = await supabase
        .from('profiles')
        .select('role')
        .eq('id', userId);

    if (response.isEmpty) {
      throw const PostgrestException(
        message: 'Profile data missing. Please complete registration.',
        code: '404', 
        details: 'User profile not found in database.',
        hint: null
      );
    }

    return response.first['role'] as String? ?? 'Unknown'; 
  }
}