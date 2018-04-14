class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :title
      t.string :content
      t.integer :stu_user_id

      t.timestamps
    end
  end
end
