# frozen_string_literal: true

namespace :fake_data do
  TAG_TITLES = %w[
    news crypto bitcoin trading ta dankmemes funny comedy talkshows humor music folksy wackadoo
    notsure ambiguous inspired business podcast standup rockmusic heavymetal makeup toys howto
    hacks bodyhacking lifestyle riches
  ].freeze

  desc 'Create user'
  # example of task launch - rake fake_data:create_user
  task create_user: :environment do
    user = User.find_or_initialize_by(email: 'facker@gmail.com')
    update_params = {
      channel_name: "johnmcclean_#{rand(9999)}",
      password: 'password',
      avatar: File.open(File.join(Rails.root, 'db/fixtures/user_avatar.jpg'))
    }

    if user.update(update_params)
      puts 'Create user with email - facker@gmail.com'.green
    else
      puts user.errors.full_messages.to_s.red
    end
  end

  desc 'Create tags'
  # example of task launch - rake fake_data:create_tags
  task create_tags: :environment do
    TAG_TITLES.each do |tag_title|
      tag = Tag.find_or_initialize_by(title: tag_title)

      if tag.save
        puts "Create tag - #{tag_title}".green
      else
        puts tag.errors.full_messages.to_s.red
      end
    end
  end

  desc 'Create 20 videos for each tags for user'
  # example of task launch - rake fake_data:create_videos
  task create_videos: :environment do
    Rake::Task['fake_data:create_user'].invoke
    Rake::Task['fake_data:create_tags'].invoke
    random_youtube_video_query_params = {
      part: 'id',
      maxResults: 20,
      type: 'video',
      q: 'test',
      key: Yt.configuration.api_key
    }

    response = RestClient.get('https://www.googleapis.com/youtube/v3/search',
                              params: random_youtube_video_query_params)

    random_youtube_video_ids = JSON.parse(response.body)['items'].map { |item| item.dig('id', 'videoId') }
    user = User.find_by_email('facker@gmail.com')

    Tag.find_each do |tag|
      20.times do |index|
        video = user.videos.build(
          tag_id: tag.id,
          url: "https://www.youtube.com/watch?v=#{random_youtube_video_ids[index]}"
        )

        if video.save
          puts "Create video - #{video.title}".green
        else
          puts video.errors.full_messages.to_s.red
        end
      end
    end
  end

  desc 'Create dummy users'
  # example of task launch - rake fake_data:create_dummy_users\[100\]
  task :create_dummy_users, [:amount] => :environment do |_t, args|
    return 'Please enter the number of users.'.red if args[:amount].blank?

    args[:amount].to_i.times do
      rand_user = JSON.parse(open('https://randomuser.me/api/').read)
      remote_avatar_url = rand_user['results'].first.dig('picture', 'large')
      channel_name = Faker::FunnyName.two_word_name.downcase.delete!(' ')

      channel_name = Faker::FunnyName.two_word_name.downcase.delete!(' ') while User.exists?(channel_name: channel_name)

      while User.exists?(fake_avatar_url: remote_avatar_url)
        rand_user = JSON.parse(open('https://randomuser.me/api/').read)
        remote_avatar_url = rand_user['results'].first.dig('picture', 'large')
      end

      email = "teamflickbin.#{channel_name}@gmail.com"
      user = User.find_or_initialize_by(email: email)
      params = {
        channel_name: channel_name,
        password: "password#{channel_name}",
        remote_avatar_url: remote_avatar_url,
        confirmed_at: DateTime.now,
        role: 'dummy'
      }

      if user.update(params)
        puts "Create dummy user with email - #{user.email}".green
      else
        puts user.errors.full_messages.to_s.red
      end
    end
  end
end
