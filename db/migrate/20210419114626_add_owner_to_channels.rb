class AddOwnerToChannels < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :user, null: true, foreign_key: true
  end
end
