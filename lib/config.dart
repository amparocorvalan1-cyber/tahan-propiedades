// Datos de conexión con Supabase.
// La clave pública (publishable key) está pensada para ir dentro de la app:
// la seguridad la dan las reglas (RLS) que crea el archivo schema.sql.

const String kSupabaseUrl = 'https://pnwoknwyyeyujzdenram.supabase.co';
const String kSupabaseAnonKey = 'sb_publishable_HvanS7wgqnBqDWYkWgBnXQ_pGpHpQiT';

bool get supabaseConfigurado =>
    !kSupabaseUrl.contains('TU-PROYECTO') && !kSupabaseAnonKey.startsWith('TU-');
