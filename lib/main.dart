import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

// Tahan Propiedades - DUO Apps Development
// NOTA: la app NO usa geolocalización (sin GPS, mapas ni permisos de ubicación).
// Base de datos: Supabase (catálogo de propiedades y consultas de clientes).

const String kWhatsApp = 'https://wa.link/lc56dd';
const String kMail = 'mailto:veronicatahaninmobiliaria@gmail.com';
const String kInstagram = 'https://www.instagram.com/veronicatahaninmobiliaria/';

// Las coordenadas están en píxeles sobre las pantallas de 880 x 1913.
const double kW = 880;
const double kH = 1913;

const Color kRosa = Color(0xFFFBE9E7);
const Color kCampo = Color(0xFFAD9C92);

// ---------------------------------------------------------------------------
// Datos (Supabase)
// ---------------------------------------------------------------------------

/// Una propiedad del catálogo. La ficha es la pantalla número (posición + 2).
class Ficha {
  final String operacion; // 'venta' o 'alquiler'
  final int orden;
  final String imagen; // nombre del archivo en el bucket "fichas"
  const Ficha({
    required this.operacion,
    required this.orden,
    required this.imagen,
  });
}

bool supabaseListo = false;
List<Ficha> catalogo = [];

/// Catálogo de respaldo: se usa si Supabase no está configurado o no responde.
List<Ficha> catalogoLocal() {
  final lista = <Ficha>[];
  for (var n = 2; n <= 19; n++) {
    lista.add(Ficha(
      operacion: n <= 10 ? 'venta' : 'alquiler',
      orden: n <= 10 ? n - 1 : n - 10,
      imagen: 's-${n.toString().padLeft(2, '0')}.jpg',
    ));
  }
  return lista;
}

Future<void> iniciarDatos() async {
  catalogo = catalogoLocal();
  if (!supabaseConfigurado) return;
  try {
    await Supabase.initialize(url: kSupabaseUrl, anonKey: kSupabaseAnonKey);
    supabaseListo = true;
  } catch (_) {
    supabaseListo = false;
    return;
  }
  try {
    final filas = await Supabase.instance.client
        .from('propiedades')
        .select()
        .order('orden')
        .timeout(const Duration(seconds: 6));
    final lista = <Ficha>[];
    for (final f in filas) {
      final imagen = (f['imagen'] ?? '').toString();
      if (imagen.isEmpty) continue;
      lista.add(Ficha(
        operacion: (f['operacion'] ?? 'venta').toString(),
        orden: (f['orden'] as num?)?.toInt() ?? 0,
        imagen: imagen,
      ));
    }
    lista.sort((a, b) {
      final c = (a.operacion == 'venta' ? 0 : 1)
          .compareTo(b.operacion == 'venta' ? 0 : 1);
      return c != 0 ? c : a.orden.compareTo(b.orden);
    });
    // Las pantallas 2 a 19 son fichas (máximo 18 propiedades).
    if (lista.isNotEmpty) catalogo = lista.take(18).toList();
  } catch (_) {
    // Si falla la lectura, queda el catálogo local.
  }
}

int get ventaCount => catalogo.where((f) => f.operacion == 'venta').length;
bool esFicha(int n) => n >= 2 && n <= catalogo.length + 1;

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await iniciarDatos();
  runApp(const TahanApp());
}

class TahanApp extends StatelessWidget {
  const TahanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahan Propiedades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF897260),
        scaffoldBackgroundColor: const Color(0xFF8B7B6C),
      ),
      // Pantalla 22 = bienvenida (logo). Al tocar pasa al Inicio (pantalla 1).
      home: const ScreenPage(22),
      // En pantallas anchas (compu) se muestra dentro de un marco de celular.
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        if (size.width < 600) return child!;
        final h = size.height * 0.94;
        final w = h * 880 / 1913;
        return Container(
          color: const Color(0xFF2B2B2B),
          alignment: Alignment.center,
          child: Container(
            width: w + 20,
            height: h + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(44),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 30, spreadRadius: 2),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Una zona táctil sobre la imagen.
class Hot {
  final double x, y, w, h, pad;
  final int? to; // número de pantalla destino
  final String? url; // o enlace externo
  final bool back; // botón visual de volver
  final bool fullScreen;
  final String label;
  const Hot(this.x, this.y, this.w, this.h,
      {this.pad = 8,
      this.to,
      this.url,
      this.back = false,
      this.fullScreen = false,
      required this.label});
}

List<Hot> hotspotsFor(int n) {
  if (n == 22) {
    return const [
      Hot(0, 0, kW, kH, pad: 0, to: 1, fullScreen: true, label: 'Entrar a la app')
    ];
  }
  if (n == 1) {
    final primeraAlquiler = ventaCount + 2;
    return [
      const Hot(257, 1177, 371, 73, to: 2, label: 'Ver propiedades en venta'),
      Hot(262, 1271, 372, 74,
          to: primeraAlquiler <= catalogo.length + 1 ? primeraAlquiler : 2,
          label: 'Ver propiedades en alquiler'),
      const Hot(254, 1606, 372, 73, to: 20, label: 'Ir a Contáctanos'),
      const Hot(254, 1700, 372, 73, to: 21, label: 'Ir a Nosotros'),
      const Hot(707, 1722, 86, 86, pad: 10, url: kWhatsApp, label: 'Abrir WhatsApp'),
    ];
  }
  if (esFicha(n)) {
    final v = ventaCount;
    final venta = n <= v + 1;
    final first = venta ? 2 : v + 2;
    final last = venta ? v + 1 : catalogo.length + 1;
    return [
      const Hot(88, 88, 190, 190, to: 1, label: 'Volver al inicio'),
      const Hot(698, 1782, 86, 86,
          pad: 10, url: kWhatsApp, label: 'Consultar por WhatsApp'),
      if (n < last)
        Hot(710, 700, 150, 240, pad: 0, to: n + 1, label: 'Siguiente propiedad'),
      if (n > first)
        Hot(20, 700, 150, 240, pad: 0, to: n - 1, label: 'Propiedad anterior')
      else if (!venta && last > first)
        Hot(20, 700, 150, 240, pad: 0, to: last, label: 'Última propiedad en alquiler'),
    ];
  }
  if (n == 20) {
    return const [
      Hot(88, 88, 92, 92, pad: 6, to: 1, back: true, label: 'Volver al inicio'),
      Hot(88, 1265, 704, 87, url: kWhatsApp, label: 'Escribir por WhatsApp'),
      Hot(88, 1413, 704, 87, url: kMail, label: 'Enviar un correo'),
      Hot(88, 1562, 694, 87, url: kInstagram, label: 'Abrir Instagram'),
    ];
  }
  if (n == 21) {
    return const [
      Hot(88, 88, 92, 92, pad: 6, to: 1, back: true, label: 'Volver al inicio')
    ];
  }
  return const [];
}

String assetFor(int n) => 'assets/screens/s-${n.toString().padLeft(2, '0')}.jpg';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

void goTo(BuildContext context, int target) {
  final nav = Navigator.of(context);
  if (target == 1) {
    // Volver al Inicio: limpiamos la pila y mostramos el Inicio.
    nav.pushAndRemoveUntil(_fade(const ScreenPage(1)), (r) => false);
  } else if (target >= 2 && target <= 19) {
    // Entre fichas se reemplaza (así "atrás" siempre vuelve al Inicio).
    final comingFromHome = ModalRoute.of(context)?.settings.name == 'p1';
    if (comingFromHome) {
      nav.push(_fade(ScreenPage(target)));
    } else {
      nav.pushReplacement(_fade(ScreenPage(target)));
    }
  } else {
    nav.push(_fade(ScreenPage(target)));
  }
}

Route<void> _fade(ScreenPage page) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: 'p${page.n}'),
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

/// Imagen de una pantalla. Las fichas se descargan de Supabase Storage;
/// mientras cargan (o si falla) se usa la copia que viene dentro de la app.
Widget screenImage(int n) {
  final local = Image.asset(
    assetFor(n),
    fit: BoxFit.fill,
    gaplessPlayback: true,
    errorBuilder: (_, __, ___) => const SizedBox.expand(),
  );
  if (supabaseListo && esFicha(n)) {
    final ficha = catalogo[n - 2];
    final url = Supabase.instance.client.storage
        .from('fichas')
        .getPublicUrl(ficha.imagen);
    return Image.network(
      url,
      fit: BoxFit.fill,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : local,
      errorBuilder: (_, __, ___) => local,
    );
  }
  return local;
}

Widget hotspotWidget(BuildContext context, Hot h, double s, int n) {
  final left = ((h.x - h.pad) * s).clamp(0.0, kW * s);
  final top = ((h.y - h.pad) * s).clamp(0.0, kH * s);
  final width = ((h.w + 2 * h.pad) * s).clamp(0.0, kW * s - left);
  final height = ((h.h + 2 * h.pad) * s).clamp(0.0, kH * s - top);

  return Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: Semantics(
      button: true,
      label: h.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (h.to != null) {
            if (n == 22) {
              Navigator.of(context).pushAndRemoveUntil(
                  _fade(const ScreenPage(1)), (r) => false);
            } else {
              goTo(context, h.to!);
            }
          } else if (h.url != null) {
            openUrl(h.url!);
          }
        },
        child: h.back ? _backButton() : const SizedBox.expand(),
      ),
    ),
  );
}

// Botón de volver (único elemento visual agregado al diseño).
Widget _backButton() {
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.86,
      heightFactor: 0.86,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBE9E7),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.arrow_back, color: Color(0xFF8B7B6C), size: 22),
        ),
      ),
    ),
  );
}

class ScreenPage extends StatelessWidget {
  final int n;
  const ScreenPage(this.n, {super.key});

  @override
  Widget build(BuildContext context) {
    if (n == 20) return const ContactoPage();
    final hots = hotspotsFor(n);
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: kW / kH,
          child: LayoutBuilder(builder: (context, c) {
            final s = c.maxWidth / kW;
            return Stack(
              fit: StackFit.expand,
              children: [
                screenImage(n),
                for (final h in hots) hotspotWidget(context, h, s, n),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contáctanos: formulario real que guarda la consulta en Supabase
// ---------------------------------------------------------------------------

class ContactoPage extends StatefulWidget {
  const ContactoPage({super.key});

  @override
  State<ContactoPage> createState() => _ContactoPageState();
}

class _ContactoPageState extends State<ContactoPage> {
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _mensaje = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _mensaje.dispose();
    super.dispose();
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    final nombre = _nombre.text.trim();
    final email = _email.text.trim();
    final mensaje = _mensaje.text.trim();
    if (nombre.isEmpty || !email.contains('@') || mensaje.isEmpty) {
      _aviso('Completá tu nombre, un correo válido y el mensaje.');
      return;
    }
    if (!supabaseListo) {
      _aviso('Por ahora no hay conexión con la base de datos.');
      return;
    }
    setState(() => _enviando = true);
    try {
      await Supabase.instance.client.from('consultas').insert({
        'nombre': nombre,
        'email': email,
        'mensaje': mensaje,
      });
      _nombre.clear();
      _email.clear();
      _mensaje.clear();
      if (mounted) _aviso('¡Gracias! Recibimos tu consulta.');
    } catch (_) {
      if (mounted) _aviso('No pudimos enviar la consulta. Probá de nuevo.');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Widget _campo(TextEditingController c, String hint, double s,
      {required double x,
      required double y,
      required double w,
      required double h,
      TextInputType tipo = TextInputType.text,
      bool multilinea = false}) {
    final estilo = TextStyle(
      color: kRosa,
      fontSize: 40 * s,
      fontWeight: FontWeight.w600,
    );
    return Positioned(
      left: x * s,
      top: y * s,
      width: w * s,
      height: h * s,
      child: TextField(
        controller: c,
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: multilinea ? TextInputType.multiline : tipo,
        inputFormatters: multilinea
            ? null
            : [FilteringTextInputFormatter.singleLineFormatter],
        style: estilo,
        cursorColor: kRosa,
        decoration: InputDecoration(
          filled: true,
          fillColor: kCampo,
          hintText: hint,
          hintStyle: estilo,
          contentPadding: EdgeInsets.fromLTRB(74 * s, 38 * s, 40 * s, 24 * s),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(92 * s),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hots = hotspotsFor(20);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: AspectRatio(
          aspectRatio: kW / kH,
          child: LayoutBuilder(builder: (context, c) {
            final s = c.maxWidth / kW;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(assetFor(20), fit: BoxFit.fill),
                _campo(_nombre, 'Nombre', s, x: 88, y: 266, w: 704, h: 184),
                _campo(_email, 'Correo electrónico', s,
                    x: 88,
                    y: 490,
                    w: 704,
                    h: 184,
                    tipo: TextInputType.emailAddress),
                _campo(_mensaje, 'Mensaje', s,
                    x: 88, y: 713, w: 704, h: 444, multilinea: true),
                for (final h in hots) hotspotWidget(context, h, s, 20),
                Positioned(
                  left: 254 * s,
                  top: 1700 * s,
                  width: 372 * s,
                  height: 73 * s,
                  child: Semantics(
                    button: true,
                    label: 'Enviar consulta',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _enviar,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRosa, width: 2.5 * s),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _enviando ? 'ENVIANDO...' : 'ENVIAR',
                          style: TextStyle(
                            color: kRosa,
                            fontSize: 34 * s,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
