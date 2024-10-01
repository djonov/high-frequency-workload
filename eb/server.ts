import express from 'express'
import * as bodyParser from 'body-parser'
import { createConnection, DataSource } from 'typeorm'
import { PostgresConnectionOptions } from 'typeorm/driver/postgres/PostgresConnectionOptions'

export const app = express()

export let server
let connection: DataSource


const runCalculation = async(area_plot) => {
    await setTimeout(() => {}, 100)
    return area_plot * 100;
}

const processRequest = async(req, res, next) => {
    try {
        console.log('Received new request to process');
        console.log(req.body.data);
        console.log(req.body.data.body)
        const { area_plot } = JSON.parse(req.body.data.body);
        const processedResult = await runCalculation(Number(area_plot));
        await connection.query(`INSERT INTO "processed" ("entryData", "predictedOutput") VALUES ($1, $2)`, [area_plot, processedResult]);
        return res.status(200).send({
            message: 'OK'
        });
    } catch (err) {
        console.log(err);
        return res.status(500).send();
    }
    
}

app.use(bodyParser.json())
app.post('/', processRequest)

const PORT = 8080

const db = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: +process.env.DB_PORT, // convert to number with unary plus operator
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: { rejectUnauthorized: false }
}

createConnection({
    ...(db as PostgresConnectionOptions),
    migrationsRun: false
})
.then(async (conn) => {
    connection = conn
    console.log('Connected to DB')
    server = app.listen(PORT, () => {
        console.log('Server running on port ' + PORT)
    })
})
.catch((error) => console.error(error))

