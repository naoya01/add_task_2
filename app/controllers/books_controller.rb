class BooksController < ApplicationController
  impressionist :actions=> [:show,:index,:search]

  def show
    @books = Book.find(params[:id])
    @user = @books.user
    @book = Book.new
    @comment = PostComment.new
    @comments = @books.post_comments
    impressionist(@books, nil, unique: [:session_hash.to_s])


  end

  def index
    @books = Book.all # 本全部 #

    # @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}　bookモデルで定義したfavarited_useでいい数を比較
    # @books = Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size} #いいね数を比較して順番を決めている#


    to  = Time.current.at_end_of_day #今日の23:59の日時を取得 (toは任意)#
    from  = (to - 6.day).at_beginning_of_day #6日前の0:00の日時取得 (fromは任意)#
    @books = Book.includes(:favorites).sort {|a,b|
        b.favorites.includes(:favorites).where(created_at: from...to).size <=>
        a.favorites.includes(:favorites).where(created_at: from...to).size
      }

    @book = Book.new
    @users = User.all
    @user = current_user
    if params[:sort_update]
     @books = Book.all.order(created_at: :desc)
    elsif params[:sort_evaluation]
      @books = Book.latest
    elsif params[:sort_favorite]
      @books = Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size} #いいね数を比較して順番を決めている#
    else
      @books = Book.all
    end


  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      # @books = Book.all
      # @user =
      # @book = Book.new
      # @users = User.all
      # @user = current_user
      # render 'index'
      redirect_to books_path
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

  def search
    @book = Book.new
    @books = Book.search(params[:keyword])
    @user = current_user
  end
  private

  def book_params
    params.require(:book).permit(:title,:body,:evaluation,:category)
  end

end
