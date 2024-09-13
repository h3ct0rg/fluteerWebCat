import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../services/db_service.dart';

class ViewCatsPage extends StatefulWidget {
  @override
  _ViewCatsPageState createState() => _ViewCatsPageState();
}

class _ViewCatsPageState extends State<ViewCatsPage> {
  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box(DbService.boxName);
  }

  bool isVaccinationExpired(DateTime lastVaccinationDate) {
    final currentDate = DateTime.now();
    final sixMonthsAgo = currentDate.subtract(Duration(days: 182));
    return lastVaccinationDate.isBefore(sixMonthsAgo);
  }

  void deleteCat(int index) {
    setState(() {
      box.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gatitos Registrados'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No hay gatitos registrados.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var gatito = Map<String, dynamic>.from(box.getAt(index) as Map);
              String nombre = gatito['nombre'] ?? 'Sin nombre';
              String raza = gatito['raza'] ?? 'Sin raza';
              String fechaVacunacion =
                  gatito['fechaVacunacion'] ?? '2000-01-01';

              DateTime fechaVacunacionDate;
              try {
                fechaVacunacionDate =
                    DateFormat('yyyy-MM-dd').parse(fechaVacunacion);
              } catch (e) {
                fechaVacunacionDate = DateTime(2000, 1, 1);
              }

              bool isExpired = isVaccinationExpired(fechaVacunacionDate);

              return Container(
                key: Key('cat_$index'),
                color: isExpired ? Colors.red[100] : Colors.transparent,
                child: ListTile(
                  title: Text('$nombre - $raza'),
                  subtitle: Text('Última vacunación: $fechaVacunacion'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Eliminar Gatito'),
                          content: Text(
                              '¿Estás seguro de que quieres eliminar a $nombre?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteCat(index);
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
