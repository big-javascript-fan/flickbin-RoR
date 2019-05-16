import { combineReducers } from 'redux';
import { TV_NAME_UPDATE } from '../constants/tvConstants';

const name = (state = '', action) => {
  switch (action.type) {
    case TV_NAME_UPDATE:
      return action.text;
    default:
      return state;
  }
};

const tvReducer = combineReducers({ name });

export default tvReducer;
