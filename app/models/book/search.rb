module Book::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(books.title) LIKE LOWER(:search) OR
    LOWER(books.description) LIKE LOWER(:search) OR
    LOWER(books.author) LIKE LOWER(:search)
  }
end
