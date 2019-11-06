use RedDeCuido

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
go

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
go

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
go

create procedure updateProvincia
@idProvincia as tinyint,
@nombre as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarProvinciaOIdProvincia @idProvincia, @nombre;
	if @errorMessage is not null begin return; end
	update Provincia set nombre = @nombre where idProvincia = @idProvincia
end
go

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
go

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
go

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
go

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
go

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
go

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
go

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
go

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
go

create procedure updateUsuario
@idUsuario as int,
@nombre as varchar(75) = null,
@idTipo as int = null,
@tipo as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idUsuario;
	if @errorMessage is not null begin return; end
	if @nombre = '' begin
		set @errorMessage = 'El nombre no puede estar vacia';
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
	update Usuario set nombre = ISNULL(@nombre, nombre), 
	idTipo = ISNULL(@idTipo, idTipo)
end
go

create procedure updateCliente
@idCliente as int,
@nombre as varchar(75) = null,
@idProvincia as tinyint = null,
@provincia as varchar(20) = null,
@idUsuario as int = null,
@baneado as bit = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idCliente;
	if @provincia is not null or @idProvincia is not null begin
		execute @errorMessage = getProvincia @idProvincia out, @provincia, @errorMessage;
	end
	if @errorMessage is not null begin return; end
	if @idUsuario is not null and @idUsuario < 0 begin
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
	update Cliente set idProvincia = ISNULL(@idProvincia, idProvincia), 
	idUsuario = ISNULL(@idUsuario, idUsuario), baneado = ISNULL(@baneado, baneado)
	where idCliente = @idCliente
end
go

create procedure updatePersonal
@idPersonal as int = null,
@idCentro as smallint = null,
@nombreCentro as varchar(30) = null,
@idHorario as int = null,
@tiempo as varchar(20) = null,
@idUsuario as int = null,
@disponibilidad as bit = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idPersonal;
	if @errorMessage is not null begin return; end
	if @idCentro is not null and @idCentro < 0 begin
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
	update Personal set idCentro = ISNULL(@idCentro, idCentro), 
	idHorario = ISNULL(@idHorario, idHorario), idUsuario = ISNULL(@idUsuario, idUsuario), 
	disponible = ISNULL(@disponibilidad, disponible) where idPersonal = @idPersonal
end
go

create procedure updateCalificacionXCliente
@id as int = null,
@idCalificacion as int = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idCalificacion is not null and @idCalificacion < 0 begin
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
	update CalificacionXCliente set idCalificacion = @idCalificacion, idCliente = @idCalificacion
	where id = @id
end
go

create procedure updateCalificacionXPersonal
@id as int = null,
@idCalificacion as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idCalificacion is not null and @idCalificacion < 0 begin
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
	update CalificacionXPersonal set idCalificacion = @idCalificacion, idPersonal = @idPersonal
	where id = @id
end
go

create procedure updateCategoria
@idCategoria as int = null,
@descripcion as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idCategoria;
	if @errorMessage is not null begin return; end
	if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id de la categoria no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @descripcion = '' begin
		set @errorMessage = 'La descripcion no puede estar vacia';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update Categoria set descripcion = @descripcion where idCategoria = @idCategoria
end
go

create procedure updateCategoriaXPersonal
@id as int = null,
@idCategoria as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update CategoriaXPersonal set idCategoria = @idCategoria, idPersonal = @idPersonal
	where id = @id
end
go

create procedure updateEstudioXPersonal
@id as int,
@idEstudio as int = null,
@idPersonal as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idEstudio is not null and @idEstudio < 0 begin
		set @errorMessage = 'El id de la calificacion no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idPersonal is not null and @idPersonal < 0 begin
		set @errorMessage = 'El id del personal no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update EstudioXPersonal set idEstudio = ISNULL(@idEstudio, idEstudio), 
	idPersonal = ISNULL(@idPersonal, idPersonal) where id = @id
end
go

create procedure updateSolicitud
@idSolicitud as int = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idSolicitud;
	execute @errorMessage = getPersonal @idPersonal, @nombrePersonal, @errorMessage;
	if @errorMessage is not null begin return; end
	if @nombrePersonal = '' begin
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
	end
	if (@idCliente is not null or @nombreCliente is not null) and not exists 
			(select idCliente = @idCliente from Cliente where
			(@idCliente is null or idCliente = @idCliente) and 
			(@nombreCliente is null and nombre = @nombreCliente)) begin
		set @errorMessage = 'El cliente dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Solicitud set idPersonal = ISNULL(@idPersonal, idPersonal), 
	idCliente = ISNULL(@idCliente, idCliente) where idSolicitud = @idSolicitud
end
go

create procedure updateContratacion
@idContratacion as int = null,
@monto as money = null,
@fecha as datetime = null,
@idSolicitud as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idContratacion;
	if @errorMessage is not null begin return; end
	if @monto is not null and @monto < 0 begin
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
	end
	if @idSolicitud is not null and not exists 
		(select idSolicitud = @idSolicitud from Solicitud where idSolicitud = @idSolicitud) begin
		set @errorMessage = 'La solicitud dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Contratacion set monto = ISNULL(@monto, monto), fecha = ISNULL(@fecha, fecha), 
	idSolicitud = ISNULL(@idSolicitud, idSolicitud) where idContratacion = @idContratacion
end
go

create procedure updateCategoriaXContratacion
@id as int = null,
@precio as money = null,
@idCategoria as smallint = null,
@idContratacion as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @precio is not null and @precio < 0 begin
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
	update CategoriaXContratacion set precio = ISNULL(@precio, precio), 
	idCategoria = ISNULL(@idCategoria, idCategoria), 
	idContratacion = ISNULL(@idContratacion, idContratacion) where id = @id
end
go

create procedure updatePuesto
@idPuesto as int = null,
@nombre as varchar(50) = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idPuesto;
	if @errorMessage is not null begin return; end
	if @idPersonal is not null and @idPersonal < 0 begin
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
	end
	if (@idPersonal is not null or @nombrePersonal is not null) and not exists 
			(select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null or nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Puesto set nombre = ISNULL(@nombre, nombre), 
	idPersonal = ISNULL(@idPersonal, idPersonal) where idPuesto = @idPuesto
end
go

create procedure updatePago
@idPago as int = null,
@fecha as datetime = null,
@monto as money = null,
@idPersonal as int = null,
@nombrePersonal as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idPago;
	if @errorMessage is not null begin return; end
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
	end
	if (@idPersonal is not null or @nombrePersonal is not null) and not exists 
			(select idPersonal = @idPersonal from Personal where 
			(@idPersonal is null or idPersonal = @idPersonal) and 
			(@nombrePersonal is null or nombre = @nombrePersonal)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	update Pago set fecha = ISNULL(@fecha, fecha), monto = ISNULL(@monto, monto), 
	idPersonal = ISNULL(@idPersonal, idPersonal) where idPago = @idPago
end
go

create procedure updateActividad
@idActividad as tinyint = null,
@descripcion as varchar(10) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage is not null begin return; end
	if @idActividad is null begin
		set @errorMessage = 'El id del dia no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idActividad < 0 begin
		set @errorMessage = 'El id de la actividad no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update Actividad set descripcion = ISNULL(@descripcion, descripcion) 
	where idActividad = @idActividad
end
go

create procedure updateCorreo
@idCorreo as int = null,
@direccion as varchar(50) = null,
@idUsuario as int = null,
@nombreUsuario as varchar(75) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idCorreo;
	if @errorMessage is not null begin return; end
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
	update Correo set direccion = ISNULL(@direccion, direccion), 
	idUsuario = ISNULL(@idUsuario, idUsuario) where idCorreo = @idCorreo
end
go

create procedure updateEnfermedad
@idEnfermedad as smallint = null,
@nombre as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarNombre @nombre;
	if @errorMessage is not null begin return; end
	if @idEnfermedad is null begin
		set @errorMessage = 'El id de la enfermedad no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idEnfermedad < 0 begin
		set @errorMessage = 'El id de la enfermedad no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update Enfermedad set nombre = @nombre where idEnfermedad = @idEnfermedad
end
go

create procedure updateTratamiento
@idTratamiento as int,
@nombre as varchar(30) = null,
@cantidad as smallint = null,
@idEnfermedad as smallint = null,
@nombreEnfermedad as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @idTratamiento;
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
	update Tratamiento set nombre = ISNULL(@nombre, nombre), 
	cantidad = ISNULL(@cantidad, cantidad), idEnfermedad = ISNULL(@idEnfermedad, idEnfermedad)
	where idTratamiento = @idTratamiento
end
go

create procedure updateTratamientoXCliente
@id as int,
@idTratamiento as int = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id del cliente no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update TratamientoXCliente set idTratamiento = ISNULL(@idTratamiento, idTratamiento),
	idCliente = ISNULL(@idCliente, idCliente) where id = @id
end
go

create procedure updateTipoServicio
@idTipo as smallint = null,
@descripcion as varchar(30) = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarDescripcion @descripcion;
	if @errorMessage is not null begin return; end
	if @idTipo is null begin
		set @errorMessage = 'El id del servicio no puede ser nulo';
		raiserror(@errorMessage, 1, 1);
		return;
	end else if @idTipo is not null and @idTipo < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update TipoServicio set descripcion = @descripcion where idServicio = @idTipo
end
go

create procedure updateServicioXCentro
@id as int,
@idServicio as smallint = null,
@idCentro as smallint = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
	if @errorMessage is not null begin return; end
	if @idServicio is not null and @idServicio < 0 begin
		set @errorMessage = 'El id del servicio no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id del centro no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	update ServicioXCentro set idServicio = ISNULL(@idServicio, idServicio), 
	idCentro = ISNULL(@idCentro, idCentro) where id = @id
end
go

create procedure updateEnfermedadXCliente
@id as int,
@idEnfermedad as smallint = null,
@idCliente as int = null,
@errorMessage as varchar(50) = null out
as begin
	execute @errorMessage = validarIntId @id;
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
	update EnfermedadXCliente set idEnfermedad = ISNULL(@idEnfermedad, idEnfermedad),
	idCliente = ISNULL(@idCliente, idCliente) where id = @id
end
go