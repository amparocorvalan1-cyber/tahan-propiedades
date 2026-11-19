// Conexión con Firebase (proyecto "tahan-propiedades").
// Estos datos se copian de: Firebase > Configuración del proyecto > Tus apps.
// Son claves públicas, pensadas para ir dentro de la app: la seguridad la dan
// las reglas de Firestore (pestaña "Reglas").

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const FirebaseOptions _web = FirebaseOptions(
  apiKey: 'AIzaSyCxkwvuOFFuxYlNNxCvHLCbxlL6c5R_0-U',
  authDomain: 'tahan-propiedades.firebaseapp.com',
  projectId: 'tahan-propiedades',
  storageBucket: 'tahan-propiedades.firebasestorage.app',
  messagingSenderId: '489506121515',
  appId: '1:489506121515:web:7c6ce2530fa2152f48076e',
);

const FirebaseOptions _android = FirebaseOptions(
  apiKey: 'AIzaSyCxkwvuOFFuxYlNNxCvHLCbxlL6c5R_0-U',
  projectId: 'tahan-propiedades',
  storageBucket: 'tahan-propiedades.firebasestorage.app',
  messagingSenderId: '489506121515',
  appId: '1:489506121515:android:88724a2802ca940748076e',
);

FirebaseOptions get kFirebaseOptions => kIsWeb ? _web : _android;

/// Catálogo inicial de propiedades (colección "propiedades" de Firestore).
const List<Map<String, Object>> kPropiedadesIniciales = [
  {'operacion': 'venta', 'orden': 1, 'imagen': 's-02.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 230000, 'direccion': 'Pueyrredon, Chacras de Coria'},
  {'operacion': 'venta', 'orden': 2, 'imagen': 's-03.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 400000, 'direccion': 'Gran Boedo'},
  {'operacion': 'venta', 'orden': 3, 'imagen': 's-04.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 250000, 'direccion': 'Liceo Country Club II'},
  {'operacion': 'venta', 'orden': 4, 'imagen': 's-05.jpg', 'tipo': 'Lote', 'moneda': 'USD', 'precio': 75000, 'direccion': 'Terrazas Park, Vistalba', 'superficie_m2': 500},
  {'operacion': 'venta', 'orden': 5, 'imagen': 's-06.jpg', 'tipo': 'Local comercial', 'moneda': 'USD', 'precio': 44000, 'direccion': 'Ing. Baglietto 2910', 'superficie_m2': 21},
  {'operacion': 'venta', 'orden': 6, 'imagen': 's-07.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 35000, 'direccion': 'Francisco Evans'},
  {'operacion': 'venta', 'orden': 7, 'imagen': 's-08.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 600000, 'direccion': 'San Francisco del Monte', 'superficie_m2': 30000},
  {'operacion': 'venta', 'orden': 8, 'imagen': 's-09.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 250000, 'direccion': 'El Marquesado'},
  {'operacion': 'venta', 'orden': 9, 'imagen': 's-10.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 105000, 'direccion': 'La Delia'},
  {'operacion': 'alquiler', 'orden': 1, 'imagen': 's-11.jpg', 'tipo': 'Departamento', 'moneda': 'ARS', 'precio': 750000, 'direccion': '9 de Julio'},
  {'operacion': 'alquiler', 'orden': 2, 'imagen': 's-12.jpg', 'tipo': 'Departamento', 'moneda': 'ARS', 'precio': 650000, 'direccion': 'Terrazas del Bombal'},
  {'operacion': 'alquiler', 'orden': 3, 'imagen': 's-13.jpg', 'tipo': 'Departamento', 'moneda': 'ARS', 'precio': 550000, 'direccion': 'Azcuenaga'},
  {'operacion': 'alquiler', 'orden': 4, 'imagen': 's-14.jpg', 'tipo': 'Casa', 'moneda': 'USD', 'precio': 1000, 'direccion': 'Maza Sur, Lunlunta'},
  {'operacion': 'alquiler', 'orden': 5, 'imagen': 's-15.jpg', 'tipo': 'Casa', 'moneda': 'ARS', 'precio': 1300000, 'direccion': 'Emilio Civit'},
  {'operacion': 'alquiler', 'orden': 6, 'imagen': 's-16.jpg', 'tipo': 'Casa', 'moneda': 'ARS', 'precio': 1500000, 'direccion': 'Las Catalpas'},
  {'operacion': 'alquiler', 'orden': 7, 'imagen': 's-17.jpg', 'tipo': 'Casa', 'moneda': 'ARS', 'precio': 1500000, 'direccion': 'Arizu, Godoy Cruz'},
  {'operacion': 'alquiler', 'orden': 8, 'imagen': 's-18.jpg', 'tipo': 'Casa', 'moneda': 'ARS', 'precio': 850000, 'direccion': 'San Martin'},
  {'operacion': 'alquiler', 'orden': 9, 'imagen': 's-19.jpg', 'tipo': 'Casa', 'moneda': 'ARS', 'precio': 2100000, 'direccion': 'Club de Campo, Guaymallen'},
];
