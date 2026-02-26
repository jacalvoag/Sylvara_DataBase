-- Optimización y Rendimiento de Sylvara

-- 1. Índices para el Dashboard y Gestión de Usuarios
-- Optimiza la carga de parcelas por usuario y el filtrado por fechas en el resumen mensual
CREATE INDEX idx_sampling_plots_user_id ON sampling_plots(user_id);
CREATE INDEX idx_sampling_plots_start_date ON sampling_plots(start_date DESC);

-- 2. Índices para el Cálculo de Índices de Biodiversidad
-- Mejora el rendimiento de los JOINs y agrupaciones necesarios para los indices de biodiversidad
CREATE INDEX idx_studies_zones_sampling_plot_id ON studies_zones(sampling_plot_id);
CREATE INDEX idx_species_zone_study_zone_id ON species_zone(study_zone_id);
CREATE INDEX idx_species_name_search ON species(species_name);

-- 3. Índices de Seguridad y Sesiones
-- Acelera la validación y limpieza de tokens de sesión
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

-- 4. Estadística de consulta
ANALYZE users;
ANALYZE sampling_plots;
ANALYZE studies_zones;
ANALYZE species_zone;