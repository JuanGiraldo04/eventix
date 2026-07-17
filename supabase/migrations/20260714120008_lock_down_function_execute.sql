-- Postgres otorga EXECUTE a PUBLIC por defecto al crear una función; se revoca
-- explícitamente para que solo quede accesible como el diseño lo requiere.

-- handle_new_user: solo la invoca el trigger on_auth_user_created, nunca vía API.
revoke execute on function public.handle_new_user () from public;
revoke execute on function public.handle_new_user () from anon, authenticated;

-- confirmar_reserva: RPC de negocio, solo para usuarios autenticados.
revoke execute on function public.confirmar_reserva (uuid) from public;
revoke execute on function public.confirmar_reserva (uuid) from anon;
