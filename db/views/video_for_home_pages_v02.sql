SELECT
  DISTINCT ON (videos.source_id) source_id,
  videos.id,
  videos.cover,
  videos.title,
  videos.source,
  videos.slug,
  users.id as user_id,
  users.avatar as user_avatar,
  users.channel_name as user_channel_name,
  users.slug as user_slug,
  tags.title as tag_title,
  tags.slug as tag_slug
FROM
  videos
INNER JOIN users ON users.id = videos.user_id
INNER JOIN tags ON tags.id = videos.tag_id
WHERE videos.removed = 'f'