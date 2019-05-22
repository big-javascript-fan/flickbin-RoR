# frozen_string_literal: true

module ApplicationHelper
  def meta_title
    (@meta_title || Array.new(0)).compact.join(' | ')
  end
end
