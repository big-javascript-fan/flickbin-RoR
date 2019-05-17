import { combineReducers } from 'redux';
import {
  TV_NAME_UPDATE,
  TV_NAME_ADD,
  TV_NAME_REMOVE,
  TV_FILTER_NAMES,
  TV_TOGGLE_COMPLETED_NAME
} from '../constants/tvConstants';

const name = (state = '', action) => {
  switch (action.type) {
    case TV_NAME_UPDATE:
      return action.text;
    default:
      return state;
  }
};

const names = (state = [], action) => {
  switch (action.type) {
    case TV_NAME_ADD:
      return [
        ...state,
        {
          title: action.value,
          id: new Date().getTime(),
          completed: false
        }
      ];
    case TV_NAME_REMOVE:
      console.log(TV_NAME_REMOVE);
      return state.filter((item) => item.id !== action.key);
    case TV_TOGGLE_COMPLETED_NAME:
      return state.map((item) => {
        if ( action.id !== item.id ) {
          return item
        } else {
          return {...item, complete: !item.complete}
        }
      });
    default:
      return state;
  }
};

const filter = (state = 'all', action) => {
  switch (action.type) {
    case TV_FILTER_NAMES:
      return action.filter;
    default:
      return state;
  }
};

const tvReducer = combineReducers({ name, names, filter });

export default tvReducer;
