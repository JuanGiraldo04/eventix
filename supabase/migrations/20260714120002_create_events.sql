-- events: catálogo de eventos deportivos.
create table public.events (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descripcion text not null,
  imagen_url text not null,
  categoria text not null check (
    categoria in ('Fútbol', 'Baloncesto', 'Tenis', 'Atletismo', 'Natación')
  ),
  ciudad text not null,
  fecha date not null,
  hora time not null,
  precio numeric(12, 2) not null check (precio >= 0),
  capacidad int not null check (capacidad > 0),
  cupos_disponibles int not null check (cupos_disponibles >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint events_cupos_le_capacidad check (cupos_disponibles <= capacidad)
);

comment on table public.events is 'Eventos deportivos disponibles para reserva.';

create index events_categoria_idx on public.events (categoria);
create index events_ciudad_idx on public.events (ciudad);
create index events_fecha_idx on public.events (fecha);

alter table public.events enable row level security;

create trigger events_set_updated_at
  before update on public.events
  for each row execute function extensions.moddatetime (updated_at);
