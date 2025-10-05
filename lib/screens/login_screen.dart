import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/feedback.dart' as ui_feedback;
import '../ui/responsive.dart';
import '../data/api_service.dart';
import '../data/session.dart';
import 'home_screen.dart';

/// Login screen for UAGro Carnet App
/// Handles authentication with institutional email and matricula
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _matriculaController = TextEditingController();
  
  bool _isLoading = false;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _checkExistingSession();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  /// Check if there's an existing valid session and auto-login
  Future<void> _checkExistingSession() async {
    try {
      final sessionData = await Session.getSessionData();
      if (sessionData != null) {
        // Set the token and try to validate by fetching carnet
        setState(() => _isLoading = true);
        
        if (sessionData.token != null) {
          _apiService.setAuthToken(sessionData.token);
          
          try {
            // Validate token by trying to fetch carnet
            await _apiService.fetchCarnetByMatricula(sessionData.matricula);
            
            // If successful, navigate to home
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          } catch (e) {
            // Token is invalid, clear session
            await Session.clearSession();
            _apiService.logout();
          }
        }
        
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ui_feedback.Feedback.showErr(context, 'Error verificando sesión: ${e.toString()}');
      }
    }
  }

  /// Handle login form submission
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim().toLowerCase();
      final matricula = _matriculaController.text.trim();

      // Call login API
      final result = await _apiService.login(email, matricula);
      
      if (result != null && result.containsKey('token')) {
        // Save session data including token
        await Session.saveSessionData(
          email: email,
          matricula: matricula,
          token: result['token'],
        );

        if (mounted) {
          ui_feedback.Feedback.showOk(context, 'Bienvenido a UAGro Carnet');
          
          // Navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ui_feedback.Feedback.showErr(context, 'Credenciales inválidas. Verifica tu email y matrícula.');
        }
      }
    } catch (e) {
      if (mounted) {
        ui_feedback.Feedback.showErr(context, 'Error de conexión. Intenta nuevamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UAgro.backgroundLight,
      body: Stack(
        children: [
          _buildLoginForm(),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // UAGro Logo and Title
                  _buildHeader(),
                  
                  const SizedBox(height: 40),
                  
                  // Email Field
                  _buildEmailField(),
                  
                  const SizedBox(height: 16),
                  
                  // Matricula Field
                  _buildMatriculaField(),
                  
                  const SizedBox(height: 32),
                  
                  // Login Button
                  _buildLoginButton(),
                  
                  const SizedBox(height: 24),
                  
                  // Information
                  _buildInfoText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: UAgro.primaryBlue,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.school,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'UAGro',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: UAgro.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Carnet Alumno',
          style: TextStyle(
            fontSize: 18,
            color: UAgro.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Institucional',
        hintText: 'matricula@uagro.mx',
        prefixIcon: Icon(Icons.email_outlined, color: UAgro.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: UAgro.primaryBlue, width: 2),
        ),
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'El correo es requerido';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
          return 'Ingresa un correo válido';
        }
        return null;
      },
    );
  }

  Widget _buildMatriculaField() {
    return TextFormField(
      controller: _matriculaController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Matrícula',
        hintText: 'Ingresa tu matrícula',
        prefixIcon: Icon(Icons.badge_outlined, color: UAgro.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: UAgro.primaryBlue, width: 2),
        ),
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'La matrícula es requerida';
        }
        if (value!.trim().length < 3) {
          return 'La matrícula debe tener al menos 3 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: UAgro.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UAgro.secondaryGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UAgro.secondaryGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: UAgro.secondaryGold,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tu correo institucional y matrícula para acceder a tu carnet digital.',
            style: TextStyle(
              color: UAgro.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
