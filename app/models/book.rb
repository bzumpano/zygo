# frozen_string_literal: true

class Book < ApplicationRecord
  include Book::Search

  acts_as_favoritable

  #  Validations

  validates :title,
            :description,
            :image,
            :author,
            presence: true

  validates :title, uniqueness: { case_sensitive: false }
end
