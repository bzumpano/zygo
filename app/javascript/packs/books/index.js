$(function() {
  'use strict';

  function _init() {
    $('[data-behavior="remote-content"]').each(function() {
      var _container = $(this),
        _domFiltersContainer = _container.find('[data-remote-content="filters"]'),
        _domResultsContainer = _container.find('[data-remote-content="result"]'),
        _filters = _domFiltersContainer.find(':input').not(':hidden'),
        _form = _domFiltersContainer.find('form');

      // events

      _filters.on('change', function() {
        _form.find('input[type="submit"]').click();
      });

      _domFiltersContainer.on('ajax:success', function(aEvent) {
        const [data, status, xhr] = aEvent.detail;
        if (data) {
          _domResultsContainer.html(xhr.responseText);
        }

        _domFiltersContainer.find('input[type=submit]:disabled').prop('disabled', false);
      });

      _form.find('input[type="submit"]').click();
    });
  }

  _init();
});
