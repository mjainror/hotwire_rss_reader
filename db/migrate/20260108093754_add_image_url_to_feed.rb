class AddImageUrlToFeed < ActiveRecord::Migration[8.1]
  def change
    add_column :feeds, :image_url, :text
  end
end
