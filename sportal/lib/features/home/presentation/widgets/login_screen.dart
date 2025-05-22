// ignore_for_file: deprecated_member_use, duplicate_ignore, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportal/core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final AppTheme theme;
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onForgotPasswordPressed;

  const LoginScreen({
    super.key,
    required this.theme,
    this.onSignUpPressed,
    this.onForgotPasswordPressed,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[200]),
                const SizedBox(width: 12),
                Expanded(child: Text('Login failed: ${e.toString()}')),
              ],
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      // This will dismiss the keyboard when tapping anywhere outside text fields
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildMainContent(theme, size),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(AppTheme theme, Size size) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 1),

                    // Logo/Header
                    _buildAnimatedLogo(theme),
                    const SizedBox(height: 40),

                    // Form
                    Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Field
                            _buildEmailField(theme),
                            const SizedBox(height: 20),

                            // Password Field
                            _buildPasswordField(theme),
                            const SizedBox(height: 10),

                            // Remember Me & Forgot Password
                            _buildRememberMeRow(theme),
                            const SizedBox(height: 25),

                            // Login Button
                            _buildLoginButton(theme),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Divider
                    _buildDivider(theme),
                    const SizedBox(height: 30),

                    // Social Login Buttons
                    _buildSocialLoginButtons(theme),
                    const SizedBox(height: 30),

                    // Sign Up Prompt
                    _buildSignUpPrompt(theme),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(AppTheme theme) {
    return Column(
      children: [
        // Animated logo container
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutBack,
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // ignore: deprecated_member_use
                theme.primaryColor.withOpacity(0.2),
                // ignore: deprecated_member_use
                theme.primaryColor.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.lock_person, size: 40, color: theme.primaryColor),
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: theme.primaryTextColor,
            height: 1.3,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Login to continue to your account',
          style: TextStyle(fontSize: 15, color: theme.secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildEmailField(AppTheme theme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      style: TextStyle(color: theme.primaryTextColor, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Email address',
        hintStyle: TextStyle(color: theme.secondaryTextColor.withOpacity(0.7)),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: theme.secondaryTextColor.withOpacity(0.7),
        ),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.secondaryTextColor.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(AppTheme theme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      style: TextStyle(color: theme.primaryTextColor, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: theme.secondaryTextColor.withOpacity(0.7)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: theme.secondaryTextColor.withOpacity(0.7),
        ),
        suffixIcon: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              key: ValueKey<bool>(_obscurePassword),
              color: theme.secondaryTextColor.withOpacity(0.5),
            ),
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.secondaryTextColor.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onFieldSubmitted: (_) => _submitForm(),
    );
  }

  Widget _buildRememberMeRow(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: theme.secondaryTextColor.withOpacity(
                  0.5,
                ),
              ),
              child: Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() => _rememberMe = value ?? false);
                  },
                  activeColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            Text(
              'Remember me',
              style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
            ),
          ],
        ),
        TextButton(
          onPressed: widget.onForgotPasswordPressed,
          child: Text(
            'Forgot password?',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AppTheme theme) {
    return SizedBox(
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              _isLoading
                  ? []
                  : [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.buttonTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child:
              _isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(theme.buttonTextColor),
                    ),
                  )
                  : Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildDivider(AppTheme theme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.secondaryTextColor.withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or continue with',
            style: TextStyle(color: theme.secondaryTextColor, fontSize: 13),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.secondaryTextColor.withOpacity(0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () {},
          color: const Color(0xFFDB4437),
          iconSize: 26,
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: Icons.facebook,
          onPressed: () {},
          color: const Color(0xFF4267B2),
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: Icons.apple,
          onPressed: () {},
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    double iconSize = 24,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.theme.secondaryTextColor.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
        ),
        GestureDetector(
          onTap: _isLoading ? null : widget.onSignUpPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        _isLoading
                            ? Colors.transparent
                            : theme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color:
                      _isLoading
                          ? theme.secondaryTextColor
                          : theme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
