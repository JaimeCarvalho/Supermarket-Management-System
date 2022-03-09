# Supermarket-Management-System

For this project a product management and shelf replenishment system was considered for a chain of Supermarkets. A supermarket has a name and an address and is identified by its Tax Identification Number (TIN).

In supermarkets, the products are displayed on shelves. Each shelf is identified by the corridor, the side (left or right) and height (floor, medium, upper). Corridors have numbers that identifies them and a length in meters.
The placement of the products is predetermined. Each product unit can be placed only on shelves known upfront according to a shelf plan known as the planogram. For each shelf it is necessary to know the location (a number within the shelf), the number of product fronts visible and the number of units on the shelf. Each supermarket has its own planogram.
The products are identified by a barcode with 13 numeric digits known as the EAN13 and have a designation.
Products are organized into named categories. There are no products without a category. There may be categories made up of other categories. That is, the categories form a hierarchy. Categories that have subcategories are designated as 'Super Categories' and categories without subcategories are designated as 'Simple Categories'. A category cannot include itself and there can be no cycles in the category hierarchy. The system has to determine, for a super-category, how many sub-categories there are. Some categories may also require certain shelves (consider for example that cold products require refrigerated shelves).

It is necessary to store the history product replenishments. Replenishments are characterized by the instant they occur and by the number of units replenished (i.e., actually placed on the shelf). There is only one replenishment at each instant. A replenishment cannot replenish more units than those prescribed by the planogram.
Every product is supplied by a supplier that is identified by its TIN. There are multiple secondary suppliers for each product. A supplier can not be primary and secondary at the same time for the same product.
The date on which a supplier became the primary supplier of a particular product must be recorded.
