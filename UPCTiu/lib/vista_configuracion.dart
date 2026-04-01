import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaConfiguracion extends StatefulWidget {
  final String initialName;
  final String initialCode;
  final String initialIdBanner;
  final double initialNameSize;
  final double initialDescSize;
  final String? initialImagePath;

  const VistaConfiguracion({
    super.key,
    required this.initialName,
    required this.initialCode,
    required this.initialIdBanner,
    required this.initialNameSize,
    required this.initialDescSize,
    this.initialImagePath,
  });

  @override
  State<VistaConfiguracion> createState() => _VistaConfiguracionState();
}

class _VistaConfiguracionState extends State<VistaConfiguracion> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _idBannerController;

  late double _nameSize;
  late double _descSize;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _codeController = TextEditingController(text: widget.initialCode);
    _idBannerController = TextEditingController(text: widget.initialIdBanner);
    _nameSize = widget.initialNameSize;
    _descSize = widget.initialDescSize;

    if (widget.initialImagePath != null && widget.initialImagePath!.isNotEmpty) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _idBannerController.dispose();
    super.dispose();
  }

  Future<void> _pickAndSaveImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedImage = await File(image.path).copy(newPath);

      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  void _guardarYSalir() {
    Navigator.pop(context, {
      'name': _nameController.text.toUpperCase(),
      'code': _codeController.text,
      'idBanner': _idBannerController.text,
      'nameSize': _nameSize,
      'descSize': _descSize,
      'imagePath': _selectedImage?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definimos la paleta de colores de la vista
    const Color primaryRed = Color(0xFFE33E3E);
    const Color backgroundColor = Color(0xFFF4F6F9);
    const Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      // Hacemos el body un Stack para crear el efecto de fondo rojo en el encabezado
      body: Stack(
        children: [
          // Fondo del encabezado (Curvado)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Botón de retroceso (Seguro por si el usuario no quiere guardar)
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context), // Cierra sin devolver datos
            ),
          ),

          // Título de la vista
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Personalizar TIU',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Contenido principal (Scrollable)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 40),
              child: Column(
                children: [
                  // --- SECCIÓN 1: FOTO DE PERFIL ---
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
                          ),
                        ),
                        // Botón flotante para editar foto
                        GestureDetector(
                          onTap: _pickAndSaveImage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- SECCIÓN 2: DATOS PERSONALES (TARJETA) ---
                  _buildCardSection(
                    title: "Datos del Estudiante",
                    icon: Icons.person_outline,
                    child: Column(
                      children: [
                        _buildCustomTextField(
                          controller: _nameController,
                          label: "Nombre Completo",
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 15),
                        _buildCustomTextField(
                          controller: _codeController,
                          label: "Código de Alumno",
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        _buildCustomTextField(
                          controller: _idBannerController,
                          label: "ID Banner",
                          icon: Icons.credit_card,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- SECCIÓN 3: APARIENCIA / TAMAÑO DE LETRA (TARJETA) ---
                  _buildCardSection(
                    title: "Apariencia de Textos",
                    icon: Icons.text_fields,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Control Tamaño Nombre
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tamaño del Nombre", style: GoogleFonts.poppins(color: Colors.grey[700])),
                            Text("${_nameSize.toInt()} pt", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryRed)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryRed,
                            thumbColor: primaryRed,
                            overlayColor: primaryRed.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _nameSize,
                            min: 15.0,
                            max: 50.0,
                            onChanged: (val) => setState(() => _nameSize = val),
                          ),
                        ),
                        // Vista Previa Nombre
                        Center(
                          child: Text(
                            _nameController.text.isEmpty ? "VISTA PREVIA" : _nameController.text.toUpperCase(),
                            style: GoogleFonts.oswald(
                              color: primaryRed,
                              fontSize: _nameSize,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(height: 1),
                        ),

                        // Control Tamaño Descripción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tamaño de Descripciones", style: GoogleFonts.poppins(color: Colors.grey[700])),
                            Text("${_descSize.toInt()} pt", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blueGrey,
                            thumbColor: Colors.blueGrey,
                            overlayColor: Colors.blueGrey.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _descSize,
                            min: 10.0,
                            max: 30.0,
                            onChanged: (val) => setState(() => _descSize = val),
                          ),
                        ),
                        // Vista Previa Descripción
                        Center(
                          child: Text(
                            "Texto de descripción de prueba",
                            style: TextStyle(
                              color: const Color(0xFF344563),
                              fontSize: _descSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- SECCIÓN 4: BOTÓN DE GUARDAR ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: primaryRed.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _guardarYSalir,
                      child: Text(
                        'GUARDAR CAMBIOS',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
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

  // Widget Helper para crear las tarjetas blancas con sombra
  Widget _buildCardSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF344563),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // Widget Helper para los TextFields con estilo moderno
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFE33E3E), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE33E3E), width: 1.5),
        ),
      ),
    );
  }
}