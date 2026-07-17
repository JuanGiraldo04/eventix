-- Crea automáticamente el perfil de negocio cuando se registra un usuario en auth.users.
-- security definer: necesita insertar en public.profiles con los privilegios del owner,
-- ya que el usuario recién creado aún no tiene permisos propios. search_path fijo por seguridad.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, nombre, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nombre', new.email),
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
