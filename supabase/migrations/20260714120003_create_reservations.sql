-- reservations: reserva/compra simulada de entradas para un evento.
create table public.reservations (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references public.profiles (id) on delete cascade,
  evento_id uuid not null references public.events (id) on delete restrict,
  cantidad_entradas int not null check (cantidad_entradas > 0),
  total numeric(12, 2) not null check (total >= 0),
  estado text not null default 'pendiente' check (
    estado in ('pendiente', 'confirmada', 'cancelada')
  ),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.reservations is 'Reservas de entradas hechas por un usuario para un evento.';

create index reservations_usuario_id_idx on public.reservations (usuario_id);
create index reservations_evento_id_idx on public.reservations (evento_id);

alter table public.reservations enable row level security;

create trigger reservations_set_updated_at
  before update on public.reservations
  for each row execute function extensions.moddatetime (updated_at);
