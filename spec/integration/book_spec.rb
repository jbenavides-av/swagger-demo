require 'swagger_helper'

describe 'Books API' do
  path '/books' do
    # Index action for the books controller
    get 'Fetch books' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'List of books' do
        schema type: :object, properties: {
          books: {
            type: :array,
            items: { '$ref' => '#/definitions/Book' }
          }
        }

        let(:genre) { Genre.create(name: 'Ficcion') }
        let!(:book) { Book.create(title: 'Book #1', isbn: 12345, genre: genre) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["books"]
          expect(data["books"].size).to eq 1
          expect(data["books"].first["title"]).to eq "Book #1"
        end
      end
    end

    # Create action for the books controller
    post 'Creates a book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          book: {
            '$ref' => '#/definitions/Book'
          }
        },
        required: ['book']
      }

      response '201', 'Book created' do
        schema type: :object, properties: {
          book: { '$ref' => '#/definitions/Book' }
        }

        let!(:genre) { Genre.create(name: "Drama") }

        # Variable name should be the same as defined in the parameter method (line 34)
        # In other words, let and parameter names should be the same
        let(:book) do
          {
            book: {
              title: "100 años de soledad",
              isbn: 9789631420494,
              genre: {
                id: genre.id,
                name: genre.name
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["book"]
          expect(data["book"]["id"]).to eq Book.last.id
          expect(data["book"]["title"]).to eq "100 años de soledad"
        end
      end

      response '404', 'Genre not found' do
        schema '$ref' => '#/definitions/ErrorResponse'

        # Variable name should be the same as defined in the parameter method (line 34)
        # In other words, let and parameter names should be the same
        let(:book) do
          {
            book: {
              title: "100 años de soledad",
              isbn: 9789631420494,
              genre: {
                id: "-1",
                name: "Unexistent genre"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["messages"]
          expect(data["messages"].first).to eq "Genre not found"
        end
      end

      response '422', 'Invalid parameters' do
        schema '$ref' => '#/definitions/ErrorResponse'

        let!(:genre) { Genre.create(name: "Drama") }

        # Variable name should be the same as defined in the parameter method (line 34)
        # In other words, let and parameter names should be the same
        let(:book) do
          {
            book: {
              title: "10",
              isbn: 9789631420494,
              genre: {
                id: genre.id,
                name: genre.name
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["messages"]
          expect(data["messages"].first).to eq "Title is too short (minimum is 3 characters)"
        end
      end
    end
  end

  # Show action for the books controller
  path '/books/{id}' do
    get 'Fetch a book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Book information' do
        schema type: :object, properties: {
          book: { '$ref' => '#/definitions/Book' }
        }

        let(:genre) { Genre.create(name: 'Ficcion') }
        let!(:book) { Book.create(title: 'Book #1', isbn: 12345, genre: genre) }
        let(:id) { book.id } # Should have the same name as the parameter name defined in line 133

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["book"]
          expect(data["book"]["id"]).to eq book.id
          expect(data["book"]["title"]).to eq "Book #1"
          expect(data["book"]["isbn"]).to eq 12345
          expect(data["book"]["genre"]["id"]).to eq genre.id
          expect(data["book"]["genre"]["name"]).to eq "Ficcion"
        end
      end

      response '404', 'Book not found' do
        schema '$ref' => '#/definitions/ErrorResponse'

        let(:id) { -1 } # Should have the same name as the parameter name defined in line 133

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["messages"]
          expect(data["messages"].first).to eq "Couldn't find Book with 'id'=-1"
        end
      end
    end
  end
end
