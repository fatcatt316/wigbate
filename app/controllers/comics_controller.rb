class ComicsController < ApplicationController
	before_action :authenticate_admin!
	before_action :set_post

  def create
    add_more_comics(comics_params[:comics])
    flash[:alert] = 'Nooo, failed to upload that image' unless @post.save
    redirect_to edit_post_path(@post)
  end

  def destroy
  	if @post.comics.size > 1
	    remove_comic_at_index(params[:id].to_i)
	    flash[:alert] = "Dangit, couldn't delete that image" unless @post.save
	  else
	  	flash[:alert] = "You can't delete the last image of a comic, c'mon man."
	  end
    redirect_to edit_post_path(@post)
  end

  private def set_post
    @post = Post.find(params[:post_id])
  end

  private def add_more_comics(new_comics)
    comics = @post.comics # copy the old comics 
    comics += new_comics # concat old comics with new ones
    @post.comics = comics # assign back
  end

  private def remove_comic_at_index(index)
    remaining_comics = @post.comics # copy the array
    return unless remaining_comics.size > 1 # Don't delete last comic of a post
    deleted_comic = remaining_comics.delete_at(index) # delete the target comic
    deleted_comic&.remove! # delete comic from S3
    @post.comics = remaining_comics # re-assign back
  end

  private def comics_params
    params.require(:post).permit({comics: []})
  end
end
