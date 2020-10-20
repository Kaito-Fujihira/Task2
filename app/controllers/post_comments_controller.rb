class PostCommentsController < ApplicationController

  def create
    # ↓2回目の投稿の際の空の変数を定義している。.new
    @post_comment = PostComment.new
    @book = Book.find(params[:book_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.book_id = @book.id
    @comment.save
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = PostComment.find_by(id: params[:id], book_id: params[:book_id])
    @comment.destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
