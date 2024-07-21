class AgregarDeviseLockable < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :failed_attempts, :integer, default: 0
    add_column :usuarios, :unlock_token, :string
    add_column :usuarios, :locked_at, :datetime
  end
end
