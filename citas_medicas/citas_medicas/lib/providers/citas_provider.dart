// ============================================================
// ARCHIVO NUEVO: lib/providers/citas_provider.dart
// MOTIVO: El proyecto no tenía estado compartido entre páginas.
// Registrar una cita en RegistroCitaPage nunca se reflejaba
// en ListaCitasPage. Este provider usa ChangeNotifier (patrón
// oficial de Flutter) como fuente de verdad de las citas.
// ============================================================

import 'package:flutter/material.dart';
import '../models/cita.dart';

class CitasProvider extends ChangeNotifier {
  final List<Cita> _citas = [
    // Datos de ejemplo para que la lista no aparezca vacía al inicio
    Cita(
      id: '1',
      paciente: 'Juan Pérez',
      especialidad: 'Odontología',
      profesional: 'Dr. Ramírez',
      fechaHora: DateTime(2026, 6, 20, 10, 0),
      motivo: 'Limpieza dental',
      estado: 'Programada',
    ),
    Cita(
      id: '2',
      paciente: 'María López',
      especialidad: 'Medicina General',
      profesional: 'Dra. Soto',
      fechaHora: DateTime(2026, 6, 18, 9, 30),
      motivo: 'Control de rutina',
      estado: 'Atendida',
    ),
    Cita(
      id: '3',
      paciente: 'Carlos Torres',
      especialidad: 'Cardiología',
      profesional: 'Dr. Vega',
      fechaHora: DateTime(2026, 6, 25, 11, 0),
      motivo: 'Electrocardiograma',
      estado: 'Reprogramada',
    ),
  ];

  List<Cita> get citas => List.unmodifiable(_citas);

  /// Agrega una nueva cita y notifica a los widgets suscritos.
  void agregarCita(Cita cita) {
    _citas.add(cita);
    notifyListeners();
  }

  /// Cambia el estado de una cita existente.
  void cambiarEstado(String id, String nuevoEstado) {
    final index = _citas.indexWhere((c) => c.id == id);
    if (index != -1) {
      _citas[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  /// Elimina una cita por su id.
  void eliminarCita(String id) {
    _citas.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  /// Genera un id único simple basado en timestamp.
  String generarId() => DateTime.now().millisecondsSinceEpoch.toString();
}
