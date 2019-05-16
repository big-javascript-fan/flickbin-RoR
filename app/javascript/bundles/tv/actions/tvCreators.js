/* eslint-disable import/prefer-default-export */

import { TV_NAME_UPDATE } from '../constants/tvConstants';

export const updateName = (text) => ({
  type: TV_NAME_UPDATE,
  text,
});
