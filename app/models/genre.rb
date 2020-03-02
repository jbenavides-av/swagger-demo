class Genre < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { in: 3..255 }

  def as_json(options = nil)
    {
      id: id,
      name: name
    }
  end
end
