/* eslint-disable import/prefer-default-export */
const BASE_URL = 'https://wagon-chat.herokuapp.com';

export const SELECT_CHANNEL = 'SELECT_CHANNEL';
export const SET_MESSAGES = 'SET_MESSAGES';
export const CREATE_MESSAGE = 'CREATE_MESSAGE';

export function selectChannel(channel) {
  return {
    type: SELECT_CHANNEL,
    payload: channel
  };
}

export function setMessages(channel) {
  const url = `${BASE_URL}/${channel}/messages`;
  const promise = fetch(url)
    .then(response => response.json());

  return {
    type: SET_MESSAGES,
    payload: promise
  };
}

export function createMessage(channel, author, content) {
  const url = `${BASE_URL}/${channel}/messages`;
  const promise = fetch(url, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ author, content })
  }).then(response => response.json());

  return {
    type: CREATE_MESSAGE,
    payload: promise
  };
}
