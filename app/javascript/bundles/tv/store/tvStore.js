import { createStore, applyMiddleware } from 'redux';
import logger from 'redux-logger';
import tvReducer from '../reducers/tvReducer';

const configureStore = (railsProps) => {
  return createStore(tvReducer, railsProps,  applyMiddleware(logger))
};

export default configureStore;
