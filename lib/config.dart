// Datos de conexión con Supabase.
// 1) En Supabase: Project Settings > API (o "Connect").
// 2) Copiá la "Project URL" y la clave pública (anon / publishable key).
// La clave pública está pensada para ir dentro de la app: la seguridad la dan
// las reglas (RLS) que crea el archivo supabase/schema.sql.

const String kSupabaseUrl = 'https://TU-PROYECTO.supabase.co';
const String kSupabaseAnonKey = 'TU-CLAVE-PUBLICA';

bool get supabaseConfigurado =>
    !kSupabaseUrl.contains('TU-PROYECTO') && !kSupabaseAnonKey.startsWith('TU-');
