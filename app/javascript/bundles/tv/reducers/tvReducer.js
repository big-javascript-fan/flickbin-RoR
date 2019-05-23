import { combineReducers } from 'redux';
import {
  GET_TV_CHANNELS,
  SET_TV_CURRENT_CHANNEL,
  SET_TV_CURRENT_VIDEO
} from '../constants/tvConstants';

const channels = (state = [], action) => {
  switch (action.type) {
    case GET_TV_CHANNELS:
      return action.channels;
    default:
      return state;
  }
};
const currentChannel = (state = 0, action) => {
  switch (action.type) {
    case SET_TV_CURRENT_CHANNEL:
      return action.currentChannel;
    default:
      return state;
  }
};
const currentVideo = (state = 0, action) => {
  switch (action.type) {
    case SET_TV_CURRENT_VIDEO:
      return action.currentVideo;
    default:
      return state;
  }
};


const tvReducer = combineReducers({ channels, currentChannel, currentVideo});

export default tvReducer;
