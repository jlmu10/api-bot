create or replace function insumo.validar_usuario(
	pcedula varchar(9),
	pvalores json
)
returns jsonb
as $$
DECLARE
cedula_found varchar(9);
resultado bitacora.sumario;
parse_logs jsonb;
BEGIN
	SELECT cedula FROM insumo.personal WHERE 
	insumo.personal.busqueda @@ to_tsquery('V10826854')and insumo.personal.baneado = false into cedula_found;
  
  if cedula_found IS NOT NULL THEN
    -- Se agrega a la bitacora el intento de inicio de sesión:
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'No existe en personal');
	select '100' into resultado.cod;
	select 'No existe en personal' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select false into resultado.res;
	select 'No se encuentra el número de cédula registrado en alguna dirección' into resultado.msj;
	select json_agg(x) into parse_logs from
    (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
	return parse_logs;
 else
	INSERT INTO bitacora.bitacora(cedula, logs, accion)
	VALUES (cedula_found, $2, 'Existe personal -> Falta password');
	select '200' into resultado.cod;
	select 'Existe personal -> Falta password' into resultado.acc;
	select 'Proceso Registro' into resultado.cam;
	select true into resultado.res;
	select 'La cédula existe asociada a una dirección, pero no se registrado completamente' into resultado.msj;
	select json_agg(x) into parse_logs from (select resultado.cod,resultado.acc,resultado.cam,resultado.res) x;
		return 
			parse_logs;
end if;
END;
$$ LANGUAGE PLPGSQL;

select * from insumo.validar_usuario('V10826854','{"nombre":"jose"}'::json)