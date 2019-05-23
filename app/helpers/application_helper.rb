# frozen_string_literal: true

module ApplicationHelper
  def meta_title
    (@meta_title || ['flickbin', 'Discover and rank the best videos on the web.']).compact.join(' | ')
  end
end
