create database if not exists bootcamp_sivirilova;
use bootcamp_sivirilova;
create table category (
	category_id int auto_increment,
    name varchar(40) not null unique,
    description varchar(200),
    primary key (category_id)
);
create table image (
	image_id int auto_increment,
    url varchar(200) not null unique,
    alt varchar(200) not null,
    primary key (image_id)
);
create table product (
	product_id int auto_increment,
    name varchar(40) not null unique,
    price int unsigned not null,
    price_sale int unsigned, -- без not null: возможно товар без скидки
    price_promocode int unsigned, -- без not null: возможно не действует промокод
    main_category int not null,
	main_image int not null,
    description varchar(200) not null,
    is_active bool not null, -- есть ли товар в продаже
    primary key (product_id),
    foreign key (main_category) references category(category_id) on delete cascade on update cascade,
    foreign key (main_image) references image(image_id) on delete cascade on update cascade
);
create table product_category (
	category_id int not null,
    product_id int not null,
	foreign key (category_id) references category(category_id) on delete cascade on update cascade,
    foreign key (product_id) references product(product_id) on delete cascade on update cascade
);
create table product_image(
	image_id int not null,
    product_id int not null,
    foreign key (image_id) references image(image_id) on delete cascade on update cascade,
    foreign key (product_id) references product(product_id) on delete cascade on update cascade
);
insert into category(name, description) 
	values  ('Бытовая техника', 'Все для быта!'),
			('Цифровая техника', 'Все для цифры!'), 
			('Б/у техника', 'Всегда дешевле рыночной стоимости!');
insert into image(url, alt)
	values  ('img/1.png', 'Фото стиральной машины'), 
			('img/1_2.png', 'Фото стиральной машины сбоку'),
            ('img/1_3.png', 'Фото стиральной машины в интерьере'),
			('img/2.png', 'Фото газовой плиты'),
            ('img/3.png', 'Фото электроплиты'),
            ('img/4.png', 'Фото духового шкафа'),
            ('img/5.png', 'Фото холодильника'),
            ('img/6.png', 'Фото кофемашины'),
            ('img/6_2.png', 'Фото кофемашины сзади');
insert into product(name, price, price_sale, price_promocode, main_category, main_image, description, is_active) 
	values  ('Стиральная машина X1', 8599, 7599, 6599, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/1.png'), 'Отстирает и пятна, и принт на футболке.', true),
			('Стиральная машина X2', 10599, 8599, 7599, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/1.png'), 'Аннигилирует вещи в 2 раза быстрее.', true),
            ('Газовая плита OLD', 1599, NULL, NULL, (select category_id from category where name = 'Б/у техника'), (select image_id from image where url = 'img/2.png'), 'Осторожно! Чрезмерное употребление газа вредно для здоровья!', true),
            ('Электроплита YOUNG', 15099, 13099, 12099, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/3.png'), 'Новое поколение - новый способы обжечься', true),
            ('Духовой шкаф ЖАРА', 8799, 8499, 8099, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/4.png'), 'Жарит не по-детски', true),
            ('Духовой шкаф DuShNy', 4599, 4559, NULL, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/4.png'), 'Тот еще душнила', false),
            ('Холодильник Yes, Frost', 15999, 13999, 10999, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/5.png'), 'Как с No Frost, только хуже', true),
            ('Кофемашина Nirvana', 2499, 2399, 2299, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/6.png'), 'Кофеин как новый наркотик', true),
            ('Кофемашина R2D2', 3499, 2899, 2599, (select category_id from category where name = 'Бытовая техника'), (select image_id from image where url = 'img/6_2.png'), 'Пип-пиу-пам-пум', true);
-- нет товаров в категории цифровой техники
-- часть товаров относится и к бытовой технике, и к б/у технике
insert into product_category
	values  ((select category_id from category where name = 'Бытовая техника'), (select product_id from product where name = 'Газовая плита OLD')), 
            ((select category_id from category where name = 'Б/у техника'), (select product_id from product where name = 'Духовой шкаф DuShNy')), 
            ((select category_id from category where name = 'Б/у техника'), (select product_id from product where name = 'Холодильник Yes, Frost'));
-- некоторые изображения использованы повторно (стиральные машины, духовые шкафы, кофемашины)
-- некоторые изображение являются главными у одного товара и дополнительными у другого (кофемашины)
insert into product_image
	values  ((select image_id from image where url = 'img/1_2.png'), (select product_id from product where name = 'Стиральная машина X1')),
			((select image_id from image where url = 'img/1_3.png'), (select product_id from product where name = 'Стиральная машина X1')), 
            ((select image_id from image where url = 'img/6_2.png'), (select product_id from product where name = 'Кофемашина Nirvana')),
            ((select image_id from image where url = 'img/6.png'), (select product_id from product where name = 'Кофемашина R2D2'));
            
															