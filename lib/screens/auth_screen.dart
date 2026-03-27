import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const AuthScreen({super.key, required this.onAuthSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _authService = AuthService();

  // Login
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Register
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmController = TextEditingController();

  bool _isLoading = false;
  bool _obscureLogin = true;
  bool _obscureRegister = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = await _authService.login(
      _loginEmailController.text.trim(),
      _loginPasswordController.text,
    );
    setState(() => _isLoading = false);

    if (user != null) {
      widget.onAuthSuccess();
    } else {
      final provider = context.read<RestaurantProvider>();
      final l = AppLocalizations(provider.currentLanguage);
      _showError(l.get('auth_login_error'));
    }
  }

  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;

    if (_registerPasswordController.text != _registerConfirmController.text) {
      final provider = context.read<RestaurantProvider>();
      final l = AppLocalizations(provider.currentLanguage);
      _showError(l.get('auth_password_mismatch'));
      return;
    }

    setState(() => _isLoading = true);
    final user = await _authService.register(
      _registerNameController.text.trim(),
      _registerEmailController.text.trim(),
      _registerPasswordController.text,
    );
    setState(() => _isLoading = false);

    if (user != null) {
      widget.onAuthSuccess();
    } else {
      final provider = context.read<RestaurantProvider>();
      final l = AppLocalizations(provider.currentLanguage);
      _showError(l.get('auth_register_error'));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'LezzetBul',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lezzeti ke\u015ffet, tad\u0131na bak!',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        isDark ? Colors.white60 : AppConstants.textSecondary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: l.get('auth_login')),
                      Tab(text: l.get('auth_register')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tab views
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(isDark, l),
                      _buildRegisterForm(isDark, l),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(bool isDark, AppLocalizations l) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _loginEmailController,
            hint: l.get('auth_email'),
            icon: Icons.email_outlined,
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.get('auth_email_required');
              if (!v.contains('@')) return l.get('auth_email_invalid');
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _loginPasswordController,
            hint: l.get('auth_password'),
            icon: Icons.lock_outline,
            isDark: isDark,
            obscure: _obscureLogin,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLogin ? Icons.visibility_off : Icons.visibility,
                color: isDark ? Colors.white38 : AppConstants.textSecondary,
                size: 20,
              ),
              onPressed: () => setState(() => _obscureLogin = !_obscureLogin),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l.get('auth_password_required');
              return null;
            },
          ),
          const SizedBox(height: 32),
          _buildActionButton(l.get('auth_login'), _handleLogin, isDark),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(bool isDark, AppLocalizations l) {
    return Form(
      key: _registerFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(
              controller: _registerNameController,
              hint: l.get('auth_name'),
              icon: Icons.person_outline,
              isDark: isDark,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.get('auth_name_required');
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registerEmailController,
              hint: l.get('auth_email'),
              icon: Icons.email_outlined,
              isDark: isDark,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.get('auth_email_required');
                if (!v.contains('@')) return l.get('auth_email_invalid');
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registerPasswordController,
              hint: l.get('auth_password'),
              icon: Icons.lock_outline,
              isDark: isDark,
              obscure: _obscureRegister,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureRegister ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.white38 : AppConstants.textSecondary,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureRegister = !_obscureRegister),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l.get('auth_password_required');
                if (v.length < 4) return l.get('auth_password_short');
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registerConfirmController,
              hint: l.get('auth_password_confirm'),
              icon: Icons.lock_outline,
              isDark: isDark,
              obscure: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.white38 : AppConstants.textSecondary,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l.get('auth_password_confirm_required');
                return null;
              },
            ),
            const SizedBox(height: 32),
            _buildActionButton(l.get('auth_register'), _handleRegister, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: isDark ? Colors.white38 : AppConstants.textSecondary),
        prefixIcon: Icon(icon,
            color: isDark ? Colors.white38 : AppConstants.textSecondary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildActionButton(
      String label, VoidCallback onPressed, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
