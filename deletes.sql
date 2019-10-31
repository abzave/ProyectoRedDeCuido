use RedDeCuido

create procedure deleteGrado
@idGrado as tinyint = null,
@tipo as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarGradoOIdGrado @idGrado, @tipo;
	if @errorMessage is not null begin return; end
	delete from Grado where (@idGrado is null or idGrado = @idGrado) and 
								(@tipo is null or tipo = @tipo)
end
go

create procedure deleteEstudio
@idEstudio as smallint = null,
@descripcion as varchar(50) = null,
@idGrado as tinyint = null,
@grado as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idEstudio is null and @descripcion is null and @idGrado is null and @grado is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripción no puede estar vacia';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	execute @errorMessage = validarGradoOIdGrado @idGrado, @grado, @errorMessage;
	execute @errorMessage = getGrado @idGrado out, @grado, @errorMessage;
	if @errorMessage is not null begin return; end
	delete from Estudio where (@idEstudio is null or idEstudio = @idEstudio) and 
	(@descripcion is null or descripcion = @descripcion) and 
	(@idGrado is null or idGrado = @idGrado)
end
go

create procedure deleteCanton
@idCanton as tinyint = null,
@nombre as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCanton is null and @nombre is null and @idProvincia is null and @provincia is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	if @errorMessage is not null begin return; end
	delete from Canton where (@idCanton is null or idCanton = @idCanton) and 
	(@nombre is null or nombre = @nombre) and (@idProvincia is null or idProvincia = @idProvincia)
end
go

create procedure deleteProvincia
@idProvincia as tinyint = null,
@nombre as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @nombre;
	if @errorMessage is not null begin return; end
	delete from Provincia where (@idProvincia is null or idProvincia = @idProvincia) and 
	(@nombre is null or nombre = @nombre)
end
go

create procedure deleteCentroDeAtencion
@idCentro as tinyint = null,
@nombre as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCentro is null and @nombre is null and @idProvincia is null and @provincia is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'La puntuacion no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	if @errorMessage is not null begin return; end
	delete from CentroDeAtencion where (@idCentro is null or idCentro = @idCentro) and 
	(@nombre is null or nombre = @nombre) and (@idProvincia is null or idProvincia = @idProvincia)
end
go

create procedure deleteComentario
@idComentario as int = null,
@contenido as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idComentario is null and @contenido is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @contenido = '' begin
		set @errorMessage = 'El contenido no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idComentario is not null and @idComentario < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @errorMessage is not null begin return; end
	delete from Comentario where (@idComentario is null or idComentario = @idComentario) and
	(@contenido is null or contenido = @contenido)
end
go

create procedure deleteCalificacion
@idCalificacion as int = null,
@puntuacion as tinyint,
@idComentario as tinyint = null,
@comentario as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCalificacion is null and @puntuacion is null and @idComentario is null and 
			@comentario is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
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
	delete from Calificacion where (@idCalificacion is null or idCalificacion = @idCalificacion)
	and (@puntuacion is null or puntuacion = @puntuacion) and 
	(@idComentario is null or idComentario = @idComentario)
end
go

create procedure deleteHorario
@idHorario as int = null,
@tiempo as varchar(20) = null,
@errorMessage as varchar(50) = null out
as begin
	if @tiempo = '' begin
		set @errorMessage = 'El tiempo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end else if @idHorario is not null and @idHorario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from Horario where (@idHorario is null or idHorario = @idHorario) and 
	(@tiempo is null or tiempo = @tiempo)
end
go

create procedure deleteDia
@idDia as tinyint = null,
@nombre as varchar(10),
@errorMessage as varchar(50) = null out
as begin
	if @idDia is null and @nombre is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idDia is not null and @idDia < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	if @errorMessage is not null begin return; end
	delete from Dia where (@idDia is null or idDia = @idDia) and 
	(@nombre is null or nombre = @nombre)
end
go

create procedure deleteJornada
@idJornada as int = null,
@horaInicio as time(0) = null,
@horaFin as time(0) = null,
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idJornada is null and @horaInicio is null and @horaFin is null and @idDia is null 
			and @dia is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @horaInicio is not null and @horaInicio > CONVERT(time, GETDATE()) begin
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
	end else if @idJornada is not null and @idJornada < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idDia is not null or @dia is not null) and not exists (select idDia = @idDia from Dia where 
			(@idDia is null or idDia = @idDia) and (@dia is null or nombre = @dia)) begin
		set @errorMessage = 'El dia dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Jornada where (@idJornada is null or idJornada = @idJornada) and 
	(@horaInicio is null or horaInicio = @horaInicio) and (@horaFin is null or horaFin = @horaFin)
	and (@idDia is null or idDia = @idDia)
end
go

create procedure deleteHorarioXJornada
@id as int = null,
@idHorario as int = null,
@idJornada as int = null,
@errorMessage as varchar(50) = null out
as begin
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
	end else if @id is null and @id < 0 begin
		set @errorMessage = 'El id de la jornada no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from HorarioXJornada where (@id is null or id = @id) and 
	(@idHorario is null or idHorario = @idHorario) and 
	(@idJornada is null or idJornada = @idJornada)
end
go

create procedure deleteTipoUsuario
@idTipo as int = null,
@tipo as varchar(30),
@errorMessage as varchar(50) = null out
as begin
	if @idTipo is null and @tipo is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idTipo is not null and @idTipo < 0 begin
		set @errorMessage = 'El id de la jornada no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @tipo = '' begin
		set @errorMessage = 'El dia no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
		return;
	end
	delete from TipoUsuario where (@idTipo is null or idTipo = @idTipo) and 
	(@tipo is null or tipo = @tipo)
end
go

create procedure deleteUsuario
@idUsuario as int = null,
@contrasenia as varchar(30),
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idUsuario is null and @contrasenia is null and @idTipo is null or @tipo is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @contrasenia = '' begin
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
	delete from Usuario where (@idUsuario is null or idUsuario = @idUsuario) and 
	(@contrasenia is null or contrasenia = @contrasenia) and (@idTipo is null or idTipo = @idTipo)
end
go

create procedure deleteCliente
@idCliente as int = null,
@nombre as varchar(30) = null,
@apellido as varchar(30) = null,
@idProvincia as tinyint = null,
@provincia as varchar(20) = null,
@idUsuario as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCliente is null and @nombre is null and @apellido is null and @idProvincia is null 
			and @provincia is null and @idUsuario is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @provincia is not null or @idProvincia is not null begin
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
	delete from Cliente where (@idCliente is null or idCliente = @idCliente) and 
	(@nombre is null or nombre = @nombre) and (@apellido is null or apellido = @apellido) and
	(@idProvincia is null or idProvincia = @idProvincia) and 
	(@idUsuario is null or idUsuario = @idUsuario)
end
go

create procedure deletePersonal
@idPersonal as int = null,
@nombre as varchar(30) = null,
@apellido as varchar(30) = null,
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@idHorario as int = null,
@tiempo as varchar(20) = null,
@idUsuario as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idPersonal is null and @nombre is null and @apellido is null and @idCentro is null and 
			@nombreCentro is null and @idHorario is null and @tiempo is null and 
			@idUsuario is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end
	if @errorMessage is not null begin return; end
	if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @apellido = '' begin
		set @errorMessage = 'El apellido no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreCentro = '' begin
		set @errorMessage = 'El centro no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idHorario is not null and @idHorario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @tiempo = '' begin
		set @errorMessage = 'El tiempo no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idUsuario is not null and @idUsuario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idCentro is not null or @nombreCentro is not null) and not exists 
			(select idCentro = @idCentro from CentroDeAtencion where 
			(@idCentro is null or idCentro = @idCentro) and 
			(@nombreCentro is null and nombre = @nombreCentro)) begin
		set @errorMessage = 'El horario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idHorario is not null or @tiempo is not null) and not exists 
			(select idHorario = @idHorario from Horario where 
			(@idHorario is null or idHorario = @idHorario) and 
			(@tiempo is null and tiempo = @tiempo)) begin
		set @errorMessage = 'El horario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if @idUsuario is not null and not exists (select idUsuario = @idUsuario from Usuario 
			where idUsuario = @idUsuario) begin
		set @errorMessage = 'El usuario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Personal where (@idPersonal is null or idPersonal = @idPersonal) and 
	(@nombre is null or nombre = @nombre) and (@apellido is null or apellido = @apellido) and
	(@idCentro is null or idCentro = @idCentro) and (@idHorario is null or idHorario = @idHorario)
	and (@idUsuario is null or idUsuario = @idUsuario)
end
go

create procedure deleteCalificacionXCliente
@id as int = null,
@idCalificacion as int = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @id is null and @idCalificacion is null and @idCliente is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idCalificacion is not null and @idCalificacion < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id del cliente no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from CalificacionXCliente where (@id is null or id = @id) and 
	(@idCalificacion is null or idCalificacion = @idCalificacion) and 
	(@idCliente is null or idCliente = @idCliente)
end
go

create procedure deleteCalificacionXPersonal
@id as int = null,
@idCalificacion as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCalificacion is null and @idPersonal is null and @id is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idCalificacion is not null and @idCalificacion < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from CalificacionXPersonal where (@id is null or id = @id) and 
	(@idCalificacion is null or idCalificacion = @idCalificacion) and 
	(@idPersonal is null or idPersonal = @idPersonal)
end
go

create procedure deleteCategoria
@idCategoria as int = null,
@descripcion as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCategoria is null and @descripcion is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id de la categoria no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripcion no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from Categoria where (@idCategoria is null or idCategoria = @idCategoria) and 
	(@descripcion is null or descripcion = @descripcion)
end
go

create procedure deleteCategoriaXPersonal
@id as int = null,
@idCategoria as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @id is null and @idCategoria is null and @idPersonal is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from CategoriaXPersonal where (@id is null or id = @id) and 
	(@idCategoria is null or idCategoria = @idCategoria) and 
	(@idPersonal is null or idPersonal = @idPersonal)
end
go

create procedure deleteEstudioXPersonal
@id as int = null,
@idEstudio as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idEstudio is null and @id is null and @idPersonal is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idEstudio is not null and @idEstudio < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from EstudioXPersonal where (@id is null or id = @id) and 
	(@idEstudio is null or idEstudio = @idEstudio) and
	(@idPersonal is null or idPersonal = @idPersonal)
end
go

create procedure deleteSolicitud
@idSolicitud as int = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idPersonal is null and @nombrePersonal is null and @idSolicitud is null and 
			@idCliente is null and @nombreCliente is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @nombrePersonal = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreCliente = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idSolicitud is not null and @idSolicitud < 0 begin
		set @errorMessage = 'El id no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idPersonal is not null or @nombrePersonal is not null) and not exists 
			(select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null and nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idCliente is not null or @nombreCliente is not null) and not exists 
			(select idCliente = @idCliente from Cliente where
			(@idCliente is null or idCliente = @idCliente) and 
			(@nombreCliente is null and nombre = @nombreCliente)) begin
		set @errorMessage = 'El cliente dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Solicitud where (@idSolicitud is null or idSolicitud = @idSolicitud) and 
	(@idPersonal is null or idPersonal = @idPersonal) and 
	(@idCliente is null or idCliente = @idCliente)
end
go

create procedure deleteContratacion
@idContratacion as int = null,
@monto as money = null,
@fecha as datetime = null,
@idSolicitud as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idContratacion is null and @monto is null and @fecha is null and @idSolicitud is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @monto is not null and @monto < 0 begin
		set @errorMessage = 'El monto debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @fecha = '' begin
		set @errorMessage = 'La fecha no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idSolicitud is not null and @idSolicitud < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idContratacion is not null and @idContratacion < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @idSolicitud is not null and not exists 
		(select idSolicitud = @idSolicitud from Solicitud where idSolicitud = @idSolicitud) begin
		set @errorMessage = 'La solicitud dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Contratacion where (@idContratacion is null or idContratacion = @idContratacion)
	and (@monto is null or monto = @monto) and (@fecha is null or fecha = @fecha) and 
	(@idSolicitud is null or idSolicitud = @idSolicitud)
end
go

create procedure deleteCategoriaXContratacion
@id as int = null,
@precio as money = null,
@idCategoria as smallint = null,
@idContratacion as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @precio is null and @id is null and @idCategoria is null and @idContratacion is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @precio is not null and @precio < 0 begin
		set @errorMessage = 'El precio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id de la categoria no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idContratacion is not null and @idContratacion < 0 begin
		set @errorMessage = 'El id del contratacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from CategoriaXContratacion where (@id is null or id = @id) and 
	(@precio is null or precio = @precio) and (@idCategoria is null or idCategoria = @idCategoria)
	and (@idContratacion is null or idContratacion = @idContratacion)
end
go

create procedure deletePuesto
@idPuesto as int = null,
@nombre as varchar(50) = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	if @errorMessage is not null begin return; end
	if @idPersonal is null and @nombrePersonal is null and @idPuesto is null and 
			@nombre is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del empleado no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombrePersonal = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPuesto is not null and @idPuesto < 0 begin
		set @errorMessage = 'El id del puesto no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idPersonal is not null or @nombrePersonal is not null) and not exists 
			(select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null or nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Puesto where (@idPuesto is null or idPuesto = @idPuesto) and 
	(@nombre is null or nombre = @nombre) and (@idPersonal is null or idPersonal = @idPersonal)
end
go

create procedure deletePago
@idPago as int = null,
@fecha as datetime = null,
@monto as money = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idPago is null and @fecha is null and @monto is null and @idPersonal is null and 
			@nombrePersonal is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end
	if @fecha = '' begin
		set @errorMessage = 'La fecha no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @monto is not null and @monto < 0 begin
		set @errorMessage = 'El monto no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del empleado no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombrePersonal = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPago is not null and @idPago < 0 begin
		set @errorMessage = 'El id del paggo no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idPersonal is not null or @nombrePersonal is not null) and not exists 
			(select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null or nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Pago where (@idPago is null or idPago = @idPago) and 
	(@fecha is null or fecha = @fecha) and (@monto is null or monto = @monto) and 
	(@idPersonal is null or idPersonal = @idPersonal)
end
go

create procedure deleteActividad
@idActividad as tinyint = null,
@descripcion as varchar(10) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idActividad is null and @descripcion is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idActividad is not null and @idActividad < 0 begin
		set @errorMessage = 'El id de la actividad no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripcion no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @errorMessage is not null begin return; end
	delete from Actividad where (@idActividad is null or idActividad = @idActividad) and 
	(@descripcion is null or descripcion = @descripcion)
end
go

create procedure deleteCorreo
@idCorreo as int = null,
@direccion as varchar(50) = null,
@idUsuario as int = null,
@nombreUsuario as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idCorreo is null and @direccion is null or @idUsuario is null or
			@nombreUsuario is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end
	if @direccion = '' begin
		set @errorMessage = 'La direccion no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idUsuario is not null and @idUsuario < 0 begin
		set @errorMessage = 'El id del usuario no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreUsuario = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCorreo is not null and @idCorreo < 0 begin
		set @errorMessage = 'El id del correo no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if not exists (select idUsuario = @idUsuario from Usuario  where 
			(@idUsuario is null or Usuario.idUsuario = @idUsuario) and 
			(@nombreUsuario is null or contrasenia = @nombreUsuario)) begin
		set @errorMessage = 'El usuario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Correo where (@idCorreo is null or idCorreo = @idCorreo) and 
	(@direccion is null or direccion = @direccion) and (@idUsuario is null or idUsuario = @idUsuario)
end
go

create procedure deleteEnfermedad
@idEnfermedad as smallint = null,
@nombre as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idEnfermedad is null and @nombre is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idEnfermedad is not null and @idEnfermedad < 0 begin
		set @errorMessage = 'El id de la enfermedad no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @errorMessage is not null begin return; end
	delete from Enfermedad where (@idEnfermedad is null or idEnfermedad = @idEnfermedad) and 
	(@nombre is null or nombre = @nombre)
end
go

create procedure deleteTratamiento
@idTratamiento as int = null,
@nombre as varchar(30) = null,
@cantidad as smallint = null,
@idEnfermedad as smallint = null,
@nombreEnfermedad as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idTratamiento is null and @nombre is null and @cantidad is null and @idEnfermedad is null 
			and @nombreEnfermedad is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end
	if @errorMessage is not null begin return; end
	if @cantidad is not null and @cantidad < 0 begin
		set @errorMessage = 'La cantidad no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idEnfermedad is not null and @idEnfermedad < 0 begin
		set @errorMessage = 'El id de la enfermedad no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreEnfermedad = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idTratamiento is not null and @idTratamiento < 0 begin
		set @errorMessage = 'El id del tratamiento no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idEnfermedad is not null or @nombreEnfermedad is not null) and not exists 
			(select idEnfermedad = @idEnfermedad from Enfermedad  where 
			(@idEnfermedad is null or idEnfermedad = @idEnfermedad) and 
			(@nombreEnfermedad is null or nombre = @nombreEnfermedad)) begin
		set @errorMessage = 'La enfermedad dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	delete from Tratamiento where (@idTratamiento is null or idTratamiento = @idTratamiento) and 
	(@nombre is null or nombre = @nombre) and (@cantidad is null or cantidad = @cantidad) and
	(@idEnfermedad is null or idEnfermedad = @idEnfermedad)
end
go

create procedure deleteTratamientoXCliente
@id as int = null,
@idTratamiento as int = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @idTratamiento is not null and @idTratamiento < 0 begin
		set @errorMessage = 'El id del tratamiento no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id del cliente no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from TratamientoXCliente where (@id is null or id = @id) and 
	(@idTratamiento is null or idTratamiento = @idTratamiento) and 
	(@idCliente is null or idCliente = @idCliente)
end
go

create procedure deleteTipoServicio
@idTipo as smallint = null,
@descripcion as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idTipo is null and @descripcion is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripcio no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idTipo is not null and @idTipo < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @errorMessage is not null begin return; end
	delete from TipoServicio where (@idTipo is null or idServicio = @idTipo) and 
	(@descripcion is null or descripcion = @descripcion)
end
go

create procedure deleteServicioXCentro
@id as int = null,
@idServicio as smallint = null,
@idCentro as smallint = null,
@errorMessage as varchar(50) = null out
as begin
	if @idServicio is not null and @idServicio < 0 begin
		set @errorMessage = 'El id del servicio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id del centro no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from ServicioXCentro where (@id is null or id = @id) and 
	(@idServicio is null or idServicio = @idServicio) and 
	(@idCentro is null or idCentro = @idCentro)
end
go

create procedure deleteEnfermedadXCliente
@id as int = null,
@idEnfermedad as smallint = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	if @id is null and @idEnfermedad is null and @idCliente is null begin
		set @errorMessage = 'El id del servicio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if @errorMessage is not null begin return; end
	if @idEnfermedad is not null and @idEnfermedad < 0 begin
		set @errorMessage = 'El id del servicio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id del cliente no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @id is not null and @id < 0 begin
		set @errorMessage = 'El id del cliente no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	delete from EnfermedadXCliente where (@id is null or id = @id) and 
	(@idEnfermedad is null or idEnfermedad = @idEnfermedad) and 
	(@idCliente is null or idCliente = @idCliente)
end
go