# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.references :linkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
