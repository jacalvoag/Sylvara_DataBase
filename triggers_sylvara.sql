-- Functions Triggers 'Sylvara'

-- 1. Actualización de la Función con filtro de cycle_number
CREATE OR REPLACE FUNCTION validar_area_zona()
RETURNS TRIGGER AS $$
DECLARE
    area_total_parcela DECIMAL(10,2);
    suma_areas_existentes DECIMAL(10,2);
BEGIN
    -- Obtenemos el área total definida para el terreno base
    SELECT total_area INTO area_total_parcela 
    FROM sampling_plots 
    WHERE sampling_plot_id = NEW.sampling_plot_id;

    -- Sumamos las sub_areas de las zonas QUE PERTENECEN AL MISMO CICLO
    -- Esto permite que cada investigación (ciclo) sea independiente espacialmente
    SELECT COALESCE(SUM(sub_area), 0) INTO suma_areas_existentes 
    FROM studies_zones 
    WHERE sampling_plot_id = NEW.sampling_plot_id 
      AND cycle_number = NEW.cycle_number 
      AND study_zone_id <> NEW.study_zone_id;

    -- Validación: La suma del ciclo actual no debe exceder el límite físico del proyecto
    IF (suma_areas_existentes + NEW.sub_area) > area_total_parcela THEN
        RAISE EXCEPTION 'Error de validación: La suma de sub-áreas para el ciclo % (%) excede el área total de la parcela (%)', 
        NEW.cycle_number, (suma_areas_existentes + NEW.sub_area), area_total_parcela;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Eliminación preventiva del trigger anterior para evitar duplicados o conflictos
DROP TRIGGER IF EXISTS trg_validar_area_zona ON studies_zones;

-- 3. Creación del nuevo trigger vinculado a la lógica de ciclos
CREATE TRIGGER trg_validar_area_zona
BEFORE INSERT OR UPDATE ON studies_zones
FOR EACH ROW EXECUTE FUNCTION validar_area_zona();