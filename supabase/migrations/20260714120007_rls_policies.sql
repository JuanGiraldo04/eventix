-- Policies de RLS. Las tablas ya tienen RLS habilitado (sin policies = sin acceso);
-- aquí se abre explícitamente lo que cada rol puede hacer.

-- profiles: el usuario solo lee y actualiza su propio perfil.
create policy "profiles_select_propio" on public.profiles
  for select to authenticated
  using ((select auth.uid()) = id);

create policy "profiles_update_propio" on public.profiles
  for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- events: lectura pública. La escritura queda reservada a service_role, que
-- tiene bypassrls por defecto, así que no se crean policies de insert/update/delete.
create policy "events_select_public" on public.events
  for select to authenticated, anon
  using (true);

-- reservations: el usuario solo ve y crea sus propias reservas.
create policy "reservations_select_propias" on public.reservations
  for select to authenticated
  using ((select auth.uid()) = usuario_id);

create policy "reservations_insert_propias" on public.reservations
  for insert to authenticated
  with check ((select auth.uid()) = usuario_id);

-- tickets: el usuario solo ve los tickets de sus propias reservas.
-- Sin policy de insert/update: los tickets solo se crean vía la función
-- confirmar_reserva (security definer), nunca directo desde el cliente.
create policy "tickets_select_propios" on public.tickets
  for select to authenticated
  using (
    exists (
      select 1
      from public.reservations r
      where r.id = tickets.reserva_id
        and r.usuario_id = (select auth.uid())
    )
  );
