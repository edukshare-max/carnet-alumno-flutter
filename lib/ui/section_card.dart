// UAGro institutional section card component
// This widget provides a consistent card design for displaying information sections

import 'package:flutter/material.dart';
import 'brand.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? backgroundColor;
  final double? elevation;
  final IconData? titleIcon;
  final List<Widget>? actions;

  const SectionCard({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.showBorder = true,
    this.backgroundColor,
    this.elevation,
    this.titleIcon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardContent = Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(UAGroConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (titleIcon != null) ...[
                  Icon(
                    titleIcon,
                    size: UAGroConstants.iconMedium,
                    color: UAGroColors.primary,
                  ),
                  SizedBox(width: UAGroConstants.paddingSmall),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: UAGroColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
            SizedBox(height: UAGroConstants.paddingMedium),
            Divider(
              color: UAGroColors.divider,
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: UAGroConstants.paddingMedium),
          ],
          child,
        ],
      ),
    );

    Widget card = Card(
      elevation: elevation ?? 2,
      color: backgroundColor ?? UAGroColors.surface,
      margin: margin ?? EdgeInsets.all(UAGroConstants.paddingMedium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        side: showBorder
            ? BorderSide(
                color: UAGroColors.border.withOpacity(0.3),
                width: 1,
              )
            : BorderSide.none,
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        child: card,
      );
    }

    return card;
  }
}

// Specialized card for displaying carnet information
class CarnetSectionCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> carnetData;
  final bool isLoading;

  const CarnetSectionCard({
    super.key,
    required this.title,
    required this.carnetData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SectionCard(
        title: title,
        titleIcon: Icons.badge,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(UAGroConstants.paddingLarge),
            child: CircularProgressIndicator(
              color: UAGroColors.primary,
            ),
          ),
        ),
      );
    }

    return SectionCard(
      title: title,
      titleIcon: Icons.badge,
      backgroundColor: UAGroColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with photo placeholder and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo placeholder
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: UAGroColors.cardBackground,
                  borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
                  border: Border.all(color: UAGroColors.border),
                ),
                child: Icon(
                  Icons.person,
                  size: UAGroConstants.iconLarge,
                  color: UAGroColors.textHint,
                ),
              ),
              SizedBox(width: UAGroConstants.paddingMedium),
              // Basic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Nombre', carnetData['nombre'] ?? 'N/A', theme),
                    _buildInfoRow('Matrícula', carnetData['matricula'] ?? 'N/A', theme),
                    _buildInfoRow('Carrera', carnetData['carrera'] ?? 'N/A', theme),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: UAGroConstants.paddingMedium),
          Divider(color: UAGroColors.divider),
          SizedBox(height: UAGroConstants.paddingMedium),
          // Additional information
          _buildInfoRow('Correo', carnetData['correo'] ?? 'N/A', theme),
          _buildInfoRow('Semestre', '${carnetData['semestre'] ?? 'N/A'}', theme),
          _buildInfoRow('CURP', carnetData['curp'] ?? 'N/A', theme),
          _buildInfoRow('Fecha de Emisión', carnetData['fecha_emision'] ?? 'N/A', theme),
          if (carnetData['vigencia'] != null)
            _buildInfoRow('Vigencia', carnetData['vigencia'], theme),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: UAGroConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: UAGroColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: UAGroColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Specialized card for displaying appointment information
class CitaSectionCard extends StatelessWidget {
  final Map<String, dynamic> cita;

  const CitaSectionCard({
    super.key,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estado = cita['estado']?.toString().toLowerCase() ?? 'pendiente';
    
    Color statusColor;
    IconData statusIcon;
    switch (estado) {
      case 'confirmada':
      case 'atendida':
        statusColor = UAGroColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelada':
        statusColor = UAGroColors.error;
        statusIcon = Icons.cancel;
        break;
      case 'reagendada':
        statusColor = UAGroColors.warning;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = UAGroColors.info;
        statusIcon = Icons.access_time;
    }

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: UAGroConstants.paddingMedium,
        vertical: UAGroConstants.paddingSmall,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        side: BorderSide(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UAGroConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: UAGroConstants.iconMedium,
                ),
                SizedBox(width: UAGroConstants.paddingSmall),
                Expanded(
                  child: Text(
                    cita['motivo'] ?? 'Cita programada',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: UAGroConstants.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    estado.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: UAGroConstants.paddingSmall),
            if (cita['fecha'] != null)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: UAGroConstants.iconSmall,
                    color: UAGroColors.textSecondary,
                  ),
                  SizedBox(width: UAGroConstants.paddingSmall),
                  Text(
                    cita['fecha'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: UAGroColors.textSecondary,
                    ),
                  ),
                ],
              ),
            if (cita['hora'] != null)
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: UAGroConstants.iconSmall,
                    color: UAGroColors.textSecondary,
                  ),
                  SizedBox(width: UAGroConstants.paddingSmall),
                  Text(
                    cita['hora'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: UAGroColors.textSecondary,
                    ),
                  ),
                ],
              ),
            if (cita['lugar'] != null) ...[
              SizedBox(height: UAGroConstants.paddingSmall),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: UAGroConstants.iconSmall,
                    color: UAGroColors.textSecondary,
                  ),
                  SizedBox(width: UAGroConstants.paddingSmall),
                  Expanded(
                    child: Text(
                      cita['lugar'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: UAGroColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}