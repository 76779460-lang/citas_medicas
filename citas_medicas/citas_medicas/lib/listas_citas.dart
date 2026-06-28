import 'package:flutter/material.dart';

class ListasCitasPage extends StatelessWidget {
  const ListasCitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Citas")),
      body: const Center(child: Text("Aquí verás tus citas")),
    );
  }
}