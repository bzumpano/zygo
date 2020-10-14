require 'rails_helper'

describe Book::Search do
  let(:book) { create(:book, title: 'abcdef') }
  let(:another_book) { create(:book, title: 'ghij') }

  before do
    book
    another_book
  end

  describe 'title' do
    it { expect(Book.search('a d f')).to eq([book]) }
  end

  describe 'description' do
    let(:book) { create(:book, description: 'abcdef') }
    let(:another_book) { create(:book, description: 'ghij') }

    it { expect(Book.search('a d f')).to eq([book]) }
  end

  describe 'author' do
    let(:book) { create(:book, author: 'abcdef') }
    let(:another_book) { create(:book, author: 'ghij') }

    it { expect(Book.search('a d f')).to eq([book]) }
  end
end
