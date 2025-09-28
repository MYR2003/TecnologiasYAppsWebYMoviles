const {Client} = require('pg');

const client = new Client({
  user: 'myr',
  host: 'localhost',
  database: 'pym',
  password: '1234',
  port: 5432,
});

module.exports = {client};