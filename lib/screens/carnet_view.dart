import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/responsive.dart';
import '../ui/section_card.dart';

/// Carnet view screen to display student ID information
/// Read-only view of student carnet data
class CarnetView extends StatelessWidget {
  final Map<String, dynamic> carnetData;
  final String matricula;

  const CarnetView({
    Key? key,
    required this.carnetData,
    required this.matricula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.responsiveScaffold(
      context: context,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCarnetCard(),
            
            const SizedBox(height: UAgro.spacingMedium),
            
            _buildPersonalInfoCard(),
            
            const SizedBox(height: UAgro.spacingMedium),
            
            _buildAcademicInfoCard(),
            
            if (_hasContactInfo()) ...[
              const SizedBox(height: UAgro.spacingMedium),
              _buildContactInfoCard(),
            ],
            
            if (_hasHealthInfo()) ...[
              const SizedBox(height: UAgro.spacingMedium),
              _buildHealthInfoCard(),
            ],
            
            const SizedBox(height: UAgro.spacingLarge),
            
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Carnet Estudiantil'),
      centerTitle: true,
      elevation: UAgro.elevationLow,
    );
  }

  /// Build main carnet card
  Widget _buildCarnetCard() {
    return CarnetCard(
      carnetData: carnetData,
    );
  }

  /// Build personal information card
  Widget _buildPersonalInfoCard() {
    final items = <InfoItem>[];

    if (carnetData['nombreCompleto'] != null || carnetData['nombre'] != null) {
      items.add(InfoItem(
        label: 'Nombre Completo',
        value: carnetData['nombreCompleto']?.toString() ?? 
               carnetData['nombre']?.toString() ?? 'N/A',
      ));
    }

    if (carnetData['matricula'] != null) {
      items.add(InfoItem(
        label: 'Matrícula',
        value: carnetData['matricula'].toString(),
      ));
    }

    if (carnetData['edad'] != null) {
      items.add(InfoItem(
        label: 'Edad',
        value: '${carnetData['edad']} años',
      ));
    }

    if (carnetData['fecha_nacimiento'] != null) {
      items.add(InfoItem(
        label: 'Fecha de Nacimiento',
        value: _formatDate(carnetData['fecha_nacimiento'].toString()),
      ));
    }

    if (carnetData['genero'] != null) {
      items.add(InfoItem(
        label: 'Género',
        value: carnetData['genero'].toString(),
      ));
    }

    if (carnetData['estado_civil'] != null) {
      items.add(InfoItem(
        label: 'Estado Civil',
        value: carnetData['estado_civil'].toString(),
      ));
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return InfoSectionCard(
      title: 'Información Personal',
      items: items,
      trailing: const Icon(
        Icons.person,
        color: UAgro.primaryBlue,
      ),
    );
  }

  /// Build academic information card
  Widget _buildAcademicInfoCard() {
    final items = <InfoItem>[];

    if (carnetData['carrera'] != null) {
      items.add(InfoItem(
        label: 'Carrera',
        value: carnetData['carrera'].toString(),
      ));
    }

    if (carnetData['programa'] != null && carnetData['programa'] != carnetData['carrera']) {
      items.add(InfoItem(
        label: 'Programa',
        value: carnetData['programa'].toString(),
      ));
    }

    if (carnetData['semestre'] != null) {
      items.add(InfoItem(
        label: 'Semestre',
        value: _formatSemestre(carnetData['semestre']),
      ));
    }

    if (carnetData['periodo'] != null) {
      items.add(InfoItem(
        label: 'Período',
        value: carnetData['periodo'].toString(),
      ));
    }

    if (carnetData['facultad'] != null) {
      items.add(InfoItem(
        label: 'Facultad',
        value: carnetData['facultad'].toString(),
      ));
    }

    if (carnetData['campus'] != null) {
      items.add(InfoItem(
        label: 'Campus',
        value: carnetData['campus'].toString(),
      ));
    }

    if (carnetData['fecha_ingreso'] != null) {
      items.add(InfoItem(
        label: 'Fecha de Ingreso',
        value: _formatDate(carnetData['fecha_ingreso'].toString()),
      ));
    }

    if (carnetData['estatus'] != null) {
      items.add(InfoItem(
        label: 'Estatus',
        value: _formatEstatus(carnetData['estatus'].toString()),
      ));
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return InfoSectionCard(
      title: 'Información Académica',
      items: items,
      trailing: const Icon(
        Icons.school,
        color: UAgro.primaryBlue,
      ),
    );
  }

  /// Build contact information card
  Widget _buildContactInfoCard() {
    final items = <InfoItem>[];

    if (carnetData['correo'] != null) {
      items.add(InfoItem(
        label: 'Correo Electrónico',
        value: carnetData['correo'].toString(),
      ));
    }

    if (carnetData['telefono'] != null) {
      items.add(InfoItem(
        label: 'Teléfono',
        value: _formatPhone(carnetData['telefono'].toString()),
      ));
    }

    if (carnetData['direccion'] != null) {
      items.add(InfoItem(
        label: 'Dirección',
        value: carnetData['direccion'].toString(),
      ));
    }

    if (carnetData['ciudad'] != null) {
      items.add(InfoItem(
        label: 'Ciudad',
        value: carnetData['ciudad'].toString(),
      ));
    }

    if (carnetData['estado'] != null) {
      items.add(InfoItem(
        label: 'Estado',
        value: carnetData['estado'].toString(),
      ));
    }

    if (carnetData['codigo_postal'] != null) {
      items.add(InfoItem(
        label: 'Código Postal',
        value: carnetData['codigo_postal'].toString(),
      ));
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return InfoSectionCard(
      title: 'Información de Contacto',
      items: items,
      trailing: const Icon(
        Icons.contact_phone,
        color: UAgro.primaryBlue,
      ),
    );
  }

  /// Build health information card
  Widget _buildHealthInfoCard() {
    final items = <InfoItem>[];

    if (carnetData['sangre'] != null) {
      items.add(InfoItem(
        label: 'Tipo de Sangre',
        value: carnetData['sangre'].toString(),
      ));
    }

    if (carnetData['alergias'] != null) {
      items.add(InfoItem(
        label: 'Alergias',
        value: carnetData['alergias'].toString(),
      ));
    }

    if (carnetData['contacto_emergencia'] != null) {
      items.add(InfoItem(
        label: 'Contacto de Emergencia',
        value: carnetData['contacto_emergencia'].toString(),
      ));
    }

    if (carnetData['telefono_emergencia'] != null) {
      items.add(InfoItem(
        label: 'Teléfono de Emergencia',
        value: _formatPhone(carnetData['telefono_emergencia'].toString()),
      ));
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return InfoSectionCard(
      title: 'Información de Salud',
      items: items,
      trailing: const Icon(
        Icons.local_hospital,
        color: UAgro.error,
      ),
    );
  }

  /// Build footer with UAGro branding
  Widget _buildFooter(BuildContext context) {
    return SectionCard(
      backgroundColor: UAgro.primaryBlue.withOpacity(0.05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                color: UAgro.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: UAgro.spacingSmall),
              Text(
                UAgro.universityShortName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: UAgro.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: UAgro.spacingSmall),
          
          Text(
            UAgro.universityName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: UAgro.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: UAgro.spacingSmall),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UAgro.spacingMedium,
              vertical: UAgro.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: UAgro.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UAgro.radiusSmall),
              border: Border.all(color: UAgro.success.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified,
                  color: UAgro.success,
                  size: 16,
                ),
                const SizedBox(width: UAgro.spacingSmall),
                Text(
                  'Carnet Oficial Verificado',
                  style: TextStyle(
                    color: UAgro.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Check if contact information is available
  bool _hasContactInfo() {
    return carnetData['correo'] != null ||
           carnetData['telefono'] != null ||
           carnetData['direccion'] != null ||
           carnetData['ciudad'] != null ||
           carnetData['estado'] != null ||
           carnetData['codigo_postal'] != null;
  }

  /// Check if health information is available
  bool _hasHealthInfo() {
    return carnetData['sangre'] != null ||
           carnetData['alergias'] != null ||
           carnetData['contacto_emergencia'] != null ||
           carnetData['telefono_emergencia'] != null;
  }

  /// Format date string
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr; // Return original if parsing fails
    }
  }

  /// Format phone number
  String _formatPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length == 10) {
      return '${cleanPhone.substring(0, 3)}-${cleanPhone.substring(3, 6)}-${cleanPhone.substring(6)}';
    } else if (cleanPhone.length == 12 && cleanPhone.startsWith('52')) {
      return '+52 ${cleanPhone.substring(2, 5)}-${cleanPhone.substring(5, 8)}-${cleanPhone.substring(8)}';
    }
    
    return phone; // Return original if format is unknown
  }

  /// Format semester display
  String _formatSemestre(dynamic semestre) {
    if (semestre == null) return 'N/A';
    
    final semestreStr = semestre.toString();
    final semestreNum = int.tryParse(semestreStr);
    
    if (semestreNum != null) {
      return '$semestreNum° Semestre';
    }
    
    return semestreStr;
  }

  /// Format student status
  String _formatEstatus(String estatus) {
    switch (estatus.toLowerCase()) {
      case 'activo':
        return 'Activo';
      case 'inactivo':
        return 'Inactivo';
      case 'egresado':
        return 'Egresado';
      case 'baja_temporal':
        return 'Baja Temporal';
      case 'baja_definitiva':
        return 'Baja Definitiva';
      default:
        return estatus;
    }
  }
}