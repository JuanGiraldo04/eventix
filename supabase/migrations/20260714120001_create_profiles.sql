-- profiles: extiende auth.users con datos propios del negocio.
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is 'Perfil de negocio del usuario, 1:1 con auth.users.';

-- RLS obligatoria en toda tabla (sin policy = sin acceso hasta que se agreguen en el punto de RLS).
alter table public.profiles enable row level security;

create extension if not exists moddatetime schema extensions;

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function extensions.moddatetime (updated_at);
