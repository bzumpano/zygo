require 'rails_helper'

RSpec.describe "Platform::Books", type: :request do

  describe "GET /index" do
    it 'returns http :success' do
      get platform_books_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it 'returns http :success' do
      get new_platform_book_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'valid' do
      let(:valid_params) do
        { book: attributes_for(:book) }
      end

      context 'redirects to index' do
        before { post(platform_books_path, params: valid_params) }

        it { expect(response).to redirect_to(platform_books_path) }
      end

      it 'create book' do
        expect do
          post(platform_books_path, params: valid_params)
        end.to change(Book, :count).by(1)
      end
    end

    context 'invalid' do
      let(:invalid_params) do
        { book: attributes_for(:book, title: nil) }
      end

      context 'returns http :success' do
        before { post(platform_books_path, params: invalid_params) }

        it { expect(response).to have_http_status(:success) }
      end

      it 'not create book' do
        expect do
          post(platform_books_path, params: invalid_params)
        end.to change(Book, :count).by(0)
      end
    end
  end

  describe "GET /edit" do
    let(:book) { create(:book) }

    it 'returns http :success' do
      get(edit_platform_book_path(book))
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    let(:book) { create(:book) }

    context 'valid' do
      let(:updated_title) { 'Title updated' }
      let(:valid_params) do
        { book: attributes_for(:book, title: updated_title) }
      end

      before { patch(platform_book_path(book), params: valid_params) }

      context 'redirects to index' do
        it { expect(response).to redirect_to(platform_books_path) }
      end

      it 'update book' do
        expect(book.reload.title).to eq(updated_title)
      end
    end

    context 'invalid' do
      let(:invalid_params) do
        { book: attributes_for(:book, title: nil) }
      end

      before { patch(platform_book_path(book), params: invalid_params) }

      context 'returns http :success' do
        it { expect(response).to have_http_status(:success) }
      end

      context 'not update book' do
        it { expect(book.reload.title).not_to eq(nil) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:book) { create(:book) }

    context 'valid' do
      context 'redirects to index' do
        before { delete(platform_book_path(book)) }
        it { expect(response).to redirect_to(platform_books_path) }
      end

      it 'remove book' do
        book

        expect do
          delete(platform_book_path(book))
        end.to change(Book, :count).by(-1)
      end
    end

    context 'invalid' do
      before do
        allow_any_instance_of(Book).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      context 'redirects to index' do
        before { delete(platform_book_path(book)) }
        it { expect(response).to redirect_to(platform_books_path) }
      end

      it 'not destroy book' do
        expect do
          delete(platform_book_path(book))
        end.to change(Book, :count).by(0)
      end
    end
  end

  describe 'GET #show' do
    let(:book) { create(:book) }

    it 'returns http :success' do
      get(platform_book_path(book))
      expect(response).to have_http_status(:success)
    end
  end
end
