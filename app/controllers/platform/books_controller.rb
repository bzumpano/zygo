class Platform::BooksController < ApplicationController

  PERMITTED_PARAMS = %i[
    title
    description
    image
    author
  ]

  # helper methods

  helper_method :books, :book, :param_order


  # actions

  def index
    if request.xhr?
      render partial: 'index', layout: false
    else
      render 'index'
    end
  end

  def new
  end

  def create
    if book.save
      flash[:notice] = t('.done')
      redirect_to platform_books_path
    else
      flash.now[:alert] = t('.error')
      render :new
    end
  end

  def edit
  end

  def update
    book.assign_attributes(resource_params) if resource_params.present?

    if book.save
      flash[:notice] = t('.done')
      redirect_to platform_books_path
    else
      flash.now[:alert] = t('.error')
      render :edit
    end
  end

  def destroy
    if book.destroy
      flash[:notice] = t('.done')
      redirect_to platform_books_path
    else
      flash[:notice] = t('.error')
      redirect_to platform_books_path
    end
  end

  def show
    book
  end

  private

  def books
    @books ||= sorted_books
  end

  def filtered_books
    Book.search(params[:search])
  end

  def sorted_books
    filtered_books.order(title: param_order)
  end

  def book
    @book ||= find_action? ? Book.find(params[:id]) : books.new(resource_params)
  end

  def resource_params
    params.require(:book).permit(*PERMITTED_PARAMS) if params[:book]
  end

  def find_action?
    %w[edit update destroy show].include?(action_name)
  end

  def param_order
    params.fetch(:order, :asc)
  end
end
