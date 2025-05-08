const { RDSDataClient, ExecuteStatementCommand } = require("@aws-sdk/client-rds-data");
const client = new RDSDataClient({});

const { DB_CLUSTER_ARN, DB_SECRET_ARN, DB_NAME } = process.env;

exports.handler = async () => {
    const cmd = new ExecuteStatementCommand({
        resourceArn: DB_CLUSTER_ARN,
        secretArn:   DB_SECRET_ARN,
        sql:         "SELECT NOW() AS current_time",
        database:    DB_NAME
    });
    const res = await client.send(cmd);
    return { statusCode: 200, body: JSON.stringify(res.records) };
};
