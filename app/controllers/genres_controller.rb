class GenresController < ApplicationController
  def index
    @genres = Genre.all
    render json: { genres: @genres }, status: :ok
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      render json: { genre: @genre }, status: :created
    else
      render json: { messages: @genre.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
