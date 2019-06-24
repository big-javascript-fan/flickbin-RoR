SELECT
  tags.id,
  tags.title,
  tags.rank,
  COUNT(distinct(videos.id)) as video_count,
  COUNT(votes.id) as vote_count
FROM
  tags
LEFT JOIN videos ON videos.tag_id = tags.id AND videos.removed = 'f' AND videos.created_at > CURRENT_DATE - 3
LEFT JOIN votes ON votes.video_id = videos.id
GROUP BY
  tags.id
