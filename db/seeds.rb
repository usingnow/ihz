# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Preorder.delete_all

# params.require(:preorder).permit(:user, :mobile, :id_num, :gender,
#                                  :remarks, :used)

po = Preorder.create([
  { user: '刘备', mobile: '13912345678', gender: true, id_num: '310101198001012419', used: true, remarks: '汉昭烈帝' },
  { user: '曹操', mobile: '13912345677', gender: true, id_num: '310102198002022439', used: false, remarks: '魏武帝东临碣石' },
  { user: '孙尚香', mobile: '18612345678', gender: false, id_num: '11001119820303244x', used: false, remarks: '少主~好嫩的PP啊' },
  { user: '赵云', mobile: '15212345678', gender: true, id_num: '81200119810404123X', used: false, remarks: '嫂嫂，放下阿斗，向我来~'}
])

FreeInsurance.delete_all

# params.require(:free_insurance).permit(:user, :mobile, :birthday, :processed, :accepted, :email,
#                                        :id_num, :id_type, :gender, :accepted_all_terms,
#                                        :processed, :province, :city, :address, :activated,
#                                        :free_insurance_no, :metlife_msg)


fi = FreeInsurance.create([
  {
    user: '刘备', mobile: '13912345678', birthday: '1980-01-01', processed: true, accepted: true,
    email: 'bei.liu@email.com', id_num: '310101198001012419', id_type: 'IdentityCard', gender: true,
    accepted_all_terms: true, province: '成都市', city: '成都市', address: '成都市', activated: true,
    free_insurance_no: 'FP0029583218|FP0029583219|FP002958322|FP0029583224|', metlife_msg: '承保成功',
    preorder_id: 1
  }
])