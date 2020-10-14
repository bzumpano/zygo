require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    describe 'unauthorized' do
      before { get books_path }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      it 'returns http :success' do
        get books_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /new" do
    describe 'unauthorized' do
      before { get new_book_path }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      it 'returns http :success' do
        get new_book_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { book: attributes_for(:book) }
    end

    describe 'unauthorized' do
      before { post(books_path, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        context 'redirects to index' do
          before { post(books_path, params: valid_params) }

          it { expect(response).to redirect_to(books_path) }
        end

        it 'create book' do
          expect do
            post(books_path, params: valid_params)
          end.to change(Book, :count).by(1)
        end
      end

      context 'invalid' do
        let(:invalid_params) do
          { book: attributes_for(:book, title: nil) }
        end

        context 'returns http :success' do
          before { post(books_path, params: invalid_params) }

          it { expect(response).to have_http_status(:success) }
        end

        it 'not create book' do
          expect do
            post(books_path, params: invalid_params)
          end.to change(Book, :count).by(0)
        end
      end
    end
  end

  describe "GET /edit" do
    let(:book) { create(:book) }

    describe 'unauthorized' do
      before { get(edit_book_path(book)) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      it 'returns http :success' do
        get(edit_book_path(book))
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PATCH #update' do
    let(:book) { create(:book) }

    let(:updated_title) { 'Title updated' }
    let(:valid_params) do
      { book: attributes_for(:book, title: updated_title) }
    end

    describe 'unauthorized' do
      before { patch(book_path(book), params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        before { patch(book_path(book), params: valid_params) }

        context 'redirects to index' do
          it { expect(response).to redirect_to(books_path) }
        end

        it 'update book' do
          expect(book.reload.title).to eq(updated_title)
        end
      end

      context 'invalid' do
        let(:invalid_params) do
          { book: attributes_for(:book, title: nil) }
        end

        before { patch(book_path(book), params: invalid_params) }

        context 'returns http :success' do
          it { expect(response).to have_http_status(:success) }
        end

        context 'not update book' do
          it { expect(book.reload.title).not_to eq(nil) }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:book) { create(:book) }

    describe 'unauthorized' do
      before { delete(book_path(book)) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        context 'redirects to index' do
          before { delete(book_path(book)) }
          it { expect(response).to redirect_to(books_path) }
        end

        it 'remove book' do
          book

          expect do
            delete(book_path(book))
          end.to change(Book, :count).by(-1)
        end
      end

      context 'invalid' do
        before do
          allow_any_instance_of(Book).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
        end

        context 'redirects to index' do
          before { delete(book_path(book)) }
          it { expect(response).to redirect_to(books_path) }
        end

        it 'not destroy book' do
          expect do
            delete(book_path(book))
          end.to change(Book, :count).by(0)
        end
      end
    end
  end
end
