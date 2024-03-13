const express = require('express');
const router = express.Router();
const {connection} = require('../../../config/db');

router
    .get('/:userId', (req, res, next) => {
        // get cart by user id
        const {userId} = req.params;
        connection.query('SELECT c.*,a.title,a.description,a.price,a.src,a.created_by,a.seller_id FROM cart as c inner join artwork as a on c.artwork_id = a.id WHERE c.user_id = ?', [userId], (err, results, fields) => {
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
        const {userId, artworkId, quantity} = req.body;
        connection.query('INSERT INTO cart (user_id, artwork_id) VALUES (?,?)', [userId, artworkId, quantity], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                res.status(201).json({
                    message: "Add cart success"
                });
            }
        });
    })
    .delete('/:id', (req, res, next) => {
        // remove cart
        const {id} = req.params;
        connection.query('DELETE FROM cart WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    id
                });
            }
        });
    });


module.exports = router;
