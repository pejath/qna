# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.boolean :value
      t.belongs_to :user, foreign_key: true
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
