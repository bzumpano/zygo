class Book < ApplicationRecord
  include Book::Search

  #  Validations

  validates :title,
    :description,
    :image,
    :author,
    presence: true

  validates_uniqueness_of :title, case_sensitive: false
end
