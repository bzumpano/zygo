# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #index' do
    before { get(:index) }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      context 'books' do
        let!(:books) { create_list(:book, 2) }

        it { expect(view_context.books).to match_array(books) }
      end
    end
  end

  describe 'GET #new' do
    before { get(:new) }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      describe 'book' do
        it { expect(view_context.book).to be_new_record }
      end
    end
  end

  describe 'POST #create' do
    let(:permitted_params) do
      %i[
        title
        description
        image
        author
      ]
    end

    let(:valid_params) do
      { book: attributes_for(:book) }
    end

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { post(:create, params: valid_params) }

      describe 'book' do
        it { expect(view_context.book).to be_persisted }
      end
    end

    describe 'permitted_params' do
      it { is_expected.to permit(*permitted_params).for(:create, params: valid_params).on(:book) }
    end

    describe 'valid' do
      it 'saves' do
        expect do
          post(:create, params: valid_params)
        end.to change(Book, :count).by(1)
      end

      context 'redirect to index' do
        let(:expected_flash) { I18n.t('books.create.done') }

        before { post(:create, params: valid_params) }

        it { expect(response).to redirect_to(books_path) }
        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      before { allow_any_instance_of(Book).to receive(:valid?).and_return(false) }

      it 'does not save' do
        expect do
          post(:create, params: valid_params)
        end.to change(Book, :count).by(0)
      end

      context 'render new with errors' do
        let(:expected_flash) { I18n.t('books.create.error') }

        before { post(:create, params: valid_params) }

        it { expect(controller).to set_flash.now.to(expected_flash) }
      end
    end
  end

  describe 'GET #edit' do
    let(:book) { create(:book) }

    before { get(:edit, params: { id: book }) }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      describe 'book' do
        it { expect(view_context.book).to eq(book) }
      end
    end
  end

  describe 'PATCH #update' do
    let(:book) { create(:book) }

    let(:permitted_params) do
      %i[
        title
        description
        image
        author
      ]
    end

    let(:valid_params) do
      {
        id: book,
        book: { title: new_title }
      }
    end

    let(:new_title) { 'New name' }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { patch(:update, params: valid_params) }

      describe 'book' do
        it { expect(view_context.book).to eq(book) }
      end
    end

    it 'permitted_params' do
      expect(subject).to permit(*permitted_params).for(:update, params: valid_params).on(:book)
    end

    context 'valid' do
      context 'saves' do
        before { patch(:update, params: valid_params) }

        it { expect(book.reload.title).to eq(new_title) }
      end

      context 'redirect to index' do
        let(:expected_flash) { I18n.t('books.update.done') }

        before { patch(:update, params: valid_params) }

        it { expect(response).to redirect_to(books_path) }
        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      render_views

      context 'does not save' do
        # invalid because is not unique name
        let(:new_title) { create(:book).title }

        before { patch(:update, params: valid_params) }

        it { expect(book.reload.title).not_to eq(new_title) }
        it { expect(controller).to set_flash.now.to(I18n.t('books.update.error')) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:book) { create(:book) }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { delete(:destroy, params: { id: book }) }

      describe 'book' do
        it { expect(view_context.book).to eq(book) }
      end
    end

    context 'valid' do
      it 'destroys' do
        book

        expect do
          delete(:destroy, params: { id: book })

          expect(response).to redirect_to(books_path)
        end.to change(Book, :count).by(-1)
      end

      context 'redirect to index' do
        before { delete(:destroy, params: { id: book }) }

        it { expect(response).to redirect_to(books_path) }
      end

      context 'set flash' do
        let(:expected_flash) { I18n.t('books.destroy.done') }

        before { delete(:destroy, params: { id: book }) }

        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      before { allow_any_instance_of(Book).to receive(:destroy).and_return(false) }

      it 'does not destroys' do
        book

        expect do
          delete(:destroy, params: { id: book })

          expect(response).to redirect_to(books_path)
        end.to change(Book, :count).by(0)
      end

      context 'redirect to index' do
        before { delete(:destroy, params: { id: book }) }

        it { expect(response).to redirect_to(books_path) }
      end

      context 'set flash' do
        let(:expected_flash) { I18n.t('books.destroy.error') }

        before { delete(:destroy, params: { id: book }) }

        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end
  end
end
