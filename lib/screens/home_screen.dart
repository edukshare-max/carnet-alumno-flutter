import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/feedback.dart' as ui_feedback;
import '../ui/responsive.dart';
import '../ui/section_card.dart';
import '../data/api_service.dart';
import '../data/session.dart';
import 'login_screen.dart';
import 'carnet_view.dart';
import 'citas_view.dart';

/// Home screen for the UAGro Carnet App
/// Provides access to carnet search and appointments view
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _matriculaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  String? _userMatricula;
  String? _userEmail;
  Map<String, dynamic>? _carnetData;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadUserData();
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    super.dispose();
  }

  /// Load current user session data
  Future<void> _loadUserData() async {
    try {
      print('🔍 LOADING USER DATA - Starting...');
      final sessionData = await Session.getSessionData();
      print('🔍 SESSION DATA: $sessionData');
      print('🔍 TOKEN: ${sessionData?.token}');
      print('🔍 EMAIL: ${sessionData?.email}');
      print('🔍 MATRICULA: ${sessionData?.matricula}');
      
      if (sessionData != null && sessionData.token != null && mounted) {
        print('✅ SESSION VALID - Setting up user data');
        setState(() {
          _userMatricula = sessionData.matricula;
          _userEmail = sessionData.email;
        });
        
        // Set the auth token for API calls
        _apiService.setAuthToken(sessionData.token);
        
        // Pre-fill matricula field with user's own matricula
        _matriculaController.text = sessionData.matricula;
        
        // Load carnet data automatically
        _loadCarnetData(sessionData.token!);
      } else {
        print('❌ SESSION INVALID - Logging out');
        print('❌ sessionData: $sessionData');
        print('❌ sessionData?.token: ${sessionData?.token}');
        print('❌ mounted: $mounted');
        // No session or token, go back to login
        _logout();
      }
    } catch (e) {
      print('💥 ERROR LOADING USER DATA: $e');
      ui_feedback.Feedback.showErr(context, 'Error cargando datos de usuario: ${e.toString()}');
    }
  }

  /// Load carnet data using token
  Future<void> _loadCarnetData(String token) async {
    try {
      print('🔍 LOADING CARNET DATA - Starting with token: ${token.substring(0, 20)}...');
      final carnetData = await _apiService.getMyCarnet(token);
      print('🔍 CARNET DATA RESPONSE: $carnetData');
      
      if (carnetData != null && mounted) {
        print('✅ CARNET DATA VALID - Setting state');
        setState(() {
          _carnetData = carnetData;
        });
        print('✅ CARNET DATA STATE SET');
      } else {
        print('❌ CARNET DATA INVALID - carnetData: $carnetData, mounted: $mounted');
      }
    } catch (e) {
      print('💥 ERROR LOADING CARNET DATA: $e');
      print('💥 ERROR STACK: ${StackTrace.current}');
      print('Error loading carnet data: $e');
    }
  }

  /// Handle carnet search
  Future<void> _searchCarnet() async {
    setState(() => _isLoading = true);

    try {
      final token = await Session.getToken();
      if (token == null) {
        _logout();
        return;
      }

      final carnetData = await _apiService.getMyCarnet(token);
      
      if (carnetData != null && mounted) {
        setState(() {
          _carnetData = carnetData;
        });
        ui_feedback.Feedback.showOk(context, 'Carnet encontrado');
      } else {
        ui_feedback.Feedback.showErr(context, 'No se encontró el carnet');
      }
    } catch (e) {
      if (mounted) {
        ui_feedback.Feedback.showErr(context, e.toString());
        
        // If authentication error, logout
        if (e.toString().contains('expirada') || e.toString().contains('autenticado')) {
          _logout();
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Navigate to appointments view
  void _viewCitas() {
    if (_userMatricula == null) {
      ui_feedback.Feedback.showErr(context, 'Error: No hay matrícula de usuario');
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CitasView(
          matricula: _userMatricula!,
          apiService: _apiService,
        ),
      ),
    );
  }

  /// Logout and return to login screen
  Future<void> _logout() async {
    try {
      await Session.clearSession();
      _apiService.logout();
      
      if (mounted) {
        // Show logout confirmation
        ui_feedback.Feedback.showOk(context, 'Sesión cerrada');
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ui_feedback.Feedback.showErr(context, 'Error cerrando sesión: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      print('🔍 BUILD - Starting HomeScreen build');
      print('🔍 BUILD - _carnetData: ${_carnetData != null ? 'HAS_DATA' : 'NULL'}');
      print('🔍 BUILD - _userMatricula: $_userMatricula');
      print('🔍 BUILD - _userEmail: $_userEmail');
      
      return Scaffold(
      backgroundColor: UAgro.backgroundLight,
      appBar: AppBar(
        title: Text(
          'UAGro Carnet',
          style: TextStyle(
            color: UAgro.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.account_circle, color: UAgro.primaryBlue),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            _buildContent(),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
    } catch (e, stackTrace) {
      print('💥 BUILD ERROR: $e');
      print('💥 BUILD STACK: $stackTrace');
      
      // Return a simple error widget instead of crashing
      return Scaffold(
        appBar: AppBar(
          title: const Text('UAGro Carnet - Error'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error cargando la aplicación'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Refresh carnet and citas data
  Future<void> _refreshData() async {
    final token = await Session.getToken();
    if (token != null) {
      await _loadCarnetData(token);
    } else {
      _logout();
    }
  }

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section
                _buildWelcomeSection(),
                
                const SizedBox(height: 24),
                
                // Search Carnet Section
                _buildSearchSection(),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                _buildActionButtons(),
                
                const SizedBox(height: 24),
                
                // Carnet Display (if loaded)
                if (_carnetData != null) _buildCarnetDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SectionCard(
      title: 'Bienvenido',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_userEmail != null) ...[
            Text(
              'Usuario: $_userEmail',
              style: TextStyle(
                fontSize: 16,
                color: UAgro.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (_userMatricula != null) ...[
            Text(
              'Matrícula: $_userMatricula',
              style: TextStyle(
                fontSize: 16,
                color: UAgro.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return SectionCard(
      title: 'Buscar Carnet',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
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
                if (value!.trim() != _userMatricula) {
                  return 'Solo puedes consultar tu propia matrícula';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _searchCarnet,
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UAgro.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _viewCitas,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Ver Citas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: UAgro.secondaryGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarnetDisplay() {
    // Safe null checks before creating CarnetView
    final carnetData = _carnetData;
    final matricula = _userMatricula;
    
    if (carnetData == null || matricula == null) {
      print('⚠️ BUILD CARNET DISPLAY - Missing data: carnetData=$carnetData, matricula=$matricula');
      return const SizedBox.shrink(); // Return empty widget instead of crashing
    }
    
    print('✅ BUILD CARNET DISPLAY - Creating CarnetView');
    return CarnetView(
      carnetData: carnetData,
      matricula: matricula,
    );
  }
}
