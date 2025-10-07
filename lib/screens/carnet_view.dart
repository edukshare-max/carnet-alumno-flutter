// Carnet view for UAGro student app
// Displays student ID card information using SectionCard

import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/responsive.dart';
import '../ui/feedback.dart';
import '../ui/section_card.dart';
import '../data/api_service.dart';

class CarnetView extends StatefulWidget {
  final String email;
  final String matricula;

  const CarnetView({
    super.key,
    required this.email,
    required this.matricula,
  });

  @override
  State<CarnetView> createState() => _CarnetViewState();
}

class _CarnetViewState extends State<CarnetView> {
  Map<String, dynamic>? _carnetData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCarnetData();
  }

  /// Load carnet data from API
  Future<void> _loadCarnetData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final carnet = await ApiService.fetchCarnetByMatricula(widget.matricula);
      
      if (!mounted) return;

      if (carnet != null) {
        // Verify email still matches (security check)
        if (ApiService.validateEmailMatch(widget.email, carnet['correo'] ?? '')) {
          setState(() {
            _carnetData = carnet;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Error de validación. Por favor, inicia sesión nuevamente.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No se pudo cargar la información del carnet.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error de conexión. Verifica tu internet e intenta nuevamente.';
          _isLoading = false;
        });
      }
    }
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    await _loadCarnetData();
    if (mounted && _carnetData != null) {
      UAGroFeedback.showOk(context, 'Carnet actualizado');
    }
  }

  /// Build carnet header with institution info
  Widget _buildCarnetHeader() {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UAGroConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UAGroColors.primary,
            UAGroColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school,
            size: UAGroConstants.iconLarge,
            color: UAGroColors.textOnPrimary,
          ),
          SizedBox(height: UAGroConstants.paddingSmall),
          Text(
            UAGroConstants.institutionName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: UAGroColors.textOnPrimary,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.isMobile(context) ? 14 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UAGroConstants.paddingSmall),
          Text(
            'CARNET ESTUDIANTIL',
            style: theme.textTheme.titleLarge?.copyWith(
              color: UAGroColors.textOnPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: Responsive.isMobile(context) ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    final theme = Theme.of(context);
    
    return Responsive.responsiveContainer(
      context: context,
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
            'Error al cargar el carnet',
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
            onPressed: _loadCarnetData,
            icon: Icon(Icons.refresh),
            label: Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: UAGroColors.primary,
              foregroundColor: UAGroColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Responsive.responsiveContainer(
      context: context,
      child: Column(
        children: [
          _buildCarnetHeader(),
          SizedBox(height: UAGroConstants.paddingMedium),
          CarnetSectionCard(
            title: 'Información del Estudiante',
            carnetData: {},
            isLoading: true,
          ),
        ],
      ),
    );
  }

  /// Build carnet content
  Widget _buildCarnetContent() {
    if (_carnetData == null) return Container();
    
    return Responsive.responsiveContainer(
      context: context,
      child: Column(
        children: [
          _buildCarnetHeader(),
          SizedBox(height: UAGroConstants.paddingMedium),
          
          // Main carnet information
          CarnetSectionCard(
            title: 'Información del Estudiante',
            carnetData: _carnetData!,
          ),
          
          // Additional information sections
          if (_carnetData!['facultad'] != null || _carnetData!['plantel'] != null)
            SectionCard(
              title: 'Información Académica',
              titleIcon: Icons.school,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_carnetData!['facultad'] != null)
                    _buildInfoRow(
                      'Facultad',
                      _carnetData!['facultad'],
                      Icons.business,
                    ),
                  if (_carnetData!['plantel'] != null)
                    _buildInfoRow(
                      'Plantel',
                      _carnetData!['plantel'],
                      Icons.location_city,
                    ),
                  if (_carnetData!['turno'] != null)
                    _buildInfoRow(
                      'Turno',
                      _carnetData!['turno'],
                      Icons.schedule,
                    ),
                ],
              ),
            ),
          
          // QR Code placeholder (if needed in the future)
          SectionCard(
            title: 'Código QR',
            titleIcon: Icons.qr_code,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: UAGroColors.cardBackground,
                borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
                border: Border.all(color: UAGroColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: UAGroConstants.iconLarge,
                      color: UAGroColors.textHint,
                    ),
                    SizedBox(height: UAGroConstants.paddingSmall),
                    Text(
                      'Código QR\ndel carnet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: UAGroColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Validity and status information
          if (_carnetData!['estado'] != null || _carnetData!['vigencia'] != null)
            SectionCard(
              title: 'Estado del Carnet',
              titleIcon: Icons.verified,
              child: Column(
                children: [
                  if (_carnetData!['estado'] != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: UAGroConstants.paddingMedium,
                        vertical: UAGroConstants.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: UAGroColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
                        border: Border.all(
                          color: UAGroColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: UAGroConstants.iconSmall,
                            color: UAGroColors.success,
                          ),
                          SizedBox(width: UAGroConstants.paddingSmall),
                          Text(
                            _carnetData!['estado'].toString().toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: UAGroColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_carnetData!['vigencia'] != null) ...[
                    SizedBox(height: UAGroConstants.paddingSmall),
                    Text(
                      'Vigencia: ${_carnetData!['vigencia']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: UAGroColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          
          SizedBox(height: UAGroConstants.paddingLarge),
        ],
      ),
    );
  }

  /// Build info row with icon
  Widget _buildInfoRow(String label, dynamic value, IconData icon) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: UAGroConstants.paddingSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: UAGroConstants.iconSmall,
            color: UAGroColors.primary,
          ),
          SizedBox(width: UAGroConstants.paddingSmall),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: UAGroColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: value?.toString() ?? 'N/A',
                    style: TextStyle(
                      color: UAGroColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UAGroColors.background,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: UAGroColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: Responsive.getResponsivePadding(context),
            child: _isLoading
                ? _buildLoadingState()
                : _errorMessage != null
                    ? _buildErrorState()
                    : _buildCarnetContent(),
          ),
        ),
      ),
    );
  }
}