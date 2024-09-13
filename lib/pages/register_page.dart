import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedRaza;

  // Lista de razas para el dropdown
  final List<String> _razas = [
    'Siamés',
    'Persa',
    'Maine Coon',
    'Bengalí',
    'Sphynx'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveGatito() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedRaza != null) {
      final dbService = DbService();

      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      final gatito = {
        'nombre': _nombreController.text,
        'raza': _selectedRaza,
        'edad': int.parse(_edadController.text),
        'color': _colorController.text,
        'fecha_ultima_vacunacion': formattedDate,
      };

      await dbService.addGatito(gatito);

      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _selectedRaza = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gatito registrado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Gatito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                key: Key('nombreField'),
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: Key('razaDropdown'),
                decoration: InputDecoration(labelText: 'Raza'),
                value: _selectedRaza,
                items: _razas.map((String raza) {
                  return DropdownMenuItem<String>(
                    value: raza,
                    child: Text(raza),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRaza = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una raza';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                key: Key('edadField'),
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Edad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una edad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, ingresa un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                key: Key('colorField'),
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un color';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Selecciona la fecha de última vacunación'
                          : 'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    ),
                  ),
                  ElevatedButton(
                    key: Key('fechaButton'),
                    onPressed: () => _selectDate(context),
                    child: Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                key: Key('saveButton'),
                onPressed: _saveGatito,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
