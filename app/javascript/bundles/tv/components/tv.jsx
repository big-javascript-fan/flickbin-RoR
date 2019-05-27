import PropTypes from 'prop-types';
import React from 'react';
import ReactPlayer from 'react-player'

const Tv = ({
  channels,
  currentChannel,
  setCurrentVideo,
  setCurrentChannel,
  currentVideo
}) => {
  console.log(channels);
  return <div>
    <div className="wrapper-tv scroll dark-theme">
      <section className="section section-tv">
        <header className="section-header">
          <div className="section-header-left">
            <a className="brand brand-white" href="/">flickbin</a>
            <div className="videoInfoControls">
              <div id="voting_button" className="upDownOptions clearfix" channelslug="new_blogger">
                <div className="counter-wrapper" loginrequired="true">
                  <span className="counterOption upVote"><span className="icon icon-arrow_drop_up"/></span>
                  <span className="counterNumber counterValueHolder">0</span>
                </div>
              </div>
            </div>
          </div>
          <div className="section-header-right">
            <div className="button-wrapper btnReverseTheme">
              <a className="btn btn-default" href="/users/sign_up">Sign up</a>
              <a className="btn btn-secondary" href="/users/sign_in">Log in</a>
            </div>
          </div>
        </header>
        <div className="section-body">
          <div className="video-wrapper">
            <div className="embed-container">
              <ReactPlayer
                url={`https://www.youtube.com/watch?v=${channels[currentChannel].playlist[currentVideo].source_id}`}
                playing={true}
                controls={false}
                onEnded={() => {
                  let nextVideo;
                  let nextChannel;

                  if (currentVideo < channels[currentChannel].playlist.length - 1) {
                    nextVideo = currentVideo + 1;
                    setCurrentVideo(nextVideo);
                  } else {
                    nextVideo = 0;
                    nextChannel = currentChannel < channels.length - 1 ? currentChannel + 1 : 0;
                    setCurrentVideo(nextVideo);
                    setCurrentChannel(nextChannel);
                  }
                }}/>
            </div>
          </div>
        </div>
        <footer className="section-footer">
          <div className="section-footer-left">
            <div className="card-tv card-tv-video">
              <figure className="card-media card-media-secondary">
                <img src={channels[currentChannel].user.avatar.thumb_44x44.url ? channels[currentChannel].user.avatar.thumb_44x44.url : 'images/avatar_holder.jpg'} alt="icon"/>
              </figure>
              <div className="card-body card-body-small">
                <h4 className="card-title">
                  {channels[currentChannel].user.channel_name}
                </h4>
                <div className="card-description">
                  {channels[currentChannel].playlist[currentVideo].title}
                </div>
              </div>
            </div>
          </div>
          <div className="section-footer-right">
            <div className="subscribe-tv">
              <div className="subscribe-tv-watching"><span>1.478</span> Watching</div>
              <button className="btn btn-subscribe btn-primary">
                <span className="icon-check"/>
                Subscribe
              </button>
            </div>
          </div>
        </footer>
      </section>
      <section className="section-tv-channel">
        <aside className="section-sidebar">
          <ul   className="list list-tv-channels" >
            { channels.map( (channel, channelIndex ) => {
              return <li key={channel.user.id} className="list-item" onClick={() => {
                if (channel.user.channel_name !== channels[currentChannel].user.channel_name && setCurrentChannel(channelIndex)) {
                  setCurrentVideo(0);
                }

              }}>
                <figure className="chanel-icon">
                  <img src={channel.user.avatar.thumb_44x44.url ? channel.user.avatar.thumb_44x44.url : 'images/avatar_holder.jpg'} alt="icon" />
                </figure>
              </li>
              })
            }
          </ul>
        </aside>
        <div className="section-body">
          {channels.map((channel, channelIndex) => {
            return <ul key={channel.user.id} className="list list-slide-videos">
              {channel.playlist.map((video, videoIndex) => {
                return <li key={video.id} className="list-item">
                  <div className="card-tv card-tv-chanel-video">
                    { currentChannel === channelIndex && currentVideo === videoIndex? ' ' : <div className="card-overlay"></div> }

                    {video.cover && <figure className="card-media">
                      <img src={video.cover.url} alt={video.title} />
                    </figure>}
                    <div className="card-body">
                      <h4 className="card-title">
                        {channel.user.channel_name}
                      </h4>
                      <div className="card-description">
                        {video.title}
                      </div>
                    </div>
                  </div>
                </li>
              })}
            </ul>
          })}
        </div>
      </section>
    </div>
  </div>
};

Tv.propTypes = {
  channels: PropTypes.array.isRequired,
  setCurrentChannel: PropTypes.func.isRequired,
  setCurrentVideo: PropTypes.func.isRequired
};

export default Tv;
