const {Client} = require('pg');

const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'pym',
  password: '1234',
  port: 5432,
  client_encoding: 'UTF8'
});

module.exports = {client};