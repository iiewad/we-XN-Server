class AddNewsIdToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :news_id, :integer
  end
end
