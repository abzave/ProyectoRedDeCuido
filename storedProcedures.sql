use RedDeCuido

create function facturar
(@monto as money,
@idSolicitud as int)
returns int
as begin
	declare @currentDate as datetime = GETDATE();
	declare @errorMessage as varchar(50) = null;
	declare @idContratacion as int = null;
	execute createContratacion @monto, @currentDate, @idSolicitud, @errorMessage out, 
								@idContratacion out;
	if @errorMessage is not null begin return -1; end
	return @idContratacion;
end

create procedure evaluarCliente
@puntuacion as tinyint,
@comentario as varchar(50),
@idCliente as int
as begin
	declare @idComentario as int = null;
	declare @idCalificacion as int = null;
	declare @promedio as tinyint = null;
	declare @errorMessage as varchar(50) = null;
	execute createComentario @comentario, @errorMessage out, @idComentario out;
	if @errorMessage is  not null begin return; end
	execute createCalificacion @puntuacion, @idComentario, null, @errorMessage out, 
								@idCalificacion out;
	if @errorMessage is not null begin return; end
	execute createCalificacionXCliente @idCliente, @idCalificacion, @errorMessage;
	if @errorMessage is not null begin return; end
	select @promedio = AVG(puntuacion) from Calificacion 
	inner join ClienteXCalificacion	on 
	ClienteXCalificacion.idCalificacion = Calificacion.idCalificacion 
	having ClienteXCalificacion.idCliente = @idCliente
	if @promedio < 7 begin
		print('No puede solicitar servicio')
	end
end

create procedure reporteServicios
@idTipo as smallint = null,
@tipoServicio as varchar(50) = null,
@idCliente as int = null,
@nombreCliente as varchar(75) = null,
@idEmpleado as int = null,
@nombreEmpleado as varchar(75) = null,
@fechaInicio as datetime = null,
@fechaFin as datetime = null,
@idCentro as smallint = null,
@nombreCentro as varchar(50) = null,
@errorMessage as varchar(50) = null out
as begin
	if @idTipo is null and @tipoServicio is null and @idCliente is null and 
			@nombreCliente is null and @idEmpleado is null and @nombreEmpleado is null and
			@fechaInicio is null and @fechaFin is null and @idCentro is null and 
			@nombreCentro is null begin
		set @errorMessage = 'Debe ingresar al menos un parametro';
		raiserror(@errorMessage, 1, 6);
		return;
	end else if @idTipo is not null and @idTipo < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @tipoServicio = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCliente is not null and @idCliente < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreCliente = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idEmpleado is not null and @idEmpleado < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreEmpleado = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @fechaInicio is null and @fechaFin is not null or 
		@fechaInicio is not null and @fechaFin is null begin
		set @errorMessage = 'Debe ingresar ambas fechas';
		raiserror(@errorMessage, 1, 5);
		return;
	end else if @fechaInicio > @fechaFin begin
		set @errorMessage = 'La fecha inicial no puede ser mayor a la final';
		raiserror(@errorMessage, 1, 8);
		return;
	end else if @fechaInicio > GETDATE() or @fechaFin > GETDATE() begin
		set @errorMessage = 'La fecha no puede mayor a la actual';
		raiserror(@errorMessage, 1, 7);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id no puede ser negativo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @nombreCentro = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end
	if (@idTipo is not null or @tipoServicio is not null) and not exists 
			(select idTipo = @idTipo from TipoServicio where idServicio = ISNULL(@idTipo, idServicio) and 
			descripcion = ISNULL(@tipoServicio, descripcion)) begin
		set @errorMessage = 'El servicio dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idCliente is not null or @nombreCliente is not null) and not exists 
			(select idCliente = @idCliente from Cliente where 
			idCliente = ISNULL(@idCliente, idCliente) and 
			nombre = ISNULL(@nombreCliente, nombre)) begin
		set @errorMessage = 'El cliente dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idEmpleado is not null or @nombreEmpleado is not null) and not exists 
			(select idPersonal = @idEmpleado from Personal where 
			idPersonal = ISNULL(@idEmpleado, idPersonal) and 
			nombre = ISNULL(@nombreEmpleado, nombre)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idCentro is not null or @nombreCentro is not null) and not exists 
			(select idCentro = @idCentro from CentroDeAtencion where 
			idCentro = ISNULL(@idCentro, idCentro) and 
			nombre = ISNULL(@nombreCentro, nombre)) begin
		set @errorMessage = 'El empleado dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	select count(Contratacion.idContratacion), SUM(Contratacion.monto), Contratacion.monto
	from Contratacion inner join Solicitud on Solicitud.idSolicitud = Contratacion.idSolicitud
	inner join Personal on Personal.idPersonal = Solicitud.idPersonal
	inner join Cliente on Cliente.idCliente = Solicitud.idCliente
	inner join CentroDeAtencion on CentroDeAtencion.idCentro = Personal.idCentro
	where Solicitud.idCliente = ISNULL(@idCliente, Solicitud.idCliente) and 
	Solicitud.idPersonal = ISNULL(@idEmpleado, Solicitud.idPersonal) and
	CentroDeAtencion.idCentro = ISNULL(@idCentro, CentroDeAtencion.idCentro) and
	Contratacion.fecha between @fechaInicio and @fechaFin group by monto
end

create procedure mejoresCuidadores
@idCategoria as smallint = null,
@categoria as varchar(50) = null,
@idCentro as smallint = null,
@centro as varchar(50) = null,
@errorMessage as varchar(50) out
as begin
	if @idCategoria is null and @categoria is null begin
		set @errorMessage = 'Debe ingresar el id del empleado o el nombre';
		raiserror(@errorMessage, 1, 3);
		return;
	end else if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @categoria = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @centro = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end 
	if (@idCategoria is not null or @categoria is not null) and not exists (
			select idCategoria = @idCategoria from Categoria where 
			idCategoria = ISNULL(@idCategoria, idCategoria) and 
			descripcion = ISNULL(@categoria, descripcion))begin
		set @errorMessage = 'La categoria dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idCentro is not null or @centro is not null) and not exists (
			select idCentro = @idCentro from CentroDeAtencion where 
			idCentro = ISNULL(@idCentro, idCentro) and nombre = ISNULL(@centro, nombre)) begin
		set @errorMessage = 'El centro dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	select Calificacion.puntuacion, Personal.nombre, Categoria.descripcion, 
	CentroDeAtencion.nombre, Pago.monto, SUM(Pago.monto), Contratacion.monto, 
	SUM(Contratacion.monto)
	from Calificacion inner join CalificacionXPersonal on 
	CalificacionXPersonal.idCalificacion = Calificacion.idCalificacion
	inner join Personal on Personal.idPersonal = CalificacionXPersonal.idPersonal
	inner join CategoriaXPersonal on CategoriaXPersonal.idPersonal = Personal.idPersonal
	inner join Categoria on Categoria.idCategoria = CategoriaXPersonal.idCategoria
	inner join CentroDeAtencion on CentroDeAtencion.idCentro = Personal.idCentro
	inner join Pago on Pago.idPersonal = Personal.idPersonal
	inner join Solicitud on Solicitud.idPersonal = Personal.idPersonal
	inner join Contratacion on Contratacion.idSolicitud = Solicitud.idSolicitud
	where Categoria.idCategoria = ISNULL(@idCategoria, Categoria.idCategoria) and
	CentroDeAtencion.idCentro = ISNULL(@idCentro, CentroDeAtencion.idCentro)
	group by Calificacion.puntuacion, Personal.nombre, Categoria.descripcion, 
	CentroDeAtencion.nombre, Contratacion.monto, Pago.monto order by puntuacion desc
end

create procedure peoresCuidadores
@idCategoria as smallint = null,
@categoria as varchar(50) = null,
@idCentro as smallint = null,
@centro as varchar(50) = null,
@errorMessage as varchar(50) out
as begin
	if @idCategoria is null and @categoria is null begin
		set @errorMessage = 'Debe ingresar el id del empleado o el nombre';
		raiserror(@errorMessage, 1, 3);
		return;
	end else if @idCategoria is not null and @idCategoria < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @categoria = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @idCentro is not null and @idCentro < 0 begin
		set @errorMessage = 'El id debe ser positivo';
		raiserror(@errorMessage, 1, 4);
		return;
	end else if @centro = '' begin
		set @errorMessage = 'El nombre no puede estar vacio';
		raiserror(@errorMessage, 1, 4);
		return;
	end 
	if (@idCategoria is not null or @categoria is not null) and not exists (
			select idCategoria = @idCategoria from Categoria where 
			idCategoria = ISNULL(@idCategoria, idCategoria) and 
			descripcion = ISNULL(@categoria, descripcion))begin
		set @errorMessage = 'La categoria dada no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end else if (@idCentro is not null or @centro is not null) and not exists (
			select idCentro = @idCentro from CentroDeAtencion where 
			idCentro = ISNULL(@idCentro, idCentro) and nombre = ISNULL(@centro, nombre)) begin
		set @errorMessage = 'El centro dado no existe';
		raiserror(@errorMessage, 2, 2);
		return;
	end
	select Calificacion.puntuacion, Personal.nombre, Categoria.descripcion, 
	CentroDeAtencion.nombre, Pago.monto, SUM(Pago.monto), Contratacion.monto, 
	SUM(Contratacion.monto)
	from Calificacion inner join CalificacionXPersonal on 
	CalificacionXPersonal.idCalificacion = Calificacion.idCalificacion
	inner join Personal on Personal.idPersonal = CalificacionXPersonal.idPersonal
	inner join CategoriaXPersonal on CategoriaXPersonal.idPersonal = Personal.idPersonal
	inner join Categoria on Categoria.idCategoria = CategoriaXPersonal.idCategoria
	inner join CentroDeAtencion on CentroDeAtencion.idCentro = Personal.idCentro
	inner join Pago on Pago.idPersonal = Personal.idPersonal
	inner join Solicitud on Solicitud.idPersonal = Personal.idPersonal
	inner join Contratacion on Contratacion.idSolicitud = Solicitud.idSolicitud
	where Categoria.idCategoria = ISNULL(@idCategoria, Categoria.idCategoria) and
	CentroDeAtencion.idCentro = ISNULL(@idCentro, CentroDeAtencion.idCentro)
	group by Calificacion.puntuacion, Personal.nombre, Categoria.descripcion, 
	CentroDeAtencion.nombre, Contratacion.monto, Pago.monto order by puntuacion asc
end