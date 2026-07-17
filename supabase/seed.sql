-- Seed de eventos deportivos para desarrollo. Fechas relativas a hoy (siempre futuras).
insert into public.events
  (titulo, descripcion, imagen_url, categoria, ciudad, fecha, hora, precio, capacidad, cupos_disponibles)
values
  ('Final Liga BetPlay', 'Gran final del fútbol profesional colombiano.', 'https://picsum.photos/id/1011/800/600', 'Fútbol', 'Bogotá', current_date + interval '7 days', '20:00', 250000, 40000, 40000),
  ('Clásico Paisa', 'Derbi de fútbol entre los equipos más tradicionales de Medellín.', 'https://picsum.photos/id/1012/800/600', 'Fútbol', 'Medellín', current_date + interval '10 days', '19:30', 180000, 35000, 35000),
  ('Copa Pacífico de Fútbol', 'Torneo amistoso internacional de fútbol.', 'https://picsum.photos/id/1013/800/600', 'Fútbol', 'Cali', current_date + interval '14 days', '18:00', 120000, 25000, 25000),
  ('Fútbol Playa Caribe', 'Torneo de fútbol playa en la costa Caribe.', 'https://picsum.photos/id/1014/800/600', 'Fútbol', 'Cartagena', current_date + interval '21 days', '16:00', 60000, 3000, 3000),
  ('Noche de Básquet Profesional', 'Jornada de baloncesto profesional colombiano.', 'https://picsum.photos/id/1015/800/600', 'Baloncesto', 'Bogotá', current_date + interval '5 days', '19:00', 150000, 8000, 8000),
  ('Baloncesto 3x3 Street', 'Torneo urbano de baloncesto 3x3.', 'https://picsum.photos/id/1016/800/600', 'Baloncesto', 'Medellín', current_date + interval '12 days', '17:00', 80000, 1500, 1500),
  ('Estrellas del Baloncesto', 'Partido exhibición con figuras internacionales.', 'https://picsum.photos/id/1018/800/600', 'Baloncesto', 'Barranquilla', current_date + interval '18 days', '20:00', 220000, 6000, 6000),
  ('Abierto de Tenis Andino', 'Torneo profesional de tenis en canchas duras.', 'https://picsum.photos/id/1019/800/600', 'Tenis', 'Bogotá', current_date + interval '9 days', '10:00', 300000, 5000, 5000),
  ('Copa Tenis del Pacífico', 'Torneo regional de tenis categoría abierta.', 'https://picsum.photos/id/1020/800/600', 'Tenis', 'Cali', current_date + interval '16 days', '09:00', 150000, 2000, 2000),
  ('Exhibición de Tenis Caribe', 'Partido de exhibición con jugadores ATP.', 'https://picsum.photos/id/1021/800/600', 'Tenis', 'Cartagena', current_date + interval '25 days', '18:30', 350000, 3000, 3000),
  ('Maratón de Bogotá', 'Carrera atlética de 42k por las calles de la ciudad.', 'https://picsum.photos/id/1022/800/600', 'Atletismo', 'Bogotá', current_date + interval '30 days', '06:00', 90000, 50000, 50000),
  ('Media Maratón de Medellín', 'Carrera de 21k por el Valle de Aburrá.', 'https://picsum.photos/id/1024/800/600', 'Atletismo', 'Medellín', current_date + interval '20 days', '06:30', 70000, 15000, 15000),
  ('Grand Prix Atletismo Cali', 'Encuentro atlético de pista y campo.', 'https://picsum.photos/id/1025/800/600', 'Atletismo', 'Cali', current_date + interval '13 days', '15:00', 50000, 4000, 4000),
  ('Copa Nacional de Natación', 'Competencia nacional de natación en piscina olímpica.', 'https://picsum.photos/id/1027/800/600', 'Natación', 'Barranquilla', current_date + interval '11 days', '08:00', 100000, 1200, 1200),
  ('Travesía Natación Cartagena', 'Prueba de aguas abiertas en la bahía.', 'https://picsum.photos/id/1035/800/600', 'Natación', 'Cartagena', current_date + interval '28 days', '07:00', 130000, 800, 800);
