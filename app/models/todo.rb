class Todo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :desc, :status, :title, :user_id
  validates :title, :presence => true
  def self.search_pending(search, user_id)
    if search
     	where('title LIKE ? AND status IS NULL AND user_id = ?', "%#{search}%", user_id)
    else
     	where('status IS NULL AND user_id = ?', user_id)
    end
  end
  def self.search_completed(search, user_id)
    if search
     	where('title LIKE ? AND status = ? AND user_id = ?', "%#{search}%", "done", user_id)
    else
     	where('status = ? AND user_id = ?', "done", user_id)
    end
  end
  def get_user_email(id)
	@o_email = User.find(id).email unless id.nil?
  end
end
