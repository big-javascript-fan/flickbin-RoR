class Api::V1::Battles::IndexSerializer < Api::V1::BaseSerializer

    def initialize(battle)
        @battle = battle
    end

    def call
        Oj.dump({
          battle:  battle_to_hash(@battle)
        })
    end

    private

    def battle_to_hash(battle)
        {
            id:                     battle.id,
            first_member_voices:    battle.first_member_voices,
            second_member_voices:   battle.second_member_voices,
            first_member:           member_to_hash(battle.first_member),
            second_member:          member_to_hash(battle.second_member)
        }
    end

    def member_to_hash(member)
        {
            id:                 member.id,
            channel_title:      member.channel_title,
            channel_avatar:     member.channel_avatar,
            station_title:      member.station_title
        }
    end
end
