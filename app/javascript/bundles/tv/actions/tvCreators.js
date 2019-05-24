/* eslint-disable import/prefer-default-export */

import { GET_TV_CHANNELS, SET_TV_CURRENT_CHANNEL, SET_TV_CURRENT_VIDEO } from '../constants/tvConstants';

export const getChannels = (channels) => ({
  type: GET_TV_CHANNELS,
  channels
});

export const setCurrentVideo = (video) => ({
  type: SET_TV_CURRENT_VIDEO,
  currentVideo: video
});
export const setCurrentChannel = (channel) => ({
  type: SET_TV_CURRENT_CHANNEL,
  currentChannel: channel
});
