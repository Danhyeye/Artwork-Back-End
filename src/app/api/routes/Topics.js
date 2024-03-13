const express = require('express');
const {connection} = require("../../../config/db");
const router = express.Router();

router
    .get('', (req, res, next) => {
        // get all topics
        connection.query('SELECT * FROM Topic', (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results);
            }
        });
    })
    .get('/:id', (req, res, next) => {
        // get topic by id
        const {id} = req.params;
        connection.query('SELECT * FROM Topic WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                if (results.length > 0) {
                    res.status(200).json(results[0]);
                } else {
                    res.status(404).json({
                        message: "Topic not found"
                    });
                }
            }
        });
    })
    .post('', (req, res, next) => {
        // create topic
        const {name} = req.body;
        console.log(req.body)
        connection.query('INSERT INTO Topic (name) VALUES (?)', [name], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                res.status(201).json({
                    message: "Create topic success"
                });
            }
        });
    })
    .delete('/:id', (req, res, next) => {
        //delete topic
        const {id} = req.params;
        connection.query('DELETE FROM Topic WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    message: "Delete topic success"
                });
            }
        });
    });

module.exports = router;
