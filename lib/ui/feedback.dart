// UAGro feedback utilities
// Provides standardized feedback methods (showOk, showErr, busyOverlay) with UAGro styling

import 'package:flutter/material.dart';
import 'brand.dart';

class UAGroFeedback {
  // Show success message with UAGro styling
  static void showOk(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: UAGroColors.textOnPrimary,
              size: 20,
            ),
            SizedBox(width: UAGroConstants.paddingSmall),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: UAGroColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: UAGroColors.success,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(UAGroConstants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
      ),
    );
  }

  // Show error message with UAGro styling
  static void showErr(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: UAGroColors.textOnPrimary,
              size: 20,
            ),
            SizedBox(width: UAGroConstants.paddingSmall),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: UAGroColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: UAGroColors.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(UAGroConstants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
      ),
    );
  }

  // Show warning message with UAGro styling
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning,
              color: UAGroColors.textPrimary,
              size: 20,
            ),
            SizedBox(width: UAGroConstants.paddingSmall),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: UAGroColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: UAGroColors.warning,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(UAGroConstants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
      ),
    );
  }

  // Show info message with UAGro styling
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: UAGroColors.textOnPrimary,
              size: 20,
            ),
            SizedBox(width: UAGroConstants.paddingSmall),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: UAGroColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: UAGroColors.info,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(UAGroConstants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
      ),
    );
  }

  // Show busy overlay with UAGro styling
  static void showBusyOverlay(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Prevent back button
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(UAGroConstants.paddingLarge),
              decoration: BoxDecoration(
                color: UAGroColors.surface,
                borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: UAGroColors.primary,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: UAGroConstants.paddingMedium),
                  Text(
                    message,
                    style: TextStyle(
                      color: UAGroColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Hide busy overlay
  static void hideBusyOverlay(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // Show confirmation dialog with UAGro styling
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    IconData? icon,
    Color? iconColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
          ),
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? UAGroColors.primary,
                  size: UAGroConstants.iconMedium,
                ),
                SizedBox(width: UAGroConstants.paddingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: UAGroColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: UAGroColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: UAGroColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: UAGroColors.primary,
                foregroundColor: UAGroColors.textOnPrimary,
              ),
              child: Text(
                confirmText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    return result ?? false;
  }

  // Show simple alert dialog with UAGro styling
  static void showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Entendido',
    IconData? icon,
    Color? iconColor,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
          ),
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? UAGroColors.primary,
                  size: UAGroConstants.iconMedium,
                ),
                SizedBox(width: UAGroConstants.paddingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: UAGroColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: UAGroColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPressed?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UAGroColors.primary,
                foregroundColor: UAGroColors.textOnPrimary,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}