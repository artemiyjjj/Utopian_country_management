CREATE TABLE IF NOT EXISTS Country
(
    id        SERIAL,
    name      text UNIQUE NOT NULL,
    leader_id integer,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Political_status
(
    id   SERIAL,
    name text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Country_relationship_event_history
(
    id                  SERIAL,
    political_status_id integer REFERENCES Political_status (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    start_event_date    date NOT NULL,
    end_event_date      date
        CONSTRAINT is_after_start CHECK ( end_event_date >= start_event_date ),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Event_group
(
    id SERIAL,
    name text NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Event_group_countries
(
    group_id   integer REFERENCES Event_group (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    country_id integer REFERENCES Country (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (group_id, country_id)
);

CREATE OR REPLACE FUNCTION count_group_countries(group_id integer) RETURNS bigint AS
$$
SELECT count(*)
FROM Event_group
WHERE id = group_id;
$$ LANGUAGE sql;

CREATE TABLE IF NOT EXISTS Event_groups
(
    id             integer REFERENCES Country_relationship_event_history (id) ON UPDATE CASCADE ON DELETE CASCADE,
    event_group_id integer REFERENCES Event_group (id) ON UPDATE CASCADE ON DELETE RESTRICT
        CONSTRAINT not_empty CHECK ( count_group_countries(event_group_id) >= 1 ),
    PRIMARY KEY (id, event_group_id)
);

-- CREATE OR REPLACE FUNCTION count_event_groups(country_event_id integer) RETURNS bigint AS
-- $$
-- SELECT count(*) FROM Event_groups WHERE id = country_event_id;
-- $$ LANGUAGE sql;


CREATE TABLE IF NOT EXISTS Resource_type
(
    id            SERIAL,
    resource_type text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Resource_storage
(
    id               SERIAL,
    resource_type_id integer REFERENCES Resource_type (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    total_quantity   double precision NOT NULL
        CONSTRAINT is_total_countable CHECK ( total_quantity >= 0 ),
    current_quantity double precision NOT NULL
        CONSTRAINT is_current_countable CHECK ( current_quantity >= 0),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Resource
(
    id                  Serial,
    resource_storage_id integer REFERENCES Resource_storage (id) ON UPDATE CASCADE ON DELETE CASCADE,
    initial_quantity    double precision NOT NULL
        CONSTRAINT is_positive CHECK ( initial_quantity > 0 ),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Resource_usage_type
(
    id     SERIAL,
    amount double precision UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Resource_usage
(
    id                     SERIAL,
    resource_id            integer REFERENCES Resource (id) ON UPDATE CASCADE ON DELETE CASCADE,
    resource_usage_type_id integer REFERENCES Resource_usage_type (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS Craft_type
(
    id         SERIAL,
    craft_name text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Family
(
    id            SERIAL,
    craft_type_id integer REFERENCES Craft_type (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    responsible_person_id integer,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Family_resource_ownership
(
    family_id   integer REFERENCES Family (id) On UPDATE CASCADE ON DELETE CASCADE,
    resource_id integer REFERENCES Resource (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (family_id, resource_id)
);

CREATE TABLE IF NOT EXISTS Person
(
    id            SERIAL,
    name          text    NOT NULL,
    motherland_id integer REFERENCES Country (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    family_id     integer REFERENCES Family (id) ON UPDATE CASCADE ON DELETE SET NULL,
    PRIMARY KEY (id)
);

ALTER TABLE Country
    ADD CONSTRAINT leader_foreign_key FOREIGN KEY (leader_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE Family
    ADD CONSTRAINT responsible_foreign_key FOREIGN KEY (responsible_person_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET DEFAULT;

CREATE TABLE IF NOT Exists Position
(
    id   SERIAL,
    name text NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Position_craft_type_relation
(
    position_id integer REFERENCES Position (id) ON UPDATE CASCADE ON DELETE CASCADE,
    craft_type_id integer REFERENCES Craft_type (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (position_id, craft_type_id)
);

CREATE TABLE IF NOT EXISTS Person_position_history
(
    id             SERIAL,
    person_id      integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    position_id    integer REFERENCES Position (id) ON UPDATE CASCADE ON DELETE RESTRICT NOT NULL,
    hire_date      date NOT NULL,
    dismissal_date date
        CONSTRAINT is_after_hire CHECK (hire_date <= dismissal_date),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Report
(
    id          SERIAL,
    title       text    NOT NULL,
    contents    text    NOT NULL,
    sender_id   integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL,
    receiver_id integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL,
    delivered   boolean NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Building_type
(
    id        SERIAL,
    type_name text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Building
(
    id               SERIAL,
    building_type_id integer REFERENCES Building_type (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Building_construction_artefact
(
    building_id                 integer REFERENCES Building (id) ON UPDATE CASCADE ON DELETE SET NULL,
    responsible_person_id       integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL,
    construction_beginning_date date,
    construction_end_date       date
        CONSTRAINT is_construction_date_range_correct CHECK ( construction_beginning_date <= construction_end_date ),
    PRIMARY KEY (building_id)
);

CREATE TABLE IF NOT EXISTS People_detachment_to_building
(
    person_id   integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE CASCADE,
    building_id integer REFERENCES Building (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (person_id, building_id)
);


CREATE TABLE IF NOT EXISTS Users
(
    user_id integer REFERENCES Person (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_password text NOT NULL,
    PRIMARY KEY (user_id)
)

