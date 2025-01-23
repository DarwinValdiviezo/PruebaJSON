import 'package:flutter/material.dart';
import '../controlador/controlador_verduras.dart';
import '../modelo/verdura.dart';
import 'pantalla_agregar.dart';
import 'pantalla_editar.dart';
import 'pantalla_detalle.dart';

class PantallaPrincipal extends StatefulWidget {
  final ControladorVerduras controlador;

  PantallaPrincipal({required this.controlador});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  List<Verdura> verduras = [];
  String sha = '';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    final archivo = await widget.controlador.obtenerArchivo();
    setState(() {
      sha = archivo['sha'];
      verduras = archivo['contenido']
          .map<Verdura>((json) => Verdura.fromJson(json))
          .toList();
    });
  }

  void _navegarAgregar() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaAgregar(
          controlador: widget.controlador,
          sha: sha,
          verduras: verduras,
        ),
      ),
    );

    if (resultado == true) {
      cargarDatos();
    }
  }

  void _navegarEditar(Verdura verdura) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaEditar(
          controlador: widget.controlador,
          sha: sha,
          verduras: verduras,
          verdura: verdura,
        ),
      ),
    );

    if (resultado == true) {
      cargarDatos();
    }
  }

  void _navegarDetalle(Verdura verdura) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaDetalle(verdura: verdura),
      ),
    );
  }

  void _eliminarVerdura(int codigo) async {
    await widget.controlador.eliminarVerdura(verduras, codigo, sha);
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Verduras')),
      body: ListView.builder(
        itemCount: verduras.length,
        itemBuilder: (context, index) {
          final verdura = verduras[index];
          return ListTile(
            title: Text(verdura.descripcion),
            subtitle: Text('Precio: \$${verdura.precio}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navegarEditar(
                      verdura), // Navegar a la pantalla de edición
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _eliminarVerdura(verdura.codigo), // Eliminar la verdura
                ),
              ],
            ),
            onTap: () =>
                _navegarDetalle(verdura), // Navegar a la pantalla de detalles
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarAgregar,
        child: Icon(Icons.add),
      ),
    );
  }
}
