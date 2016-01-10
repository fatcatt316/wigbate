class AddComicToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :comic, :string
  end
end
