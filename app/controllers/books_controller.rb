class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, { only: [:edit, :update, :destroy] }

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to books_path(@book.id), notice: 'You have created book successfully.'
    else
      @user = current_user
      @books = Book.all
      render template: "books/index"
    end
  end

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def show
    @user = User.find(params[:id])
    @book = Book.find(params[:id])
    @book_new = Book.new

  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: 'You have updated book successfully.'
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find_by(id: params[:id])
    return unless @book.user_id != current_user.id
    redirect_to root_path
  end


end
