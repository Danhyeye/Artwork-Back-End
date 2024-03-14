const express = require('express');
const {connection} = require("../../../config/db");
const router = express.Router();

router
    .get('/cart', (req, res) => {
        const {userId} = req.query;
        const sql = `
            SELECT p.*
            FROM \`Cart\` c
                     LEFT JOIN Artwork p ON c.artwork_id = p.id
            WHERE c.user_id = ?;
        `
        connection.query(sql, [userId], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });

            } else {
                if (!results || !(results.length > 0)) {
                    res.status(200).json(
                        []
                    )
                } else
                    res.status(200).json(
                        results
                    )
            }
        })
    })
    .get('/topic', (req, res) => {
        const {topicname} = req.query;
        const param = `%${topicname}%`
        connection.query(`SELECT artwork.*
                          FROM artwork
                                   inner JOIN artworktopic ON artworktopic.artwork = artwork.id
                                   INNER JOIN topic ON artworktopic.topic = topic.id
                          WHERE topic.name like ?
                            and artwork.status = 1
                          GROUP BY artworktopic.artwork`, [param], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });

            } else {
                if (!results || !(results.length > 0)) {
                    res.status(200).json(
                        []
                    )
                } else
                    res.status(200).json(
                        results
                    )
            }
        })
    })
    .get('', (req, res, next) => {
        // get all artworks
        connection.query('SELECT * FROM Artwork  A where  A.status = 1', (err, results, fields) => {
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
        // get artwork by id
        const {id} = req.params;
        connection.query(`SELECT A.*, U.first_name, U.last_name
                          FROM Artwork as A
                                   INNER JOIN User as U on A.created_by = U.id
                          WHERE A.id = ?
                            and A.status = 1`, [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                if (results.length > 0) {
                    connection.query(`
                        SELECT T.name
                        FROM ArtworkTopic as AT
                                 INNER JOIN Topic as T
                                            on T.id = AT.topic
                        WHERE AT.artwork = ?;
                    `, [id], (err, topics, fields) => {
                        if (err) {
                            res.status(500).json({
                                message: "Error" + err.message
                            });
                        } else {
                            res.status(200).json({
                                ...results[0],
                                topics: topics
                            });
                        }
                    });
                } else {
                    res.status(404).json({
                        message: "Artwork not found"
                    });
                }
            }
        });
    })
    .get('/created/:userId', (req, res, next) => {
        const {userId} = req.params;
        connection.query('SELECT * FROM Artwork WHERE created_by = ?', [userId], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json(results);
            }
        });
    })
    .get('/saved/:userId', (req, res, next) => {
        const {userId} = req.params;
        connection.query('SELECT A.* FROM Artwork as A INNER JOIN ArtworkSaved as ASD on A.id = ASD.artwork_id WHERE ASD.user_id = ?', [userId], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                res.status(200).json(results);
            }
        });
    })
    .post('/save', (req, res, next) => {
        const {userId, artworkId} = req.body;
        //check if arworksaved already exist
        connection.query('SELECT * FROM ArtworkSaved WHERE user_id = ? AND artwork_id = ?', [userId, artworkId], (err, results, fields) => {
            if (results.length > 0) {
                res.status(409).json({
                    message: "Artwork already saved"
                });
            } else {
                connection.query('INSERT INTO ArtworkSaved (user_id, artwork_id) VALUES (?,?)', [userId, artworkId], (err, results, fields) => {
                    if (err) {
                        res.status(500).json({
                            message: "Error" + err.message
                        });
                    } else {
                        res.status(201).json({
                            message: "Save artwork success"
                        });
                    }
                });
            }
        })
    })
    .post('', (req, res, next) => {
        // create artwork
        const {title, description, price, src, createdBy, topics} = req.body;
        console.log(req.body)
        connection.query('INSERT INTO Artwork (title, description, price, src, created_by) VALUES (?,?,?,?,?)', [title, description, price, src, createdBy], (err, result, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error artwork" + err.message
                });
            } else {
                const topicsData = topics.map(top => {
                    const artwork = result.insertId;
                    const topic = top.id
                    return [artwork, topic];
                });
                console.log("topicdata", topicsData);
                connection.query('INSERT INTO artworktopic (artwork, topic) VALUES ?', [topicsData], (err, results, fields) => {
                    if (err) {
                        res.status(500).json({
                            message: "Error topic" + err.message
                        });
                    } else {
                        res.status(201).json({
                            message: "Create artwork & topic success"
                        });
                    }
                });
            }
        });
    })
    .delete('/:id', (req, res, next) => {
        //delete artwork
        const {id} = req.params;
        connection.query('UPDATE Artwork a SET a.status = 0 WHERE a.id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    message: "Delete artwork success"
                });
            }
        });
    })
    .delete('/:id', (req, res, next) => {
        //delete artwork
        const {id} = req.params;
        connection.query('DELETE FROM Artwork WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                res.status(200).json({
                    message: "Delete artwork success"
                });
            }
        });
    })


module.exports = router;
