// ignore_for_file: deprecated_member_use, duplicate_ignore, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportal/core/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  final AppTheme theme;
  final VoidCallback? onLoginPressed;

  const RegistrationScreen({
    super.key,
    required this.theme,
    this.onLoginPressed,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Please accept terms and conditions'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushNamed(context, '/dashboard');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[200]),
                const SizedBox(width: 12),
                const Expanded(child: Text('Registration successful!')),
              ],
            ),
          ),
        );
      }
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
                Expanded(child: Text('Registration failed: ${e.toString()}')),
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
      onTap: () => FocusScope.of(context).unfocus(),
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
                    const SizedBox(height: 30),

                    // Form
                    Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Name Field
                            _buildNameField(theme),
                            const SizedBox(height: 20),

                            // Email Field
                            _buildEmailField(theme),
                            const SizedBox(height: 20),

                            // Password Field
                            _buildPasswordField(theme),
                            const SizedBox(height: 20),

                            // Confirm Password Field
                            _buildConfirmPasswordField(theme),
                            const SizedBox(height: 15),

                            // Terms Checkbox
                            _buildTermsCheckbox(theme),
                            const SizedBox(height: 25),

                            // Register Button
                            _buildRegisterButton(theme),
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

                    // Login Prompt
                    _buildLoginPrompt(theme),
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
                theme.primaryColor.withOpacity(0.2),
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
          child: Icon(Icons.person_add, size: 40, color: theme.primaryColor),
        ),
        const SizedBox(height: 20),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: theme.primaryTextColor,
            height: 1.3,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Fill in your details to get started',
          style: TextStyle(fontSize: 15, color: theme.secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildNameField(AppTheme theme) {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      style: TextStyle(color: theme.primaryTextColor, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Full name',
        hintStyle: TextStyle(color: theme.secondaryTextColor.withOpacity(0.7)),
        prefixIcon: Icon(
          Icons.person_outline,
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
          return 'Please enter your name';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
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
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.newPassword],
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
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain at least one number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(AppTheme theme) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      style: TextStyle(color: theme.primaryTextColor, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Confirm password',
        hintStyle: TextStyle(color: theme.secondaryTextColor.withOpacity(0.7)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: theme.secondaryTextColor.withOpacity(0.7),
        ),
        suffixIcon: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              key: ValueKey<bool>(_obscureConfirmPassword),
              color: theme.secondaryTextColor.withOpacity(0.5),
            ),
          ),
          onPressed: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
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
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      onFieldSubmitted: (_) => _submitForm(),
    );
  }

  Widget _buildTermsCheckbox(AppTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: theme.secondaryTextColor.withOpacity(0.5),
          ),
          child: Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() => _acceptTerms = value ?? false);
              },
              activeColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: theme.secondaryTextColor,
                  fontSize: 13,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Show terms dialog
                          },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Show privacy policy dialog
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AppTheme theme) {
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
                    'Register',
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
            'Or sign up with',
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

  Widget _buildLoginPrompt(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
        ),
        GestureDetector(
          onTap:
              _isLoading
                  ? null
                  : widget.onLoginPressed ?? () => Navigator.pop(context),
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
                'Login',
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
