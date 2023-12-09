class Usuario < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :recoverable, :invitable
end
