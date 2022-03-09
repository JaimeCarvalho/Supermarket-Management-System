DROP TABLE simple_category;
DROP TABLE made_up;
DROP TABLE super_category;
DROP TABLE organized_into;
DROP TABLE requires;
DROP TABLE category;
DROP TABLE supplies_secondary;
DROP TABLE secondary_supplier;
DROP TABLE replenishment;
DROP TABLE planogram;
DROP TABLE product;
DROP TABLE primary_supplier;
DROP TABLE supplier;
DROP TABLE shelf;
DROP TABLE corridor;
DROP TABLE supermarket;

CREATE TABLE supermarket(
	tin_supermarket NUMERIC(9),
	name VARCHAR(80) UNIQUE NOT NULL,
	address VARCHAR(255) UNIQUE NOT NULL,
	PRIMARY KEY(tin_supermarket)
);

CREATE TABLE corridor(
	tin_supermarket NUMERIC(9),
	number_corridor INTEGER,
	length FLOAT NOT NULL,
	PRIMARY KEY(tin_supermarket, number_corridor),
	FOREIGN KEY(tin_supermarket) REFERENCES supermarket(tin_supermarket)
	-- Every corridor must exist in the table 'shelf'
);

CREATE TABLE shelf(
	tin_supermarket NUMERIC(9),
	number_corridor INTEGER,
	height VARCHAR(10),
	side VARCHAR(5),
	CHECK (side IN ('Left', 'Right')),
	CHECK (height IN ('Floor', 'Medium', 'Upper')),
	PRIMARY KEY(tin_supermarket, number_corridor, height, side),
	FOREIGN KEY(tin_supermarket, number_corridor) REFERENCES corridor(tin_supermarket, number_corridor)
);

CREATE TABLE supplier(
	tin_supplier NUMERIC(9),
	name_supplier VARCHAR(80) UNIQUE NOT NULL,
	PRIMARY KEY(tin_supplier)
	-- Every supplier must exist either in the table 'primary_supplier' or in the table 'secondary_supplier'
	-- IC-6: A supplier cannot be primary and secondary supplier at the same time for the same product
);

CREATE TABLE primary_supplier(
	tin_supplier NUMERIC(9),
	name_supplier VARCHAR(80) UNIQUE NOT NULL,
	PRIMARY KEY(tin_supplier),
	FOREIGN KEY(tin_supplier) REFERENCES supplier(tin_supplier)
);
	
CREATE TABLE product(
	ean NUMERIC(13),
	designation VARCHAR(80) UNIQUE NOT NULL,
	tin_supplier NUMERIC(9),
	date_since DATE NOT NULL,
	PRIMARY KEY(ean),
	FOREIGN KEY(tin_supplier) REFERENCES primary_supplier(tin_supplier),
	CHECK (LEN(ean) = 13)
	-- Every product must exist in the table 'planogram'
	-- Every product must exist in the table 'supplies_secondary'
	-- Every product must exist in the table 'organized_into'
);

CREATE TABLE planogram(
	tin_supermarket NUMERIC(9),
	number_corridor INTEGER,
	height VARCHAR(10),
	side VARCHAR(5),
	ean NUMERIC(13),
	number_units INTEGER NOT NULL,
	location_number INTEGER NOT NULL,
	number_visible_fronts INTEGER NOT NULL,
	PRIMARY KEY(tin_supermarket, number_corridor, height, side, ean),
	FOREIGN KEY(tin_supermarket, number_corridor, height, side) REFERENCES shelf(tin_supermarket, number_corridor, height, side),
	FOREIGN KEY(ean) REFERENCES product(ean),
	-- IC-1: Each product unit can be placed only on shelves known upfront according to the planogram
);

CREATE TABLE replenishment(
	instant DATETIME UNIQUE,
	number_units INTEGER NOT NULL,
	tin_supermarket NUMERIC(9),
	number_corridor INTEGER,
	height VARCHAR(10),
	side VARCHAR(5),
	ean NUMERIC(13),
	PRIMARY KEY(instant, tin_supermarket, number_corridor, height, side, ean),
	FOREIGN KEY(tin_supermarket, number_corridor, height, side, ean) REFERENCES planogram(tin_supermarket, number_corridor, height, side, ean)
	-- IC-4: A replenishment cannot replenish more units than those prescribed by the planogram
);

CREATE TABLE secondary_supplier(
	tin_supplier NUMERIC(9),
	name_supplier VARCHAR(80) NOT NULL,
	PRIMARY KEY(tin_supplier),
	FOREIGN KEY(tin_supplier) REFERENCES supplier(tin_supplier)
);

CREATE TABLE supplies_secondary(
	tin_supplier NUMERIC(9),
	ean NUMERIC(13),
	PRIMARY KEY(tin_supplier, ean),
	FOREIGN KEY(ean) REFERENCES product(ean),
	FOREIGN KEY(tin_supplier) REFERENCES secondary_supplier(tin_supplier)
	-- IC-5: There are multiple secondary suppliers for each product (at least 2)
);

CREATE TABLE category(
	name VARCHAR(80),
	PRIMARY KEY(name)
	-- Every category must exist either in the table 'simple_category' or in the table 'super_category'
	-- No category can exist at the same time in both the table 'simple_category' or in the table 'super_category'
);

CREATE TABLE simple_category(
	name VARCHAR(80),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE super_category(
	name VARCHAR(80),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES category(name)
	-- Every super_category must exist in the table 'made_up'
);

CREATE TABLE made_up (
	name_super VARCHAR(80),
	name_sub VARCHAR(80),
	PRIMARY KEY(name_super, name_sub),
	FOREIGN KEY(name_super) REFERENCES super_category(name),
	FOREIGN KEY(name_sub) REFERENCES category(name)
	-- IC-2: A category cannot include itself
	-- IC-3: There can be no cycles in the category hierarchy
);

CREATE TABLE requires(
	name VARCHAR(80),
	tin_supermarket NUMERIC(9),
	number_corridor INTEGER,
	height VARCHAR(10),
	side VARCHAR(5),
	PRIMARY KEY(tin_supermarket, number_corridor, height, side, name),
	FOREIGN KEY(tin_supermarket, number_corridor, height, side) REFERENCES shelf(tin_supermarket, number_corridor, height, side),
	FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE organized_into(
	name VARCHAR(80),
	ean NUMERIC(13),
	PRIMARY KEY(name,ean),
	FOREIGN KEY(name) REFERENCES category(name),
	FOREIGN KEY(ean) REFERENCES product(ean)
);