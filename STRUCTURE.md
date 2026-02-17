# Library App Structure

This document explains the architecture and implementation details of the Library CRUD application.

## Technology Stack
- **Language**: Ruby 3.0
- **Web Framework**: [Roda](http://roda.jeremyevans.net/) (Routing Tree Web Toolkit)
- **Database Toolkit**: [Sequel](http://sequel.jeremyevans.net/)
- **Database**: SQLite 3
- **Templating**: [Slim](http://slim-lang.com/)
- **Styling**: Sass (SCSS)

## Project Layout
```text
library_app/
├── app.rb              # Main application logic and routing
├── config.ru           # Rack configuration for starting the server
├── STRUCTURE.md        # This documentation
├── assets/
│   └── sass/
│       └── app.scss    # Source styling
├── db/
│   ├── library.db      # SQLite database file
│   └── setup.rb        # Database schema and seed script
├── public/
│   └── css/
│       └── app.css     # Compiled CSS
├── views/
    ├── layout.slim     # Main layout template
    ├── authors/        # Author-related views (index, edit)
    ├── publishers/     # Publisher-related views (index, edit)
    └── relationships/  # Relationship management views (edit, drag_drop)
## Database Schema
The application uses a relational schema with a many-to-many relationship:
- **authors**: `id`, `name`, `bio`
- **publishers**: `id`, `name`, `address`
- **authors_publishers**: `author_id`, `publisher_id` (Join table with foreign keys and cascade delete)

## Full HTTP Verb Coverage
Standard HTML forms only support `GET` and `POST`. To achieve full RESTful verb coverage (`PUT`, `DELETE`), this application uses the Roda `all_verbs` plugin.

### Implementation:
1. **Form Configuration**: Forms are submitted via `POST`.
2. **Hidden Field**: A hidden input named `_method` is added to the form.
   ```slim
   input type="hidden" name="_method" value="PUT"
   ```
3. **Server-side Handling**: Roda detects this parameter and routes the request as the specified HTTP verb.

## Design Constraints
- **Sans-serif Fonts**: Enforced via CSS.
- **No Scrolling**: The application uses a flexbox layout with `overflow: hidden` on the body and containers to ensure all content fits within the viewport.
- **Smaller Type**: Font sizes are reduced to maximize information density without scrolling.

## Running the Application
To start the application locally:
```bash
rackup -p 9292
```
The app will be available at `http://localhost:9292`.
