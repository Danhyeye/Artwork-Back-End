create database if not exists `Printer`;
# drop database if exists `Printer`;
use `Printer`;

create table if not exists Topic
(
    id   int auto_increment primary key,
    name varchar(255) not null
);

create table if not exists `User`
(
    `id`         int          not null auto_increment,
    `username`   varchar(255) not null,
    `password`   varchar(255) not null,
    `first_name` varchar(255) not null,
    `last_name`  varchar(255) not null,
    `email`      varchar(255) not null,
    primary key (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `Artwork`
(
    `id`          int            not null auto_increment,
    `title`       varchar(255)   not null,
    `description` text           null,
    `price`       decimal(10, 2) not null,
    `src`         varchar(255)   null,
    `created_by`  int            not null,
    `seller_id`   int            null,
    status        BOOLEAN DEFAULT true,
    foreign key (`created_by`) references `User` (`id`),
    foreign key (`seller_id`) references `User` (`id`),
    primary key (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `ArtworkTopic`
(
    `id`      int not null auto_increment,
    `artwork` int not null,
    `topic`   int not null,
    primary key (`id`),
    foreign key (`artwork`) references `Artwork` (`id`),
    foreign key (`topic`) references `Topic` (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `Comments`
(
    `id`         int  not null auto_increment,
    `user_id`    int  not null,
    `artwork_id` int  not null,
    `comment`    text not null,
    date    datetime default current_timestamp,
    primary key (`id`),
    foreign key (`user_id`) references `User` (`id`),
    foreign key (`artwork_id`) references `Artwork` (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `Cart`
(
    `id`         int not null auto_increment,
    `user_id`    int not null,
    `artwork_id` int not null,
    primary key (`id`),
    foreign key (`user_id`) references `User` (`id`),
    foreign key (`artwork_id`) references `Artwork` (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `ArtworkSaved`
(
    `id`         int not null auto_increment,
    `user_id`    int not null,
    `artwork_id` int not null,
    primary key (`id`),
    foreign key (`user_id`) references `User` (`id`),
    foreign key (`artwork_id`) references `Artwork` (`id`)
) engine = InnoDB
  default charset = utf8mb4;

create table if not exists `Order`
(
    id             int auto_increment primary key,
    user_id        int not null,
    card_name      varchar(255),
    card_number    varchar(255),
    cvv            varchar(255),
    expiry_date    varchar(255),
    total_price    decimal(18, 2),

    first_name     varchar(255),
    last_name      varchar(255),
    address_line_1 varchar(500),
    address_line_2 varchar(500),
    city           varchar(255),
    state          varchar(255),
    postal_code    varchar(255),
    country        varchar(255),

    foreign key (user_id) references User (id)
);

create table if not exists `OrderDetails`
(
    id         int auto_increment primary key,
    order_id   int not null,
    artwork_id int not null,
    price      decimal(18, 2),
    foreign key (order_id) references `Order` (id),
    foreign key (artwork_id) references Artwork (id)
);

create table if not exists `Notification`
(
    id          int auto_increment primary key,
    content     varchar(500),
    user_id     int          not null, # người bán
    seller_name varchar(255) not null, # người mua
    order_id    int          not null,
    foreign key (user_id) references User (id),
    foreign key (order_id) references `Order` (id)
);

create table if not exists `Revenue`
(
    id      int auto_increment primary key,
    user_id int not null,
    tax     decimal(18, 2),
    profit  decimal(18, 2),
    total   decimal(18, 2),
    date    datetime default current_timestamp,
    order_id int not null,
    foreign key (order_id) references `Order` (id),
    foreign key (user_id) references User (id)
);

# get artworks by user_id from cart



# INSERT INTO `Order` (user_id, card_number, cvv, expiry_date, total_price)
# VALUES (1, '1234567890123456', '123', '12/23', 20);
#
# INSERT INTO `OrderDetails` (order_id, artwork_id, price)
# VALUES (1, 1, 20);
# INSERT INTO `OrderDetails` (order_id, artwork_id, price)
# VALUES (1, 2, 20);

INSERT INTO `Topic` (name)
VALUES ('Anime'),
       ('Art'),
       ('Animal'),
       ('Photography'),
       ('Flower'),
       ('Painting'),
       ('Football'),
       ('Street Art'),
       ('Fashion');

INSERT INTO `User` (username, password, first_name, last_name, email)
VALUES ('Danhyeye', '123456', 'Dan', 'Hyeye', 'danhyeye@gmail.com');


INSERT INTO `User` (username, password, first_name, last_name, email)
VALUES ('Bui Thanh', '1234567', 'Thanh', 'Bui', 'manhthanh@gmail.com');

INSERT INTO `Artwork` (src, title, price, description, created_by)
VALUES ('assets/images/img0.jpg', 'Danhyeye', 20, 'This is artwork!!!', 1),
       ('assets/images/img1.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img2.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img3.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img4.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img5.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img6.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img7.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img8.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img9.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img10.png', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img11.jfif', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img12.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1),
       ('assets/images/img13.jpg', 'Danhyeye', 40, 'This is artwork!!!', 1);
# INSERT INTO `ArtworkTopic` (topic, artwork)
# VALUES (1, 1),
#        (2, 2),
#        (3, 3),
#        (4, 4),
#        (5, 5),
#        (2, 6),
#        (4, 8),
#        (5, 9),
#        (7, 10),
#        (1, 12),
#        (1, 13),
#        (1, 14),
#        (1, 15);


# SELECT o.*, u.first_name, u.last_name, p.id atrwork_id, p.title, p.src, u2.username
# FROM `order` o
#          LEFT JOIN OrderDetails od ON o.id = od.order_id
#          LEFT JOIN Artwork p ON od.artwork_id = p.id
#          LEFT JOIN User u ON u.id = o.user_id
#          LEFT JOIN User u2 ON u2.id = p.created_by
# WHERE o.user_id = ?
