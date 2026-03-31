import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'vista_configuracion.dart';

class VistaTIU extends StatefulWidget {
  const VistaTIU({super.key});

  @override
  State<VistaTIU> createState() => _VistaTIUState();
}

class _VistaTIUState extends State<VistaTIU> {
  // --- CONFIGURACIÓN DE NUBES ANIMADAS ---

  // 1. TAMAÑO DE NUBES: Busca este valor para cambiar el tamaño base
  final double _cloudBaseSize = 50.0; // <--- TAMAÑO BASE DE NUBES (DIsminuido para look discreto)
  final double _cloudSizeVariation = 6.0; // Variación de tamaño por índice

  // Lógica de posicionamiento vertical del spawn (para que nazcan más abajo)
  final double _cloudSpawnYBase = 350.0; // <--- DÓNDE EMPIEZAN A APARECER (Más abajo, entre foto y tarjeta)
  final double _cloudSpawnYVariation = 40.0; // Variación vertical

  final List<double> _cloudPositionsX = List.generate(6, (index) => Random().nextDouble() * 380);
  final List<double> _cloudPositionsY = List.generate(6, (index) => 350.0 + (index * 40));

  String _currentTime = '';
  String _currentDate = '';
  String _userName = 'EDERY RENZO A*** V***';
  String _userCode = '201822832';
  String _idBanner = 'N01864219';

  @override
  void initState() {
    super.initState();
    _startClock();
    _startCloudAnimation();
  }

  void _startClock() {
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('EEEE, d MMM. yyyy', 'es_ES').format(now);
    });
  }

  void _startCloudAnimation() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _cloudPositionsX.length; i++) {
            _cloudPositionsX[i] -= 0.6 + (i % 2); // Velocidad ligeramente reducida
            if (_cloudPositionsX[i] < -130) {
              _cloudPositionsX[i] = MediaQuery.of(context).size.width + 100;
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculamos la posición de la foto para que no pise excesivamente la tarjeta
    final photoTopPosition = screenHeight * 0.38;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Fondo NO blanco puro
      body: Stack(
        children: [
          // 1. TEXTURA DE FONDO (Imagen de textura sutil de la UPC)
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.3, // Muy sutil
              child: Image.asset(
                'assets/arbolito.png', // O la textura de iconos que tengas
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 2. Nubes Animadas (Más sutiles sobre el fondo blanco y naciendo más abajo)
          ...List.generate(_cloudPositionsX.length, (index) {
            final cloudWidth = _cloudBaseSize + (index * _cloudSizeVariation);
            return Positioned(
              top: _cloudSpawnYBase + (index * _cloudSpawnYVariation),
              left: _cloudPositionsX[index],
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/cloud.png', width: cloudWidth),
              ),
            );
          }),

          // 3. Encabezado y LÍNEA DIVISORIA
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VistaConfiguracion(
                              onNameChanged: (val) => setState(() => _userName = val),
                              onCodeChanged: (val) => setState(() => _userCode = val),
                            ),
                          ),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFE33E3E), size: 22),
                      ),
                      const SizedBox(width: 25),
                      Text(
                        'TIU VIRTUAL',
                        style: GoogleFonts.oswald(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // LA RAYA DIVISORIA (Fina y sutil)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.black.withOpacity(0.09),
                ),
              ],
            ),
          ),

          // 4. Reloj Digital y Fecha (DISEÑO MÁS COMPACTO)
          Positioned(
            top: 135,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8), // Padding COMPACTADO vertical y horizontal
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E3FF), // Lavanda muy suave
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _currentTime,
                    style: GoogleFonts.roboto(
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _currentDate,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF5C6B82), // Gris azulado suave
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // 5. Tarjeta de Información (Diseño Flat Compacto y organizado, alineado con Pin 📍)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black.withOpacity(0.05)), // Borde plano sutil
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10), // Espacio para que la foto no pise excesivamente
                  // Nombre Modernizado (FittedBox para una línea con auto-ajuste)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _userName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: 32,
                        color: const Color(0xFFE33E3E), // Rojo UPC vibrante
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Código de alumno:", style: TextStyle(color: Color(0xFF6B778C), fontSize: 13)),
                  Text(
                    _userCode,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF344563)),
                  ),
                  const SizedBox(height: 8),
                  const Text("ID Banner:", style: TextStyle(color: Color(0xFF6B778C), fontSize: 13)),
                  Text(
                    _idBanner,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF344563)),
                  ),
                  const SizedBox(height: 18),
                  // Título de la carrera (más cerca de la info de arriba)
                  const Text(
                    "INGENIERÍA DE SOFTWARE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF344563)),
                  ),
                  const SizedBox(height: 8),
                  // Ubicación y Pin Rojo 📍 bien alineados
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Color(0xFFE33E3E), size: 19), // Pin Rojo📍
                      SizedBox(width: 8),
                      Text(
                        "Campus San Miguel",
                        style: TextStyle(fontSize: 15, color: Color(0xFF6B778C), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. Foto de Perfil (DISEÑO SIN BORDE, CÍRCULO PERFECTO)
          Positioned(
            top: photoTopPosition, // Posición elevada para que no pise excesivamente
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                // Eliminado el Container blanco con padding y boxShadow
                child: Image.asset(
                  'assets/profile_picture.jpg',
                  width: 175, // Ajusta este tamaño para el círculo perfecto
                  height: 175,
                  fit: BoxFit.cover, // Cubre el círculo perfectamente
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}