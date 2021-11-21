class PostCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.book_id = @book.id
    @comment.save
    @comments = @book.post_comments
    render :index
  end

  def destroy
    @comment = PostComment.find_by(id: params[:id])
    @comment.destroy
    @book = Book.find(params[:book_id])
    @comments = @book.post_comments
    render :index

  end

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
