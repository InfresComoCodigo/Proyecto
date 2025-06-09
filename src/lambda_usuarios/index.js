// index.js — versión CommonJS
const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");

const client = new DynamoDBClient();          // SDK v3 ya viene en Node 20.x
const TABLE  = process.env.USERS_TABLE;

exports.handler = async (event) => {
  try {
    // body puede venir como string o como objeto
    const payload = typeof event.body === "string" ? JSON.parse(event.body) : event.body;

    if (!payload.dni) {
      return { statusCode: 400, body: JSON.stringify({ error: "dni requerido" }) };
    }

    await client.send(new PutItemCommand({
      TableName: TABLE,
      Item: {
        dni:              { S: payload.dni },
        nombre:           { S: payload.nombre           ?? "" },
        apellido:         { S: payload.apellido         ?? "" },
        fecha_nacimiento: { S: payload.fechaNacimiento  ?? "" },
        rol:              { S: payload.rol              ?? "cliente" }
      }
    }));

    return { statusCode: 201, body: JSON.stringify({ ok: true }) };
  } catch (err) {
    console.error(err);
    return { statusCode: 500, body: JSON.stringify({ error: "error interno" }) };
  }
};
