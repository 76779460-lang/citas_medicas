// ============================================================
// ARCHIVO NUEVO: lib/models/cita.dart
// MOTIVO: El proyecto no tenía modelo de datos.
// Sin esta clase es imposible pasar citas entre pantallas,
// mostrar datos reales en la lista, o validar campos.
// ============================================================

class Cita {
  final String id;
  final String paciente;
  final String especialidad;
  final String profesional;
  final DateTime fechaHora;
  final String motivo;
  String estado;

  Cita({
    required this.id,
    required this.paciente,
    required this.especialidad,
    required this.profesional,
    required this.fechaHora,
    required this.motivo,
    this.estado = 'Programada',
  });

  /// Color asociado al estado para la UI.
  static const Map<String, int> coloresEstado = {
    'Programada':   0xFF1976D2, // azul
    'Atendida':     0xFF388E3C, // verde
    'Cancelada':    0xFFD32F2F, // rojo
    'Reprogramada': 0xFFF57C00, // naranja
  };

  int get colorEstado => coloresEstado[estado] ?? 0xFF757575;
}
