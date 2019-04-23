class HomePageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "home_page"
  end

  def unsubscribed
    stop_all_streams
  end
end
