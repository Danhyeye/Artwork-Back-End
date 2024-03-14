const express = require('express');
const router = express.Router();
const {connection} = require('../../../config/db');

router
    .get('', (req, res, next) => {
        // get all revenue
        connection.query('SELECT COALESCE(SUM(profit),0) AS profit FROM revenue', (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results[0]);
            }
        });
    })
    .get('/month/:month', (req, res, next) => {
        // get revenue by month
        const {month} = req.params;
        connection.query(`
            SELECT COALESCE(SUM(profit),0) AS profit
            FROM revenue
            WHERE YEAR(date) = YEAR(CURDATE())
              AND MONTH(date) = ?
        `, [month], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results[0]);
            }
        });
    })
    .get('/day', (req, res, next) => {
        const {from, to} = req.query;
        connection.query(`
            SELECT COALESCE(SUM(profit),0) AS profit
            FROM revenue
            WHERE date BETWEEN ? AND ?
        `, [from, to], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results[0]);
            }
        });
    })

module.exports = router;
