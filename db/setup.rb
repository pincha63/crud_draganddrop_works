require 'sequel'
require 'sqlite3'

# Connect to SQLite database
DB = Sequel.sqlite('db/library.sqlite3')

# Create tables
DB.create_table? :authors do
  primary_key :id
  String :name, null: false
  String :bio
end

DB.create_table? :publishers do
  primary_key :id
  String :name, null: false
  String :address
end

# Many-to-many join table
DB.create_table? :authors_publishers do
  foreign_key :author_id, :authors, null: false, on_delete: :cascade
  foreign_key :publisher_id, :publishers, null: false, on_delete: :cascade
  primary_key [:author_id, :publisher_id]
end

# Seed data
if DB[:authors].count == 0
  a1 = DB[:authors].insert(name: 'J.K. Rowling', bio: 'Author of Harry Potter')
  a2 = DB[:authors].insert(name: 'Stephen King', bio: 'Master of horror')
  
  p1 = DB[:publishers].insert(name: 'Bloomsbury', address: 'London, UK')
  p2 = DB[:publishers].insert(name: 'Scribner', address: 'New York, USA')
  
  DB[:authors_publishers].insert(author_id: a1, publisher_id: p1)
  DB[:authors_publishers].insert(author_id: a2, publisher_id: p2)
  DB[:authors_publishers].insert(author_id: a1, publisher_id: p2) # Multiple publishers for one author
end

puts "Database setup complete."
