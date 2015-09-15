class Preorder < ActiveRecord::Base
  has_one :free_insurance

  private
    def self.search(user, mobile)
      if user&&mobile
        where(['user = ? AND mobile = ?', user.to_s, mobile.to_s])
      end
    end
end
