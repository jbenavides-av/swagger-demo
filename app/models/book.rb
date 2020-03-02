class Book < ApplicationRecord
  belongs_to :genre
  validates :title, :isbn, :genre, presence: true
  validates :title, length: { in: 3..255 }
  validates :isbn, numericality: { only_integer: true }

  def as_json(options = nil)
    {
      id: id,
      title: title,
      isbn: isbn,
      genre: genre.as_json
    }
  end
end
