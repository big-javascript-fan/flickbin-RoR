/* eslint-disable import/prefer-default-export */

import { TV_NAME_UPDATE, TV_NAME_ADD, TV_NAME_REMOVE, TV_FILTER_NAMES, TV_TOGGLE_COMPLETED_NAME } from '../constants/tvConstants';

export const updateName = (text) => ({
  type: TV_NAME_UPDATE,
  text,
});

export const addName = (value) =>  ({
  type: TV_NAME_ADD,
  value,
});

export const removeName = (key) =>  ({
  type: TV_NAME_REMOVE,
  key,
});

export const filterNames = (filter) =>  ({
  type: TV_FILTER_NAMES,
  filter,
});

export const toggleCompletedName = (id) =>  ({
  type: TV_TOGGLE_COMPLETED_NAME,
  id,
});
