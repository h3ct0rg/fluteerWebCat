import 'package:flutter/material.dart';
import '../routes.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              key: Key('welcome_image'),
              constraints: BoxConstraints(
                maxHeight: 300,
              ),
              child: Image.network(
                'https://png.pngtree.com/png-clipart/20240105/original/pngtree-bengal-kitten-cat-bengal-photo-png-image_14022475.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              key: Key('registerButton'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: Text('Registrar Gatito'),
            ),
            ElevatedButton(
              key: Key('viewButton'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.viewCats);
              },
              child: Text('Ver Gatitos Registrados'),
            ),
          ],
        ),
      ),
    );
  }
}
