class BooksController < ApplicationController
  impressionist :actions=> [:show,:index]

  def show
    @books = Book.find(params[:id])
    @user = @books.user
    @book = Book.new
    @comment = PostComment.new
    @comments = @books.post_comments
    impressionist(@books, nil, unique: [:session_hash.to_s])
    

  end

  def index
    @books = Book.all
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @book = Book.new
    @users = User.all
    @user = current_user
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render "edit"
    else
      redirect_to books_path
    end
  end


  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

end
