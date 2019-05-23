// Simple example of a React "smart" component

import { connect } from 'react-redux';
import Tv from '../components/tv';
import * as actions from '../actions/tvCreators';



// function getCurrentChannel ( channels, currentChannel ) {
//   if (!currentChannel) return channels[0];
//   return currentChannel
// }
//
// function getCurrentVideo ( currentChannel, currentVideo ) {
//   if (!currentVideo) return currentChannel.playlist[0];
//   return currentVideo
// }

// Which part of the Redux global state does our component want to receive as props?
const mapStateToProps = (state) => ({
  channels: state.channels,
  currentChannel: state.currentChannel ? state.currentChannel : 0,
  currentVideo: state.currentVideo ? state.currentVideo : 0
});

// Don't forget to actually use connect!
// Note that we don't export Tv, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(mapStateToProps, actions)(Tv);
