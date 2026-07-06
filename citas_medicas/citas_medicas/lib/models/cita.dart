// ============================================================
// ARCHIVO NUEVO: lib/models/cita.dart
// MOTIVO: El proyecto no tenía modelo de datos.
// Sin esta clase es imposible pasar citas entre pantallas,
// mostrar datos reales en la lista, o validar campos.
// ============================================================

// ============================================================
// ARCHIVO: lib/models/cita.dart
// ============================================================

class Cita {
  final String id;
  final String paciente;
  final String especialidad; 
  final String profesional;
  final DateTime fechaHora;
  final String motivo;
  final String estado;

  Cita({
    required this.id,
    required this.paciente,
    required this.especialidad,
    required this.profesional,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
  });

  Cita copyWith({
    String? id,
    String? paciente,
    String? especialidad,
    String? profesional,
    DateTime? fechaHora,
    String? motivo,
    String? estado,
  }) {
    return Cita(
      id: id ?? this.id,
      paciente: paciente ?? this.paciente,
      especialidad: especialidad ?? this.especialidad,
      profesional: profesional ?? this.profesional,
      fechaHora: fechaHora ?? this.fechaHora,
      motivo: motivo ?? this.motivo,
      estado: estado ?? this.estado,
    );
  }
}