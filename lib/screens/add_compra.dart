import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'table_screen.dart';

class AddCompraScreen extends StatefulWidget {
  @override
  _AddCompraScreenState createState() => _AddCompraScreenState();
}

class _AddCompraScreenState extends State<AddCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  String _categoria = 'Alimentación';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir Compra')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _montoController,
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _categoria,
                onChanged: (String? newValue) {
                  setState(() {
                    _categoria = newValue!;
                  });
                },
                items: <String>['Alimentación', 'Casa', 'Transporte', 'Ropa']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Categoría'),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseHelper.instance.insertCompra({
                        'monto': double.parse(_montoController.text),
                        'categoria': _categoria,
                        'fecha': DateTime.now().toIso8601String(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Compra agregada exitosamente')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TableScreen()),
                      );
                    }
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
