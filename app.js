const express = require('express');
const app = express();
const bp = require('body-parser')
const {connection} = require('./src/config/db');
const cors = require('cors');

const corsOptions = {
    origin: 'http://localhost:3000',
    methods: "GET, PUT, POST, DELETE",
}
const artworkRoutes = require('./src/app/api/routes/Artworks');
const userRoutes = require('./src/app/api/routes/Users');
const cartRoutes = require('./src/app/api/routes/Carts');
const commentRoutes = require('./src/app/api/routes/Comments');
const topicRoutes = require('./src/app/api/routes/Topics');
const orderRoutes = require('./src/app/api/routes/Orders');
const noticeRoutes = require('./src/app/api/routes/Notification');
const revenueRoutes = require('./src/app/api/routes/Revenue');


app.use(cors(corsOptions))
app.use(bp.json())
app.use(bp.urlencoded({extended: true}))

app.use('/artworks', artworkRoutes);
app.use('/users', userRoutes);
app.use('/carts', cartRoutes);
app.use('/comments', commentRoutes);
app.use('/topics', topicRoutes);
app.use('/orders', orderRoutes);
app.use('/notices', noticeRoutes);
app.use('/revenue', revenueRoutes);

connection.connect(err => {
    if (err) throw err;
    console.log("Connected!");
});

module.exports = app;
