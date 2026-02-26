-- Views 'Sylvara'

CREATE OR REPLACE VIEW view_resumen_usuario AS
SELECT 
    u.user_id,
    u.user_name,
    -- Conteo total histórico de parcelas del usuario
    (SELECT COUNT(*) 
     FROM sampling_plots sp2 
     WHERE sp2.user_id = u.user_id) AS total_historico_parcelas,
    -- Conteo de parcelas creadas solo en el mes actual
    (SELECT COUNT(*) 
     FROM sampling_plots sp3 
     WHERE sp3.user_id = u.user_id 
       AND sp3.start_date >= DATE_TRUNC('month', CURRENT_DATE)
       AND sp3.start_date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month') AS parcelas_mes_actual
FROM users u;


CREATE OR REPLACE VIEW view_ultimas_parcelas AS
SELECT 
    user_id,
    sampling_plot_name AS nombre_proyecto,
    sampling_plot_status AS estatus,
    description AS descripcion,
    total_area,
    start_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY start_date DESC, sampling_plot_id DESC) as posicion
    FROM sampling_plots
) sub
WHERE posicion <= 3;