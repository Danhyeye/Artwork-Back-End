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
INSERT INTO `ArtworkTopic` (topic, artwork)
VALUES (1, 1), (2, 2), (3, 3),(4, 4), (5, 5),(2, 6),(4, 8),(5, 9),(7, 10), (1, 12), (1, 13), (1, 14),(1, 15)


