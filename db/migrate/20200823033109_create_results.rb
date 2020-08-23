class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.string :query, null: false
      t.datetime :before, null: false
      t.datetime :after, null: false
      t.string :interval, null: false
      t.jsonb :body, default: {}

      t.timestamps
    end
  end
end
