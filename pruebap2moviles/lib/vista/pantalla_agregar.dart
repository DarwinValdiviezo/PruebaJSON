import 'package:flutter/material.dart';
import '../controlador/controlador_verduras.dart';
import '../modelo/verdura.dart';

class PantallaAgregar extends StatefulWidget {
  final ControladorVerduras controlador;
  final String sha;
  final List<Verdura> verduras;

  PantallaAgregar(
      {required this.controlador, required this.sha, required this.verduras});

  @override
  _PantallaAgregarState createState() => _PantallaAgregarState();
}

class _PantallaAgregarState extends State<PantallaAgregar> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();

  void _agregar() async {
    if (_formKey.currentState!.validate()) {
      final nuevaVerdura = Verdura(
        codigo: int.parse(_codigoController.text),
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
      );
      try {
        await widget.controlador
            .agregarVerdura(widget.verduras, nuevaVerdura, widget.sha);
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
      appBar: AppBar(title: Text('Agregar Verdura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codigoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el código' : null,
              ),
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
                onPressed: _agregar,
                child: Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
