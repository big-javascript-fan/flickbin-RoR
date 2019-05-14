SELECT
  battles.*,
  UPPER((ARRAY_AGG(first_members_battles.name))[1]) || ' vs ' || UPPER((ARRAY_AGG(second_members_battles.name))[1]) as title,
  (ARRAY_AGG(first_members_battles.id))[1] as first_members_battles_id,
  (ARRAY_AGG(first_members_battles.name))[1] as first_members_battles_name,
  (ARRAY_AGG(first_members_battles.twitter_account_name))[1] as first_members_battles_twitter_account_name,
  (ARRAY_AGG(first_members_battles.photo))[1] as first_members_battles_photo,
  COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id) as first_members_battles_voices,
  (ARRAY_AGG(second_members_battles.id))[1] as second_members_battles_id,
  (ARRAY_AGG(second_members_battles.name))[1] as second_members_battles_name,
  (ARRAY_AGG(second_members_battles.twitter_account_name))[1] as second_members_battles_twitter_account_name,
  (ARRAY_AGG(second_members_battles.photo))[1] as second_members_battles_photo,
  COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id) as second_members_battles_voices,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN (ARRAY_AGG(first_members_battles.id))[1]
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN (ARRAY_AGG(second_members_battles.id))[1]
    ELSE NULL
  END AS winner_members_battles_id,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN (ARRAY_AGG(first_members_battles.twitter_account_name))[1]
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN (ARRAY_AGG(second_members_battles.twitter_account_name))[1]
    ELSE NULL
  END AS winner_members_battles_twitter_account_name,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN (ARRAY_AGG(first_members_battles.photo))[1]
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN (ARRAY_AGG(second_members_battles.photo))[1]
    ELSE NULL
  END AS winner_members_battles_photo,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN (ARRAY_AGG(second_members_battles.twitter_account_name))[1]
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN (ARRAY_AGG(first_members_battles.twitter_account_name))[1]
    ELSE NULL
  END AS loser_members_battles_twitter_account_name,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id)
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id)
    ELSE NULL
  END AS winner_members_battles_voices,
  CASE
    WHEN battles.winner = (ARRAY_AGG(first_members_battles.name))[1] THEN COUNT(battle_votes.id) filter (where battle_member_id = second_members_battles.id)
    WHEN battles.winner = (ARRAY_AGG(second_members_battles.name))[1] THEN COUNT(battle_votes.id) filter (where battle_member_id = first_members_battles.id)
    ELSE NULL
  END AS loser_members_battles_voices
FROM
  battles
LEFT JOIN battle_votes ON battle_votes.battle_id = battles.id
INNER JOIN battle_members first_members_battles ON first_members_battles.id = battles.first_member_id
INNER JOIN battle_members second_members_battles ON second_members_battles.id = battles.second_member_id
GROUP BY battles.id