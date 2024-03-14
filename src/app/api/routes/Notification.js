const express = require('express');
const {connection} = require("../../../config/db");
const router = express.Router();

router
    .get('/user', (req, res, next) => {
        const {userId} = req.query;
        const sql =
            `SELECT *
             FROM notification
             WHERE user_id = ?`

        connection.query(sql, [userId], (err, results) => {
            if (err) {
                res.status(500).json({error: err});
                return;
            }
            res.status(200).json(results);
        });

    })

module.exports = router;
