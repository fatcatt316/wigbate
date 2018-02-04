class AddComicsToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :comics, :text, array: true, default: [] # add comics column as array
  end
end
