// Home screen for UAGro student app
// Contains tabs for Carnet and Citas with logout functionality

import 'package:flutter/material.dart';
import '../ui/brand.dart';
import '../ui/responsive.dart';
import '../ui/feedback.dart';
import '../data/session.dart';
import 'login_screen.dart';
import 'carnet_view.dart';
import 'citas_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _email;
  String? _matricula;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSessionData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load session data for display
  Future<void> _loadSessionData() async {
    final email = await Session.getEmail();
    final matricula = await Session.getMatricula();
    
    if (mounted) {
      setState(() {
        _email = email;
        _matricula = matricula;
      });
    }
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    final shouldLogout = await UAGroFeedback.showConfirmDialog(
      context,
      title: 'Cerrar Sesión',
      message: '¿Estás seguro de que quieres cerrar tu sesión?',
      confirmText: 'Salir',
      cancelText: 'Cancelar',
      icon: Icons.logout,
      iconColor: UAGroColors.warning,
    );

    if (!shouldLogout) return;

    UAGroFeedback.showBusyOverlay(context, 'Cerrando sesión...');

    try {
      await Session.clear();
      
      if (mounted) {
        UAGroFeedback.hideBusyOverlay(context);
        
        // Navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        
        UAGroFeedback.showOk(context, 'Sesión cerrada correctamente');
      }
    } catch (e) {
      if (mounted) {
        UAGroFeedback.hideBusyOverlay(context);
        UAGroFeedback.showErr(context, 'Error al cerrar sesión');
      }
    }
  }

  /// Build logout button for app bar
  Widget _buildLogoutButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.account_circle,
        color: UAGroColors.textOnPrimary,
        size: UAGroConstants.iconMedium,
      ),
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout();
        } else if (value == 'info') {
          _showSessionInfo();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'info',
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: UAGroColors.primary,
                size: UAGroConstants.iconSmall,
              ),
              SizedBox(width: UAGroConstants.paddingSmall),
              Text('Información de sesión'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: UAGroColors.error,
                size: UAGroConstants.iconSmall,
              ),
              SizedBox(width: UAGroConstants.paddingSmall),
              Text('Cerrar Sesión'),
            ],
          ),
        ),
      ],
    );
  }

  /// Show session information dialog
  void _showSessionInfo() {
    UAGroFeedback.showAlertDialog(
      context,
      title: 'Información de Sesión',
      message: 'Email: $_email\nMatrícula: $_matricula',
      icon: Icons.info,
      iconColor: UAGroColors.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: UAGroColors.background,
      appBar: AppBar(
        backgroundColor: UAGroColors.primary,
        foregroundColor: UAGroColors.textOnPrimary,
        elevation: 2,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              UAGroConstants.shortName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: UAGroColors.textOnPrimary,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.isMobile(context) ? 18 : 20,
              ),
            ),
            if (!Responsive.isMobile(context))
              Text(
                'Carnet Estudiantil',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: UAGroColors.textOnPrimary.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          _buildLogoutButton(),
          SizedBox(width: UAGroConstants.paddingSmall),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: UAGroColors.textOnPrimary,
          labelColor: UAGroColors.textOnPrimary,
          unselectedLabelColor: UAGroColors.textOnPrimary.withOpacity(0.7),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Responsive.isMobile(context) ? 14 : 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Responsive.isMobile(context) ? 14 : 16,
          ),
          tabs: [
            Tab(
              icon: Icon(
                Icons.badge,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              text: 'Carnet',
            ),
            Tab(
              icon: Icon(
                Icons.calendar_today,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              text: 'Citas',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Carnet tab
          CarnetView(
            email: _email ?? '',
            matricula: _matricula ?? '',
          ),
          
          // Citas tab
          CitasView(
            matricula: _matricula ?? '',
          ),
        ],
      ),
    );
  }
}