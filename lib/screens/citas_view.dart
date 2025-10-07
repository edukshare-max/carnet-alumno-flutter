// Citas view for UAGro student app
// Displays student appointments with refresh functionality

import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/feedback.dart';
import '../ui/section_card.dart';
import '../data/api_service.dart';

class CitasView extends StatefulWidget {
  final String matricula;

  const CitasView({
    super.key,
    required this.matricula,
  });

  @override
  State<CitasView> createState() => _CitasViewState();
}

class _CitasViewState extends State<CitasView> {
  List<Map<String, dynamic>> _citas = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  /// Load citas data from API
  Future<void> _loadCitas({bool isRefresh = false}) async {
    if (!mounted) return;

    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else {
        _isLoading = true;
      }
      _errorMessage = null;
    });

    try {
      final citas = await ApiService.fetchCitas(widget.matricula);
      
      if (!mounted) return;

      setState(() {
        _citas = citas;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error de conexión. Verifica tu internet e intenta nuevamente.';
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    await _loadCitas(isRefresh: true);
    if (mounted) {
      UAGroFeedback.showOk(context, 'Citas actualizadas');
    }
  }

  /// Handle manual refresh button
  Future<void> _handleManualRefresh() async {
    await _loadCitas(isRefresh: true);
    if (mounted) {
      UAGroFeedback.showOk(context, 'Citas actualizadas');
    }
  }

  /// Build citas header with refresh button
  Widget _buildCitasHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(UAGroConstants.paddingMedium),
      margin: EdgeInsets.symmetric(horizontal: UAGroConstants.paddingMedium),
      decoration: BoxDecoration(
        color: UAGroColors.surface,
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        border: Border.all(
          color: UAGroColors.border.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: UAGroConstants.iconMedium,
            color: UAGroColors.primary,
          ),
          SizedBox(width: UAGroConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis Citas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: UAGroColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Matrícula: ${widget.matricula}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: UAGroColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isLoading || _isRefreshing ? null : _handleManualRefresh,
            icon: _isRefreshing
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        UAGroColors.textOnPrimary,
                      ),
                    ),
                  )
                : Icon(Icons.refresh, size: UAGroConstants.iconSmall),
            label: Text(
              'Refrescar',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: UAGroColors.primary,
              foregroundColor: UAGroColors.textOnPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: UAGroConstants.paddingMedium,
                vertical: UAGroConstants.paddingSmall,
              ),
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build citas statistics
  Widget _buildCitasStats() {
    final confirmadas = _citas.where((c) => 
        (c['estado']?.toString().toLowerCase() ?? '') == 'confirmada').length;
    final pendientes = _citas.where((c) => 
        (c['estado']?.toString().toLowerCase() ?? '') == 'pendiente').length;
    final atendidas = _citas.where((c) => 
        (c['estado']?.toString().toLowerCase() ?? '') == 'atendida').length;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UAGroConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              _citas.length.toString(),
              UAGroColors.primary,
              Icons.calendar_today,
            ),
          ),
          SizedBox(width: UAGroConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              'Confirmadas',
              confirmadas.toString(),
              UAGroColors.success,
              Icons.check_circle,
            ),
          ),
          SizedBox(width: UAGroConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              'Pendientes',
              pendientes.toString(),
              UAGroColors.warning,
              Icons.schedule,
            ),
          ),
          SizedBox(width: UAGroConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              'Atendidas',
              atendidas.toString(),
              UAGroColors.info,
              Icons.done_all,
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(UAGroConstants.paddingSmall),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: UAGroConstants.iconSmall,
            color: color,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UAGroConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: UAGroConstants.iconXLarge * 1.5,
              color: UAGroColors.textHint,
            ),
            SizedBox(height: UAGroConstants.paddingMedium),
            Text(
              'No tienes citas programadas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: UAGroColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UAGroConstants.paddingSmall),
            Text(
              'Cuando tengas citas programadas aparecerán aquí.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: UAGroColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UAGroConstants.paddingLarge),
            ElevatedButton.icon(
              onPressed: _handleManualRefresh,
              icon: Icon(Icons.refresh),
              label: Text('Verificar nuevamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UAGroColors.primary,
                foregroundColor: UAGroColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UAGroConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: UAGroConstants.iconXLarge,
              color: UAGroColors.error,
            ),
            SizedBox(height: UAGroConstants.paddingMedium),
            Text(
              'Error al cargar las citas',
              style: theme.textTheme.titleLarge?.copyWith(
                color: UAGroColors.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UAGroConstants.paddingSmall),
            Text(
              _errorMessage ?? 'Error desconocido',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: UAGroColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UAGroConstants.paddingLarge),
            ElevatedButton.icon(
              onPressed: () => _loadCitas(),
              icon: Icon(Icons.refresh),
              label: Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UAGroColors.primary,
                foregroundColor: UAGroColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UAGroConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: UAGroColors.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: UAGroConstants.paddingMedium),
            Text(
              'Cargando citas...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: UAGroColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build citas list
  Widget _buildCitasList() {
    return Column(
      children: [
        _buildCitasHeader(),
        SizedBox(height: UAGroConstants.paddingMedium),
        
        if (_citas.isNotEmpty) ...[
          _buildCitasStats(),
          SizedBox(height: UAGroConstants.paddingMedium),
        ],
        
        _citas.isEmpty
            ? _buildEmptyState()
            : Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: UAGroConstants.paddingSmall),
                  itemCount: _citas.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: UAGroConstants.paddingSmall,
                  ),
                  itemBuilder: (context, index) {
                    final cita = _citas[index];
                    return CitaSectionCard(cita: cita);
                  },
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UAGroColors.background,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: UAGroColors.primary,
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
                ? _buildErrorState()
                : _buildCitasList(),
      ),
    );
  }
}