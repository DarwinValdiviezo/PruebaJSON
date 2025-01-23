import 'package:flutter/material.dart';
import '../controlador/controlador_verduras.dart';
import '../modelo/verdura.dart';

class PantallaEditar extends StatefulWidget {
  final ControladorVerduras controlador;
  final String sha;
  final List<Verdura> verduras;
  final Verdura verdura;

  PantallaEditar({
    required this.controlador,
    required this.sha,
    required this.verduras,
    required this.verdura,
  });

  @override
  _PantallaEditarState createState() => _PantallaEditarState();
}

class _PantallaEditarState extends State<PantallaEditar> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales de la verdura
    _descripcionController =
        TextEditingController(text: widget.verdura.descripcion);
    _precioController =
        TextEditingController(text: widget.verdura.precio.toString());
  }

  void _editarVerdura() async {
    if (_formKey.currentState!.validate()) {
      final verduraActualizada = Verdura(
        codigo: widget.verdura.codigo, // Mantener el mismo código
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
      );

      try {
        // Actualizar la verdura en la lista y en GitHub
        await widget.controlador
            .actualizarVerdura(widget.verduras, verduraActualizada, widget.sha);

        // Volver a la pantalla principal
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Verdura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Código: ${widget.verdura.codigo}', // Mostrar el código, no se puede cambiar
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la descripción' : null,
              ),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Precio'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el precio' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editarVerdura,
                child: Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
