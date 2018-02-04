class PostsController < ApplicationController
  before_action :authenticate_admin!, except: [:show, :index, :random]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
    @comment = @post.comments.new(params[:comment])
  end

  def random
    random_post = Post.random(exclude_id: params[:exclude_id])
    redirect_to random_post.presence || root_url
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, alert: 'Post could not be created.'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, alert: 'Post could not be updated.'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, {comics: [] })
  end
end
