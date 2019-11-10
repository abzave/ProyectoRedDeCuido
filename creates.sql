use RedDeCuido

create procedure validarTipo
@tipo as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @tipo is null begin
		set @errorMessage = 1;
		raiserror('El tipo no puede ser nulo', 1, 1);
	end else if @tipo = '' begin
		set @errorMessage = 2;
		raiserror('El tipo no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeGrado
@tipo as varchar(50),
@errorMessage as tinyint = null
as begin
	if exists (select @@ERROR from Grado where tipo = @tipo) begin
		set @errorMessage = 8;
		raiserror('Este tipo ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarDescripcion
@descripcion as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @descripcion is null begin
		set @errorMessage = 1;
		raiserror('La descripción no puede ser nula', 1, 1);
	end else if @descripcion = '' begin
		set @errorMessage = 2;
		raiserror('La descripción no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeEstudio
@descripcion as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Estudio where descripcion = @descripcion) begin
		set @errorMessage = 8;
		raiserror('Esta descripción ya se encuentra registrada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarGradoOIdGrado
@idGrado as tinyint,
@grado as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @idGrado is null and @grado is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del grado o el nombre', 1, 3);
	end else if @idGrado is not null and @idGrado < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @grado = '' begin
		set @errorMessage = 2;
		raiserror('El grado no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure getGrado
@idGrado as tinyint out,
@grado as varchar(50),
@errorMessage as tinyint = 0
as begin
	if not exists (select idGrado from Grado where idGrado = ISNULL(@idGrado, idGrado) and 
			tipo = ISNULL(@grado, tipo)) begin
		set @errorMessage = 9;
		raiserror('El grado dado no existe', 2, 2);
	end
	if @idGrado is null begin
		select @idGrado = idGrado from Grado where tipo = @grado
	end
	return @errorMessage;
end
go

create procedure validarNombre
@nombre as varchar(75),
@errorMessage as tinyint = 0
as begin
	if @nombre is null begin
		set @errorMessage = 1;
		raiserror('El nombre no puede ser nulo', 1, 1);
	end else if @nombre = '' begin
		set @errorMessage = 2;
		raiserror('El nombre no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure validarProvinciaOIdProvincia
@idProvincia as tinyint,
@provincia as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @idProvincia is null and @provincia is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id de la provincia o el nombre', 1, 3);
	end else if @idProvincia < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @provincia = '' begin
		set @errorMessage = 2;
		raiserror('El grado no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeCanton
@nombre as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Canton where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Este nombre ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure getProvincia
@idProvincia as tinyint out,
@provincia as varchar(50),
@errorMessage as tinyint = 0
as begin
	if not exists (select idProvincia from Provincia where 
			(@idProvincia is null or idProvincia = @idProvincia) 
			and (@provincia is null or nombre = @provincia)) begin
		set @errorMessage = 2;
		raiserror('La provincia dado no existe', 2, 2);
	end
	if @idProvincia is null begin
		select @idProvincia = idProvincia from Provincia where nombre = @provincia
	end	
	return @errorMessage;
end
go

create procedure existeProvincia
@nombre as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Provincia where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Este nombre ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCentroDeAtencion
@nombre as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from CentroDeAtencion where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Este nombre ya se encuentra registrado', 2, 1);
		return;
	end
end
go

create procedure validarContenido
@contenido as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @contenido is null begin
		set @errorMessage = 1;
		raiserror('El contenido no puede ser nulo', 1, 1);
	end else if @contenido = '' begin
		set @errorMessage = 2;
		raiserror('El contenido no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeComentario
@contenido as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Comentario where contenido = @contenido) begin
		set @errorMessage = 8;
		raiserror('Este contenido ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarPuntuacion
@puntuacion as varchar(50),
@errorMessage as tinyint = 0
as begin
	if @puntuacion is null begin
		set @errorMessage = 1;
		raiserror('La puntuacion no puede ser nula', 1, 1);
	end else if @puntuacion < 0 begin
		set @errorMessage = 4;
		raiserror('La puntuacion no puede ser negativa', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarComentarioOIdComentario
@idComentario as tinyint,
@comentario as varchar(30),
@errorMessage as tinyint = 0
as begin
	if @idComentario is null and @comentario is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del comentario o el texto', 1, 3);
	end else if @idComentario < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @comentario = '' begin
		set @errorMessage = 2;
		raiserror('El comentario no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeCalificacion
@puntuacion as tinyint,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Calificacion where puntuacion = @puntuacion) begin
		set @errorMessage = 8;
		raiserror('Esta calificacion ya se encuentra registrado', 2, 1);
	end 
	return @errorMessage;
end
go

create procedure getComentario
@idComentario as tinyint out,
@comentario as varchar(30),
@errorMessage as tinyint = 0
as begin
	if not exists (select idComentario from Comentario where 
			(@idComentario is null or idComentario = @idComentario) and 
			(@comentario is null or contenido = @comentario)) begin
		set @errorMessage = 2;
		raiserror('El comentario dado no existe', 2, 2);
	end
	if @idComentario is null begin
		select @idComentario = idComentario from Comentario where contenido = @comentario
	end	
	return @errorMessage;
end
go

create procedure validarTiempo
@tiempo as varchar(20),
@errorMessage as tinyint = 0
as begin
	if @tiempo is null begin
		set @errorMessage = 1;
		raiserror('El tiempo no puede ser nulo', 1, 1);
	end else if @tiempo = '' begin
		set @errorMessage = 2;
		raiserror('El tiempo no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure existeHorario
@tiempo as tinyint,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Horario where tiempo = @tiempo) begin
		set @errorMessage = 8;
		raiserror('Este tiempo ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeDia
@nombre as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Dia where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Este dia ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarHora
@hora as time(0),
@errorMessage as tinyint = 0
as begin
	if @hora is null begin
		set @errorMessage = 1;
		raiserror('La hora no puede ser nula', 1, 1);
	end else if @hora < CONVERT(time, GETDATE()) begin
		set @errorMessage = 7;
		raiserror('La hora no puede mayor al dia actual', 1, 7);
	end
	return @errorMessage;
end
go

create procedure validarDiaOIdDia
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as tinyint = 0
as begin
	if @idDia is null and @dia is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del dia o el nombre', 1, 3);
	end else if @idDia is not null and @idDia < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @dia = '' begin
		set @errorMessage = 2;
		raiserror('El dia no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure getDia
@idDia as tinyint = null,
@dia as varchar(10) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idDia from Dia where (@idDia is null or idDia = @idDia) 
			and (@dia is null or nombre = @dia)) begin
		set @errorMessage = 2;
		raiserror('El dia dado no existe', 2, 2);
	end
	if @idDia is null begin
		select @idDia = idDia from Dia where nombre = @dia
	end	
	return @errorMessage;
end
go

create procedure existeJornada
@horaInicio as time(0),
@horaFin as time(0),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Jornada where horaInicio = @horaInicio and horaFin = @horaFin) begin
		set @errorMessage = 8;
		raiserror('Esta jornada ya se encuentra registrada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarIntId
@id as int = null,
@errorMessage as tinyint = 0
as begin
	if @id is null begin
		set @errorMessage = 1;
		raiserror('El id no puede ser nulo', 1, 1);
	end else if @id < 0 begin
		set @errorMessage = 4;
		raiserror('El id no puede ser negativo', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure existeHorarioXJornada
@idHorario as int,
@idJornada as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from HorarioXJornada where idHorario = @idHorario and idJornada = @idJornada) begin
		set @errorMessage = 8;
		raiserror('Este horario ya se encuentra registrado con esta jornada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeTipoUsuario
@tipo as varchar(30),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from TipoUsuario where tipo = @tipo) begin
		set @errorMessage = 8;
		raiserror('Este tipo ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarTipoOIdTipo
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as tinyint = null
as begin
	if @idTipo is null and @tipo is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del tipo o el nombre', 1, 3);
	end else if @idTipo < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @tipo = '' begin
		set @errorMessage = 2;
		raiserror('El tipo no puede estar vacio', 1, 2);
	end
	return @errorMessage;
end
go

create procedure getTipoUsuario
@idTipo as int = null out,
@tipo as varchar(30) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idTipo from TipoUsuario where 
			(@idTipo is null or idTipo = @idTipo) and (@tipo is null and tipo = @tipo)) begin
		set @errorMessage = 2;
		raiserror('El tipo dado no existe', 2, 2);
	end
	if @idTipo is null begin
		select @idTipo = idTipo from TipoUsuario where tipo = @tipo
	end	
	return @errorMessage;
end
go

create procedure getUsuario
@idUsuario as int out,
@nombre as varchar(75),
@errorMessage as tinyint = 0
as begin
	if not exists (select idUsuario from Usuario
			where idUsuario = ISNULL(@idUsuario, idUsuario) and 
			nombre = ISNULL(@nombre, nombre)) begin
		set @errorMessage = 2;
		raiserror('El usuario dado no existe', 2, 2);
	end 
	if @idUsuario is null begin
		select @idUsuario = idUsuario from Usuario where nombre = @nombre
	end	
	return @errorMessage;
end
go

create procedure existeCliente
@nombre as varchar(75),
@idProvincia as tinyint,
@idUsuario as int,
@errorMessage as tinyint = 0
as begin
	if exists(select @@ERROR from Cliente  inner join Usuario on 
	Usuario.idUsuario = Cliente.idUsuario where Usuario.nombre = @nombre and 
	idProvincia = @idProvincia and Cliente.idUsuario = @idUsuario) begin
		set @errorMessage = 8;
		raiserror('Este cliente ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarCentroOIdCentro
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@errorMessage as tinyint = 0
as begin
	if @idCentro is null and @nombreCentro is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del centro o el nombre', 1, 3);
	end else if @idCentro < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @nombreCentro = '' begin
		set @errorMessage = 4;
		raiserror('El centro no puede estar vacio', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarTiempoOIdHorario
@idHorario as int = null,
@tiempo as varchar(20) = null,
@errorMessage as tinyint = 0
as begin
	if @idHorario is null and @tiempo is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar la id del horario o el tiempo', 1, 3);
	end else if @idHorario < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @tiempo = '' begin
		set @errorMessage = 4;
		raiserror('El tiempo no puede estar vacio', 1, 4);
	end
	return @errorMessage;
end
go

create procedure getCentro
@idCentro as smallint = null out,
@nombreCentro as varchar(30) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idCentro from CentroDeAtencion where 
			(@idCentro is null or idCentro = @idCentro) and 
			(@nombreCentro is null and nombre = @nombreCentro)) begin
		set @errorMessage = 2;
		raiserror('El horario dado no existe', 2, 2);
	end 
	if @idCentro is null begin
		select @idCentro = idCentro from CentroDeAtencion where nombre = @nombreCentro
	end	
	return @errorMessage;
end
go

create procedure getHorario
@idHorario as int = null out,
@tiempo as varchar(20) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idHorario from Horario where 
			(@idHorario is null or idHorario = @idHorario) and 
			(@tiempo is null and tiempo = @tiempo)) begin
		set @errorMessage = 2;
		raiserror('El horario dado no existe', 2, 2);
	end
	if @idHorario is null begin
		select @idHorario = idHorario from Horario where tiempo = @tiempo
	end	
	return @errorMessage;
	end
go

create procedure existePersonal
@nombre as varchar(75),
@idCentro as smallint = null,
@idHorario as int = null,
@idUsuario as int,
@errorMessage as tinyint = 0
as begin
	if exists(select @@ERROR from Personal inner join Usuario on 
			Usuario.idUsuario = Personal.idUsuario where Usuario.nombre = @nombre and 
			idCentro = @idCentro and idHorario = @idHorario and Personal.idUsuario = @idUsuario) 
			begin
		set @errorMessage = 8;
		raiserror('Este empleado ya se encuentra registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCalificacionXCliente
@idCalificacion as int,
@idCliente as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from CalificacionXCliente where idCalificacion = @idCalificacion 
			and idCliente = @idCliente) begin
		set @errorMessage = 8;
		raiserror('Esta calificacion ya se encuentra registrado con este cliente', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCalificacionXPersonal
@idCalificacion as int,
@idPersonal as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from CalificacionXPersonal where idCalificacion = @idCalificacion 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 8;
		raiserror('Esta calificacion ya se encuentra registrado con este empleado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCategoria
@descripcion as varchar(30),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Categoria where descripcion = @descripcion) begin
		set @errorMessage = 8;
		raiserror('Esta categoria ya se encuentra registrada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeCategoriaXPersonal
@idCategoria as int,
@idPersonal as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from CategoriaXPersonal where idCategoria = @idCategoria 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 8;
		raiserror('Esta categoria ya se encuentra registrado con este empleado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existeEstudioXPersonal
@idEstudio as int,
@idPersonal as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from EstudioXPersonal where idEstudio = @idEstudio 
			and idPersonal = @idPersonal) begin
		set @errorMessage = 8;
		raiserror('Este estudio ya se encuentra registrado con este empleado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarPersonalOIdPersonal
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as tinyint = 0
as begin
	if @idPersonal is null and @nombrePersonal is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar el id del empleado o el nombre', 1, 3);
	end else if @nombrePersonal = '' begin
		set @errorMessage = 4;
		raiserror('El nombre no puede estar vacio', 1, 4);
	end if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarClienteOIdCliente
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@errorMessage as tinyint = 0
as begin
	if @idCliente is null and @nombreCliente is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar el id del cliente o el nombre', 1, 3);
	end else if @idCliente is null and @idCliente < 0 begin
		set @errorMessage = 4;
		raiserror('El id debe ser positivo', 1, 4);
	end else if @nombreCliente = '' begin
		set @errorMessage = 4;
		raiserror('El nombre no puede estar vacio', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure getPersonal
@idPersonal as int = null out,
@nombrePersonal as varchar(75) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idPersonal from Personal inner join Usuario on 
			Usuario.idUsuario = Personal.idUsuario where (@idPersonal is null or 
			idPersonal = @idPersonal) and (@nombrePersonal is null and 
			Usuario.nombre = @nombrePersonal)) begin
		set @errorMessage = 2;
		raiserror('El empleado dado no existe', 2, 2);
	end 
	if @idPersonal is null begin
		select @idPersonal = idPersonal from Personal inner join Usuario on
		Usuario.idUsuario = Personal.idUsuario where Usuario.nombre = @nombrePersonal
	end	return @errorMessage;
end
go

create procedure getCliente
@idCliente as int = null out,
@nombreCliente as varchar(75) = null,
@errorMessage as tinyint = 0
as begin
	if not exists (select idCliente from Cliente inner join Usuario on 
			Usuario.idUsuario = Cliente.idUsuario where (@idCliente is null or 
			idCliente = @idCliente) and (@nombreCliente is null and nombre = @nombreCliente)) begin
		set @errorMessage = 2;
		raiserror('El cliente dado no existe', 2, 2);
	end 
	if @idCliente is null begin
		select @idCliente = idCliente from Cliente inner join Usuario on 
		Usuario.idUsuario = Cliente.idUsuario where Usuario.nombre = @nombreCliente
	end	return @errorMessage;
end
go

create procedure existeSolicitud
@idPersonal as int = null,
@idCliente as int = null,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Solicitud where idPersonal = @idPersonal 
			and idCliente = @idCliente) begin
		set @errorMessage = 8;
		raiserror('Esta solicitud ya se encuentra registrada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarMonto
@monto as money,
@errorMessage as tinyint = 0
as begin
	if @monto is null begin
		set @errorMessage = 1;
		raiserror('El monto no puede ser nulo', 1, 1);
	end else if @monto < 0 begin
		set @errorMessage = 4;
		raiserror('El monto debe ser positivo', 1, 4);
	end 
	return @errorMessage;
end
go

create procedure validarFecha
@fecha as datetime,
@errorMessage as tinyint = 0
as begin
	if @fecha is null begin
		set @errorMessage = 1;
		raiserror('La fecha no puede ser nula', 1, 1);
	end else if @fecha = '' begin
		set @errorMessage = 4;
		raiserror('La fecha no puede estar vacia', 1, 4);
	end else if @fecha > GETDATE() begin
		set @errorMessage = 7;
		raiserror('La fecha no puede mayor a la actual', 1, 7);
	end
	return @errorMessage;
end
go

create procedure getSolicitud
@idSolicitud as int = null out,
@errorMessage as tinyint = 0
as begin
	if not exists (select idSolicitud from Solicitud where idSolicitud = @idSolicitud)
			begin
		set @errorMessage = 2;
		raiserror('La solicitud dada no existe', 2, 2);
	end
end
go

create procedure existeContratacion
@monto as money,
@fecha as datetime,
@idSolicitud as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Contratacion where monto = @monto and fecha = @fecha 
				and idSolicitud = @idSolicitud) begin
		set @errorMessage = 8;
		raiserror('Esta solicitud ya se encuentra registrada', 2, 1);
	end
	return @errorMessage;
end
go

create procedure validarSmallintId
@id as smallint,
@errorMessage as tinyint = 0
as begin
	if @id is null begin
		set @errorMessage = 1;
		raiserror('El id no puede ser nulo', 1, 1);
	end else if @id < 0 begin
		set @errorMessage = 4;
		raiserror('El id no puede ser negativo', 1, 4);
	end
	return @errorMessage;
end
go

create procedure existeCategoriaXContratacion
@idCategoria as smallint,
@idContratacion as int,
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from CategoriaXContratacion where idCategoria = @idCategoria 
			and idContratacion = @idCategoria) begin
		set @errorMessage = 8;
		raiserror('Esta categoria ya se encuentra registrado con esta contratacion', 2, 1);
	end
	return @errorMessage;
end
go

create procedure existePuesto
@nombre as varchar(50),
@errorMessage as tinyint = 0
as begin
	if exists (select @@ERROR from Puesto where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Este puesto ya está registrado', 2, 1);
	end
	return @errorMessage;
end
go

create procedure createGrado
@tipo as varchar(50),
@errorMessage as tinyint = 0 out,
@idGrado as tinyint = null out
as begin
	execute @errorMessage = validarTipo @tipo;
	execute @errorMessage = existeGrado @tipo, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idEstudio as smallint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	execute @errorMessage = validarGradoOIdGrado @idGrado, @grado, @errorMessage;
	execute @errorMessage = existeEstudio @descripcion, @errorMessage;
	execute @errorMessage = getGrado @idGrado out, @grado, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idCanton as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = existeCanton @nombre, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Canton(nombre, idProvincia) values (@nombre, @idProvincia)
	select @idCanton = @@IDENTITY
	commit transaction
end
go

create procedure createProvincia
@nombre as varchar(50),
@errorMessage as tinyint = 0 out,
@idProvincia as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = existeProvincia @nombre, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idCentro as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	execute @errorMessage = existeCentroDeAtencion @nombre, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into CentroDeAtencion(nombre, idProvincia) values (@nombre, @idProvincia)
	select @idCentro = @@IDENTITY
	commit transaction
end
go

create procedure createComentario
@contenido as varchar(50),
@errorMessage as tinyint = 0 out,
@idComentario as int = null out
as begin
	execute @errorMessage = validarContenido @contenido;
	execute @errorMessage = existeComentario @contenido, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idCalificacion as int = null out
as begin
	execute @errorMessage = validarPuntuacion @puntuacion;
	execute @errorMessage = validarComentarioOIdComentario @idComentario, @comentario, 
															@errorMessage;
	execute @errorMessage = existeCalificacion @puntuacion, @errorMessage;
	execute @errorMessage = getComentario @idComentario, @comentario, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Calificacion(puntuacion, idComentario) values (@puntuacion, @idComentario)
	select @idCalificacion = @@IDENTITY
	commit transaction
end
go

create procedure createHorario
@tiempo as varchar(20),
@errorMessage as tinyint = 0 out,
@idHorario as int = null out
as begin
	execute @errorMessage = validarTiempo @tiempo;
	execute @errorMessage = existeHorario @tiempo, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Horario(tiempo) values (@tiempo)
	select @idHorario = @@IDENTITY
	commit transaction
end
go

create procedure createDia
@nombre as varchar(10),
@errorMessage as tinyint = 0 out,
@idDia as tinyint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = existeDia @nombre, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idJornada as int = null out
as begin
	execute @errorMessage = validarHora @horaInicio;
	execute @errorMessage = validarHora @horaFin, @errorMessage;
	execute @errorMessage = validarDiaOIdDia @idDia, @dia, @errorMessage;
	execute @errorMessage = getDia @idDia, @dia, @errorMessage;
	execute @errorMessage = existeJornada @horaInicio, @horaFin, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Jornada(horaInicio, horaFin, idDia) values (@horaInicio, @horaFin, @idDia)
	select @idJornada = @@IDENTITY
	commit transaction
end
go

create procedure createHorarioXJornada
@idHorario as int,
@idJornada as int,
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idHorario;
	execute @errorMessage = validarIntId @idJornada, @errorMessage;
	execute @errorMessage = existeHorarioXJornada @idHorario, @idJornada, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into HorarioXJornada(idHorario, idJornada) values (@idHorario, @idJornada)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createTipoUsuario
@tipo as varchar(30),
@errorMessage as tinyint = 0 out,
@idTipo as int = null out
as begin
	execute @errorMessage = validarTipo @tipo;
	execute @errorMessage = existeTipoUsuario @tipo, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into TipoUsuario(tipo) values (@tipo)
	select @idTipo = @@IDENTITY
	commit transaction
end
go

create procedure createUsuario
@nombre as varchar(75),
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as tinyint = 0 out,
@idUsuario as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarTipoOIdTipo @idTipo, @tipo, @errorMessage;
	execute @errorMessage = getTipoUsuario @idTipo out, @tipo, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Usuario(nombre, idTipo) values (@nombre, @idTipo)
	select @idUsuario = @@IDENTITY
	commit transaction
end
go

create procedure createCliente
@nombre as varchar(75),
@idProvincia as tinyint = null,
@provincia as varchar(20) = null,
@idUsuario as int,
@errorMessage as tinyint = 0 out,
@idCliente as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @provincia, @errorMessage;
	execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	execute @errorMessage = validarIntId @idUsuario, @errorMessage;
	execute @errorMessage = getUsuario @idUsuario out, @errorMessage;
	execute @errorMessage = existeCliente @nombre, @idProvincia, @idUsuario, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Cliente(baneado, idProvincia, idUsuario) values (0, @idProvincia, @idUsuario)
	select @idCliente = @@IDENTITY
	commit transaction
end
go

create procedure createPersonal
@nombre as varchar(75),
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@idHorario as int = null,
@tiempo as varchar(20) = null,
@idUsuario as int,
@errorMessage as tinyint = 0 out,
@idPersonal as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarIntId @idUsuario, @errorMessage;
	execute @errorMessage = validarCentroOIdCentro @idCentro, @nombreCentro, @errorMessage;
	execute @errorMessage = validarTiempoOIdHorario @idHorario, @tiempo, @errorMessage;
	execute @errorMessage = getCentro @idCentro out, @nombreCentro, @errorMessage;
	execute @errorMessage = getHorario @idHorario out, @tiempo, @errorMessage;
	execute @errorMessage = getUsuario @idUsuario out, @errorMessage;
	execute @errorMessage = existePersonal @nombre, @idCentro, @idHorario, @idUsuario, 
											@errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Personal(disponible, idCentro, idHorario, idUsuario) values 
						(1, @idCentro, @idHorario, @idUsuario)
	select @idPersonal = @@IDENTITY
	commit transaction
end
go

create procedure createCalificacionXCliente
@idCalificacion as int,
@idCliente as int,
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCalificacion;
	execute @errorMessage = validarIntId @idCliente, @errorMessage;
	execute @errorMessage = existeCalificacionXCliente @idCalificacion, @idCliente, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into CalificacionXCliente(idCalificacion, idCliente) values (@idCalificacion, @idCliente)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createCalificacionXPersonal
@idCalificacion as int,
@idPersonal as int,
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCalificacion;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeCalificacionXPersonal @idCalificacion, @idPersonal, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into CalificacionXPersonal(idCalificacion, idPersonal) values (@idCalificacion, @idPersonal)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createCategoria
@descripcion as varchar(30),
@errorMessage as tinyint = 0 out,
@idCategoria as int = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	execute @errorMessage = existeCategoria @descripcion, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into Categoria(descripcion) values (@descripcion)
	select @idCategoria = @@IDENTITY
	commit transaction
end
go

create procedure createCategoriaXPersonal
@idCategoria as int,
@idPersonal as int,
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCategoria;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeCategoriaXPersonal @idCategoria, @idPersonal, @errorMessage;
	if @errorMessage != 0 begin return; end
	begin transaction 
	insert into CategoriaXPersonal(idCategoria, idPersonal) values (@idCategoria, @idPersonal)
	select @id = @@IDENTITY
	commit transaction
end
go

create procedure createEstudioXPersonal
@idEstudio as int,
@idPersonal as int,
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idEstudio;
	execute @errorMessage = validarIntId @idPersonal, @errorMessage;
	execute @errorMessage = existeEstudioXPersonal @idEstudio, @idPersonal, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idSolicitud as int = null out
as begin
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal;
	execute @errorMessage = validarClienteOIdCliente @idCliente, @nombreCliente, @errorMessage;
	execute @errorMessage = getPersonal @idPersonal, @nombrePersonal, @errorMessage;
	execute @errorMessage = getCliente @idCliente, @nombreCliente, @errorMessage;
	execute @errorMessage = existeSolicitud @idPersonal, @idCliente, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idContratacion as int = null out
as begin
	execute @errorMessage = validarIntId @idSolicitud;
	execute @errorMessage = validarMonto @monto, @errorMessage;
	execute @errorMessage = validarFecha @fecha, @errorMessage;
	execute @errorMessage = getSolicitud @idSolicitud out, @errorMessage;
	execute @errorMessage = existeContratacion @monto, @fecha, @idSolicitud, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idContratacion;
	execute @errorMessage = validarMonto @precio, @errorMessage;
	execute @errorMessage = validarSmallintId @idCategoria, @errorMessage;
	execute @errorMessage = validarIntId @idContratacion, @errorMessage;
	execute @errorMessage = existeCategoriaXContratacion @idCategoria, @idContratacion, 
														 @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idPuesto as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal, @errorMessage;
	execute @errorMessage = getPersonal @idPersonal out, @nombrePersonal, @errorMessage;
	execute @errorMessage = existePuesto @nombre, @errorMessage;
	if @errorMessage != 0 begin return; end
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
@errorMessage as tinyint = 0 out,
@idPago as int = null out
as begin
	execute @errorMessage = validarPersonalOIdPersonal @idPersonal, @nombrePersonal;
	execute @errorMessage = getPersonal @idPersonal out, @nombrePersonal, @errorMessage;
	execute @errorMessage = validarMonto @monto, @errorMessage;
	execute @errorMessage = validarFecha @fecha, @errorMessage;
	if @errorMessage != 0 begin return; end
	if exists (select @@ERROR from Pago where fecha = @fecha and monto = @monto and idPersonal = @idPersonal) begin
		set @errorMessage = 8;
		raiserror('Este pago ya está registrado', 2, 1);
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
@errorMessage as tinyint = 0 out,
@idActividad as tinyint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage != 0 begin return; end
	if exists (select @@ERROR from Actividad where descripcion = @descripcion) begin
		set @errorMessage = 8;
		raiserror('Esta actividad ya se encuentra registrada', 2, 1);
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
@errorMessage as tinyint = 0 out,
@idCorreo as int = null out
as begin
	if @direccion is null begin
		set @errorMessage = 1;
		raiserror('El nombre no puede ser nulo', 1, 1);
		return;
	end else if @direccion = '' begin
		set @errorMessage = 4;
		raiserror('El nombre no puede estar vacio', 1, 4);
		return;
	end else if @idUsuario is null and @nombreUsuario is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar el id del usuario o el nombre', 1, 3);
		return;
	end else if @idUsuario is not null and @idUsuario < 0 begin
		set @errorMessage = 4;
		raiserror('El id del usuario no puede ser negativo', 1, 4);
		return;
	end else if @nombreUsuario = '' begin
		set @errorMessage = 4;
		raiserror('El nombre no puede estar vacio', 1, 4);
		return;
	end
	if not exists (select idUsuario from Usuario  where 
			(@idUsuario is null or Usuario.idUsuario = @idUsuario) and 
			(@nombreUsuario is null or nombre = @nombreUsuario)) begin
		set @errorMessage = 2;
		raiserror('El usuario dado no existe', 2, 2);
		return;
	end else if exists (select @@ERROR from Correo where direccion = @direccion) begin
		set @errorMessage = 8;
		raiserror('Este correo ya está registrado', 2, 1);
		return;
	end
	if @idUsuario is null begin
		select @idUsuario = idUsuario from Usuario where nombre = @nombreUsuario
	end	
	begin transaction 
	insert into Correo(direccion, idUsuario) values (@direccion, @idUsuario)
	select @idCorreo = @@IDENTITY
	commit transaction
end
go

create procedure createEnfermedad
@nombre as varchar(30),
@errorMessage as tinyint = 0 out,
@idEnfermedad as smallint = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage != 0 begin return; end
	if exists (select @@ERROR from Enfermedad where nombre = @nombre) begin
		set @errorMessage = 8;
		raiserror('Esta enfermedad ya se encuentra registrada', 2, 1);
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
@errorMessage as tinyint = 0 out,
@idTratamiento as int = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage != 0 begin return; end
	if @cantidad is null begin
		set @errorMessage = 1;
		raiserror('La cantidad no puede ser nula', 1, 1);
		return;
	end else if @cantidad < 0 begin
		set @errorMessage = 4;
		raiserror('La cantidad no puede ser negativa', 1, 4);
		return;
	end else if @idEnfermedad is null and @nombreEnfermedad is null begin
		set @errorMessage = 3;
		raiserror('Debe ingresar el id de la enfermedad o el nombre', 1, 3);
		return;
	end else if @idEnfermedad is not null and @idEnfermedad < 0 begin
		set @errorMessage = 4;
		raiserror('El id de la enfermedad no puede ser negativa', 1, 4);
		return;
	end else if @nombreEnfermedad = '' begin
		set @errorMessage = 4;
		raiserror('El nombre no puede estar vacio', 1, 4);
		return;
	end
	if not exists (select idEnfermedad from Enfermedad  where 
			(@idEnfermedad is null or idEnfermedad = @idEnfermedad) and 
			(@nombreEnfermedad is null or nombre = @nombreEnfermedad)) begin
		set @errorMessage = 2;
		raiserror('La enfermedad dada no existe', 2, 2);
		return;
	end else if exists (select @@ERROR from Tratamiento where nombre = @nombre and 
			cantidad = @cantidad and idEnfermedad = @idEnfermedad) begin
		set @errorMessage = 8;
		raiserror('Este tratamiento ya se encuentra registrado', 2, 1);
		return;
	end
	if @idEnfermedad is null begin
		select @idEnfermedad = idEnfermedad from Enfermedad where nombre = @nombreEnfermedad
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
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idTratamiento;
	execute @errorMessage = validarIntId @idCliente, @errorMessage;
	if @errorMessage != 0 begin return; end
	if exists (select @@ERROR from TratamientoXCliente where idTratamiento = @idTratamiento 
			and idCliente = @idCliente) begin
		set @errorMessage = 8;
		raiserror('Este tratamiento ya se encuentra registrado con este cliente', 2, 1);
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
@errorMessage as tinyint = 0 out,
@idTipo as smallint = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage != 0 begin return; end
	if exists (select @@ERROR from TipoServicio where descripcion = @descripcion) begin
		set @errorMessage = 8;
		raiserror('Este tipo ya se encuentra registrada', 2, 1);
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
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarSmallintId @idServicio, @errorMessage;
	if @idCentro is null begin
		set @errorMessage = 1;
		raiserror('El id del centro no puede ser nulo', 1, 1);
		return;
	end else if @idCentro < 0 begin
		set @errorMessage = 4;
		raiserror('El id del centro no puede ser negativo', 1, 4);
		return;
	end
	if exists (select @@ERROR from ServicioXCentro where idCentro = @idCentro 
			and idServicio = @idServicio) begin
		set @errorMessage = 8;
		raiserror('Este servicio ya se encuentra registrado con este centro', 2, 1);
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
@errorMessage as tinyint = 0 out,
@id as int = null out
as begin
	execute @errorMessage = validarIntId @idCliente;
	if @errorMessage != 0 begin return; end
	if @idEnfermedad is null begin
		set @errorMessage = 1;
		raiserror('El id del servicio no puede ser nulo', 1, 1);
		return;
	end else if @idEnfermedad < 0 begin
		set @errorMessage = 4;
		raiserror('El id del servicio no puede ser negativo', 1, 4);
		return;
	end
	if exists (select @@ERROR from Enfermedad where idEnfermedad = @idEnfermedad 
			and @idCliente = @idCliente) begin
		set @errorMessage = 8;
		raiserror('Esta enfermedad ya se encuentra registrado con este cliente', 2, 1);
		return;
	end
	begin transaction 
	insert into EnfermedadXCliente(idEnfermedad, idCliente) values (@idEnfermedad, @idCliente)
	select @id = @@IDENTITY
	commit transaction
end
go