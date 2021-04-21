import { SET_MESSAGES, CREATE_MESSAGE } from '../actions/index';

const messagesReducer = (state, action) => {
  if (state === undefined) {
    return [];
  }
  switch (action.type) {
    case SET_MESSAGES:
      return action.payload.messages;
    case CREATE_MESSAGE: {
      const stateClone = state.slice(0);
      stateClone.push(action.payload);
      return stateClone;
    }
    default:
      return state;
  }
};

export default messagesReducer;
