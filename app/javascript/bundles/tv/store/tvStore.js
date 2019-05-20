import { createStore } from 'redux';
import tvReducer from '../reducers/tvReducer';

const configureStore = (railsProps) => {
  return createStore(tvReducer, railsProps)
};

export default configureStore;
