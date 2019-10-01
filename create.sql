create database RedDeCuido;

create table Grado(
	idGrado tinyint primary key not null,
	tipo varchar(50) not null default ''
);

create table Estudio(
	idEstudio smallint primary key not null,
	descripcion varchar(50) not null,
	idGrado tinyint foreign key references Grado not null,
	check (descripcion != '')
);

create table Canton(
	idCanton tinyint primary key not null,
	nombre varchar(30) not null,
	check (nombre != '')
);

create table Provincia(
	idProvincia tinyint primary key not null,
	nombre varchar(30) not null unique,
	idCanton tinyint foreign key references Canton not null,
	check (nombre != '')
);

create table CentroDeAtencion(
	idCentro smallint primary key not null,
	nombre varchar(30) not null,
	idProvincia tinyint foreign key references Provincia not null,
	check (nombre != '')
);

create table Comentario(
	idComentario int primary key not null,
	contenido varchar(50) not null default 'El usuario no ha dejado comentario'
);

create table Calificacion(
	idCalificacion int primary key not null,
	puntuacion tinyint not null default 0,
	idComentario int foreign key references Comentario not null,
	check (puntuacion >= 0)
);

create table Horario(
	idHorario int primary key not null,
	tiempo varchar(20) not null,
	check (tiempo != '')
);

create table Dia(
	idDia tinyint primary key not null,
	nombre varchar(10) not null,
	check (nombre != '')
);

create Table Jornada(
	idJornada int primary key not null,
	horaInicio time(0) not null,
	horaFin time(0) not null,
	idDia tinyint foreign key references Dia not null
);

create table HorarioXJornada(
	id int primary key not null,
	idHorario int foreign key references Horario not null,
	idJornada int foreign key references Jornada not null
);

create table TipoUsuario(
	idTipo int primary key not null,
	tipo varchar(30) not null,
	check(tipo != '')
)

create table Usuario(
	idUsuario int primary key not null,
	contrasenia varchar(30) not null,
	idTipo int foreign key references TipoUsuario not null,
	check(contrasenia != '')
)

create table Cliente(
	idCliente int primary key not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	idProvincia tinyint foreign key references Provincia not null,
	idUsuario int foreign key references Usuario not null,
	check(nombre != '' and apellido != '')
)

create table Personal(
	idPersonal int primary key not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	idCentro smallint foreign key references CentroDeAtencion not null,
	idHorario int foreign key references Horario not null,
	idUsuario int foreign key references Usuario not null,
	check(nombre != '' and apellido != '')
)

create table CalificacionXCliente(
	id int primary key not null,
	idCalificacion int foreign key references Calificacion not null,
	idCliente int foreign key references Cliente not null
)

create table CalificacionXPersonal(
	id int primary key not null,
	idCalificacion int foreign key references Calificacion not null,
	idPersonal int foreign key references Personal not null
)

create table Categoria(
	idCategoria smallint primary key not null,
	descripcion varchar(50) not null,
	check (descripcion != '')
)

create table CategoriaXPersonal(
	id int primary key not null,
	idCategoria smallint foreign key references Categoria not null,
	idPersonal int foreign key references Personal not null
)

create table EstudioXPersonal(
	id int primary key not null,
	idEstudio smallint foreign key references Estudio not null,
	idPersonal int foreign key references Personal not null
)

create table Solicitud(
	idSolicitud int primary key not null,
	idPersonal int foreign key references Personal not null,
	idCliente int foreign key references Cliente not null
)

create table Contratacion(
	idContratacion int primary key not null,
	monto money not null default 0,
	fecha datetime not null default GETDATE(),
	idSolicitud int foreign key references Solicitud not null,
	check(monto >= 0)
)

create table CategoriaXContratacion(
	id int primary key not null,
	precio money not null default 0,
	idCategoria smallint foreign key references Categoria not null,
	idContratacion int foreign key references Contratacion not null,
	check(precio >= 0)
)

create table Puesto(
	idPuesto smallint primary key not null,
	nombre varchar(50) not null,
	idPersonal int foreign key references Personal not null,
	check(nombre != '')
)

create table Pago(
	idPago int primary key not null,
	fecha datetime not null default GETDATE(),
	monto money not null default 0,
	idPersonal int foreign key references Personal not null,
	check(monto >= 0)
)

create table Actividad(
	idActividad int primary key not null,
	descripcion varchar(50) not null,
	check(descripcion != '')
)

create table Correo(
	idCorreo int primary key not null,
	direccion varchar(50) not null,
	idUsuario int foreign key references Usuario not null,
	check(direccion != '')
)

create table Enfermedad(
	idEnfermedad smallint primary key not null,
	nombre varchar(30) not null,
	check(nombre != '')
)

create table Tratamiento(
	idTratamiento int primary key not null,
	nombre varchar(30) not null,
	cantidad smallint not null default 0,
	idEnfermedad smallint foreign key references Enfermedad not null,
	check(nombre != '' and cantidad >= 0)
)

create table TratamientoXCliente(
	id int primary key not null,
	idTratamiento int foreign key references Tratamiento not null,
	idCliente int foreign key references Cliente not null
)

create table TipoServicio(
	idServicio smallint primary key not null,
	descripcion varchar(50) not null,
	check(descripcion != '')
)

create table ServicioXCentro(
	id smallint primary key not null,
	idServicio smallint foreign key references TipoServicio not null,
	idCentro smallint foreign key references CentroDeAtencion not null
)

create table EnfermedadXCliente(
	id int primary key not null,
	idEnfermedad smallint foreign key references Enfermedad,
	idCliente int foreign key references Cliente
)