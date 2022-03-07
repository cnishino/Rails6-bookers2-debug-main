class PostCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.book_id = book.id
    if comment.save
      @post_comment = comment
      @book = Book.find(params[:book_id])
    else
      @post_comment = comment
      render :error
    end
    # redirect_to request.referer
  end

  def destroy
    PostComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    @book = Book.find(params[:book_id])
  # redirect_to request.referer
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
