// ============================================================
// ARCHIVO NUEVO: lib/providers/citas_provider.dart
// MOTIVO: El proyecto no tenía estado compartido entre páginas.
// Registrar una cita en RegistroCitaPage nunca se reflejaba
// en ListaCitasPage. Este provider usa ChangeNotifier (patrón
// oficial de Flutter) como fuente de verdad de las citas.
// ============================================================

// ============================================================
// ARCHIVO: lib/providers/citas_provider.dart
// ============================================================

import 'package:flutter/material.dart';

class Cita {
  final String nombre;
  final String motivo;
  String estado;

  Cita({required this.nombre, required this.motivo, this.estado = 'Pendiente'});
}

class CitasProvider extends ChangeNotifier {
  final List<Cita> _citas = [];
  
  List<Cita> get citas => _citas;

  void agregarCita(String nombre, String motivo) {
    _citas.add(Cita(nombre: nombre, motivo: motivo));
    notifyListeners();
  }

  void eliminarCita(int index) {
    _citas.removeAt(index);
    notifyListeners();
  }

  void insertarCita(int index, Cita cita) {
    _citas.insert(index, cita);
    notifyListeners();
  }

  void cambiarEstado(int index, String nuevoEstado) {
    _citas[index].estado = nuevoEstado;
    notifyListeners();
  }
}