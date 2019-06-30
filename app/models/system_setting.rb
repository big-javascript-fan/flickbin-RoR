# frozen_string_literal: true

# == Schema Information
#
# Table name: system_settings
#
#  id         :bigint(8)        not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SystemSetting < ApplicationRecord
end
