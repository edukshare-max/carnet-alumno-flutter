import 'package:flutter/material.dart';
import 'brand.dart';

/// Feedback utilities for the UAGro Carnet App
/// Provides consistent UI feedback including dialogs and loading overlays
class Feedback {
  Feedback._();

  /// Show a success dialog with UAGro branding
  static Future<void> showOk(
    BuildContext context,
    String message, {
    String title = 'Éxito',
    VoidCallback? onOk,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: UAgro.success,
          size: 48,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: UAgro.success,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: UAgro.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: UAgro.success,
            ),
            child: const Text('Aceptar'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
      ),
    );
  }

  /// Show an error dialog with UAGro branding
  static Future<void> showErr(
    BuildContext context,
    String message, {
    String title = 'Error',
    VoidCallback? onOk,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: UAgro.error,
          size: 48,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: UAgro.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: UAgro.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: UAgro.error,
            ),
            child: const Text('Aceptar'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
      ),
    );
  }

  /// Show an informational dialog with UAGro branding
  static Future<void> showInfo(
    BuildContext context,
    String message, {
    String title = 'Información',
    VoidCallback? onOk,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.info,
          color: UAgro.info,
          size: 48,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: UAgro.info,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: UAgro.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: UAgro.info,
            ),
            child: const Text('Aceptar'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
      ),
    );
  }

  /// Show a warning dialog with UAGro branding
  static Future<void> showWarning(
    BuildContext context,
    String message, {
    String title = 'Advertencia',
    VoidCallback? onOk,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning,
          color: UAgro.warning,
          size: 48,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: UAgro.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: UAgro.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: UAgro.warning,
            ),
            child: const Text('Aceptar'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
      ),
    );
  }

  /// Show a confirmation dialog with UAGro branding
  static Future<bool> showConfirm(
    BuildContext context,
    String message, {
    String title = 'Confirmación',
    String confirmText = 'Sí',
    String cancelText = 'No',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.help,
          color: UAgro.primaryBlue,
          size: 48,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: UAgro.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: UAgro.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: UAgro.textSecondary,
            ),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: UAgro.primaryBlue,
              foregroundColor: UAgro.white,
            ),
            child: Text(confirmText),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
        ),
      ),
    );
    return result ?? false;
  }

  /// Show a loading overlay with UAGro institutional spinner
  static void busyOverlay(BuildContext context, bool isBusy) {
    if (isBusy) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const BusyOverlay(),
      );
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  /// Run an async operation with a loading overlay
  static Future<T> runWithLoader<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? loadingMessage,
  }) async {
    busyOverlay(context, true);
    try {
      final result = await operation();
      busyOverlay(context, false);
      return result;
    } catch (e) {
      busyOverlay(context, false);
      rethrow;
    }
  }

  /// Show a snackbar with UAGro branding
  static void showSnackbar(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? action,
    String? actionLabel,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = UAgro.success;
        textColor = UAgro.white;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = UAgro.error;
        textColor = UAgro.white;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = UAgro.warning;
        textColor = UAgro.white;
        icon = Icons.warning;
        break;
      case SnackbarType.info:
      default:
        backgroundColor = UAgro.primaryBlue;
        textColor = UAgro.white;
        icon = Icons.info;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: UAgro.spacingSmall),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UAgro.radiusSmall),
      ),
      action: action != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: action,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Enum for different types of snackbars
enum SnackbarType { success, error, warning, info }

/// Loading overlay widget with UAGro institutional spinner
class BusyOverlay extends StatelessWidget {
  final String? message;

  const BusyOverlay({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(UAgro.spacingLarge),
          decoration: BoxDecoration(
            color: UAgro.white,
            borderRadius: BorderRadius.circular(UAgro.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: UAgro.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UAgro.primaryBlue),
                strokeWidth: 3,
              ),
              const SizedBox(height: UAgro.spacingMedium),
              Text(
                message ?? 'Cargando...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: UAgro.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading button that shows a spinner while loading
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;

  const LoadingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildContent(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(UAgro.white),
            ),
          ),
          const SizedBox(width: UAgro.spacingSmall),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}