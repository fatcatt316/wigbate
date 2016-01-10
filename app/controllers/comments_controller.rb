class CommentsController < ApplicationController
  before_action :authenticate_admin!, except: [:show, :index, :create, :new]
  before_action :set_post
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = @post.comments
  end

  def show
  end

  def new
    @comment = @post.comments.new
  end

  def edit
  end

  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to @post, notice: '¡Thanks for your comment!'
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @post, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'That comment is gone for good.'
  end

  private

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :author)
  end
end
