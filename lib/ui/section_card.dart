import 'package:flutter/material.dart';
import 'brand.dart';

/// A styled card component for displaying sections of information
/// Used throughout the UAGro Carnet App for consistent UI
class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget? trailing;
  final Color? backgroundColor;
  final double? elevation;

  const SectionCard({
    Key? key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.showDivider = false,
    this.trailing,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: UAgro.spacingMedium,
        vertical: UAgro.spacingSmall,
      ),
      child: Card(
        color: backgroundColor ?? UAgro.white,
        elevation: elevation ?? UAgro.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(UAgro.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: UAgro.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                  if (showDivider) ...[
                    const SizedBox(height: UAgro.spacingSmall),
                    const Divider(
                      color: UAgro.border,
                      height: 1,
                    ),
                  ],
                  const SizedBox(height: UAgro.spacingMedium),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A specialized section card for displaying key-value pairs
class InfoSectionCard extends StatelessWidget {
  final String title;
  final List<InfoItem> items;
  final EdgeInsetsGeometry? margin;
  final Widget? trailing;

  const InfoSectionCard({
    Key? key,
    required this.title,
    required this.items,
    this.margin,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      margin: margin,
      trailing: trailing,
      showDivider: true,
      child: Column(
        children: items.map((item) => _buildInfoRow(context, item)).toList(),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, InfoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UAgro.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: UAgro.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: UAgro.spacingMedium),
          Expanded(
            flex: 3,
            child: Text(
              item.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: UAgro.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for information items
class InfoItem {
  final String label;
  final String value;

  const InfoItem({
    required this.label,
    required this.value,
  });
}

/// A section card specifically for displaying student carnet information
class CarnetCard extends StatelessWidget {
  final Map<String, dynamic> carnetData;
  final EdgeInsetsGeometry? margin;

  const CarnetCard({
    Key? key,
    required this.carnetData,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      InfoItem(
        label: 'Nombre',
        value: carnetData['nombre']?.toString() ?? 'N/A',
      ),
      InfoItem(
        label: 'Matrícula',
        value: carnetData['matricula']?.toString() ?? 'N/A',
      ),
      InfoItem(
        label: 'Carrera/Programa',
        value: carnetData['carrera']?.toString() ?? 
               carnetData['programa']?.toString() ?? 'N/A',
      ),
      InfoItem(
        label: 'Correo',
        value: carnetData['correo']?.toString() ?? 'N/A',
      ),
      if (carnetData['edad'] != null)
        InfoItem(
          label: 'Edad',
          value: carnetData['edad']?.toString() ?? 'N/A',
        ),
      if (carnetData['sangre'] != null)
        InfoItem(
          label: 'Tipo de Sangre',
          value: carnetData['sangre']?.toString() ?? 'N/A',
        ),
      if (carnetData['semestre'] != null)
        InfoItem(
          label: 'Semestre',
          value: carnetData['semestre']?.toString() ?? 'N/A',
        ),
      if (carnetData['telefono'] != null)
        InfoItem(
          label: 'Teléfono',
          value: carnetData['telefono']?.toString() ?? 'N/A',
        ),
    ];

    return InfoSectionCard(
      title: 'Carnet Estudiantil',
      items: items,
      margin: margin,
      trailing: const Icon(
        Icons.badge,
        color: UAgro.primaryBlue,
      ),
    );
  }
}

/// A section card for displaying appointment information
class CitaCard extends StatelessWidget {
  final Map<String, dynamic> citaData;
  final EdgeInsetsGeometry? margin;

  const CitaCard({
    Key? key,
    required this.citaData,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String motivo = citaData['motivo']?.toString() ?? 'Sin motivo especificado';
    final String fecha = citaData['fecha']?.toString() ?? 'N/A';
    final String horaInicio = citaData['hora_inicio']?.toString() ?? '';
    final String horaFin = citaData['hora_fin']?.toString() ?? '';
    final String estado = citaData['estado']?.toString() ?? 'Pendiente';
    
    String horario = '';
    if (horaInicio.isNotEmpty && horaFin.isNotEmpty) {
      horario = '$horaInicio - $horaFin';
    } else if (horaInicio.isNotEmpty) {
      horario = horaInicio;
    }

    Color estadoColor;
    switch (estado.toLowerCase()) {
      case 'confirmada':
      case 'activa':
        estadoColor = UAgro.success;
        break;
      case 'cancelada':
        estadoColor = UAgro.error;
        break;
      case 'completada':
        estadoColor = UAgro.info;
        break;
      default:
        estadoColor = UAgro.warning;
    }

    return SectionCard(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  motivo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: UAgro.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UAgro.spacingSmall,
                  vertical: UAgro.spacingXSmall,
                ),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(UAgro.radiusSmall),
                  border: Border.all(color: estadoColor.withOpacity(0.3)),
                ),
                child: Text(
                  estado,
                  style: TextStyle(
                    color: estadoColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UAgro.spacingSmall),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: UAgro.textSecondary,
              ),
              const SizedBox(width: UAgro.spacingSmall),
              Text(
                fecha,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: UAgro.textSecondary,
                ),
              ),
              if (horario.isNotEmpty) ...[
                const SizedBox(width: UAgro.spacingMedium),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: UAgro.textSecondary,
                ),
                const SizedBox(width: UAgro.spacingSmall),
                Text(
                  horario,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: UAgro.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}