-- Base de datos de 'Sylvara' para el Proyecto Integrador II

CREATE TYPE roles AS ENUM ('USER', 'ADMIN');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_lastname VARCHAR(100) NOT NULL,
    user_birthday DATE NOT NULL,
    user_email VARCHAR(255) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    user_role roles NOT NULL DEFAULT 'USER'
);

CREATE TABLE refresh_tokens (
    token_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    token VARCHAR(512) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL
);

CREATE TYPE status AS ENUM ('active', 'inactive');

CREATE TABLE unit_measurement (
    unit_id SERIAL PRIMARY KEY,
    unit_name VARCHAR(250) NOT NULL UNIQUE
);

INSERT INTO unit_measurement (unit_name) VALUES 
('Metros'),
('Hectareas');


CREATE TABLE sampling_plots (
     sampling_plot_id SERIAL PRIMARY KEY,
     user_id INT NOT NULL,
     sampling_plot_name VARCHAR(100) NOT NULL,
     sampling_plot_status status NOT NULL DEFAULT 'active',
     description TEXT,
     total_area DECIMAL(10,2) NOT NULL,
     unit_id INT NOT NULL,
     start_date DATE NOT NULL DEFAULT CURRENT_DATE,
     end_date DATE,
     FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
     FOREIGN KEY (unit_id) REFERENCES unit_measurement(unit_id)
);

CREATE TABLE studies_zones(
    study_zone_id SERIAL PRIMARY KEY,
    sampling_plot_id INT NOT NULL,
    name_study_zone VARCHAR(250) NOT NULL,
    description TEXT,
    sub_area DECIMAL(10,2) NOT NULL, 
    unit_id INT NOT NULL,
    FOREIGN KEY (sampling_plot_id) REFERENCES sampling_plots(sampling_plot_id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES unit_measurement(unit_id)
);

CREATE TABLE functional_types(
    functional_type_id SERIAL PRIMARY KEY,
    functional_type_name VARCHAR(250) NOT NULL UNIQUE
);

INSERT INTO functional_types (functional_type_name) VALUES 
('Frutal'),
('Cerco vivo'),
('Maderable'),
('Medicinal'),
('Medicinal y plaguicida'),
('Ornamental'),
('Maderable y medicinal'),
('Frutal trepadora'),
('Medicinal y ornamental'),
('Medicinal y forrajero'),
('Frutal y forrajero');

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    species_name VARCHAR(250) NOT NULL,
    functional_type_id INT NOT NULL,
    FOREIGN KEY (functional_type_id) REFERENCES functional_types(functional_type_id)
);

CREATE TABLE species_zone(
    species_zone_id SERIAL PRIMARY KEY,
    study_zone_id INT NOT NULL,
    species_id INT NOT NULL,
    individual_count INT NOT NULL,
    height_stratum_min DECIMAL(10, 2) NOT NULL,
    height_stratum_max DECIMAL(10, 2) NOT NULL,
    unit_id INT NOT NULL DEFAULT 1 CHECK (unit_id = 1),
    FOREIGN KEY (species_id) REFERENCES species(species_id) ON DELETE RESTRICT,
    FOREIGN KEY (study_zone_id) REFERENCES studies_zones(study_zone_id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES unit_measurement(unit_id) 
);


-- Adding profile picture support for users
ALTER TABLE users 
ADD COLUMN profile_picture_url VARCHAR(512);

-- Adding catalog image support for species
ALTER TABLE species 
ADD COLUMN species_image_url VARCHAR(512);