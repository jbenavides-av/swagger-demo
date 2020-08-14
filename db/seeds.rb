# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

genre = Genre.create({ name: "Literatura Clásica"})
Book.create(
  [
    { title: "100 años de soledad", isbn: "9789631420494", genre: genre },
    { title: "Don Quijote de la Mancha", isbn: "9780805511963", genre: genre }
  ]
)
