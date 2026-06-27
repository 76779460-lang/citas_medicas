import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/citas_provider.dart';
import 'registro_cita.dart';
import 'listas_citas.dart';

// MODIFICADO: se envuelve la app con ChangeNotifierProvider para que
// CitasProvider (estado compartido de citas) sea accesible en todas
// las páginas. Sin esto, las citas registradas nunca llegarían a la lista.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CitasProvider(),
      child: const CitasMedicasApp(),
    ),
  );
}

class CitasMedicasApp extends StatelessWidget {
  const CitasMedicasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citas Médicas',
      // AÑADIDO: ThemeData con colores médicos. El original no tenía tema,
      // lo que causaba que botones y AppBar usaran el gris por defecto.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const InicioPage(),
    );
  }
}

// MODIFICADO: InicioPage mejorada visualmente. Se mantiene la misma
// estructura (dos botones: Registrar y Ver Citas) pero ahora usa
// tarjetas con ícono y descripción, y muestra el total de citas.
class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contador reactivo: se actualiza cada vez que se agrega una cita
    final totalCitas = context.watch<CitasProvider>().citas.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("Citas Médicas"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // AÑADIDO: ícono médico decorativo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital,
                size: 60,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 20),

            // ORIGINAL conservado — mismo texto, mismo estilo
            const Text(
              "Sistema de Gestión de Citas",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // AÑADIDO: badge con total de citas registradas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$totalCitas cita${totalCitas == 1 ? '' : 's'} registrada${totalCitas == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ORIGINAL conservado — misma acción, mejorado visualmente
            _MenuCard(
              icon: Icons.add_circle_outline,
              titulo: 'Registrar Cita',
              descripcion: 'Programa una nueva cita médica',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroCitaPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // ORIGINAL conservado — misma acción, mejorado visualmente
            _MenuCard(
              icon: Icons.list_alt,
              titulo: 'Ver Citas',
              descripcion: 'Consulta y gestiona las citas existentes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaCitasPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AÑADIDO: widget de tarjeta de menú reutilizable para los dos accesos.
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF1565C0), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
