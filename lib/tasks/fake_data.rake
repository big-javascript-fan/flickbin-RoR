namespace :fake_data do
  TAG_TITLES = %w(
    news crypto bitcoin trading ta dankmemes funny comedy talkshows humor music folksy wackadoo
    notsure ambiguous inspired business podcast standup rockmusic heavymetal makeup toys howto
    hacks bodyhacking lifestyle riches
  )

  VIDEO_TITLES = [
    'Pos Hardware More Options In Less Space',
    'Going Wireless With Your Headphones',
    'Popular Uses Of The Internet',
    'Why Use External It Support',
    'Compatible Inkjet Cartridge',
    'Stu Unger Rise And Fall Of A Poker Genius',
    'Download Anything Now A Days',
    'Looking For Your Dvd Printing Solution',
    'Not All Blank Cassettes Are Created Equal',
    'How Plasma Tvs And Lcd Tvs Diffe',
    'Thousands Now Adware Removal Who Never Thought They Could',
    'Fta Keys'
  ]

  desc "Create user"
  # example of task launch - rake fake_data:create_user
  task create_user: :environment do
    user = User.find_or_initialize_by(email: 'facker@gmail.com')
    update_params = {
      channel_name: "johnmcclean_#{rand(9999)}",
      password: 'password',
      avatar: File.open(File.join(Rails.root, 'db/fixtures/user_avatar.jpg'))
    }

    if user.update(update_params)
      puts "Create user with email - facker@gmail.com".green
    else
      puts "#{user.errors.full_messages}".red
    end
  end

  desc "Create tags"
  # example of task launch - rake fake_data:create_tags
  task create_tags: :environment do
    TAG_TITLES.each do |tag_title|
      tag = Tag.find_or_initialize_by(title: tag_title)

      if tag.save
        puts "Create tag - #{tag_title}".green
      else
        puts "#{tag.errors.full_messages}".red
      end
    end
  end

  desc "Create videos with tags for user"
  # example of task launch - rake fake_data:create_videos
  task create_videos: :environment do
    Rake::Task['fake_data:create_user'].invoke
    Rake::Task['fake_data:create_tags'].invoke

    user = User.find_by_email('facker@gmail.com')

    Tag.find_each do |tag|
      VIDEO_TITLES.each do |video_title|
        video = user.videos.build(
          title: video_title,
          tag_id: tag.id,
          url: "https://www.youtube.com/watch?v=#{SecureRandom.hex.first(20)}",
        )

        if video.save
          puts "Create video - #{video_title}".green
        else
          puts "#{video.errors.full_messages}".red
        end
      end
    end
  end
end
