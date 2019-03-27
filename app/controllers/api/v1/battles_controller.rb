class Api::V1::BattlesController < Api::V1::BaseController
    before_action :set_battle
    before_action :set_voices

    def index 
        # render json: Api::V1::Battles::IndexSerializer.new(@battle).call
        render json: [@voices1, @voices2]
    end

    def update
        if params[:value1]
            @battle.increment!(:first_member_voices) 
        end 
        if params[:value2]
            @battle.increment!(:second_member_voices)
        end 
        render json: [@voices1, @voices2]
    end

    private 

    def set_battle 
        @battle = Battle.last
    end

    def set_voices 
        @voices1 = @battle.first_member_voices.to_json
        @voices2 = @battle.second_member_voices.to_json
    end
end