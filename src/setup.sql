-- ========================================
-- Organizations
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- ========================================
-- Categories
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO category (name)
VALUES
('Environmental'),
('Educational'),
('Community Service'),
('Health and Wellness');

-- ========================================
-- Projects
-- ========================================
CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    date DATE NOT NULL,
    organization_id INTEGER NOT NULL,
    FOREIGN KEY (organization_id) REFERENCES organization (organization_id)
);

INSERT INTO project (name, description, location, date, organization_id)
VALUES
('Affordable Housing Initiative', 'Build affordable housing units for low-income families.', 'Downtown District', '2026-08-01', 1),
('Community Center Renovation', 'Renovate and improve the local community center facility.', 'Riverside Park', '2026-08-15', 1),
('Habitat Restoration', 'Restore natural habitats damaged by construction.', 'Green Valley', '2026-09-01', 1),
('Roof Repair Project', 'Repair roofs for low-income elderly residents.', 'Maple Street', '2026-09-10', 1),
('Sustainable Housing Workshop', 'Teach sustainable building practices to volunteers.', 'Downtown District', '2026-09-20', 1),
('Urban Garden Expansion', 'Expand community garden plots for local families.', 'Eastside Lot', '2026-08-05', 2),
('Farmers Market Support', 'Help organize and run the weekly farmers market.', 'Town Square', '2026-08-20', 2),
('Composting Education Program', 'Teach composting techniques to reduce food waste.', 'Community Garden', '2026-09-05', 2),
('Youth Farming Camp', 'Run a summer camp teaching kids about farming.', 'Green Acres Farm', '2026-09-15', 2),
('Seed Distribution Drive', 'Distribute seeds and starter plants to residents.', 'Eastside Lot', '2026-09-25', 2),
('Park Cleanup', 'Join us to clean up local parks and make them beautiful!', 'Central Park', '2026-08-10', 3),
('Food Drive', 'Help collect and distribute food to those in need.', 'Downtown Shelter', '2026-08-25', 3),
('Community Tutoring', 'Volunteer to tutor students in various subjects.', 'Public Library', '2026-09-08', 3),
('After-School Mentoring', 'Mentor local youth after school hours.', 'Lincoln Elementary', '2026-09-18', 3),
('Career Exploration Workshop', 'Help youth explore different career paths.', 'Community Hall', '2026-09-28', 3);

-- ========================================
-- Project-Category Junction Table (Many-to-Many)
-- ========================================
CREATE TABLE project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, category_id),
    FOREIGN KEY (project_id) REFERENCES project (project_id),
    FOREIGN KEY (category_id) REFERENCES category (category_id)
);

INSERT INTO project_category (project_id, category_id)
VALUES
(1, 1), (2, 3), (3, 1), (4, 4), (5, 1),
(6, 1), (7, 3), (8, 1), (9, 2), (10, 1),
(11, 1), (12, 3), (13, 2), (14, 2), (15, 2);