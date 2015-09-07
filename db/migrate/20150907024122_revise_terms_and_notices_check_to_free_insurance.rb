class ReviseTermsAndNoticesCheckToFreeInsurance < ActiveRecord::Migration
  def change
    remove_column :free_insurances, :accepted_terms
    remove_column :free_insurances, :accepted_notices

    add_column :free_insurances, :accepted_all_terms, :boolean
  end
end
