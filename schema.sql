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
    `role`       VARCHAR(50)  NOT NULL DEFAULT 'USER',
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
    date         datetime default current_timestamp,
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
    id       int auto_increment primary key,
    user_id  int not null,
    tax      decimal(18, 2),
    profit   decimal(18, 2),
    total    decimal(18, 2),
    date     datetime default current_timestamp,
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
VALUES ('Danhyeye', '123456', 'Dan', 'Hyeye', 'danhyeye@gmail.com'),
       ('Bui Thanh', '1234567', 'Thanh', 'Bui', 'manhthanh@gmail.com');


INSERT INTO `User` (username, password, first_name, last_name, email,role)
VALUES ('ngoclnb1811', '123456', 'Lê', 'Ngọc', 'ngoclnb1811@gmail.com','ADMIN');

INSERT INTO `Artwork` (src, title, price, description, created_by)
VALUES ('https://i.pinimg.com/564x/56/01/e7/5601e72265b56929fe04b2a2a72fa37a.jpg', 'A normal day in the anime world', 10, 'This is my first artwork', 1),
       ('https://i.pinimg.com/564x/9e/df/74/9edf743ef1fba233b98836a59322dcac.jpg', 'Anime world', 10, '2nd', 2),
       ('https://i.pinimg.com/564x/b8/6a/25/b86a258ee3c3b4b44d2a8e71a0db983d.jpg', 'A normal day in the anime world #2', 10, 'How to recognize day or night in this artwork', 1),
       ('https://i.pinimg.com/564x/2a/e0/15/2ae015b00d2f9dea172c6ca256f2196f.jpg', 'Anime world #2', 10, 'Meow', 2),
       ('https://i.pinimg.com/564x/8e/ed/34/8eed348391577a585ba378095f8d585c.jpg', 'A normal day in the anime world #3', 10, 'My Shiba Inu', 1),


       ('https://i.pinimg.com/564x/88/6c/2d/886c2dd9632df00ec675fdcf6d2fac92.jpg', 'Not just art', 10, 'My boy', 3),
       ('https://i.pinimg.com/736x/b1/29/f6/b129f69309638fda34b7da2ebbfce83a.jpg', 'Not just art #2', 20, 'Looking my eyes', 3),
       ('https://i.pinimg.com/736x/85/3e/bf/853ebff19a985aae38e65c8111e59ef8.jpg', 'Not just art #3', 10, 'Lighthouse', 3),
       ('https://i.pinimg.com/564x/18/58/af/1858af19eff301bf38c24917f2dd5ce3.jpg', 'Not just art #4', 10, 'Under the sea', 3),



       ('https://i.pinimg.com/564x/e2/06/8d/e2068dde6d50f4b27ea080304d095ce2.jpg', 'Animal Party', 10, 'Gecko', 1),
       ('https://i.pinimg.com/564x/6f/3b/c1/6f3bc12d260a820f0a9be1eb41d61f4d.jpg', 'Animal Kingdom', 20, 'My parrot', 2),
       ('https://i.pinimg.com/564x/a5/e0/16/a5e016e8b816258ba1fb51f0188f7298.jpg', 'Poisionous', 20, 'Look her eyes', 3),



       ('https://i.pinimg.com/564x/7a/9a/ed/7a9aedb8b717c648f6c9f803e75b82a7.jpg', 'My album', 10, 'Wild Cat', 1),
       ('https://i.pinimg.com/564x/5d/8c/4b/5d8c4bb8899242cdd50afead57133833.jpg', 'My album #2', 5, 'Wild Cat', 1),
       ('https://i.pinimg.com/564x/ba/1b/37/ba1b377dabeeb286b6831fd74bed7f6e.jpg', 'My album #3', 5, 'My Meow', 1),
       ('https://i.pinimg.com/564x/e6/83/f6/e683f63408e6aa2237a1da404be12eb3.jpg', 'Fall Cat', 15, 'Fall', 2	),


       ('https://i.pinimg.com/564x/6a/92/7b/6a927b476b6343fc382916d5f02a1ed3.jpg', 'Pacific Horticulture | Bellflowers', 20, 'Softly speckled pink bells on Korean bellflower.', 1),
       ('https://i.pinimg.com/564x/cb/65/8f/cb658fa5ba315bbb47a376675bd71776.jpg', 'Hydrangea', 20, 'I planted it in front of my house', 2),
       ('https://i.pinimg.com/564x/79/47/c5/7947c589b9384e2cc8ff2b20bb14873e.jpg', 'Four-leaf clover', 10, 'Good luck to u', 3),



       ('https://i.pinimg.com/564x/1b/56/0d/1b560d616f3301352022ab6b93f3eab5.jpg', 'Pre-Painting', 10, 'Colour Talk DIY Oil Painting, Paint by Number Kits ', 1),
       ('https://i.pinimg.com/736x/b3/72/bc/b372bcf2591f29da0cb3f2e29be97e36.jpg', ' Impressionism', 25, 'Make me wow', 2),
       ('https://i.pinimg.com/564x/6a/48/09/6a4809494cc87d42176b4e4ed5a6ad3b.jpg', 'ArtStation - Explore', 20, 'Explore now', 2),


       ('https://i.pinimg.com/564x/aa/5e/3f/aa5e3fc3b46a21d0554d89ede3410296.jpg', ' Countryside', 20, 'I accidentally caught this scene', 3),
       ('https://i.pinimg.com/564x/b6/2d/cc/b62dcc1468f8e9f6689838310c645cc2.jpg', ' Da G.O.A.T', 20, 'This shoot ', 3),
       ('https://i.pinimg.com/564x/bf/80/37/bf80373f1efc523d9ea108ca43d5effb.jpg', ' Messi', 20, 'I made it for you', 3),

       ('https://i.pinimg.com/564x/73/cb/cd/73cbcd8ff7c0f78b5ba24656558d5cdb.jpg', ' Mr. Brainwash ', 20, 'Dream Big Dreams', 3),
       ('https://i.pinimg.com/564x/14/ef/ef/14efef8984badf3d36b7154160d23b91.jpg', ' Illustration', 20, 'The painting I dedicated to the Urban Biennale', 1),
       ('https://i.pinimg.com/564x/f5/73/63/f57363391d9dbcbe76406d17f2e6613e.jpg', ' Wave ', 20, 'Japanese Wave Wall mural', 1),

       ('https://i.pinimg.com/564x/71/a0/c8/71a0c8820f2e032a11774e7075357337.jpg', ' Back to the 90s ', 20, 'Leonardo DiCaprio', 2),
       ('https://i.pinimg.com/564x/f9/df/4d/f9df4d27a0618999f36c01b723bcd48a.jpg', ' Back to the 90s #2 ', 20, 'Will Smith', 2),
       ('https://i.pinimg.com/564x/25/ab/65/25ab655a33a234ca82af380069828115.jpg', ' Back to the 90s #3 ', 20, 'Michael Jackson', 2);

INSERT INTO `ArtworkTopic` (topic, artwork)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (2, 6),
       (4, 8),
       (5, 9),
       (7, 10),
       (1, 12),
       (1, 13),
       (1, 14),
       (1, 15),
       (1, 16),
       (1, 17),
       (1, 18),
       (1, 19),
       (1, 20),
       (1, 21),
       (1, 22),
       (1, 23),
       (1, 24),
       (1, 25),
       (1, 26),
       (1, 27),
       (1, 28),
       (1, 29),
       (1, 30),
       (2, 31),
       (2, 5),
       (2, 6),
       (2, 8),
       (2, 9),
       (2, 10),
       (2, 12),
       (2, 13),
       (3, 12),
       (3, 13),
       (3, 14),
       (3, 15),
       (3, 16),
       (3, 17);


