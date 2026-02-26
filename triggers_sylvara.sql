-- Functions Triggers 'Sylvara' 

CREATE OR REPLACE FUNCTION validar_area_zona()
RETURNS TRIGGER AS $$
DECLARE
    area_total_parcela DECIMAL(10,2);
    suma_areas_existentes DECIMAL(10,2);
BEGIN
    -- Ahora buscamos en sampling_plots
    SELECT total_area INTO area_total_parcela FROM sampling_plots WHERE sampling_plot_id = NEW.sampling_plot_id;

    -- Sumamos las sub_areas de las zonas de esta parcela
    SELECT COALESCE(SUM(sub_area), 0) INTO suma_areas_existentes 
    FROM studies_zones 
    WHERE sampling_plot_id = NEW.sampling_plot_id AND study_zone_id <> NEW.study_zone_id;

    IF (suma_areas_existentes + NEW.sub_area) > area_total_parcela THEN
        RAISE EXCEPTION 'La suma de las sub-áreas (%) excede el área total de la parcela (%)', 
        (suma_areas_existentes + NEW.sub_area), area_total_parcela;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_area_zona
BEFORE INSERT OR UPDATE ON studies_zones
FOR EACH ROW EXECUTE FUNCTION validar_area_zona();