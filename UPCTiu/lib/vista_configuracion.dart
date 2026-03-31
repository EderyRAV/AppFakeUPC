import 'package:flutter/material.dart';

class VistaConfiguracion extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(String) onCodeChanged;

  const VistaConfiguracion({
    super.key,
    required this.onNameChanged,
    required this.onCodeChanged
  });

  @override
  State<VistaConfiguracion> createState() => _VistaConfiguracionState();
}

class _VistaConfiguracionState extends State<VistaConfiguracion> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco plano
      appBar: AppBar(
        title: const Text(
          'Configuración de TIU',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // SIN SOMBRAS en el AppBar
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Personalizar Datos",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF344563)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Asegúrate de usar el formato correcto con asteriscos si es necesario.",
              style: TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
            ),
            const SizedBox(height: 30),

            // Campo de Nombre con estilo plano
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                labelStyle: const TextStyle(color: Color(0xFF6B778C)),
                hintText: "Ej: EDERY RENZO A*** V***",
                fillColor: const Color(0xFFF4F5F7),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Borde plano
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de Código con estilo plano
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Código de Alumno',
                labelStyle: const TextStyle(color: Color(0xFF6B778C)),
                fillColor: const Color(0xFFF4F5F7),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Borde plano
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),

            const SizedBox(height: 50),

            // Botón GUARDAR con estilo plano y sin sombras
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE33E3E), // Rojo UPC
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0, // SIN SOMBRAS en el botón
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  widget.onNameChanged(_nameController.text.toUpperCase());
                }
                if (_codeController.text.isNotEmpty) {
                  widget.onCodeChanged(_codeController.text);
                }
                Navigator.pop(context);
              },
              child: const Text(
                'GUARDAR CAMBIOS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}