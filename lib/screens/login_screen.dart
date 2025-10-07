// Login screen for UAGro student app
// Handles email and matricula authentication with carnet validation

import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/responsive.dart';
import '../ui/feedback.dart';
import '../data/api_service.dart';
import '../data/session.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _matriculaController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  /// Check if user already has a valid session
  Future<void> _checkExistingSession() async {
    if (await Session.isLoggedIn() && !(await Session.isSessionExpired())) {
      final email = await Session.getEmail();
      final matricula = await Session.getMatricula();
      
      if (email != null && matricula != null) {
        // Silent revalidation of carnet
        final carnet = await ApiService.fetchCarnetByMatricula(matricula);
        if (carnet != null && 
            ApiService.validateEmailMatch(email, carnet['correo'] ?? '')) {
          // Session is still valid, navigate to home
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
          return;
        } else {
          // Session invalid, clear it
          await Session.clear();
        }
      }
    }
  }

  /// Handle login button press
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final matricula = _matriculaController.text.trim();

    setState(() {
      _isLoading = true;
    });

    UAGroFeedback.showBusyOverlay(context, 'Validando credenciales...');

    try {
      // Fetch carnet with double attempt
      final carnet = await ApiService.fetchCarnetByMatricula(matricula);
      
      if (mounted) {
        UAGroFeedback.hideBusyOverlay(context);
      }

      if (carnet == null) {
        if (mounted) {
          UAGroFeedback.showErr(context, 'Matrícula no encontrada en el sistema');
        }
        return;
      }

      // Validate email match
      final carnetEmail = carnet['correo'] ?? '';
      if (!ApiService.validateEmailMatch(email, carnetEmail)) {
        if (mounted) {
          UAGroFeedback.showErr(context, 'Correo o matrícula no coinciden');
        }
        return;
      }

      // Save session
      final sessionSaved = await Session.save(email, matricula);
      if (!sessionSaved) {
        if (mounted) {
          UAGroFeedback.showErr(context, 'Error al guardar la sesión');
        }
        return;
      }

      // Success
      if (mounted) {
        UAGroFeedback.showOk(context, 'Bienvenido ${carnet['nombre'] ?? 'Estudiante'}');
        
        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }

    } catch (e) {
      if (mounted) {
        UAGroFeedback.hideBusyOverlay(context);
        UAGroFeedback.showErr(context, 'Error de conexión. Intenta nuevamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: UAGroColors.background,
      body: SafeArea(
        child: Responsive.responsiveContainer(
          context: context,
          maxWidth: 400,
          child: SingleChildScrollView(
            child: Padding(
              padding: Responsive.getResponsivePadding(context),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: UAGroConstants.paddingXLarge),
                    
                    // UAGro Logo placeholder and title
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: UAGroColors.primary,
                        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 48,
                              color: UAGroColors.textOnPrimary,
                            ),
                            SizedBox(height: UAGroConstants.paddingSmall),
                            Text(
                              'UAGro',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: UAGroColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingLarge),
                    
                    // App title
                    Text(
                      UAGroConstants.appName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: UAGroColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isMobile(context) ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingSmall),
                    
                    Text(
                      UAGroConstants.institutionName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: UAGroColors.textSecondary,
                        fontSize: Responsive.isMobile(context) ? 14 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingXLarge),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        hintText: 'tu.correo@uagro.mx',
                        prefixIcon: Icon(
                          Icons.email,
                          color: UAGroColors.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu correo electrónico';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingMedium),
                    
                    // Matricula field
                    TextFormField(
                      controller: _matriculaController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Matrícula',
                        hintText: 'Tu matrícula estudiantil',
                        prefixIcon: Icon(
                          Icons.badge,
                          color: UAGroColors.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu matrícula';
                        }
                        if (value.trim().length < 3) {
                          return 'La matrícula debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingXLarge),
                    
                    // Login button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UAGroColors.primary,
                          foregroundColor: UAGroColors.textOnPrimary,
                          elevation: _isLoading ? 0 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    UAGroColors.textOnPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Entrar',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: UAGroColors.textOnPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingLarge),
                    
                    // Help text
                    Container(
                      padding: EdgeInsets.all(UAGroConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: UAGroColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
                        border: Border.all(
                          color: UAGroColors.info.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                size: UAGroConstants.iconSmall,
                                color: UAGroColors.info,
                              ),
                              SizedBox(width: UAGroConstants.paddingSmall),
                              Text(
                                'Información de acceso',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: UAGroColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: UAGroConstants.paddingSmall),
                          Text(
                            'Ingresa el correo electrónico registrado en tu carnet estudiantil y tu matrícula para acceder.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: UAGroColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: UAGroConstants.paddingXLarge),
                    
                    // Footer
                    Text(
                      'Versión ${UAGroConstants.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: UAGroColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
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