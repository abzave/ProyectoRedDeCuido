create procedure updateGrado
@idGrado as tinyint,
@tipo as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarTipo @tipo;
	if @errorMessage is not null begin return; end
	if @idGrado is null begin
		set @errorMessage = 'El id del grado no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idGrado < 0 begin 
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end 
	if not exists (select @@ERROR from Grado where idGrado = @idGrado) begin
		set @errorMessage = 'Este id no se encuentra registrado';
		raiserror(@errorMessage, 2, 3);
	end
	update Grado set tipo = @tipo where idGrado = @idGrado
end

create procedure updateEstudio
@idEstudio as smallint,
@descripcion as varchar(50) = null,
@idGrado as tinyint = null,
@grado as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idEstudio is null begin
		set @errorMessage = 'El id del estudio no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idEstudio < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripcion no puede estar vacia';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idGrado is not null and @idGrado < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @grado = '' begin
		set @errorMessage = 'El grado no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if not exists (select @@ERROR from Estudio where idEstudio = @idEstudio) begin
		set @errorMessage = 'Este id no se encuentra registrado';
		raiserror(@errorMessage, 2, 3);
	end
	execute @errorMessage = getGrado @idGrado out, @grado;
	if @errorMessage is not null begin return; end
	update Estudio set descripcion = ISNULL(@descripcion, descripcion), 
	idGrado = ISNULL(@idGrado, idGrado) where idEstudio = @idEstudio
end

create procedure updateCanton
@idCanton as tinyint = null,
@nombre as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCanton is null begin
		set @errorMessage = 'El id del estudio no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idCanton < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El grado no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idProvincia is not null and @idProvincia < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @provincia = '' begin
		set @errorMessage = 'El grado no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if @idProvincia is not null or @provincia is not null begin
		execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	end else if @errorMessage is not null begin return; end
	update Canton set nombre = ISNULL(@nombre, nombre), 
	idProvincia = ISNULL(@idProvincia, idProvincia) where idCanton = @idCanton
end

create procedure updateProvincia
@idProvincia as tinyint,
@nombre as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @nombre;
	if @errorMessage is not null begin return; end
	update Provincia set nombre = @nombre where idProvincia = @idProvincia
end

create procedure updateCentroDeAtencion
@idCentro as tinyint,
@nombre as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCentro is null begin
		set @errorMessage = 'El id del centro no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idCentro < 0 begin
		set @errorMessage = 'El id centro no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idProvincia is not null and @idProvincia < 0 begin
		set @errorMessage = 'La provincia no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @provincia = '' begin
		set @errorMessage = 'La provincia no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if @idProvincia is not null or @provincia is not null begin
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	end else if @errorMessage is not null begin return; end
	update CentroDeAtencion set nombre = ISNULL(@nombre, nombre), 
	idProvincia = ISNULL(@idProvincia, idProvincia) where idCentro = @idCentro
end

create procedure updateComentario
@idComentario as int,
@contenido as varchar(50),
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idComentario;
	execute @errorMessage = validarContenido @contenido, @errorMessage;
	if @errorMessage is not null begin return; end
	update Comentario set contenido = @contenido where idComentario = @idComentario
end

create procedure updateCalificacion
@idCalificacion as int,
@puntuacion as tinyint = null,
@idComentario as tinyint = null,
@comentario as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCalificacion is null begin
		set @errorMessage = 'El id de la calificacion no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @puntuacion is not null and @puntuacion < 0 begin
		set @errorMessage = 'La puntuacion no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idComentario is not null and @idComentario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @comentario = '' begin
		set @errorMessage = 'El comentario no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if (@idComentario is not null or @comentario is not null) and not exists 
			(select idComentario = @idComentario from Comentario where 
			(@idComentario is null or idComentario = @idComentario) and
			(@comentario is null or contenido = @comentario)) begin
		set @errorMessage = 'El comentario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Calificacion set puntuacion = ISNULL(@puntuacion, puntuacion), 
	idComentario = ISNULL(@idComentario, idComentario) where idCalificacion = @idCalificacion
end

create procedure updateHorario
@idHorario as int,
@tiempo as varchar(20),
@errorMessage as varchar(50) = null out
as begin
	if @idHorario is null begin
		set @errorMessage = 'El id de la calificacion no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @tiempo is null begin
		set @errorMessage = 'El tiempo no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @tiempo = '' begin
		set @errorMessage = 'El tiempo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idHorario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update Horario set tiempo = @tiempo where idHorario = @idHorario
end

create procedure updateDia
@idDia as tinyint,
@nombre as varchar(10),
@errorMessage as varchar(50) = null out
as begin
	if @idDia is null begin
		set @errorMessage = 'El id del dia no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idDia < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage is not null begin return; end
	update Dia set nombre = @nombre where idDia = @idDia
end

create procedure updateJornada
@idJornada as int,
@horaInicio as time(0) = null,
@horaFin as time(0) = null,
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idJornada;
	if @errorMessage is not null begin return; end
	if @horaInicio is not null and @horaInicio > CONVERT(time, GETDATE()) begin
		set @errorMessage = 'La hora de inicio mayor al dia actual';
		raiserror(@errorMessage, 1, 7);
		return;
	end else if @horaFin is not null and @horaFin > CONVERT(time, GETDATE()) begin
		set @errorMessage = 'La hora de inicio mayor al dia actual';
		raiserror(@errorMessage, 1, 7);
		return;
	end else if @idDia is not null and @idDia < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @dia = '' begin
		set @errorMessage = 'El dia no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if (@idDia is not null or @dia is not null) and not exists (select idDia = @idDia from Dia where 
			(@idDia is null or idDia = @idDia) and (@dia is null or nombre = @dia)) begin
		set @errorMessage = 'El dia dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Jornada set horaInicio = ISNULL(@horaInicio, horaInicio), 
	horaFin = ISNULL(@horaFin, horaFin), idDia = ISNULL(@idDia, idDia) where idJornada = @idJornada
end

create procedure updateHorarioXJornada
@id as int,
@idHorario as int = null,
@idJornada as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idHorario is null and @idJornada is null and @id is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idHorario is not null and @idHorario < 0 begin
		set @errorMessage = 'El id del horario no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idJornada is null and @idJornada < 0 begin
		set @errorMessage = 'El id de la jornada no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update HorarioXJornada set idHorario = ISNULL(@idHorario, idHorario), 
	idJornada = ISNULL(@idJornada, idJornada)
end

create procedure updateTipoUsuario
@idTipo as int,
@tipo as varchar(30),
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idTipo;
	execute @errorMessage = validarTipo @tipo, @errorMessage;
	if @errorMessage is not null begin return; end
	update TipoUsuario set tipo = @tipo where idTipo = @idTipo
end

create procedure updateUsuario
@idUsuario as int,
@contrasenia as varchar(30) = null,
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idUsuario;
	if @errorMessage is not null begin return; end
	if @contrasenia = '' begin
		set @errorMessage = 'La contraseña no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idTipo is not null and @idTipo < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @tipo = '' begin
		set @errorMessage = 'El tipo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if (@idTipo is not null or @tipo is not null) and not exists (select idTipo = @idTipo from 
			TipoUsuario where (@idTipo is null or idTipo = @idTipo) and 
			(@tipo is null and tipo = @tipo)) begin
		set @errorMessage = 'El tipo dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Usuario set contrasenia = ISNULL(@contrasenia, contrasenia), 
	idTipo = ISNULL(@idTipo, idTipo)
end

create procedure updateCliente
@idCliente as int,
@nombre as varchar(30) = null,
@apellido as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(20) = null,
@idUsuario as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idCliente;
	if @provincia is not null or @idProvincia is not null begin
		execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	end
	if @errorMessage is not null begin return; end
	if @apellido = '' begin
		set @errorMessage = 'El apellido no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idUsuario is not null and @idUsuario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @provincia = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idProvincia is not null and @idProvincia < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @idUsuario is not null and not exists (select idUsuario = @idUsuario from Usuario
			where idUsuario = @idUsuario) begin
		set @errorMessage = 'El usuario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Cliente set nombre = ISNULL(@nombre, nombre), apellido = ISNULL(@apellido, apellido), 
	idProvincia = ISNULL(@idProvincia, idProvincia), idUsuario = ISNULL(@idUsuario, idUsuario) 
	where idCliente = @idCliente
end

use RedDeCuido