-- --   Триггер БП 2 к
-- -- тригер или функция что лучше для бл на стороне бд? процедуры vs функции,
-- -- можно ли объявлять переменные внутири
-- -- Триггерная функция
create or replace function create_report_for_king_on_sos()
returns trigger as $$
DECLARE
   political_status varchar = (select name from political_status where political_status.id = NEW.political_status_id);
   currentid_king_of_utopia integer = (select leader_id from country where country.name = 'Utopia');
   currentid_sender integer = (
     select person.person_id from person_position_history person
       join position
       on person.position_id = position.id and position.name = 'Foreign diplomat'
   );

BEGIN
      raise notice '%',political_status;
  if political_status = 'WAR' then
    insert into report (title,contents,sender_id,receiver_id,delivered)
      values('SOS','please',currentid_sender,currentid_king_of_utopia,false);

  end if;

  return NEW;

END;
$$ language plpgsql;

create or replace trigger update_political_status_trigger
  after insert or update
  on country_relationship_event_history
  for each row
  execute function create_report_for_king_on_sos();


UPDATE country_relationship_event_history
  SET  political_status_id=1
  WHERE country_relationship_event_history.id = 1;

-- Триггер как ограничние целосности к БП 3

-- create or replace procedure

create or replace function check_person_family_transition() return trigger as
$$
declare
  declare person_current_position integer =
  (
    select position_id from person_position_history
      where person_position_history.position_id = OLD.id
  );
  declare person_prev_position_id integer=
  (
    select position_id from person_position_history
    where person_position_history.position_id = OLD.id
    order by person_position_history.hire_date desc
    offset 1
  )
  declare craft_of_new_family varchar =
  (
    select craft_type_id from family where family.id = NEW.family_id
  )
begin
  if NEW.family_id <> OLD.family_id then
--  Проверяем, изменился ли интерес у персона и совпадает ли интерес с новой семьей
    if person_current_position = person_prev_position_id then
      raise exception 'Поменять семью не имеет смысла.У пользователя не менялся интерес.'
    end if;

    if exists(
      select id from position_craft_type_relation
        where position_craft_type_relation.position_id = NEW.position_id
        and position_craft_type_relation.craft_type_id = craft_of_new_family
    ) then

    end if;

--       проверка равенства ремесел.
  end if;
  return NEW;
end;
$$ language plpgsql;

create or replace trigger check_person_family_transition_trigger() REturns trigger AS
    $$
  after update person
  on country_relationship_event_history
  for each row
  execute function check_person_family_transition();
  $$ language sql;

-- Создание индексов

create or replace function allocate_resource_to_family(_family_id integer, _resource_type_name text, _resource_quantity double precision) RETURNS void AS
$$
    DECLARE
        _resource_type_id integer;
        _resource_storage_id integer;
        _resource_id integer;
    BEGIN
        SELECT get_resource_type_id_by_name(_resource_type_name) INTO _resource_type_id;
        SELECT id FROM resource_storage where resource_type_id = _resource_type_id and current_quantity >= _resource_quantity INTO _resource_storage_id;
        UPDATE resource_storage SET current_quantity = current_quantity - _resource_quantity WHERE id = _resource_storage_id;
        SELECT insert_resource(_resource_storage_id, _resource_quantity) INTO _resource_id;
        PERFORM insert_family_resource_ownership(_family_id, _resource_id);
        COMMIT;
    END;
$$ LANGUAGE plpgsql;

-- -- Триггер как ограничние целосности к БП 3


create or replace function check_person_family_transition() returns trigger as $$
declare
  declare person_current_position integer =
  (
    select position_id from person_position_history
      where person_position_history.position_id = OLD.id
  );
  declare person_prev_position_id integer=
  (
    select position_id from person_position_history
    where person_position_history.position_id = OLD.id
    order by person_position_history.hire_date desc
    offset 1
  );
  declare craft_of_new_family varchar =
  (
    select craft_type_id from family where family.id = NEW.family_id
  );
begin
  if NEW.family_id <> OLD.family_id then
--   Проверяем, изменился ли интерес у персона и совпадает ли интерес с новой семьей
    if person_current_position = person_prev_position_id then
      raise exception 'Поменять семью не имеет смысла.У пользователя не менялся интерес.';
    end if;

    if not exists(
      select id from position_craft_type_relation
        where position_craft_type_relation.position_id = NEW.position_id
        and position_craft_type_relation.craft_type_id = craft_of_new_family
    ) then
      raise exception 'Невозможно поменять семью. Интересы семьи и пользователя не совпадают';

    end if;

--       проверка равенства ремесел.
  end if;
  return NEW;
end;
$$ language plpgsql;

create or replace trigger check_person_family_transition_trigger
  after update
  on person
  for each row
  execute function check_person_family_transition();