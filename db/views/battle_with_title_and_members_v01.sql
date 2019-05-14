SELECT
  battles.*,
  STRING_AGG(UPPER(first_members_battles.name) || ' vs ' || UPPER(second_members_battles.name), '') as title,
  (ARRAY_AGG(first_members_battles.id))[1] as first_members_battles_id,
  STRING_AGG(first_members_battles.name, '') as first_members_battles_name,
  STRING_AGG(first_members_battles.twitter_account_name, '') as first_members_battles_twitter_account_name,
  STRING_AGG(first_members_battles.photo, '') as first_members_battles_photo,
  COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id) as first_members_battles_voices,
  (ARRAY_AGG(second_members_battles.id))[1] as second_members_battles_id,
  STRING_AGG(second_members_battles.name, '') as second_members_battles_name,
  STRING_AGG(second_members_battles.twitter_account_name, '') as second_members_battles_twitter_account_name,
  STRING_AGG(second_members_battles.photo, '') as second_members_battles_photo,
  COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id) as second_members_battles_voices,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN (ARRAY_AGG(first_members_battles.id))[1]
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN (ARRAY_AGG(second_members_battles.id))[1]
    ELSE NULL
  END AS winner_members_battles_id,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN STRING_AGG(first_members_battles.twitter_account_name, '')
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN STRING_AGG(second_members_battles.twitter_account_name, '')
    ELSE NULL
  END AS winner_members_battles_twitter_account_name,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN STRING_AGG(first_members_battles.photo, '')
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN STRING_AGG(second_members_battles.photo, '')
    ELSE NULL
  END AS winner_members_battles_photo,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN STRING_AGG(second_members_battles.twitter_account_name, '')
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN STRING_AGG(first_members_battles.twitter_account_name, '')
    ELSE NULL
  END AS loser_members_battles_twitter_account_name,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id)
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id)
    ELSE NULL
  END AS winner_members_battles_voices,
  CASE
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(first_members_battles.name, '') THEN COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id)
    WHEN STRING_AGG(battles.winner, '') = STRING_AGG(second_members_battles.name, '') THEN COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id)
    ELSE NULL
  END AS loser_members_battles_voices
FROM
  battles
LEFT JOIN battle_votes ON battle_votes.battle_id = battles.id
INNER JOIN battle_members first_members_battles ON first_members_battles.id = battles.first_member_id
INNER JOIN battle_members second_members_battles ON second_members_battles.id = battles.second_member_id
GROUP BY battles.id