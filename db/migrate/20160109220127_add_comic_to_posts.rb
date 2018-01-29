class AddComicToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :comic, :string
  end
end
