# frozen_string_literal: true

class TvController < ApplicationController
  layout 'application'

  def index
    @hello_world_props = { name: 'Stranger', names: [] }
  end
end
