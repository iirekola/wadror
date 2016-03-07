class AddLoginModeToUser < ActiveRecord::Migration

  def change
    add_column :users, :login_mode, :string
  end

end
