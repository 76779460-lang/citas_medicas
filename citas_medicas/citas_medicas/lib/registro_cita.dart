import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Asegúrate de importar tu archivo del provider aquí:
import 'providers/citas_provider.dart'; 

class RegistroCitaPage extends StatefulWidget {
  const RegistroCitaPage({super.key});

  @override
  State<RegistroCitaPage> createState() => _RegistroCitaPageState();
}

class _RegistroCitaPageState extends State<RegistroCitaPage> {
  // 1. Controladores para capturar el texto
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _motivoCtrl = TextEditingController();
  final TextEditingController _telefonoCtrl = TextEditingController();

  final List<String> especialidades = ['Medicina General', 'Pediatría', 'Cardiología', 'Dermatología'];
  String? especialidadSeleccionada;
  DateTime? fechaSeleccionada;
  TimeOfDay? horaSeleccionada;

  // Funciones de selección (se mantienen igual)
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2027));
    if (picked != null) setState(() => fechaSeleccionada = picked);
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => horaSeleccionada = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Cita"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 15),
            TextField(controller: _motivoCtrl, decoration: const InputDecoration(labelText: 'Motivo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.medical_services))),
            const SizedBox(height: 15),
            TextField(controller: _telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Especialidad', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
              value: especialidadSeleccionada,
              items: especialidades.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => especialidadSeleccionada = v),
            ),
            const SizedBox(height: 15),

            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Colors.grey)),
              title: Text(fechaSeleccionada == null ? 'Seleccionar fecha' : 'Fecha: ${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _seleccionarFecha(context),
            ),
            const SizedBox(height: 15),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Colors.grey)),
              title: Text(horaSeleccionada == null ? 'Seleccionar hora' : 'Hora: ${horaSeleccionada!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _seleccionarHora(context),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 2. Aquí enviamos los datos al Provider
                  if (_nombreCtrl.text.isNotEmpty) {
                    Provider.of<CitasProvider>(context, listen: false).agregarCita(
                      _nombreCtrl.text,
                      _motivoCtrl.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar Cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}