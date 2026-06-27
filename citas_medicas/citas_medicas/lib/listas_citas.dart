import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cita.dart';
import 'providers/citas_provider.dart';

// MODIFICADO: StatelessWidget → StatefulWidget
// MOTIVO: necesita estado para la búsqueda y filtros.
// CAMBIO CRÍTICO: los datos hardcodeados (3 ListTile fijos) fueron
// reemplazados por datos reales del CitasProvider. El original nunca
// mostraría las citas que el usuario registra.
class ListaCitasPage extends StatefulWidget {
  const ListaCitasPage({super.key});

  @override
  State<ListaCitasPage> createState() => _ListaCitasPageState();
}

class _ListaCitasPageState extends State<ListaCitasPage> {
  // AÑADIDO: estado para búsqueda y filtro por estado
  String  _busqueda    = '';
  String? _filtroEstado; // null = todos

  static const _estados = [
    'Programada',
    'Atendida',
    'Cancelada',
    'Reprogramada',
  ];

  List<Cita> _filtrar(List<Cita> citas) {
    return citas.where((c) {
      final coincideBusqueda = _busqueda.isEmpty ||
          c.paciente.toLowerCase().contains(_busqueda.toLowerCase());
      final coincideEstado =
          _filtroEstado == null || c.estado == _filtroEstado;
      return coincideBusqueda && coincideEstado;
    }).toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  String _formatearFecha(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  // AÑADIDO: diálogo para cambiar el estado de una cita
  void _cambiarEstado(Cita cita) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cambiar Estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _estados
              .map((e) => ListTile(
                    title: Text(e),
                    leading: Radio<String>(
                      value: e,
                      groupValue: cita.estado,
                      onChanged: (v) {
                        if (v != null) {
                          context
                              .read<CitasProvider>()
                              .cambiarEstado(cita.id, v);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // AÑADIDO: diálogo de confirmación antes de eliminar
  void _confirmarEliminar(Cita cita) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Cita'),
        content: Text(
            '¿Estás seguro de eliminar la cita de ${cita.paciente}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<CitasProvider>().eliminarCita(cita.id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MODIFICADO: en lugar de los 3 ListTile fijos, se obtienen
    // las citas reales del CitasProvider y se aplican filtros.
    final todasLasCitas = context.watch<CitasProvider>().citas;
    final citasFiltradas = _filtrar(todasLasCitas.toList());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Citas"),
      ),
      body: Column(
        children: [
          // AÑADIDO: barra de búsqueda por nombre de paciente
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por paciente…',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _busqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _busqueda = ''),
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _busqueda = v),
            ),
          ),

          // AÑADIDO: chips de filtro rápido por estado
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Todos'),
                    selected: _filtroEstado == null,
                    onSelected: (_) =>
                        setState(() => _filtroEstado = null),
                  ),
                ),
                ..._estados.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(e),
                        selected: _filtroEstado == e,
                        onSelected: (_) => setState(() =>
                            _filtroEstado = _filtroEstado == e ? null : e),
                      ),
                    )),
              ],
            ),
          ),

          // AÑADIDO: contador de resultados visibles
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text(
                  '${citasFiltradas.length} cita${citasFiltradas.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // MODIFICADO: ListView ahora muestra datos reales.
          // ORIGINAL conservado en estructura: mismo ListView con leading icon,
          // title con nombre del paciente, subtitle con detalles.
          // Se añade menú contextual y colores de estado.
          Expanded(
            child: citasFiltradas.isEmpty
                ? _EmptyState(
                    hayFiltro: _busqueda.isNotEmpty ||
                        _filtroEstado != null,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: citasFiltradas.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, i) {
                      final cita = citasFiltradas[i];
                      final colorEstado = Color(cita.colorEstado);
                      return ListTile(
                        // ORIGINAL conservado: leading icon de persona
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF1565C0).withOpacity(0.12),
                          child: const Icon(Icons.person,
                              color: Color(0xFF1565C0)),
                        ),
                        // ORIGINAL conservado: title con nombre del paciente
                        title: Text(
                          cita.paciente,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        // ORIGINAL conservado: subtitle con especialidad/fecha/estado
                        // ahora con datos reales en lugar de texto hardcodeado
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cita.especialidad} · ${cita.profesional}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              _formatearFecha(cita.fechaHora),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600),
                            ),
                            if (cita.motivo.isNotEmpty)
                              Text(
                                cita.motivo,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        // AÑADIDO: badge de estado con color + menú de acciones
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorEstado.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: colorEstado.withOpacity(0.4)),
                              ),
                              child: Text(
                                cita.estado,
                                style: TextStyle(
                                  color: colorEstado,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // AÑADIDO: menú contextual al mantener presionado
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.swap_horiz),
                                    title: const Text('Cambiar estado'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _cambiarEstado(cita);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete,
                                        color: Colors.red),
                                    title: const Text('Eliminar cita',
                                        style:
                                            TextStyle(color: Colors.red)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _confirmarEliminar(cita);
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
          ),
        ],
      ),
    );
  }
}

// AÑADIDO: pantalla vacía cuando no hay citas o no hay resultados de búsqueda
class _EmptyState extends StatelessWidget {
  final bool hayFiltro;
  const _EmptyState({required this.hayFiltro});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hayFiltro
                ? Icons.search_off
                : Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            hayFiltro
                ? 'Sin resultados para tu búsqueda'
                : 'No hay citas registradas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!hayFiltro) ...[
            const SizedBox(height: 8),
            Text(
              'Registra una cita desde la pantalla principal',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }
}
