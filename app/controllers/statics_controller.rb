# frozen_string_literal: true

class StaticsController < ApplicationController
  before_action :load_sidebar_tags

  def show;
  end

  private

  def load_sidebar_tags
    @sidebar_tags ||= get_sidebar_tags(70)
  end
end
