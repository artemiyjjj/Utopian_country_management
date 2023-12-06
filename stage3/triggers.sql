
-- -- Триггер как ограничние целосности к БП 3
create or replace function allocate_resource_to_family(_family_id integer, _resource_type_name text, _resource_quantity double precision) RETURNS void AS
$$
    DECLARE
        _resource_type_id integer;
        _resource_id integer;
    BEGIN
        SELECT get_resource_type_id_by_name(_resource_type_name) INTO _resource_type_id;
        SELECT get_resource_from_resource_storage(_resource_type_id, _resource_quantity) INTO _resource_id;
        PERFORM insert_family_resource_ownership(_family_id, _resource_id);
    END;
$$ LANGUAGE plpgsql;

-- --   Триггер БП 2 к
-- -- Триггерная функция
create or replace function create_report_for_king_on_sos()
returns trigger as $$
DECLARE
   political_status varchar = (select name from political_status where political_status.id = NEW.political_status_id);
   currentid_king_of_utopia integer = (select leader_id from country where country.name = 'Utopia');
   currentid_sender integer = (
     select person.person_id from person_position_history person
       join position
       on person.position_id = position.id and position.name = 'Protofilarch' limit 1
   );

BEGIN
      raise notice '%',political_status;
  if political_status = 'War' then
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
  SET  political_status_id=5
  WHERE country_relationship_event_history.id = 2;


CREATE OR REPLACE FUNCTION update_resource_storages_quantities (_resource_storage_id integer, _resource_addition_amount double precision) RETURNS void AS
$$
    BEGIN
        UPDATE resource_storage SET current_quantity = current_quantity + _resource_addition_amount
        WHERE id = _resource_storage_id;
    end;
$$ language plpgsql;

-- -- Триггер как ограничние целосности к БП 3


create or replace function check_person_family_transition() returns trigger as $$
declare
  declare person_current_position integer =
  (
    select position_id from person_position_history
      where person_position_history.person_id = OLD.id
    order by person_position_history.hire_date asc
    offset 1
  );
  declare person_prev_position_id integer=
  (
    select position_id from person_position_history
    where person_position_history.person_id = OLD.id
    order by person_position_history.hire_date desc
    offset 1
  );
  declare craft_of_new_family integer =
  (
    select craft_type_id from family where family.id = NEW.family_id
  );

  declare match_craft_and_family_id RECORD = (select 1 from position_craft_type_relation
        where position_craft_type_relation.position_id = person_current_position
        and position_craft_type_relation.craft_type_id = craft_of_new_family);

begin
  raise notice'Trigger ouput:';
  raise notice'%',craft_of_new_family;
  raise notice'%',person_current_position;
  raise notice'%',person_prev_position_id;
  raise notice'%',match_craft_and_family_id;

  if NEW.family_id <> OLD.family_id then
--   Проверяем, изменился ли интерес у персона и совпадает ли интерес с новой семьей
    if person_current_position = person_prev_position_id then
      raise exception 'Поменять семью не имеет смысла.У пользователя не менялся интерес.';
    end if;
if not exists(
      select 1 from position_craft_type_relation
        where position_craft_type_relation.position_id = person_current_position
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


UPDATE person
  SET  family_id = 11
  WHERE person.id = 1108;