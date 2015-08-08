class FreeInsurance < ActiveRecord::Base
  validates_presence_of :user, :mobile, :birthday, :email
  validates_length_of :mobile, is: 11, message: "需填写11位手机号，无需0086或者+86。"
  validates_uniqueness_of :mobile, message: "该手机已经领取过，请核实，谢谢。"
  validates_format_of :mobile, with: /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/, :multiline => true, message: "请确保您填写是有效手机号码。"
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :multiline => true, message: "请填写有效邮件地址。"
end
