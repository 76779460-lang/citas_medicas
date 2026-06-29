import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/citas_provider.dart';

class ListasCitasPage extends StatelessWidget {
  const ListasCitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Citas"), centerTitle: true),
      body: Consumer<CitasProvider>(
        builder: (context, provider, child) {
          if (provider.citas.isEmpty) {
            return const Center(child: Text("No tienes citas programadas."));
          }
          
          return ListView.builder(
            itemCount: provider.citas.length,
            itemBuilder: (context, index) {
              final cita = provider.citas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(cita.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Motivo: ${cita.motivo}"),
                      Text("Estado: ${cita.estado}", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Menú de Estados
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        tooltip: "Cambiar estado",
                        onSelected: (nuevo) => provider.cambiarEstado(index, nuevo),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Pendiente', child: Text('Pendiente')),
                          const PopupMenuItem(value: 'Atendida', child: Text('Atendida')),
                          const PopupMenuItem(value: 'Reprogramada', child: Text('Reprogramada')),
                        ],
                      ),
                      // Botón Eliminar con Deshacer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final citaEliminada = provider.citas[index];
                          provider.eliminarCita(index);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Cita eliminada'),
                              action: SnackBarAction(
                                label: 'Deshacer',
                                onPressed: () => provider.insertarCita(index, citaEliminada),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}