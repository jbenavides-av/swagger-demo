class BooksController < ApplicationController
  before_action :find_genre, only: :create

  def index
    @books = Book.includes(:genre).all
    render json: { books: @books }, status: :ok
  end

  def show
    @book = Book.includes(:genre).find(params[:id])
    render json: { book: @book }, status: :ok
  end

  def create
    @book = Book.new(book_params.merge!({genre: @genre}))
    if @book.save
      render json: { book: @book }, status: :created
    else
      render json: { messages: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_genre
    begin
      @genre = Genre.find genre_params[:id]
    rescue ActiveRecord::RecordNotFound
      return render json: { messages: ["Genre not found"] }, status: :not_found
    end
  end

  def book_params
    params.require(:book).permit(:title, :isbn)
  end

  def genre_params
    params.require(:book).require(:genre).permit(:id)
  end
end
