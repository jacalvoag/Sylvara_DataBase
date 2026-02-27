-- Views 'Sylvara'

CREATE OR REPLACE VIEW view_user_summary AS
SELECT 
    u.user_id,
    u.user_name,
    -- Conteo total histórico de parcelas del usuario
    (SELECT COUNT(*) 
     FROM sampling_plots sp2 
     WHERE sp2.user_id = u.user_id) AS total_historical_plots,
    -- Conteo de parcelas creadas solo en el mes actual
    (SELECT COUNT(*) 
     FROM sampling_plots sp3 
     WHERE sp3.user_id = u.user_id 
       AND sp3.start_date >= DATE_TRUNC('month', CURRENT_DATE)
       AND sp3.start_date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month') AS current_month_plots
FROM users u;


CREATE OR REPLACE VIEW view_latest_plots AS
SELECT 
    user_id,
    sampling_plot_id AS id,
    sampling_plot_name AS name,
    description,
    total_area,
    unit_name AS area_unit,
    sampling_plot_status AS status,
    start_date
FROM (
    SELECT sp.*, um.unit_name,
           ROW_NUMBER() OVER (PARTITION BY sp.user_id ORDER BY sp.start_date DESC, sp.sampling_plot_id DESC) as position
    FROM sampling_plots sp
    JOIN unit_measurement um ON sp.unit_id = um.unit_id
) sub
WHERE position <= 3;