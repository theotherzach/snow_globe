class CreateShoppingCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_carts do |t|
      t.references :user, foreign_key: true
      t.references :address, foreign_key: true
      t.integer :shipping_method
      t.references :discount_code, foreign_key: true

      t.timestamps
    end
  end
end
