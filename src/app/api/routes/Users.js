const express = require('express');
const router = express.Router();
const { connection } = require('../../../config/db');

router
    .post('/login', (req, res, next) => {
        // login
        console.log(req.body)
        const { email, password } = req.body;
        connection.query('SELECT * FROM user WHERE email = ? AND password = ?', [email, password], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                if (results.length > 0) {
                    res.status(200).json(results[0]);
                } else {
                    res.status(401).json({
                        message: "Email or password is incorrect, please log in again"
                    });
                }
            }
        });
    })
    .post('/register', (req, res, next) => {
        // register
        console.log(req.body);
        const { username, password, firstName, lastName, email } = req.body;
        connection.query('SELECT * FROM user WHERE email like ?', [email], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                if (results.length > 0) {
                    res.status(400).json({
                        message: "Email already exists in the database"
                    });
                } else {
                    connection.query('INSERT INTO user (username, password, first_name, last_name, email) VALUES (?, ?, ?, ?, ?)', [username, password, firstName, lastName, email], (err, results, fields) => {
                        if (err) {
                            res.status(500).json({
                                message: "Error"
                            });
                        } else {
                            res.status(201).json({
                                message: "Registration successful"
                            });
                        }
                    });
                }
            }
        });
    })
    .put('/edit', (req, res, next) => {
        const { username, first_name, last_name, email, id } = req.body;
        connection.query('UPDATE user SET username= ?, first_name=?,last_name=?,email=? where id = ?', [username, first_name, last_name, email, id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                res.status(201).json({
                    message: "Edit success"
                });
            }
        });

    })


module.exports = router;
