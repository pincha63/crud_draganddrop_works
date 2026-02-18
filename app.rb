require 'roda'
require 'sequel'
require 'json'
require 'slim'
require 'sqlite3'
require 'rack'
require_relative "LibraryHelpers"

# Connect to database
DB = Sequel.sqlite('db/library.sqlite3')

class LibraryApp < Roda
  plugin :render, engine: 'slim', views: 'views'
  plugin :sessions, secret: 'a' * 64
  plugin :flash
  plugin :all_verbs
  plugin :static, ['/css'], root: 'public'
  plugin :path
  plugin :status_handler

  include LibraryHelpers

  route do |r|
    # Root redirects to authors
    r.root do
      r.redirect "/authors"
    end

    # Relationships Management
    r.on "relationships" do

      r.get "drag_drop" do
        view("relationships/drag_drop", locals: { 
          all_authors: DB[:authors].all, 
          all_publishers: DB[:publishers].all,
          author_publisher_ids: get_relations_map
        })
      end

      r.get do
        view("relationships/edit", locals: { 
          all_authors: DB[:authors].all, 
          all_publishers: DB[:publishers].all,
          author_publisher_ids: get_relations_map
        })
      end

      # New bulk update route for drag-and-drop
      r.put "bulk" do
        author_id = r.params['author_id'].to_i
        pub_ids = r.params['publisher_ids']
        update_author_publishers(author_id, pub_ids)
        flash[:notice] = "Relationships updated successfully"
        r.redirect "/relationships/drag_drop"
      end

      r.put do
        author_id = r.params['author_id'].to_i
        pub_ids = r.params['publisher_ids']
        update_author_publishers(author_id, pub_ids)
        flash[:notice] = "Relationships updated for author"
        r.redirect "/authors"
      end
    end

    # Authors CRUD
    r.on "authors" do
      # List Authors (Read)
      r.is do
        r.get do
          authors = DB[:authors].all
          # Fetch publishers for each author to show in list
          author_publishers = {}
          DB[:authors_publishers].join(:publishers, id: :publisher_id).all.each do |row|
            (author_publishers[row[:author_id]] ||= []) << row
          end
          view("authors/index", locals: { authors: authors, author_publishers: author_publishers })
        end

        # Create Author (Post)
        r.post do
          author_params = r.params['author']
          pub_ids = r.params['publisher_ids']
          id = DB[:authors].insert(author_params)
          update_author_publishers(id, pub_ids)
          flash[:notice] = "Author created successfully"
          r.redirect "/authors"
        end
      end

      # New Author Form
      r.get "new" do
        view("authors/edit", locals: { author: nil, all_publishers: DB[:publishers].all, author_publisher_ids: [] })
      end

      # Specific Author Operations
      r.on Integer do |id|
        author = DB[:authors][id: id]
        
        # Update Author (Put)
        # Note: 'all_verbs' plugin allows this to be called via POST form with _method=PUT
        r.put do
          author_params = r.params['author']
          pub_ids = r.params['publisher_ids']
          DB[:authors].where(id: id).update(author_params)
          update_author_publishers(id, pub_ids)
          flash[:notice] = "Author updated successfully"
          r.redirect "/authors"
        end

        # Delete Author (Delete)
        # Note: 'all_verbs' plugin allows this via POST form with _method=DELETE
        r.delete do
          DB[:authors].where(id: id).delete
          flash[:notice] = "Author deleted"
          r.redirect "/authors"
        end

        # Edit Author Form
        r.get "edit" do
          pub_ids = DB[:authors_publishers].where(author_id: id).map(:publisher_id)
          view("authors/edit", locals: { author: author, all_publishers: DB[:publishers].all, author_publisher_ids: pub_ids })
        end
      end
    end # authors CRUD

    # Publishers CRUD
    r.on "publishers" do
      r.is do
        r.get do
          view("publishers/index", locals: { publishers: DB[:publishers].all })
        end

        r.post do
          DB[:publishers].insert(r.params['publisher'])
          flash[:notice] = "Publisher created"
          r.redirect "/publishers"
        end
      end

      r.get "new" do
        view("publishers/edit", locals: { publisher: nil })
      end

      r.on Integer do |id|
        r.put do
          DB[:publishers].where(id: id).update(r.params['publisher'])
          flash[:notice] = "Publisher updated"
          r.redirect "/publishers"
        end

        r.delete do
          DB[:publishers].where(id: id).delete
          flash[:notice] = "Publisher deleted"
          r.redirect "/publishers"
        end

        r.get "edit" do
          view("publishers/edit", locals: { publisher: DB[:publishers][id: id] })
        end
      end # specific publisher
    end # publishers CRUD
  end # route
end # class LibraryApp
