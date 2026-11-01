\set ON_ERROR_STOP on

DROP DATABASE IF EXISTS alumnes;
CREATE DATABASE alumnes;

\c alumnes

CREATE TABLE IF NOT EXISTS alumnes (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(60) NOT NULL,
    edat INT CHECK (edat > 0)
);

BEGIN;
\copy alumnes (nom, edat) FROM '/tmp/alumnes.csv' WITH (FORMAT csv, HEADER true)
COMMIT;
