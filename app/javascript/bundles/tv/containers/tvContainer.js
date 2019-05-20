// Simple example of a React "smart" component

import { connect } from 'react-redux';
import Tv from '../components/tv';
import * as actions from '../actions/tvCreators';


function fitredNames( names, filter ) {
  return names.filter((name) => {
    switch (filter) {
      case 'active':
        return !name.complete;
      case 'complete':
        return name.complete;
      default:
        return true
    }
  })
}

// Which part of the Redux global state does our component want to receive as props?
const mapStateToProps = (state) => ({
  name: state.name,
  names: fitredNames(state.names, state.filter),
  filter: state.filter
});

// Don't forget to actually use connect!
// Note that we don't export Tv, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(mapStateToProps, actions)(Tv);
