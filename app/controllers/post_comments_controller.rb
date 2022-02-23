class PostCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.post_comment.new(post_comment_params)
    comment.save
    redirect_to request.referer
  end
  
  def destroy
   PostComment.find(params[:id]).destroy
   redirect_to request.referer
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
