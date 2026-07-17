-- Permite al usuario ajustar cantidad_entradas/total de su propia reserva
-- mientras siga 'pendiente' (paso de checkout antes de confirmar_reserva).
-- No puede tocar reservas ya confirmadas o canceladas.
create policy "reservations_update_propia_pendiente" on public.reservations
  for update to authenticated
  using ((select auth.uid()) = usuario_id and estado = 'pendiente')
  with check ((select auth.uid()) = usuario_id and estado = 'pendiente');
