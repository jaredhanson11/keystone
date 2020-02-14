-- Connect to endergy database
\c endergy;

-- endery_landing_page
CREATE SCHEMA IF NOT EXISTS endergy_landing_page;

CREATE TABLE IF NOT EXISTS endergy_landing_page.demo (
        id SERIAL NOT NULL, 
        name VARCHAR(50), 
        email VARCHAR(120), 
        phone VARCHAR(20), 
        use_case VARCHAR(20), 
        use_case_description VARCHAR(2000), 
        created_date TIMESTAMP WITHOUT TIME ZONE, 
        PRIMARY KEY (id)
);
