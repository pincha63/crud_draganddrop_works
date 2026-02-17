# Library Management System (Ruby, Roda, Sequel, SQLite)

This is a full-featured Ruby 3.4 web application designed to manage Authors, Publishers, and their complex many-to-many relationships. Built with a focus on efficiency, it features a modern drag-and-drop interface and strict single-screen layout.

---

## 1. Project Overview
The application serves as a robust example of a Ruby web stack using the Routing Tree pattern. It manages a SQLite database with three tables:
1. **Authors**: Individual writers with names and biographies.
2. **Publishers**: Companies with names and addresses.
3. **Authors-Publishers**: A many-to-many join table linking the two.

---

## 2. Technical Architecture
The code is structured into several distinct layers:
1. **Routing (Roda)**: Uses a tree-based routing system in `app.rb` for high performance and clean URL structures.
2. **Database (Sequel)**: An ORM-like toolkit that handles all SQL queries, table creation, and relationship management.
3. **Templating (Slim)**: A minimalist template engine that generates HTML with significantly less boilerplate than standard ERB.
4. **Styling (Sass)**: Compiled CSS that enforces a "no-scroll" policy, ensuring all tools are visible on one screen.

---

## 3. Detailed Code Breakdown

### 3.1. Database Schema (`db/setup.rb`)
- Defines the tables and their constraints.
- Uses `foreign_key` with `on_delete: :cascade` to ensure that if an author or publisher is deleted, their relationships are automatically cleaned up.

### 3.2. Core Logic (`app.rb`)
- **Plugin System**: Uses `all_verbs` and `Rack::MethodOverride` to support `PUT` and `DELETE` requests from standard HTML forms.
- **Helper Methods**: Includes `update_author_publishers` which synchronizes the many-to-many links in a single transaction-like step.
- **Routing Tree**: Organizes endpoints by resource (`/authors`, `/publishers`, `/relationships`).

### 3.3. Views (`views/`)
- **Layout**: The global frame including navigation and flash message alerts.
- **CRUD Views**: Reusable forms for creating and editing records.
- **Advanced Manager**: A sophisticated drag-and-drop interface powered by vanilla JavaScript for managing complex links.

---

## 4. Full HTTP Verb Coverage
Standard browsers only support `GET` and `POST`. This app achieves full RESTful coverage:
1. **POST**: Used for creating new records.
2. **PUT**: Used for updating existing records. Triggered by a hidden `<input type="hidden" name="_method" value="PUT">` field.
3. **DELETE**: Used for removing records. Triggered by a hidden `<input type="hidden" name="_method" value="DELETE">` field within a form.

---

## 5. Usage Instructions for New Users

### 5.1. Initial Setup
1. **Install Ruby**: Ensure you have Ruby 3.4 installed.
2. **Install Gems**: Run `bundle install` or manually install: roda, sequel, slim, sqlite3, json, rack, rack-session, rackup, base64, puma, sass, sass-embedded (your mileage may vary esp. for base64 and sass)
3. **Initialize DB**: Run `ruby db/setup.rb` to create the database and seed initial data.

### 5.2. Managing Data
1. **Authors/Publishers**: Click the respective tabs to list records. Use "Add New" to create, or "Edit" to modify existing ones.
2. **Deleting**: Click the red "Delete" button. A confirmation prompt will appear to prevent accidental loss.

### 5.3. Managing Relationships (The Drag-and-Drop Way)
1. Navigate to **Drag & Drop Manager**.
2. **Select an Author** from the dropdown menu.
3. **Drag Publishers** from the "Available" box to the "Current" box to link them.
4. **Drag Back** to remove a link.
5. **Undo**: If you make a mistake before saving, click "Undo" to reset the boxes.
6. **Save**: Click the green "Save Changes" button to commit your new configuration to the database.

---

## 6. Design Principles
- **Sans-Serif Only**: All text uses clean, modern fonts for readability.
- **Zero Scrolling**: The layout is engineered to fit 100% of the interface within your browser window height.
- **Instant Feedback**: Uses flash messages (green/red bars) to confirm every successful action or error.
