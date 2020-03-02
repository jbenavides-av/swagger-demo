require 'swagger_helper'

describe 'Genres API' do
  path '/genres' do
    get 'Retrieves genres' do
      tags 'Genres'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'List of genres' do
        schema type: :object, properties: {
          genres: {
            type: :array,
            items: { '$ref' => '#/definitions/Genre' }
          }
        }

        let!(:genre) { Genre.create(name: 'Ficción') } 

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["genres"]
          expect(data["genres"].size).to eq 1
          expect(data["genres"].first["name"]).to eq "Ficción"
        end
      end
    end

    post 'Create genre' do
      tags 'Genres'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :genre, in: :body, schema: {
        type: :object,
        properties: {
          genre: {
            '$ref' => '#/definitions/Genre'
          }
        },
        required: ['genre']
      }

      response '201', 'Genre created' do
        schema type: :object, properties: {
          genre: { '$ref' => '#/definitions/Genre' }
        }

        # Variable name should be the same as defined in the parameter method (line 33)
        # In other words, let and parameter names should be the same
        let(:genre) do
          {
            genre: { 
              name: "Ficción" 
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["genre"]
          expect(data["genre"]["id"]).to eq Genre.last.id
          expect(data["genre"]["name"]).to eq "Ficción"
        end
      end

      response '422', 'Invalid parameters' do
        schema '$ref' => '#/definitions/ErrorResponse'

        # Variable name should be the same as defined in the parameter method (line 33)
        # In other words, let and parameter names should be the same
        let(:genre) do
          {
            genre: { 
              name: "a" 
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to eq ["messages"]
          expect(data["messages"].first).to eq "Name is too short (minimum is 3 characters)"
        end
      end
    end
  end
end