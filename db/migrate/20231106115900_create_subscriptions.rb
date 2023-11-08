class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false
      t.belongs_to :question, null: false
      t.timestamps
    end
  end
end
