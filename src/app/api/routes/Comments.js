const express = require('express');
const router = express.Router();
const {connection} = require('../../../config/db');

router
    .get('/artworks/:artworkId', (req, res, next) => {
        // get comment by artwork id
        const {artworkId} = req.params;
        connection.query('SELECT C.*,U.first_name,U.last_name FROM comments as C LEFT JOIN User as U on C.user_id = U.id WHERE artwork_id = ?', [artworkId], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results);
            }
        });
    })
    .post('', (req, res, next) => {
        // add cart to user
        const {userId, artworkId, comment} = req.body;
        connection.query('INSERT INTO comments (user_id, artwork_id, comment) VALUES (?,?,?)', [userId, artworkId, comment], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(201).json({
                    message: "Add cart success"
                });
            }
        });
    })
    .put('', (req, res, next) => {
        // update comment
        const {id, comment} = req.body;
        connection.query('UPDATE comments SET comment = ? WHERE id = ?', [comment, id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    message: "Update cart success"
                });
            }
        });
    })
    .delete('/:id', (req, res, next) => {
        // remove comment
        const {id} = req.params;
        connection.query('DELETE FROM comments WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    message: "Remove cart success"
                });
            }
        });
    });

module.exports = router;
