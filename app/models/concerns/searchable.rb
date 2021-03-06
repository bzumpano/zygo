# frozen_string_literal: true

#
# Módulo incluído por models que permitem buscas.
#
module Searchable
  extend ActiveSupport::Concern

  # Define quais outros models relacionados ao model principal fará parte da
  # busca. É usado para o 'joins' no search_scope
  # Ex:
  # [
  #   :organ
  # ]
  SEARCH_INCLUDES = [].freeze

  # Define a expressão de busca que será usada para o filtro.
  # Ex:
  # %q{
  #   tickets.protocol = :value OR
  #   tickets.name LIKE :search OR
  #   ...
  #   organs.name LIKE :search
  # }
  #
  # Os parâmetros :search serão automaticamente transformados para buscas do
  # tipo LIKE. Os parâmetros :value serão comparados com o valor exato passado.
  #
  SEARCH_EXPRESSION = '
  '

  class_methods do
    def search(search_term, limit = nil, search_expression = self::SEARCH_EXPRESSION)
      return search_scope if search_term.blank?

      results(search_term, limit, search_expression)
    end

    def search_scope
      includes(search_includes).references(search_includes)
    end

    private

    def search_includes
      self::SEARCH_INCLUDES
    end

    def results(search_term, limit, search_expression)
      # transform o termo de busca para padrão LIKE
      search = '%' + search_term.to_s.tr(' ', '%') + '%'

      # permite que seja buscado por valor exato, como nos casos de coluna 'type'
      value = search_term

      results = search_scope.where(search_expression, search: search, value: value)
      results = results.limit(limit) if limit

      results
    end
  end
end
