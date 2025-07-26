import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_login_buttons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.whenOrNull(
                authenticated: (user) {
                  context.go('/home');
                },
                error: (message) {
                  _showErrorMessage(context, message);
                },
              );
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Title
                        Text(
                          'Hoşgeldiniz',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Tempus varius a vitae interdum id tortor\nelementum tristique eleifend at.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Name Field
                        AuthTextField(
                          controller: _nameController,
                          label: 'Ad Soyad',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ad soyad boş olamaz';
                            }
                            if (value.trim().split(' ').length < 2) {
                              return 'Ad ve soyadınızı girin';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Email Field
                        AuthTextField(
                          controller: _emailController,
                          label: 'E-Posta',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-posta adresi boş olamaz';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Geçerli bir e-posta adresi girin';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Password Field
                        AuthTextField(
                          controller: _passwordController,
                          label: 'Şifre',
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Şifre boş olamaz';
                            }
                            if (value.length < 8) {
                              return 'Şifre en az 8 karakter olmalıdır';
                            }
                            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                              return 'Şifre büyük harf, küçük harf ve rakam içermelidir';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Confirm Password Field
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Şifre Tekrar',
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Şifre tekrarı boş olamaz';
                            }
                            if (value != _passwordController.text) {
                              return 'Şifreler eşleşmiyor';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Terms and Conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFE53E3E),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Kullanıcı sözleşmesini '),
                                      TextSpan(
                                        text: 'okudum ve kabul ediyorum',
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: '. Bu sözleşmeyi okuyarak devam ediniz lütfen.'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Register Button
                        PrimaryButton(
                          onPressed: (isLoading || !_acceptTerms) ? null : _handleRegister,
                          isLoading: isLoading,
                          child: const Text('Şimdi Kaydol'),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Social Login Buttons
                        const SocialLoginButtons(),
                        
                        const SizedBox(height: 32),
                        
                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Zaten bir hesabın var mı? ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/login');
                              },
                              child: const Text(
                                'Giriş Yap!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        _showErrorMessage(context, 'Kullanıcı sözleşmesini kabul etmelisiniz');
        return;
      }
      
      context.read<AuthBloc>().add(
        AuthEvent.registerRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SelectableText.rich(
          TextSpan(
            text: message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }
} 