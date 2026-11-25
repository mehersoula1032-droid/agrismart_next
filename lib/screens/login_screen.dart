import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/app_strings.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(
    text: '',
  );
  final _passwordController = TextEditingController(text: '');
  final _nameController = TextEditingController();

  bool _isObscure = true;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = AppStrings.of(context);
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    bool success = false;

    if (_isSignUp) {
      success = await authProvider.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
    } else {
      success = await authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (!mounted) return;

    if (success) {
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      }
    } else {
      final error = authProvider.errorMessage ?? s.tr('generic_error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final s = AppStrings.of(context);
    final resetEmailController = TextEditingController(
      text: _emailController.text,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          s.tr('reset_password_title'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF276738),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.tr('reset_password_desc'),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: s.tr('email'),
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF276738),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF276738),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final email = resetEmailController.text.trim();
              Navigator.pop(dialogContext);

              if (email.isEmpty) return;

              final authProvider = context.read<AuthProvider>();
              final success = await authProvider.sendPasswordResetEmail(email);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? s.tr('reset_email_sent')
                        : (authProvider.errorMessage ??
                        s.tr('reset_email_error')),
                  ),
                  backgroundColor: success
                      ? const Color(0xFF2B362B)
                      : Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(s.tr('send')),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, Color green) {
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 20, color: Color(0xFF276738)),
          const SizedBox(width: 8),
          SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: green,
              selectedForegroundColor: Colors.white,
              foregroundColor: const Color(0xFF1B4332),
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment<String>(
                value: 'ar',
                label: Text('العربية'),
              ),
              ButtonSegment<String>(
                value: 'fr',
                label: Text('FR'),
              ),
              ButtonSegment<String>(
                value: 'en',
                label: Text('EN'),
              ),
            ],
            selected: <String>{currentLang},
            onSelectionChanged: (Set<String> newSelection) {
              langProvider.setLanguage(newSelection.first);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    const green = Color(0xFF276738);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // Sélecteur de langue (AR / FR / EN)
                  _buildLanguageSelector(context, green),

                  const SizedBox(height: 24),

                  // Tractor Logo Icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF3E8),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    s.tr('app_name'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4332),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 36),

                  if (_isSignUp) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: s.tr('farm_name'),
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: green,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? s.tr('enter_name')
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email Input Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: s.tr('email'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: green, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: green,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return s.tr('enter_email');
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(v.trim())) {
                        return s.tr('invalid_email');
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Input Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: s.tr('password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: green,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return s.tr('enter_password');
                      }
                      if (v.length < 6) return s.tr('password_min_6');
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        _isSignUp
                            ? s.tr('signup_title')
                            : s.tr('login_title'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Forgot Password Button
                  if (!_isSignUp)
                    TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: Text(
                        s.tr('forgot_password'),
                        style: const TextStyle(
                          color: green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Toggle Sign Up / Login
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: _isSignUp
                              ? s.tr('already_have_account')
                              : s.tr('no_account'),
                          style: TextStyle(color: Colors.grey.shade700),
                          children: [
                            TextSpan(
                              text: _isSignUp
                                  ? s.tr('login_title')
                                  : s.tr('signup_title'),
                              style: const TextStyle(
                                color: green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}