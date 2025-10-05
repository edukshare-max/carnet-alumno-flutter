import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/feedback.dart' as ui_feedback;
import '../ui/responsive.dart';
import '../ui/section_card.dart';
import '../data/api_service.dart';
import '../data/session.dart';
import 'login_screen.dart';

/// Citas (Appointments) view screen
/// Displays student appointments with refresh functionality
class CitasView extends StatefulWidget {
  final String matricula;
  final ApiService apiService;

  const CitasView({
    Key? key,
    required this.matricula,
    required this.apiService,
  }) : super(key: key);

  @override
  State<CitasView> createState() => _CitasViewState();
}

class _CitasViewState extends State<CitasView> {
  List<Map<String, dynamic>>? _citas;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  /// Load appointments for the student
  Future<void> _loadCitas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get token from session
      final token = await Session.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final citas = await widget.apiService.getMyCitas(token);
      
      if (mounted) {
        setState(() {
          _citas = citas;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Check for session expiration (401) 
        if (e.toString().contains('401') || e.toString().contains('Session expired')) {
          // Clear session and navigate to login
          await Session.clearSession();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
          return;
        }
        
        String errorMessage = 'Error al cargar las citas.';
        
        if (e is ApiException) {
          errorMessage = e.toString();
        } else {
          errorMessage = e.toString();
        }

        setState(() {
          _errorMessage = errorMessage;
          _isLoading = false;
        });
      }
    }
  }

  /// Refresh appointments
  Future<void> _refreshCitas() async {
    await _loadCitas();
    
    if (mounted && _errorMessage == null) {
      ui_feedback.Feedback.showSnackbar(
        context,
        'Citas actualizadas',
        type: ui_feedback.SnackbarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.responsiveScaffold(
      context: context,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshCitas,
        color: UAgro.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Mis Citas'),
      centerTitle: true,
      elevation: UAgro.elevationLow,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _isLoading ? null : _refreshCitas,
          tooltip: 'Actualizar',
        ),
      ],
    );
  }

  /// Build main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: Responsive.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(),
          
          const SizedBox(height: UAgro.spacingMedium),
          
          if (_isLoading)
            _buildLoadingCard()
          else if (_errorMessage != null)
            _buildErrorCard()
          else if (_citas == null || _citas!.isEmpty)
            _buildEmptyCard()
          else
            _buildCitasList(),
        ],
      ),
    );
  }

  /// Build header card with student info
  Widget _buildHeaderCard() {
    return SectionCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(UAgro.spacingSmall),
            decoration: BoxDecoration(
              color: UAgro.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UAgro.radiusSmall),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: UAgro.primaryBlue,
              size: 24,
            ),
          ),
          
          const SizedBox(width: UAgro.spacingMedium),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Citas Programadas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: UAgro.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Matrícula: ${widget.matricula}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: UAgro.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          if (_citas != null && _citas!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UAgro.spacingSmall,
                vertical: UAgro.spacingXSmall,
              ),
              decoration: BoxDecoration(
                color: UAgro.secondaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(UAgro.radiusSmall),
                border: Border.all(color: UAgro.secondaryGold.withOpacity(0.3)),
              ),
              child: Text(
                '${_citas!.length}',
                style: TextStyle(
                  color: UAgro.secondaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build loading card
  Widget _buildLoadingCard() {
    return SectionCard(
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(UAgro.primaryBlue),
          ),
          const SizedBox(height: UAgro.spacingMedium),
          Text(
            'Cargando citas...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UAgro.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build error card
  Widget _buildErrorCard() {
    return SectionCard(
      backgroundColor: UAgro.error.withOpacity(0.05),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: UAgro.error,
            size: 48,
          ),
          
          const SizedBox(height: UAgro.spacingMedium),
          
          Text(
            'Error al cargar las citas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: UAgro.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: UAgro.spacingSmall),
          
          Text(
            _errorMessage ?? 'Error desconocido',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UAgro.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: UAgro.spacingMedium),
          
          ElevatedButton.icon(
            onPressed: _loadCitas,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: UAgro.error,
              foregroundColor: UAgro.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty citas card
  Widget _buildEmptyCard() {
    return SectionCard(
      backgroundColor: UAgro.lightGray.withOpacity(0.5),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            color: UAgro.textSecondary,
            size: 48,
          ),
          
          const SizedBox(height: UAgro.spacingMedium),
          
          Text(
            'Sin citas registradas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: UAgro.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: UAgro.spacingSmall),
          
          Text(
            'No tienes citas programadas en este momento.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UAgro.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: UAgro.spacingMedium),
          
          OutlinedButton.icon(
            onPressed: _refreshCitas,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  /// Build list of citas
  Widget _buildCitasList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary card
        _buildSummaryCard(),
        
        const SizedBox(height: UAgro.spacingMedium),
        
        // Filter options (if needed in the future)
        _buildFilterCard(),
        
        const SizedBox(height: UAgro.spacingMedium),
        
        // Citas list
        ..._citas!.asMap().entries.map((entry) {
          final index = entry.key;
          final cita = entry.value;
          
          return Column(
            children: [
              CitaCard(
                citaData: cita,
                margin: EdgeInsets.zero,
              ),
              if (index < _citas!.length - 1)
                const SizedBox(height: UAgro.spacingSmall),
            ],
          );
        }),
      ],
    );
  }

  /// Build summary card
  Widget _buildSummaryCard() {
    final totalCitas = _citas!.length;
    final citasActivas = _citas!.where((cita) {
      final estado = cita['estado']?.toString().toLowerCase() ?? '';
      return estado == 'confirmada' || estado == 'activa' || estado == 'pendiente';
    }).length;
    
    final citasCanceladas = _citas!.where((cita) {
      final estado = cita['estado']?.toString().toLowerCase() ?? '';
      return estado == 'cancelada';
    }).length;
    
    final citasCompletadas = _citas!.where((cita) {
      final estado = cita['estado']?.toString().toLowerCase() ?? '';
      return estado == 'completada';
    }).length;

    return SectionCard(
      title: 'Resumen de Citas',
      showDivider: true,
      child: ResponsiveRow(
        children: [
          _buildSummaryItem('Total', totalCitas, UAgro.primaryBlue),
          _buildSummaryItem('Activas', citasActivas, UAgro.success),
          _buildSummaryItem('Completadas', citasCompletadas, UAgro.info),
          _buildSummaryItem('Canceladas', citasCanceladas, UAgro.error),
        ],
      ),
    );
  }

  /// Build summary item
  Widget _buildSummaryItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: UAgro.spacingSmall,
          horizontal: UAgro.spacingXSmall,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(UAgro.radiusSmall),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: UAgro.spacingXSmall),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build filter card (placeholder for future filtering)
  Widget _buildFilterCard() {
    return SectionCard(
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: UAgro.textSecondary,
            size: 20,
          ),
          
          const SizedBox(width: UAgro.spacingSmall),
          
          Text(
            'Mostrando todas las citas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UAgro.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          const Spacer(),
          
          Text(
            '${_citas!.length} resultado${_citas!.length != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: UAgro.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}