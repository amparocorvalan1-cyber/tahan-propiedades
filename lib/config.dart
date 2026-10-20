// Datos de conexión con Supabase.
// 1) En Supabase: Project Settings > API (o "Connect").
// 2) Copiá la "Project URL" y la clave pública (anon / publishable key).
// La clave pública está pensada para ir dentro de la app: la seguridad la dan
// las reglas (RLS) que crea el archivo supabase/schema.sql.

const String kSupabaseUrl = 'https://pnwoknwyyeyujzdenram.supabase.co';
const String kSupabaseAnonKey = 'sb_publishable_HvanS7wgqnBqDWYkWgBnXQ_pGpHpQiT';

bool get supabaseConfigurado =>
    !kSupabaseUrl.contains('TU-PROYECTO') && !kSupabaseAnonKey.startsWith('TU-');
