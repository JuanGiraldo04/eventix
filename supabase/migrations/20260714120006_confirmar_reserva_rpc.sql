-- RPC: confirma una reserva pendiente del usuario autenticado.
-- Reduce cupos_disponibles del evento, emite un ticket por entrada y marca la reserva
-- como 'confirmada'. Todo corre en la transacción implícita de la función (atómico).
-- security definer: el usuario solo tiene policies de solo-lectura/insert sobre sus propias
-- reservations y ninguna sobre events/tickets; la función valida la propiedad de la reserva
-- con auth.uid() antes de mutar nada. search_path fijo por seguridad.
create function public.confirmar_reserva(p_reserva_id uuid)
returns public.reservations
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_reserva public.reservations;
  v_evento public.events;
  v_codigo text;
  i int;
begin
  select * into v_reserva
  from public.reservations
  where id = p_reserva_id
  for update;

  if v_reserva.id is null then
    raise exception 'La reserva % no existe', p_reserva_id;
  end if;

  if v_reserva.usuario_id <> auth.uid() then
    raise exception 'No autorizado para confirmar esta reserva' using errcode = '42501';
  end if;

  if v_reserva.estado <> 'pendiente' then
    raise exception 'La reserva ya está en estado %', v_reserva.estado;
  end if;

  select * into v_evento
  from public.events
  where id = v_reserva.evento_id
  for update;

  if v_evento.cupos_disponibles < v_reserva.cantidad_entradas then
    raise exception 'Cupos insuficientes para el evento %', v_evento.titulo;
  end if;

  update public.events
  set cupos_disponibles = cupos_disponibles - v_reserva.cantidad_entradas
  where id = v_evento.id;

  for i in 1..v_reserva.cantidad_entradas loop
    v_codigo := encode(extensions.gen_random_bytes(8), 'hex');
    insert into public.tickets (reserva_id, codigo) values (v_reserva.id, v_codigo);
  end loop;

  update public.reservations
  set estado = 'confirmada'
  where id = v_reserva.id
  returning * into v_reserva;

  return v_reserva;
end;
$$;

grant execute on function public.confirmar_reserva (uuid) to authenticated;
