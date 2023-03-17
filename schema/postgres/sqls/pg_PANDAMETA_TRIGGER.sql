-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.2
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:ADCR

SET client_encoding TO 'UTF8';

SET search_path = doma_pandameta,public;
\set ON_ERROR_STOP ON

SET check_function_bodies = false;

DROP TRIGGER IF EXISTS cloudconfig_modtime_trg ON cloudconfig CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cloudconfig_modtime_trg() RETURNS trigger AS $BODY$
DECLARE
BEGIN
  NEW.modtime := LOCALTIMESTAMP;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cloudconfig_modtime_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_cloudconfig_modtime_trg() OWNER TO panda;

CREATE TRIGGER cloudconfig_modtime_trg
	BEFORE INSERT OR UPDATE ON cloudconfig FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cloudconfig_modtime_trg();

DROP TRIGGER IF EXISTS fifo_5rows_persite ON multicloud_history CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fifo_5rows_persite() RETURNS trigger AS $BODY$
DECLARE
    num bigint := 0;
BEGIN
  BEGIN

	SELECT count(site) INTO STRICT num FROM atlas_pandameta.MULTICLOUD_HISTORY where SITE=NEW.site;
 	IF (num >= 5) THEN
		DELETE FROM atlas_pandameta.MULTICLOUD_HISTORY where SITE=NEW.site AND last_update <= (SELECT MIN(last_update) FROM atlas_pandameta.MULTICLOUD_HISTORY where SITE=NEW.site );
         END IF;

EXCEPTION
        WHEN no_data_found THEN NULL;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fifo_5rows_persite() FROM PUBLIC;

ALTER FUNCTION trigger_fct_fifo_5rows_persite() OWNER TO panda;

CREATE TRIGGER fifo_5rows_persite
	BEFORE INSERT ON multicloud_history FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fifo_5rows_persite();

DROP TRIGGER IF EXISTS jobclass_id_trg ON jobclass CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_jobclass_id_trg() RETURNS trigger AS $BODY$
DECLARE
v_newVal bigint := 0;
v_incval bigint := 0;
BEGIN
  IF TG_OP = 'INSERT' AND coalesce(NEW.id::text, '') = '' THEN
    SELECT  nextval('jobclass_id_seq') INTO STRICT v_newVal;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT max(id) INTO STRICT v_newVal FROM jobclass;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT nextval('jobclass_id_seq') INTO STRICT v_incval;
      END LOOP;
    END IF;
    -- save this to emulate @@identity
   mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   NEW.id := v_newVal;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_jobclass_id_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_jobclass_id_trg() OWNER TO panda;

CREATE TRIGGER jobclass_id_trg
	BEFORE INSERT OR UPDATE ON jobclass FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_jobclass_id_trg();

DROP TRIGGER IF EXISTS proxykey_created_trg ON proxykey CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proxykey_created_trg() RETURNS trigger AS $BODY$
DECLARE
BEGIN
  NEW.created := LOCALTIMESTAMP;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proxykey_created_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_proxykey_created_trg() OWNER TO panda;

CREATE TRIGGER proxykey_created_trg
	BEFORE INSERT OR UPDATE ON proxykey FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proxykey_created_trg();

DROP TRIGGER IF EXISTS schedinstance_tvalid_trg ON schedinstance CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_schedinstance_tvalid_trg() RETURNS trigger AS $BODY$
DECLARE
BEGIN
  NEW.tvalid := LOCALTIMESTAMP;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_schedinstance_tvalid_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_schedinstance_tvalid_trg() OWNER TO panda;

CREATE TRIGGER schedinstance_tvalid_trg
	BEFORE INSERT OR UPDATE ON schedinstance FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_schedinstance_tvalid_trg();

DROP TRIGGER IF EXISTS users_id_trg ON users CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_users_id_trg() RETURNS trigger AS $BODY$
DECLARE
v_newVal bigint := 0;
v_incval bigint := 0;
BEGIN
  IF TG_OP = 'INSERT' AND coalesce(NEW.id::text, '') = '' THEN
    SELECT  nextval('users_id_seq') INTO STRICT v_newVal;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT max(id) INTO STRICT v_newVal FROM users;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT nextval('users_id_seq') INTO STRICT v_incval;
      END LOOP;
    END IF;
    -- save this to emulate @@identity
   mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   NEW.id := v_newVal;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_users_id_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_users_id_trg() OWNER TO panda;

CREATE TRIGGER users_id_trg
	BEFORE INSERT OR UPDATE ON users FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_users_id_trg();

DROP TRIGGER IF EXISTS users_lastmod_trg ON users CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_users_lastmod_trg() RETURNS trigger AS $BODY$
DECLARE
BEGIN
  NEW.lastmod := (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_users_lastmod_trg() FROM PUBLIC;

ALTER FUNCTION trigger_fct_users_lastmod_trg() OWNER TO panda;

CREATE TRIGGER users_lastmod_trg
	BEFORE INSERT OR UPDATE ON users FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_users_lastmod_trg();
