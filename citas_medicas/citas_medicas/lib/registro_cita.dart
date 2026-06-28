import 'package:flutter/material.dart';

class RegistroCitaPage extends StatefulWidget {
  const RegistroCitaPage({super.key});

  @override
  State<RegistroCitaPage> createState() => _RegistroCitaPageState();
}

class _RegistroCitaPageState extends State<RegistroCitaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Cita")),
      body: const Center(child: Text("Formulario aquí")),
    );
  }
}