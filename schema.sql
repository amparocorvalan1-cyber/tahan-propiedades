-- Tahan Propiedades - base de datos en Supabase
-- Pegar todo este archivo en Supabase > SQL Editor y tocar "Run".

-- 1) Catálogo de propiedades (lo lee la app)
create table if not exists public.propiedades (
  id bigint generated always as identity primary key,
  operacion text not null check (operacion in ('venta', 'alquiler')),
  orden int not null,
  tipo text,
  moneda text,
  precio numeric,
  direccion text,
  dormitorios int,
  banos int,
  cochera boolean default false,
  superficie_m2 int,
  imagen text not null,
  creado timestamptz not null default now()
);

alter table public.propiedades enable row level security;

drop policy if exists "Todos pueden ver las propiedades" on public.propiedades;
create policy "Todos pueden ver las propiedades"
  on public.propiedades for select
  using (true);

-- 2) Consultas de clientes (las escribe la app, solo se leen en el panel)
create table if not exists public.consultas (
  id bigint generated always as identity primary key,
  nombre text not null,
  email text not null,
  mensaje text not null,
  creado timestamptz not null default now()
);

alter table public.consultas enable row level security;

drop policy if exists "Cualquiera puede enviar una consulta" on public.consultas;
create policy "Cualquiera puede enviar una consulta"
  on public.consultas for insert
  with check (true);
-- No hay política de lectura: desde la app nadie puede ver las consultas.

-- 3) Carpeta pública para las imágenes de las fichas
insert into storage.buckets (id, name, public)
values ('fichas', 'fichas', true)
on conflict (id) do nothing;

-- 4) Datos de las 18 propiedades (tomados de las pantallas del diseño)
delete from public.propiedades;

insert into public.propiedades
  (operacion, orden, tipo, moneda, precio, direccion, dormitorios, banos, cochera, superficie_m2, imagen)
values
  ('venta',    1, 'Casa',            'USD', 230000,  'Calle Pueyrredon, Chacras de Coria',          2, 2, true,  null,  's-02.jpg'),
  ('venta',    2, 'Casa',            'USD', 400000,  'Barrio Privado Gran Boedo, Luján de Cuyo',    2, 2, true,  null,  's-03.jpg'),
  ('venta',    3, 'Casa',            'USD', 250000,  'Barrio Privado Liceo Country Club II',        2, 2, true,  null,  's-04.jpg'),
  ('venta',    4, 'Lote',            'USD', 75000,   'Barrio Privado Terrazas Park, Vistalba',      null, null, false, 500,   's-05.jpg'),
  ('venta',    5, 'Local comercial', 'USD', 44000,   'Ing. Baglietto 2910, Ciudad de Mendoza',      null, null, false, 21,    's-06.jpg'),
  ('venta',    6, 'Casa',            'USD', 35000,   'Calle Francisco Evans, Luján de Cuyo',        2, 2, true,  null,  's-07.jpg'),
  ('venta',    7, 'Casa',            'USD', 600000,  'Calle San Francisco del Monte',               null, null, false, 30000, 's-08.jpg'),
  ('venta',    8, 'Casa',            'USD', 250000,  'Barrio privado El Marquesado',                2, 2, true,  null,  's-09.jpg'),
  ('venta',    9, 'Casa',            'USD', 105000,  'Barrio privado La Delia',                     2, 2, true,  null,  's-10.jpg'),
  ('alquiler', 1, 'Departamento',    'ARS', 750000,  'Calle 9 de Julio, Ciudad',                    2, 2, true,  null,  's-11.jpg'),
  ('alquiler', 2, 'Departamento',    'ARS', 650000,  'Edificio Terrazas del Bombal, calle Beltran', 2, 2, true,  null,  's-12.jpg'),
  ('alquiler', 3, 'Departamento',    'ARS', 550000,  'Calle Azcuenaga, Ciudad',                     2, 2, true,  null,  's-13.jpg'),
  ('alquiler', 4, 'Casa',            'USD', 1000,    'Maza Sur, Lunlunta, Mendoza',                 2, 2, true,  null,  's-14.jpg'),
  ('alquiler', 5, 'Casa',            'ARS', 1300000, 'Emilio Civit lateral Juan José Paso',         2, 2, true,  null,  's-15.jpg'),
  ('alquiler', 6, 'Casa',            'ARS', 1500000, 'Barrio Privado Las Catalpas, Chacras de Coria', 2, 2, true, null, 's-16.jpg'),
  ('alquiler', 7, 'Casa',            'ARS', 1500000, 'Barrio semiprivado Arizu, Godoy Cruz',        2, 2, true,  null,  's-17.jpg'),
  ('alquiler', 8, 'Casa',            'ARS', 850000,  'Calle San Martin, Ciudad',                    2, 2, true,  null,  's-18.jpg'),
  ('alquiler', 9, 'Casa',            'ARS', 2100000, 'Barrio privado Club de Campo, Guaymallén',    2, 2, true,  null,  's-19.jpg');
