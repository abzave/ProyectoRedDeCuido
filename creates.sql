use RedDeCuido

create procedure validarTipo
@tipo as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @tipo is null begin
		set @errorMessage = 'El tipo no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @tipo = '' begin
		set @errorMessage = 'El tipo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure existeGrado
@tipo as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Grado where tipo = @tipo) begin
		set @errorMessage = 'Este tipo ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarDescripcion
@descripcion as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @descripcion is null begin
		set @errorMessage = 'La descripción no puede ser nula';
		raiserror(@errorMessage, 1, 1);
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripción no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure existeEstudio
@descripcion as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Estudio where descripcion = @descripcion) begin
		set @errorMessage = 'Esta descripción ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarGradoOIdGrado
@idGrado as tinyint,
@grado as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @idGrado is null and @grado is null begin
		set @errorMessage = 'Debe ingresar la id del grado o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idGrado is not null and @idGrado < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @grado = '' begin
		set @errorMessage = 'El grado no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure getGrado
@idGrado as tinyint out,
@grado as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if not exists (select idGrado = @idGrado from Grado where ISNULL(idGrado, tipo) = ISNULL(@idGrado, @grado)) begin
		set @errorMessage = 'El grado dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end

create procedure validarNombre
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @nombre is null begin
		set @errorMessage = 'El nombre no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure validarProvinciaOIdProvincia
@idProvincia as tinyint,
@provincia as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @idProvincia is null and @provincia is null begin
		set @errorMessage = 'Debe ingresar la id de la provincia o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idProvincia < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @provincia = '' begin
		set @errorMessage = 'El grado no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure existeCanton
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Canton where nombre = @nombre) begin
		set @errorMessage = 'Este nombre ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure getProvincia
@idProvincia as tinyint out,
@provincia as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if not exists (select idProvincia = @idProvincia from Provincia where 
			(@idProvincia is null or idProvincia = @idProvincia) 
			and (@provincia is null or nombre = @provincia)) begin
		set @errorMessage = 'La provincia dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end

create procedure existeProvincia
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Provincia where nombre = @nombre) begin
		set @errorMessage = 'Este nombre ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure existeCentroDeAtencion
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from CentroDeAtencion where nombre = @nombre) begin
		set @errorMessage = 'Este nombre ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
		return;
	end
end

create procedure validarContenido
@contenido as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @contenido is null begin
		set @errorMessage = 'El contenido no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @contenido = '' begin
		set @errorMessage = 'El contenido no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end

create procedure existeComentario
@contenido as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Comentario where contenido = @contenido) begin
		set @errorMessage = 'Este contenido ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarPuntuacion
@puntuacion as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if @puntuacion is null begin
		set @errorMessage = 'La puntuacion no puede ser nula';
		raiserror(@errorMessage, 1, 1);
	end else if @puntuacion < 0 begin
		set @errorMessage = 'La puntuacion no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end

create procedure validarComentarioOIdComentario
@idComentario as tinyint,
@comentario as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if @idComentario is null and @comentario is null begin
		set @errorMessage = 'Debe ingresar la id del comentario o el texto';
		raiserror(@errorMessage, 1, 3);
	end else if @idComentario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @comentario = '' begin
		set @errorMessage = 'El comentario no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeCalificacion
@puntuacion as tinyint,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Calificacion where puntuacion = @puntuacion) begin
		set @errorMessage = 'Esta calificacion ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end 
	return @errorMessage;
end

create procedure getComentario
@idComentario as tinyint out,
@comentario as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if not exists (select idComentario = @idComentario from Comentario where 
			(@idComentario is null or idComentario = @idComentario) and 
			(@comentario is null or contenido = @comentario)) begin
		set @errorMessage = 'El comentario dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end
go

create procedure validarTiempo
@tiempo as varchar(20),
@errorMessage as varchar(50) = null
as begin
	if @tiempo is null begin
		set @errorMessage = 'El tiempo no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @tiempo = '' begin
		set @errorMessage = 'El tiempo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeHorario
@tiempo as tinyint,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Horario where tiempo = @tiempo) begin
		set @errorMessage = 'Este tiempo ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeDia
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Dia where nombre = @nombre) begin
		set @errorMessage = 'Este dia ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarHora
@hora as time(0),
@errorMessage as varchar(50) = null
as begin
	if @hora is null begin
		set @errorMessage = 'La hora no puede ser nula';
		raiserror(@errorMessage, 1, 1);
	end else if @hora < CONVERT(time, GETDATE()) begin
		set @errorMessage = 'La hora no puede mayor al dia actual';
		raiserror(@errorMessage, 1, 7);
	end
	return @errorMessage;
end
go

create procedure validarDiaOIdDia
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as varchar(50) = null
as begin
	if @idDia is null and @dia is null begin
		set @errorMessage = 'Debe ingresar la id del dia o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idDia is not null and @idDia < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @dia = '' begin
		set @errorMessage = 'El dia no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end
go

create procedure getDia
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idDia = @idDia from Dia where (@idDia is null or idDia = @idDia) 
			and (@dia is null or nombre = @dia)) begin
		set @errorMessage = 'El dia dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end
go

create procedure existeJornada
@horaInicio as time(0),
@horaFin as time(0),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Jornada where horaInicio = @horaInicio and horaFin = @horaFin) begin
		set @errorMessage = 'Esta jornada ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarIntId
@id as int = null,
@errorMessage as varchar(50) = null
as begin
	if @id is null begin
		set @errorMessage = 'El id no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end
go

create procedure existeHorarioXJornada
@idHorario as int,
@idJornada as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from HorarioXJornada where idHorario = @idHorario and idJornada = @idJornada) begin
		set @errorMessage = 'Este horario ya se encuentra registrado con esta jornada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeTipoUsuario
@tipo as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from TipoUsuario where tipo = @tipo) begin
		set @errorMessage = 'Este tipo ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarContrasenia
@contrasenia as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if @contrasenia is null begin
		set @errorMessage = 'La constraseña no puede ser nula';
		raiserror(@errorMessage, 1, 1);
	end else if @contrasenia = '' begin
		set @errorMessage = 'La contraseña no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarTipoOIdTipo
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null
as begin
	if @idTipo is null and @tipo is null begin
		set @errorMessage = 'Debe ingresar la id del tipo o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idTipo < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @tipo = '' begin
		set @errorMessage = 'El tipo no puede estar vacio';
		raiserror(@errorMessage, 1, 2);
	end
	return @errorMessage;
end
go

create procedure getTipoUsuario
@idTipo as int = null out,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idTipo = @idTipo from TipoUsuario where 
			(@idTipo is null or idTipo = @idTipo) and (@tipo is null and tipo = @tipo)) begin
		set @errorMessage = 'El tipo dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end
go

create procedure validarApellido
@apellido as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if @apellido is null begin
		set @errorMessage = 'El apellido no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @apellido = '' begin
		set @errorMessage = 'El apellido no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
	end
	return @errorMessage;
end
go

create procedure getUsuario
@idUsuario as int out,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idUsuario = @idUsuario from Usuario
			where idUsuario = @idUsuario) begin
		set @errorMessage = 'El usuario dado no existe';
		raiserror(@errorMessage, 2, 2);
	end 
	return @errorMessage;
end
go

create procedure existeCliente
@nombre as varchar(30),
@apellido as varchar(30),
@idProvincia as tinyint,
@idUsuario as int,
@errorMessage as varchar(50) = null
as begin
	if exists(select @@ERROR from Cliente where nombre = @nombre and apellido = @apellido 
			and idProvincia = @idProvincia and idUsuario = @idUsuario) begin
		set @errorMessage = 'Este cliente ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarCentroOIdCentro
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@errorMessage as varchar(50) = null
as begin
	if @idCentro is null and @nombreCentro is null begin
		set @errorMessage = 'Debe ingresar la id del centro o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idCentro < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @nombreCentro = '' begin
		set @errorMessage = 'El centro no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarTiempoOIdHorario
@idHorario as int = null,
@tiempo as varchar(20) = null,
@errorMessage as varchar(50) = null
as begin
	if @idHorario is null and @tiempo is null begin
		set @errorMessage = 'Debe ingresar la id del horario o el tiempo';
		raiserror(@errorMessage, 1, 3);
	end else if @idHorario < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @tiempo = '' begin
		set @errorMessage = 'El tiempo no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
	end
	return @errorMessage;
end
go

create procedure getCentro
@idCentro as smallint = null out,
@nombreCentro as varchar(30) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idCentro = @idCentro from CentroDeAtencion where 
			(@idCentro is null or idCentro = @idCentro) and 
			(@nombreCentro is null and nombre = @nombreCentro)) begin
		set @errorMessage = 'El horario dado no existe';
		raiserror(@errorMessage, 2, 2);
	end 
	return @errorMessage;
end
go

create procedure getHorario
@idHorario as int = null out,
@tiempo as varchar(20) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idHorario = @idHorario from Horario where 
			(@idHorario is null or idHorario = @idHorario) and 
			(@tiempo is null and tiempo = @tiempo)) begin
		set @errorMessage = 'El horario dado no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end
go

create procedure existePersonal
@nombre as varchar(30),
@apellido as varchar(30),
@idCentro as smallint = null,
@idHorario as int = null,
@idUsuario as int,
@errorMessage as varchar(50) = null
as begin
	if exists(select @@ERROR from Personal where nombre = @nombre and apellido = @apellido 
			and idCentro = @idCentro and idHorario = @idHorario and idUsuario = @idUsuario) begin
		set @errorMessage = 'Este empleado ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCalificacionXCliente
@idCalificacion as int,
@idCliente as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from CalificacionXCliente where idCalificacion = @idCalificacion 
			and idCliente = @idCliente) begin
		set @errorMessage = 'Esta calificacion ya se encuentra registrado con este cliente';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCalificacionXPersonal
@idCalificacion as int,
@idPersonal as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from CalificacionXPersonal where idCalificacion = @idCalificacion 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 'Esta calificacion ya se encuentra registrado con este empleado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure existeCategoria
@descripcion as varchar(30),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Categoria where descripcion = @descripcion) begin
		set @errorMessage = 'Esta categoria ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure existeCategoriaXPersonal
@idCategoria as int,
@idPersonal as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from CategoriaXPersonal where idCategoria = @idCategoria 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 'Esta categoria ya se encuentra registrado con este empleado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure existeEstudioXPersonal
@idEstudio as int,
@idPersonal as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from EstudioXPersonal where idEstudio = @idEstudio 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 'Este estudio ya se encuentra registrado con este empleado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarPersonalOIdPersonal
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null
as begin
	if @idPersonal is null and @nombrePersonal is null begin
		set @errorMessage = 'Debe ingresar el id del empleado o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @nombrePersonal = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
	end if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end

create procedure validarClienteOIdCliente
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@errorMessage as varchar(50) = null
as begin
	if @idCliente is null and @nombreCliente is null begin
		set @errorMessage = 'Debe ingresar el id del cliente o el nombre';
		raiserror(@errorMessage, 1, 3);
	end else if @idCliente is null and @idCliente < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end else if @nombreCliente = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end

create procedure getPersonal
@idPersonal as int = null out,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null and nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
	end 
	return @errorMessage;
end

create procedure getCliente
@idCliente as int = null out,
@nombreCliente as varchar(75) = null,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idCliente = @idCliente from Cliente where 
			(@idCliente is null or idCliente = @idCliente) and 
			(@nombreCliente is null and nombre = @nombreCliente)) begin
		set @errorMessage = 'El cliente dado no existe';
		raiserror(@errorMessage, 2, 2);
	end 
	return @errorMessage;
end

create procedure existeSolicitud
@idPersonal as int = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Solicitud where idPersonal = @idPersonal 
			and idCliente = @idCliente) begin
		set @errorMessage = 'Esta solicitud ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarMonto
@monto as money,
@errorMessage as varchar(50) = null
as begin
	if @monto is null begin
		set @errorMessage = 'El monto no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @monto < 0 begin
		set @errorMessage = 'El monto debe ser positivo';
		raiserror(@errorMessage, 1, 4);
	end 
	return @errorMessage;
end

create procedure validarFecha
@fecha as datetime,
@errorMessage as varchar(50) = null
as begin
	if @fecha is null begin
		set @errorMessage = 'La fecha no puede ser nula';
		raiserror(@errorMessage, 1, 1);
	end else if @fecha = '' begin
		set @errorMessage = 'La fecha no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
	end else if @fecha > GETDATE() begin
		set @errorMessage = 'La fecha no puede mayor a la actual';
		raiserror(@errorMessage, 1, 7);
	end
	return @errorMessage;
end

create procedure getSolicitud
@idSolicitud as int = null out,
@errorMessage as varchar(50) = null
as begin
	if not exists (select idSolicitud = @idSolicitud from Solicitud where idSolicitud = @idSolicitud)
			begin
		set @errorMessage = 'La solicitud dada no existe';
		raiserror(@errorMessage, 2, 2);
	end
	return @errorMessage;
end

create procedure existeContratacion
@monto as money,
@fecha as datetime,
@idSolicitud as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Contratacion where monto = @monto and fecha = @fecha 
				and idSolicitud = @idSolicitud) begin
		set @errorMessage = 'Esta solicitud ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure validarSmallintId
@id as smallint,
@errorMessage as varchar(50) = null
as begin
	if @id is null begin
		set @errorMessage = 'El id no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
	end else if @id < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
	end
	return @errorMessage;
end

create procedure existeCategoriaXContratacion
@idCategoria as smallint,
@idContratacion as int,
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from CategoriaXContratacion where idCategoria = @idCategoria 
			and idContratacion = @idCategoria) begin
		set @errorMessage = 'Esta categoria ya se encuentra registrado con esta contratacion';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure existePuesto
@nombre as varchar(50),
@errorMessage as varchar(50) = null
as begin
	if exists (select @@ERROR from Puesto where nombre = @nombre) begin
		set @errorMessage = 'Este puesto ya está registrado';
		raiserror(@errorMessage, 2, 1);
	end
	return @errorMessage;
end

create procedure createGrado
@tipo as varchar(50),
@errorMessage as varchar(50) = null out,
@idGrado as tinyint = null out
as begin
	execute @errorMessage = validarTipo @tipo;
	execute @errorMessage = existeGrado @tipo, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Grado (tipo) values (@tipo)
	select @idGrado = @@IDENTITY
	commit transaction
end
go

create procedure createEstudio
@descripcion as varchar(50),
@idGrado as tinyint = null,
@grado as varchar(50) = null,
@errorMessage as varchar(50) = null out,
@idEstudio as smallint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	execute @errorMessage = validarGradoOIdGrado @idGrado, @grado, @errorMessage;
	execute @errorMessage = existeEstudio @descripcion, @errorMessage;
	execute @errorMessage = getGrado @idGrado out, @grado, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction
	insert into Estudio (descripcion, idGrado) values (@descripcion, @idGrado)
	select @idEstudio = @@IDENTITY
	commit transaction
end
go

create procedure createCanton
@nombre as varchar(30),
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out,
@idCanton as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = existeCanton @nombre, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Canton(nombre, idProvincia) values (@nombre, @idProvincia)
	select @idCanton = @@IDENTITY
	commit transaction
end
go

create procedure createProvincia
@nombre as varchar(50),
@errorMessage as varchar(50) = null out,
@idProvincia as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = existeProvincia @nombre, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Provincia(nombre) values (@nombre)
	select @idProvincia = @@IDENTITY
	commit transaction
end
go

create procedure createCentroDeAtencion
@nombre as varchar(30),
@idProvincia as tinyint = null,
@provincia as varchar(30) = null,
@errorMessage as varchar(50) = null out,
@idCentro as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	execute @errorMessage = existeCentroDeAtencion @nombre, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into CentroDeAtencion(nombre, idProvincia) values (@nombre, @idProvincia)
	select @idCentro = @@IDENTITY
	commit transaction
end
go

create procedure createComentario
@contenido as varchar(50),
@errorMessage as varchar(50) = null out,
@idComentario as int = null out
as begin
	execute @errorMessage = validarContenido @contenido;
	execute @errorMessage = existeComentario @contenido, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Comentario(contenido) values (@contenido)
	select @idComentario = @@IDENTITY
	commit transaction
end
go

create procedure createCalificacion
@puntuacion as tinyint,
@idComentario as tinyint = null,
@comentario as varchar(30) = null,
@errorMessage as varchar(50) = null out,
@idCalificacion as int = null out
as begin
	execute @errorMessage = validarPuntuacion @puntuacion;
	execute @errorMessage = validarComentarioOIdComentario @idComentario, @comentario, 
															@errorMessage;
	execute @errorMessage = existeCalificacion @puntuacion, @errorMessage;
	execute @errorMessage = getComentario @idComentario, @comentario, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Calificacion(puntuacion, idComentario) values (@puntuacion, @idComentario)
	select @idCalificacion = @@IDENTITY
	commit transaction
end
go

create procedure createHorario
@tiempo as varchar(20),
@errorMessage as varchar(50) = null out,
@idHorario as int = null out
as begin
	execute @errorMessage = validarTiempo @tiempo;
	execute @errorMessage = existeHorario @tiempo, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Horario(tiempo) values (@tiempo)
	select @idHorario = @@IDENTITY
	commit transaction
end
go

create procedure createDia
@nombre as varchar(10),
@errorMessage as varchar(50) = null out,
@idDia as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = existeDia @nombre, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Dia(nombre) values (@nombre)
	select @idDia = @@IDENTITY
	commit transaction
end
go

create procedure createJornada
@horaInicio as time(0),
@horaFin as time(0),
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as varchar(50) = null out,
@idJornada as int = null out
as begin
	execute @errorMessage = validarHora @horaInicio;
	execute @errorMessage = validarHora @horaFin, @errorMessage;
	execute @errorMessage = validarDiaOIdDia @idDia, @dia, @errorMessage;
	execute @errorMessage = getDia @idDia, @dia, @errorMessage;
	execute @errorMessage = existeJornada @horaInicio, @horaFin, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Jornada(horaInicio, horaFin, idDia) values (@horaInicio, @horaFin, @idDia)
	select @idJornada = @@IDENTITY
	commit transaction
end
go

create procedure createHorarioXJornada
@idHorario as int,
@idJornada as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idHorario;
	execute @errorMessage = validarIntId @idJornada, @errorMessage;
	execute @errorMessage = existeHorarioXJornada @idHorario, @idJornada, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into HorarioXJornada(idHorario, idJornada) values (@idHorario, @idJornada)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createTipoUsuario
@tipo as varchar(30),
@errorMessage as varchar(50) = null out,
@idTipo as int = null out
as begin
	execute @errorMessage = validarTipo @tipo;
	execute @errorMessage = existeTipoUsuario @tipo, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into TipoUsuario(tipo) values (@tipo)
	select @idTipo = @@IDENTITY
	commit transaction
end
go

create procedure createUsuario
@contrasenia as varchar(30),
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null out,
@idUsuario as int = null out
as begin
	execute @errorMessage = validarContrasenia @contrasenia;
	execute @errorMessage = validarTipoOIdTipo @idTipo, @tipo, @errorMessage;
	execute @errorMessage = getTipoUsuario @idTipo out, @tipo, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Usuario(contrasenia, idTipo) values (@contrasenia, @idTipo)
	select @idUsuario = @@IDENTITY
	commit transaction
end
go

create procedure createCliente
@nombre as varchar(30),
@apellido as varchar(30),
@idProvincia as tinyint = null,
@provincia as varchar(20) = null,
@idUsuario as int,
@errorMessage as varchar(50) = null out,
@idCliente as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarApellido @apellido, @errorMessage;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	execute @errorMessage = validarIntId @idUsuario, @errorMessage;
	execute @errorMessage = getUsuario @idUsuario out, @errorMessage;
	execute @errorMessage = existeCliente @nombre, @apellido, @idProvincia, @idUsuario, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Cliente(nombre, apellido, idProvincia, idUsuario) values (@nombre, @apellido, @idProvincia, @idUsuario)
	select @idCliente = @@IDENTITY
	commit transaction
end
go

create procedure createPersonal
@nombre as varchar(30),
@apellido as varchar(30),
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@idHorario as int = null,
@tiempo as varchar(20) = null,
@idUsuario as int,
@errorMessage as varchar(50) = null out,
@idPersonal as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarIntId @idUsuario, @errorMessage;
	execute @errorMessage = validarApellido @apellido, @errorMessage;
	execute @errorMessage = validarCentroOIdCentro @idCentro, @nombreCentro, @errorMessage;
	execute @errorMessage = validarTiempoOIdHorario @idHorario, @tiempo, @errorMessage;
	execute @errorMessage = getCentro @idCentro out, @nombreCentro, @errorMessage;
	execute @errorMessage = getHorario @idHorario out, @tiempo, @errorMessage;
	execute @errorMessage = getUsuario @idUsuario out, @errorMessage;
	execute @errorMessage = existePersonal @nombre, @apellido, @idCentro, @idHorario, @idUsuario, 
											@errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Personal(nombre, apellido, idCentro, idHorario, idUsuario) values 
						(@nombre, @apellido, @idCentro, @idHorario, @idUsuario)
	select @idPersonal = @@IDENTITY
	commit transaction
end
go

create procedure createCalificacionXCliente
@idCalificacion as int,
@idCliente as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCalificacion;
	execute @errorMessage = validarIntId @idCliente, @errorMessage;
	execute @errorMessage = existeCalificacionXCliente @idCalificacion, @idCliente, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into CalificacionXCliente(idCalificacion, idCliente) values (@idCalificacion, @idCliente)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createCalificacionXPersonal
@idCalificacion as int,
@idPersonal as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCalificacion;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeCalificacionXPersonal @idCalificacion, @idPersonal, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into CalificacionXPersonal(idCalificacion, idPersonal) values (@idCalificacion, @idPersonal)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createCategoria
@descripcion as varchar(30),
@errorMessage as varchar(50) = null out,
@idCategoria as int = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	execute @errorMessage = existeCategoria @descripcion, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Categoria(descripcion) values (@descripcion)
	select @idCategoria = @@IDENTITY
	commit transaction
end
go

create procedure createCategoriaXPersonal
@idCategoria as int,
@idPersonal as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCategoria;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeCategoriaXPersonal @idCategoria, @idPersonal, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into CategoriaXPersonal(idCategoria, idPersonal) values (@idCategoria, @idPersonal)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createEstudioXPersonal
@idEstudio as int,
@idPersonal as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idEstudio;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeEstudioXPersonal @idEstudio, @idPersonal, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into EstudioXPersonal(idEstudio, idPersonal) values (@idEstudio, @idPersonal)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createSolicitud
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@errorMessage as varchar(50) = null out,
@idSolicitud as int = null out
as begin
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal;
	execute @errorMessage = validarClienteOIdCliente @idCliente, @nombreCliente, @errorMessage;
	execute @errorMessage = getPersonal @idPersonal, @nombrePersonal, @errorMessage;
	execute @errorMessage = getCliente @idCliente, @nombreCliente, @errorMessage;
	execute @errorMessage = existeSolicitud @idPersonal, @idCliente, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Solicitud(idPersonal, idCliente) values (@idPersonal, @idCliente)
	select @idSolicitud = @@IDENTITY
	commit transaction
end
go

create procedure createContratacion
@monto as money,
@fecha as datetime,
@idSolicitud as int,
@errorMessage as varchar(50) = null out,
@idContratacion as int = null out
as begin
	execute @errorMessage = validarIntId @idSolicitud;
	execute @errorMessage = validarMonto @monto, @errorMessage;
	execute @errorMessage = validarFecha @fecha, @errorMessage;
	execute @errorMessage = getSolicitud @idSolicitud out, @errorMessage;
	execute @errorMessage = existeContratacion @monto, @fecha, @idSolicitud, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Contratacion(monto, fecha, idSolicitud) values (@monto, @fecha, @idSolicitud)
	select @idContratacion = @@IDENTITY
	commit transaction
end
go

create procedure createCategoriaXContratacion
@precio as money,
@idCategoria as smallint,
@idContratacion as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idContratacion;
	execute @errorMessage = validarMonto @precio, @errorMessage;
	execute @errorMessage = validarSmallintId @idCategoria, @errorMessage;
	execute @errorMessage = validarIntId @idContratacion, @errorMessage;
	execute @errorMessage = existeCategoriaXContratacion @idCategoria, @idContratacion, 
														 @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into CategoriaXContratacion(precio, idCategoria, idContratacion) values 
									(@precio, @idCategoria, @idContratacion)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createPuesto
@nombre as varchar(50),
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out,
@idPuesto as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal, @errorMessage;
	execute @errorMessage = getPersonal @idPersonal out, @nombrePersonal, @errorMessage;
	execute @errorMessage = existePuesto @nombre, @errorMessage;
	if @errorMessage is not null begin return; end
	begin transaction 
	insert into Puesto(nombre, idPersonal) values (@nombre, @idPersonal)
	select @idPuesto = @@IDENTITY
	commit transaction
end
go

create procedure createPago
@fecha as datetime,
@monto as money,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out,
@idPago as int = null out
as begin
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal;
	execute @errorMessage = getPersonal @idPersonal out, @nombrePersonal, @errorMessage;
	execute @errorMessage = validarMonto @monto, @errorMessage;
	execute @errorMessage = validarFecha @fecha, @errorMessage;
	if @errorMessage is not null begin return; end
	if exists (select @@ERROR from Pago where fecha = @fecha and monto = @monto and idPersonal = @idPersonal) begin
		set @errorMessage = 'Este pago ya está registrado';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into Pago(fecha, monto, idPersonal) values (@fecha, @monto, @idPersonal)
	select @idPago = @@IDENTITY
	commit transaction
end
go

create procedure createActividad
@descripcion as varchar(10),
@errorMessage as varchar(50) = null out,
@idActividad as tinyint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage is not null begin return; end
	if exists (select @@ERROR from Actividad where descripcion = @descripcion) begin
		set @errorMessage = 'Esta actividad ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into Actividad(descripcion) values (@descripcion)
	select @idActividad = @@IDENTITY
	commit transaction
end
go

create procedure createCorreo
@direccion as varchar(50),
@idUsuario as int = null,
@nombreUsuario as varchar(75) = null,
@errorMessage as varchar(50) = null out,
@idCorreo as int = null out
as begin
	if @direccion is null begin
		set @errorMessage = 'El nombre no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @direccion = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idUsuario is null and @nombreUsuario is null begin
		set @errorMessage = 'Debe ingresar el id del usuario o el nombre';
		raiserror(@errorMessage, 1, 3);
		return;
	end else if @idUsuario is not null and @idUsuario < 0 begin
		set @errorMessage = 'El id del usuario no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreUsuario = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if not exists (select idUsuario = @idUsuario from Usuario  where 
			(@idUsuario is null or Usuario.idUsuario = @idUsuario) and 
			(@nombreUsuario is null or contrasenia = @nombreUsuario)) begin
		set @errorMessage = 'El usuario dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if exists (select @@ERROR from Correo where direccion = @direccion) begin
		set @errorMessage = 'Este correo ya está registrado';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into Correo(direccion, idUsuario) values (@direccion, @idUsuario)
	select @idCorreo = @@IDENTITY
	commit transaction
end
go

create procedure createEnfermedad
@nombre as varchar(30),
@errorMessage as varchar(50) = null out,
@idEnfermedad as smallint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage is not null begin return; end
	if exists (select @@ERROR from Enfermedad where nombre = @nombre) begin
		set @errorMessage = 'Esta enfermedad ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into Enfermedad(nombre) values (@nombre)
	select @idEnfermedad = @@IDENTITY
	commit transaction
end
go

create procedure createTratamiento
@nombre as varchar(30),
@cantidad as smallint,
@idEnfermedad as smallint = null,
@nombreEnfermedad as varchar(30) = null,
@errorMessage as varchar(50) = null out,
@idTratamiento as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage is not null begin return; end
	if @cantidad is null begin
		set @errorMessage = 'La cantidad no puede ser nula';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @cantidad < 0 begin
		set @errorMessage = 'La cantidad no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idEnfermedad is null and @nombreEnfermedad is null begin
		set @errorMessage = 'Debe ingresar el id de la enfermedad o el nombre';
		raiserror(@errorMessage, 1, 3);
		return;
	end else if @idEnfermedad is not null and @idEnfermedad < 0 begin
		set @errorMessage = 'El id de la enfermedad no puede ser negativa';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreEnfermedad = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if not exists (select idEnfermedad = @idEnfermedad from Enfermedad  where 
			(@idEnfermedad is null or idEnfermedad = @idEnfermedad) and 
			(@nombreEnfermedad is null or nombre = @nombreEnfermedad)) begin
		set @errorMessage = 'La enfermedad dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if exists (select @@ERROR from Tratamiento where nombre = @nombre and 
			cantidad = @cantidad and idEnfermedad = @idEnfermedad) begin
		set @errorMessage = 'Este tratamiento ya se encuentra registrado';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into Tratamiento(nombre, cantidad, idEnfermedad) values (@nombre, @cantidad, @idEnfermedad)
	select @idTratamiento = @@IDENTITY
	commit transaction
end
go

create procedure createTratamientoXCliente
@idTratamiento as int,
@idCliente as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idTratamiento;
	execute @errorMessage = validarIntId @idCliente, @errorMessage;
	if @errorMessage is not null begin return; end
	if exists (select @@ERROR from TratamientoXCliente where idTratamiento = @idTratamiento 
			and idCliente = @idCliente) begin
		set @errorMessage = 'Este tratamiento ya se encuentra registrado con este cliente';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into TratamientoXCliente(idTratamiento, idCliente) values 
									(@idTratamiento, @idCliente)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createTipoServicio
@descripcion as varchar(30),
@errorMessage as varchar(50) = null out,
@idTipo as smallint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage is not null begin return; end
	if exists (select @@ERROR from TipoServicio where descripcion = @descripcion) begin
		set @errorMessage = 'Este tipo ya se encuentra registrada';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into TipoServicio(descripcion) values (@descripcion)
	select @idTipo = @@IDENTITY
	commit transaction
end
go

create procedure createServicioXCentro
@idServicio as smallint,
@idCentro as smallint,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarSmallintId @idServicio, @errorMessage;
	if @idCentro is null begin
		set @errorMessage = 'El id del centro no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idCentro < 0 begin
		set @errorMessage = 'El id del centro no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if exists (select @@ERROR from ServicioXCentro where idCentro = @idCentro 
			and idServicio = @idServicio) begin
		set @errorMessage = 'Este servicio ya se encuentra registrado con este centro';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into ServicioXCentro(idServicio, idCentro) values (@idServicio, @idCentro)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createEnfermedadXCliente
@idEnfermedad as smallint,
@idCliente as int,
@errorMessage as varchar(50) = null out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCliente;
	if @errorMessage is not null begin return; end
	if @idEnfermedad is null begin
		set @errorMessage = 'El id del servicio no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idEnfermedad < 0 begin
		set @errorMessage = 'El id del servicio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if exists (select @@ERROR from Enfermedad where idEnfermedad = @idEnfermedad 
			and @idCliente = @idCliente) begin
		set @errorMessage = 'Esta enfermedad ya se encuentra registrado con este cliente';
		raiserror(@errorMessage, 2, 1);
		return;
	end
	begin transaction 
	insert into EnfermedadXCliente(idEnfermedad, idCliente) values (@idEnfermedad, @idCliente)
	select @id = @@IDENTITY
	commit transaction
end
go