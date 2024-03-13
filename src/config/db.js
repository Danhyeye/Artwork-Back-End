// connect nodejs to mysql
const mysql = require('mysql');

const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "Printer"
});


module.exports = { connection };
