const {Pool} = require('pg');
const db = require('./config');

const pool = new Pool({
    user: db.dbUser,
    host: db.dbHost,
    database: db.dbName,
    password: db.dbPassword,
    port: db.dbPort,
});

module.exports = pool;