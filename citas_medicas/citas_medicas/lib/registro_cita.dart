import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cita.dart';
import 'providers/citas_provider.dart';

// MODIFICADO: StatelessWidget → StatefulWidget
// MOTIVO CRÍTICO: el original era StatelessWidget, lo que hacía imposible
// leer lo que el usuario escribía. Un StatelessWidget no puede tener
// TextEditingControllers ni guardar el estado del formulario.
class RegistroCitaPage extends StatefulWidget {
  const RegistroCitaPage({super.key});

  @override
  State<RegistroCitaPage> createState() => _RegistroCitaPageState();
}

class _RegistroCitaPageState extends State<RegistroCitaPage> {
  // AÑADIDO: clave de formulario para validación global
  final _formKey = GlobalKey<FormState>();

  // AÑADIDO: controladores — el original no los tenía, los campos eran decorativos
  final _pacienteCtrl     = TextEditingController();
  final _especialidadCtrl = TextEditingController();
  final _profesionalCtrl  = TextEditingController();
  final _motivoCtrl       = TextEditingController();

  // AÑADIDO: estado para fecha/hora y dropdown
  DateTime?  _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;

  // CORREGIDO: el original tenía onChanged: (value) {} → valor siempre null
  String _estadoSeleccionado = 'Programada';

  @override
  void dispose() {
    // AÑADIDO: liberar memoria al salir. El original no tenía dispose
    // porque no había controladores que limpiar.
    _pacienteCtrl.dispose();
    _especialidadCtrl.dispose();
    _profesionalCtrl.dispose();
    _motivoCtrl.dispose();
    super.dispose();
  }

  // AÑADIDO: selector de fecha + hora en secuencia (DatePicker → TimePicker)
  // El original tenía un TextField libre para fecha, sin formato garantizado.
  Future<void> _seleccionarFechaHora() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Seleccionar fecha de la cita',
    );
    if (fecha == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Seleccionar hora de la cita',
    );
    if (hora == null || !mounted) return;

    setState(() {
      _fechaSeleccionada = fecha;
      _horaSeleccionada  = hora;
    });
  }

  String get _fechaTexto {
    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      return 'Seleccionar fecha y hora';
    }
    final d = _fechaSeleccionada!;
    final h = _horaSeleccionada!;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}  '
        '${h.hour.toString().padLeft(2, '0')}:'
        '${h.minute.toString().padLeft(2, '0')}';
  }

  // AÑADIDO: lógica real de guardado. El original solo mostraba un SnackBar
  // sin hacer nada con los datos ingresados.
  void _guardarCita() {
    if (!_formKey.currentState!.validate()) return;

    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona fecha y hora de la cita.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final fechaHora = DateTime(
      _fechaSeleccionada!.year,
      _fechaSeleccionada!.month,
      _fechaSeleccionada!.day,
      _horaSeleccionada!.hour,
      _horaSeleccionada!.minute,
    );

    final provider = context.read<CitasProvider>();
    provider.agregarCita(Cita(
      id:           provider.generarId(),
      paciente:     _pacienteCtrl.text.trim(),
      especialidad: _especialidadCtrl.text.trim(),
      profesional:  _profesionalCtrl.text.trim(),
      fechaHora:    fechaHora,
      motivo:       _motivoCtrl.text.trim(),
      estado:       _estadoSeleccionado,
    ));

    // ORIGINAL conservado — mismo SnackBar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cita registrada correctamente"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // volver a inicio tras guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Cita"),
      ),
      // AÑADIDO: Form wrapper para habilitar validación con _formKey
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ORIGINAL conservado — campo Paciente, ahora con controller y validator
                TextFormField(
                  controller: _pacienteCtrl,
                  decoration: const InputDecoration(
                    labelText: "Paciente",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre del paciente'
                      : null,
                ),

                const SizedBox(height: 15),

                // ORIGINAL conservado — campo Especialidad, ahora con controller y validator
                TextFormField(
                  controller: _especialidadCtrl,
                  decoration: const InputDecoration(
                    labelText: "Especialidad",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa la especialidad'
                      : null,
                ),

                const SizedBox(height: 15),

                // ORIGINAL conservado — campo Profesional, ahora con controller y validator
                TextFormField(
                  controller: _profesionalCtrl,
                  decoration: const InputDecoration(
                    labelText: "Profesional",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre del profesional'
                      : null,
                ),

                const SizedBox(height: 15),

                // ORIGINAL: era TextField libre para "Fecha y Hora".
                // MODIFICADO: ahora abre DatePicker + TimePicker para
                // garantizar un formato de fecha consistente y válido.
                GestureDetector(
                  onTap: _seleccionarFechaHora,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: _fechaSeleccionada == null
                            ? Colors.grey.shade400
                            : const Color(0xFF1565C0),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: _fechaSeleccionada == null
                              ? Colors.grey
                              : const Color(0xFF1565C0),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _fechaTexto,
                          style: TextStyle(
                            fontSize: 16,
                            color: _fechaSeleccionada == null
                                ? Colors.grey.shade600
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ORIGINAL conservado — campo Motivo, ahora con controller y validator
                TextFormField(
                  controller: _motivoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Motivo de la cita",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Describe el motivo de la cita'
                      : null,
                ),

                const SizedBox(height: 20),

                // ORIGINAL conservado — mismo Dropdown con los mismos 4 estados.
                // CORREGIDO: onChanged ahora guarda el valor (antes era vacío).
                DropdownButtonFormField<String>(
                  value: _estadoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: "Estado",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Programada",
                      child: Text("Programada"),
                    ),
                    DropdownMenuItem(
                      value: "Atendida",
                      child: Text("Atendida"),
                    ),
                    DropdownMenuItem(
                      value: "Cancelada",
                      child: Text("Cancelada"),
                    ),
                    DropdownMenuItem(
                      value: "Reprogramada",
                      child: Text("Reprogramada"),
                    ),
                  ],
                  // CORREGIDO: el original tenía onChanged: (value) {}
                  // El valor nunca se actualizaba. Ahora sí se guarda.
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _estadoSeleccionado = value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // ORIGINAL conservado — mismo botón "Guardar Cita",
                // ahora llama a _guardarCita() en lugar de solo mostrar SnackBar.
                ElevatedButton(
                  onPressed: _guardarCita,
                  child: const Text("Guardar Cita"),
                ),

                const SizedBox(height: 10),

                // AÑADIDO: botón cancelar para volver sin guardar
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
