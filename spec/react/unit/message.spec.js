import React from 'react';
import Message from 'chat/components/message';
import { shallow } from 'enzyme';
import { childText } from '../utils';

describe('<Message/>', () => {
  const message = {
    author: 'ryan',
    content: 'hello',
    created_at: new Date(Date.UTC(1995, 11, 17, 3, 24, 0)), // Sunday, 17th dec 1995 03:24:00 UTC
  };
  const wrapper = shallow(<Message message={message} />);

  it('should be a li', () => {
    expect(wrapper.is('li')).toEqual(true);
  });

  it('should have a .message class', () => {
    expect(wrapper.hasClass('message')).toEqual(true);
  });

  it('should have the author in a div with the class .message-author', () => {
    expect(childText(wrapper, '.message-author')).toBe(message.author);
  });

  it('should have the message content in a div with the class .message-content', () => {
    expect(childText(wrapper, '.message-content')).toBe(message.content);
  });

  it('should have the message created_at date formatted in a div with the class .message-date', () => {
    // we want the expected date to be in the user's local time, so we made the created_at in UTC
    // however, if it gets changed to locale time ca only be checked if have a different time to UTC
    const expTime = new Intl.DateTimeFormat('en-GB', {
      timeStyle: 'short',
    }).format(message.created_at);
    const expDate = new Intl.DateTimeFormat('en-GB', {
      dateStyle: 'short',
    }).format(message.created_at);

    const expectedDateStr = `${expTime}, ${expDate}`;
    expect(childText(wrapper, '.message-date')).toBe(expectedDateStr);
  });
});
