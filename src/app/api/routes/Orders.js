const express = require('express');
const {connection} = require("../../../config/db");
const router = express.Router();

router
    .get('/user', (req, res, next) => {
        // get orders with orderdetails by userId
        const {userId} = req.query;
        const sql = `
            SELECT o.*, u.first_name, u.last_name, p.id atrwork_id, p.title, p.src, p.price,  c.first_name  firstname, c.last_name  lastname
            FROM \`order\` o
                     LEFT JOIN OrderDetails od ON o.id = od.order_id
                     LEFT JOIN Artwork p ON od.artwork_id = p.id
                     LEFT JOIN User c ON c.id = p.created_by
                     LEFT JOIN User u ON u.id = o.user_id
            WHERE o.user_id = ?
        `
        connection.query(sql, [userId], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                const orders = {};
                results.forEach(row => {
                    const orderId = row.id;
                    if (!orders[orderId]) {
                        orders[orderId] = {
                            id: orderId,
                            user_id: row.user_id,
                            first_name: row.first_name,
                            last_name: row.last_name,
                            card_name: row.card_name,
                            card_number: row.card_number,
                            cvv: row.cvv,
                            expiry_date: row.expiry_date,
                            total_price: row.total_price,
                            address_line_1: row.address_line_1,
                            address_line_2: row.address_line_2,
                            city: row.city,
                            state: row.state,
                            postal_code: row.postal_code,
                            country: row.country,
                            order_details: []
                        };
                    }
                    orders[orderId].order_details.push({
                        artwork_id: row.artwork_id,
                        title: row.title,
                        src: row.src,
                        price: row.price,
                        firstname: row.firstname,
                        lastname: row.lastname,
                    });
                    // res.status(200).json(ordersArray);
                })
                const ordersArray = Object.values(orders);
                res.status(200).json(ordersArray);
            }
        });
    })
    .get('', (req, res, next) => {
        const sql = `
            SELECT o.*, u.first_name, u.last_name, p.id atrwork_id, p.title, p.src, p.price
            FROM \`order\` o
                     LEFT JOIN OrderDetails od ON o.id = od.order_id
                     LEFT JOIN Artwork p ON od.artwork_id = p.id
                     LEFT JOIN User u ON u.id = o.user_id
        `
        connection.query(sql, [], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error"
                });
            } else {
                const orders = {};
                results.forEach(row => {
                    const orderId = row.id;
                    if (!orders[orderId]) {
                        orders[orderId] = {
                            id: orderId,
                            user_id: row.user_id,
                            first_name: row.first_name,
                            last_name: row.last_name,
                            card_name: row.card_name,
                            card_number: row.card_number,
                            cvv: row.cvv,
                            expiry_date: row.expiry_date,
                            total_price: row.total_price,
                            address_line_1: row.address_line_1,
                            address_line_2: row.address_line_2,
                            city: row.city,
                            state: row.state,
                            postal_code: row.postal_code,
                            country: row.country,
                            order_details: []
                        };
                    }
                    orders[orderId].order_details.push({
                        artwork_id: row.artwork_id,
                        title: row.title,
                        src: row.src,
                        price: row.price
                    });
                    // res.status(200).json(ordersArray);
                })
                const ordersArray = Object.values(orders);
                res.status(200).json(ordersArray);
            }
        });
    })
    .post('', (req, res, next) => {
        // save order and order details from carts
        const {
            user_id,
            card_name,
            card_number,
            cvv,
            expiry_date,
            first_name,
            last_name,
            address_line_1,
            address_line_2,
            city,
            state,
            postal_code,
            country,
            artworks
        } = req.body

        const totalPrice = artworks.reduce((acc, artwork) => acc + artwork.price, 0);
        const tax = 20 / 100;
        const profit = totalPrice * tax;
        const totalPriceWithTax = totalPrice + profit;

        const sql = `
            INSERT INTO \`order\` (user_id, card_name, card_number, cvv, expiry_date, total_price, first_name,
                                   last_name, address_line_1, address_line_2, city, state, postal_code, country)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        `

        connection.query(sql, [user_id, card_name, card_number, cvv, expiry_date, totalPriceWithTax, first_name, last_name, address_line_1, address_line_2, city, state, postal_code, country], (err, results, fields) => {
            if (err) {
                res.status(500).json({
                    message: "Error" + err.message
                });
            } else {
                const orderId = results.insertId;
                const orderDetails = artworks.map(artwork => [orderId, artwork.id, artwork.price]);

                const notifications = artworks.map(artwork =>
                    [`Artwork của bạn ${artwork.title} đã được mua bởi ${artwork.seller_name}`, artwork.created_by, artwork.seller_name, orderId]
                );

                const sqlNotification = `
                    INSERT INTO Notification (content, user_id, seller_name, order_id)
                    VALUES ?;
                `

                const sql = `
                    INSERT INTO OrderDetails (order_id, artwork_id, price)
                    VALUES ?;
                `

                const sqlRevenue = `
                    INSERT INTO Revenue (user_id, tax, profit, total, order_id)
                    VALUES (?, ?, ?, ?, ?);
                `


                connection.query(sql, [orderDetails], (err, results, fields) => {
                    if (err) {
                        res.status(500).json({
                            message: "Error" + err.message
                        });
                    } else {
                        connection.query(sqlNotification, [notifications], (err, results, fields) => {
                            if (err) {
                                res.status(500).json({
                                    message: "Error" + err.message
                                });
                            } else {
                                connection.query(sqlRevenue, [user_id, tax, profit, totalPriceWithTax, orderId], (err, results, fields) => {
                                    if (err) {
                                        res.status(500).json({
                                            message: "Error" + err.message
                                        });
                                    } else {
                                        artworks.forEach(artwork => {
                                            const sqlUpdateArtwork = `
                                                UPDATE Artwork
                                                SET seller_id = ?,
                                                    status    = 0
                                                WHERE id = ?
                                            `

                                            const sqlCart = `
                                                DELETE
                                                FROM Cart
                                                WHERE artwork_id = ?
                                            `
                                            connection.query(sqlUpdateArtwork, [user_id, artwork.id], (err, results, fields) => {
                                                if (err) {
                                                    res.status(500).json({
                                                        message: "Error" + err.message
                                                    });
                                                } else {
                                                    connection.query(sqlCart, [artwork.id], (err, results, fields) => {
                                                        if (err) {
                                                            res.status(500).json({
                                                                message: "Error"
                                                            });
                                                        }
                                                    });
                                                }
                                            })


                                        })
                                        res.status(201).json({
                                            message: "Create order success"
                                        });
                                    }
                                })
                            }
                        })
                    }
                });
            }
        });
    })

module.exports = router;
