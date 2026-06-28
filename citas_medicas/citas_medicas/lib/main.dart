import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/citas_provider.dart';
import 'registro_cita.dart'; 
import 'listas_citas.dart'; 

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalCitas = context.watch<CitasProvider>().citas.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Citas Médicas"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Total citas: $totalCitas'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const RegistroCitaPage())
              ),
              child: const Text('Registrar Cita'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const ListasCitasPage())
              ),
              child: const Text('Ver Citas'),
            ),
          ],
        ),
      ),
    );
  }
}