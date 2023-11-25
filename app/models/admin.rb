# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id         :bigint           not null, primary key
#  is_deleted :boolean          default(FALSE), not null
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Admin < ApplicationRecord
  include AuthenticatableConcern
  include DestroyRecord

  audited

  validates :name, presence: true
end
