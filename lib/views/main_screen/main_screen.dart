import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/theme_provider.dart';
import 'widgets/animated_gauge.dart';
import 'widgets/loading_message.dart';
import 'widgets/weather_table.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().startLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: Stack(
        children: [
          // ── Fond dégradé harmonisé ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [
                  Color(0xFF1A0533),
                  Color(0xFF2D1045),
                  Color(0xFF3D1A20),
                ]
                    : const [
                  Color(0xFF7B1F2E),
                  Color(0xFFD4541A),
                  Color(0xFFEF9D1B),
                ],
              ),
            ),
          ),

          // ── Cercle décoratif en haut à droite ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // ── Contenu ──
          SafeArea(
            child: Column(
              children: [
                // AppBar custom
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // Bouton retour
                      _NavButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          '🌍 Météo Sénégal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      // Toggle thème
                      _NavButton(
                        icon: isDark ? Icons.light_mode : Icons.dark_mode,
                        onTap: () =>
                            context.read<ThemeProvider>().toggleTheme(),
                      ),
                    ],
                  ),
                ),

                // Corps
                Expanded(
                  child: Consumer<WeatherProvider>(
                    builder: (context, provider, _) {
                      if (provider.hasError) {
                        return _buildErrorView(provider);
                      }
                      if (!provider.isComplete) {
                        return _buildLoadingView(provider);
                      }
                      return _buildResultView(provider);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView(WeatherProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedGauge(progress: provider.progress),
        const SizedBox(height: 30),
        LoadingMessage(messageIndex: provider.messageIndex),
      ],
    );
  }

  Widget _buildResultView(WeatherProvider provider) {
    return Column(
      children: [
        Expanded(child: WeatherTable(weathers: provider.weathers)),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: _StyledButton(
            label: 'Actualiser 🔁',
            icon: Icons.refresh_rounded,
            onTap: () => provider.startLoading(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(WeatherProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: const Icon(Icons.error_outline,
                  size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            _StyledButton(
              label: 'Réessayer 🔄',
              icon: Icons.refresh_rounded,
              onTap: () => provider.startLoading(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bouton de navigation (cercle) ────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ── Bouton stylisé orange ────────────────────────────────────────
class _StyledButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _StyledButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFD4541A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}