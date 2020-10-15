# frozen_string_literal: true

module Book
  module Search
    extend ActiveSupport::Concern
    include Searchable

    # Consts

    SEARCH_EXPRESSION = '
    LOWER(books.title) LIKE LOWER(:search) OR
    LOWER(books.description) LIKE LOWER(:search) OR
    LOWER(books.author) LIKE LOWER(:search)
  '
  end
end
