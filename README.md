# E-commerce Database Design Project

## 🎯 Objective
This project will help you master the art of database design. Your group will collaboratively design an Entity-Relationship Diagram (ERD) and build an e-commerce database from scratch.

---

## 🛠️ Instructions
1. **Create an ERD** ✍️  
   - Define all entities (tables) and their attributes.  
   - Document relationships between tables.  
   - Identify primary keys, foreign keys, and constraints.  
   - Use tools like Lucidchart, draw.io, dbdiagram.io, or MySQL Workbench to create the ERD.

2. **Plan the Data Flow** 🔄  
   - Map how data flows between entities.  
   - Discuss database structure as a team.  

3. **Group Collaboration** 🤝  
   - Work together on analysis, design, and implementation.  
   - Use GitHub for version control, documentation, and version tracking.  

4. **Submission** 🚀  
   - Upload the ERD diagram and `ecommerce.sql` file to this repository.  
   - Ensure all files are accessible to reviewers.

---

## 🗃️ Tables to Be Created
### Core Tables
- `product_image`: Stores product image URLs or file references.
- `color`: Manages available color options.
- `product_category`: Classifies products into categories (e.g., clothing, electronics).
- `product`: Stores general product details (name, brand, base price).
- `product_item`: Represents purchasable items with specific variations.
- `brand`: Stores brand-related data.
- `product_variation`: Links a product to its variations (e.g., size, color).
- `size_category`: Groups sizes into categories (e.g., clothing sizes, shoe sizes).
- `size_option`: Lists specific sizes (e.g., S, M, L, 42).

### Attribute Tables
- `product_attribute`: Stores custom attributes (e.g., material, weight).
- `attribute_category`: Groups attributes into categories (e.g., physical, technical).
- `attribute_type`: Defines types of attributes (e.g., text, number, boolean).

---

## 📂 Deliverables
1. **ERD**: A visual representation of the database structure.
2. **SQL Schema**: [ecommerce.sql](./ecommerce.sql) for creating the database.

---

## ERD Diagram
To be added. Design the ERD using a tool like Lucidchart or dbdiagram.io, then upload it to this repository as `docs/ERD.png` or similar.
