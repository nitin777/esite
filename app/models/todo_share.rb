class TodoShare < ActiveRecord::Base
  attr_accessible :share_user_id, :user_id
  belongs_to :user
  scope :all_users,      joins("INNER JOIN comments ON events.eventable_id = comments.id").where(:comments => {:commentable_type => %w(Day Week Month)}, :eventable_type => "Comment")

  def self.all_users(user_id)
	joins(:user).where("todo_shares.user_id" => user_id)
  end
  def get_user_email(id)
	@o_email = User.find(id).email unless id.nil?
  end
end
