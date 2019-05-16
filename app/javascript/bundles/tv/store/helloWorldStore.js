import { createStore } from 'redux';
import tvReducer from '../reducers/tvReducer';

const configureStore = (railsProps) => (
  createStore(tvReducer, railsProps)
);

export default configureStore;
