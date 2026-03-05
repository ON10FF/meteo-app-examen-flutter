import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sunController;
  late Animation<double> _sunPulse;

  @override
  void initState() {
    super.initState();
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _sunPulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _sunController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Fond dégradé coucher de soleil sénégalais ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0533), // violet nuit
                  Color(0xFF7B1F2E), // rouge baobab
                  Color(0xFFD4541A), // orange brûlé
                  Color(0xFFEF9D1B), // or du soleil
                  Color(0xFFFFC94A), // jaune sable
                ],
                stops: [0.0, 0.25, 0.55, 0.78, 1.0],
              ),
            ),
          ),

          // ── Cercles lumineux d'ambiance ──
          Positioned(
            top: -80,
            right: -60,
            child: _GlowCircle(color: const Color(0xFFFF6B35), size: 280),
          ),
          Positioned(
            top: 60,
            left: -100,
            child: _GlowCircle(color: const Color(0xFFD4541A), size: 220),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: _GlowCircle(color: const Color(0xFF7B1F2E), size: 200),
          ),

          // ── Motif géométrique wolof en filigrane ──
          Positioned.fill(
            child: CustomPaint(painter: _WolofPatternPainter()),
          ),

          // ── Contenu principal ──
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Badge pays
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.white.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇸🇳', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 8),
                        Text(
                          'SÉNÉGAL',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2),

                  const SizedBox(height: 32),

                  // ── Soleil animé ──
                  ScaleTransition(
                    scale: _sunPulse,
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Halo extérieur
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFFFD700).withOpacity(0.25),
                                  const Color(0xFFFF6B35).withOpacity(0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Halo moyen
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFFFD700).withOpacity(0.45),
                                  const Color(0xFFFF8C00).withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Corps du soleil
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFFFFEE88),
                                  Color(0xFFFFD700),
                                  Color(0xFFFF8C00),
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFFAA00),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Color(0xFFFF6B35),
                                  blurRadius: 60,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text('☀️',
                                  style: TextStyle(fontSize: 34)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(begin: const Offset(0.6, 0.6)),

                  const SizedBox(height: 28),

                  // Titre
                  const Text(
                    'Météo\nSénégal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      letterSpacing: -1,
                      shadows: [
                        Shadow(
                          color: Color(0xFFD4541A),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 14),

                  // Sous-titre
                  Text(
                    'Découvre la météo de 5 villes en direct !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 28),

                  // Chips des villes
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 32),
                      children: ['Dakar', 'Mbour', 'Kaffrine', 'Kaolack', 'Thiès']
                          .map(
                            (city) => Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Text(
                            city,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 50),

                  // ── Bouton principal ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: _MainButton(
                      onTap: () => Navigator.pushNamed(context, '/main'),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms)
                      .scale(begin: const Offset(0.85, 0.85)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton principal ──────────────────────────────────────────────
class _MainButton extends StatefulWidget {
  final VoidCallback onTap;
  const _MainButton({required this.onTap});

  @override
  State<_MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<_MainButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF8C00),
                Color(0xFFFF4500),
                Color(0xFFD4541A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFFFF4500).withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Reflet en haut
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 31,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Texte + icônes
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌤️', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    const Text(
                      'Lancer l\'expérience 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Color(0x55000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cercle lumineux flou ──────────────────────────────────────────────
class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.18),
      ),
    );
  }
}

// ── Motif géométrique wolof ──────────────────────────────────────────────
class _WolofPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 60.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final cx = col * spacing + (row.isOdd ? spacing / 2 : 0);
        final cy = row * spacing;

        final path = Path()
          ..moveTo(cx, cy - 14)
          ..lineTo(cx + 10, cy)
          ..lineTo(cx, cy + 14)
          ..lineTo(cx - 10, cy)
          ..close();
        canvas.drawPath(path, paint);

        paint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(cx, cy), 2, paint);
        paint.style = PaintingStyle.stroke;
      }
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 0.8;

    for (double d = -size.height; d < size.width + size.height; d += 80) {
      canvas.drawLine(
        Offset(d, 0),
        Offset(d + size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}