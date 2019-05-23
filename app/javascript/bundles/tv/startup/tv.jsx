import React from 'react';
import { Provider } from 'react-redux';

import configureStore from '../store/tvStore';
import TvContainer from '../containers/tvContainer';

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
const Tv = (props) => (
  <Provider store={configureStore(props)}>
    <TvContainer />
  </Provider>
);

export default Tv;
