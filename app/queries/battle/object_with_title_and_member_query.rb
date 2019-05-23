# frozen_string_literal: true

class Battle
  class ObjectWithTitleAndMemberQuery < ApplicationQuery
    def initialize(id)
      @id = id
    end

    def call
      BattleWithTitleAndMember.find(@id)
    end
  end
end
