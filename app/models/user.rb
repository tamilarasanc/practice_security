class User < ApplicationRecord

  def self.create_user(user_params)
    user = self.new(user_params)
    user.save
  end

  def update_user(user_params)
    self.update(user_params)
  end

  def update_password(password)
    self.update_attributes(:password => password)
  end

end
