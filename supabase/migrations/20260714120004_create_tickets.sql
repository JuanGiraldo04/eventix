-- tickets: entrada individual emitida al confirmar una reserva.
create table public.tickets (
  id uuid primary key default gen_random_uuid(),
  reserva_id uuid not null references public.reservations (id) on delete cascade,
  codigo text not null unique,
  created_at timestamptz not null default now()
);

comment on table public.tickets is 'Entradas individuales emitidas por reserva confirmada.';

create index tickets_reserva_id_idx on public.tickets (reserva_id);

alter table public.tickets enable row level security;
