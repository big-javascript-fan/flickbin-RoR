# frozen_string_literal: true

# == Schema Information
#
# Table name: exception_loggers
#
#  id         :bigint(8)        not null, primary key
#  message    :text
#  source     :string
#  params     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExceptionLogger < ApplicationRecord
end
