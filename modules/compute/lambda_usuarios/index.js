const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");

const client = new DynamoDBClient();          // SDK v3 ya viene en Node 20.x
const TABLE  = process.env.USERS_TABLE;

exports.handler = async (event) => {
  // Imprimir el evento completo recibido para revisar su estructura
  console.log("Evento completo recibido:", JSON.stringify(event, null, 2));

  // Verificar si el evento tiene un campo 'body'
  if (!event.body) {
    console.error("El campo 'body' está vacío o no se recibe correctamente.");
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "El campo 'body' está vacío o no se recibe correctamente." })
    };
  }

  // Intentar parsear el cuerpo del evento
  let body;
  try {
    body = JSON.parse(event.body);  // Intentamos parsear el cuerpo
    console.log("Cuerpo del evento parseado:", JSON.stringify(body, null, 2));  // Ver los datos procesados
  } catch (error) {
    console.error("Error al parsear el cuerpo del evento:", error);
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Error al parsear el cuerpo del evento", error: error.message })
    };
  }

  // Extraemos los valores del evento (sin el campo 'dni')
  const { nombre, apellido, fechaNacimiento, rol } = body;
  console.log("Datos recibidos:", { nombre, apellido, fechaNacimiento, rol });

  // Validar si los campos están presentes
  if (!nombre || !apellido || !fechaNacimiento || !rol) {
    console.error("Faltan datos requeridos:", { nombre, apellido, fechaNacimiento, rol });
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Todos los campos son obligatorios" })
    };
  }

  // Validar el rol
  const validRoles = ['usuario', 'administrador'];
  if (!validRoles.includes(rol)) {
    console.error("Rol inválido:", rol);
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Rol inválido. Los valores permitidos son: 'usuario', 'administrador'" })
    };
  }

  // Crear el objeto de usuario para insertar en DynamoDB
  const user = {
    nombre: nombre,
    apellido: apellido,
    fechaNacimiento: fechaNacimiento,
    rol: rol,  // Guardar el rol en DynamoDB
    createdAt: new Date().toISOString()  // Timestamp de creación
  };

  // Insertar el usuario en la tabla DynamoDB
  const params = {
    TableName: process.env.USERS_TABLE,  // La tabla DynamoDB configurada en el entorno
    Item: user
  };

  try {
    // Intentar insertar el nuevo usuario en DynamoDB
    await client.send(new PutItemCommand(params));
    console.log("Usuario insertado correctamente:", user);

    // Respuesta exitosa
    return {
      statusCode: 201,
      body: JSON.stringify({ message: "Usuario creado exitosamente", user })
    };
  } catch (error) {
    // Capturar cualquier error de DynamoDB
    console.error("Error al guardar el usuario:", error);

    // Respuesta de error
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Error al crear el usuario", error: error.message })
    };
  }
};
