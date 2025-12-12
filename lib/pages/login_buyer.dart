// lib/pages/login_buyer.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_service.dart';
import '/pages/buyer_dashboard.dart';
import '/pages/createbuyer_account.dart';

class LoginBuyerPage extends StatefulWidget {
  const LoginBuyerPage({super.key});

  @override
  State<LoginBuyerPage> createState() => _LoginBuyerPageState();
}

class _LoginBuyerPageState extends State<LoginBuyerPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State and Service instance declarations
  final SupabaseService _supabaseService = SupabaseService();
  bool _obscurePassword = true; 
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Attempt to sign in with Supabase Auth
      final AuthResponse response = await _supabaseService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // 2. Check Auth success and verify role
      if (response.user != null) {
        final userId = response.user!.id;
        final role = await _supabaseService.getUserRole(userId);

        if (!mounted) return;

        // 3. Verify the role is correct for this login page
        if (role == 'Buyer' || role == 'Wholesaler/Buyer') {
          // Successful login and correct role, navigate to Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BuyerDashboardPage()),
          );
        } else {
          // Deny login if they are a Farmer trying to use the Buyer login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login denied: Your account is registered as a Farmer. Please use the correct login page.')),
          );
          await _supabaseService.signOut();
        }
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    } catch (e) {
      // Catches the PostgrestException from getUserRole (missing profile)
      String errorMessage = 'An unexpected error occurred.';
      if (e is PostgrestException && e.message.contains('Profile data missing')) {
        errorMessage = 'Login failed. Account profile is incomplete.';
        await _supabaseService.signOut();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  void _handleSocialLogin(String provider) {
    print('Login with $provider');
    // Placeholder for actual social login implementation
    // For now, redirecting to Dashboard (This should be removed in production)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BuyerDashboardPage()),
    );
  }

  // Helper widget for social buttons (unchanged)
  Widget _buildSocialButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Helper widget for text field
    Widget buildTextField({
      required TextEditingController controller,
      required String hint,
      bool obscureText = false,
      Widget? suffixIcon,
      String? Function(String?)? validator,
    }) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress, // Default to email type
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F3F1),
              Color(0xFFA8D5C5),
              Color(0xFF6B9B87),
              Color(0xFF3B5F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Log In Wholesaler/Buyer', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 60),
                    // Title Section
                    Center(
                      child: Column(
                        children: const [
                          Text('Welcome Back!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 8),
                          Text('Login as Wholesaler / Buyer', style: TextStyle(fontSize: 16, color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Email Address Field
                    const Text('Email Address', style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    buildTextField(
                      controller: _emailController,
                      hint: 'Enter Your Email Address',
                      validator: (value) {
                        if (value == null || !value.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    const Text('Password', style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    buildTextField(
                      controller: _passwordController,
                      hint: 'Enter Your Password',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () { setState(() { _obscurePassword = !_obscurePassword; }); },
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () { print('Forgot Password'); },
                        child: const Text('Forgot Password?', style: TextStyle(color: Colors.black87, fontSize: 13, decoration: TextDecoration.underline)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button (Updated for loading state)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5F3D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        // CORRECTED SYNTAX: Added parentheses around the ternary expression
                        child: (_isLoading
                            ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)))
                            : const Text('LOG IN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2))),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Or Log in with
                    const Center(child: Text('Or Log in with', style: TextStyle(fontSize: 14, color: Colors.white))),
                    const SizedBox(height: 20),
                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(onTap: () => _handleSocialLogin('Google'), child: Image.asset('assets/logo_google.png', width: 30, height: 30)),
                        const SizedBox(width: 20),
                        _buildSocialButton(onTap: () => _handleSocialLogin('Apple'), child: const Icon(Icons.apple, size: 35, color: Colors.black)),
                        const SizedBox(width: 20),
                        _buildSocialButton(onTap: () => _handleSocialLogin('Facebook'), child: Image.asset('assets/logo_facebook.png', width: 30, height: 30)),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Create Account
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateBuyerAccountPage()));
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(text: 'Create New Account', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}