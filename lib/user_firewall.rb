class UserFirewall
  def initialize
     @allowed_users = %w[dany89_2 adre89] 
  end
  
  def authorized?(user)
    puts "#{user} try to talk with me"
    @allowed_users.include?user
  end
end