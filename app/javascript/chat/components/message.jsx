import React from 'react';

const Message = (props) => {
  const { author, content, created_at } = props.message;
  const date = new Date(created_at).toLocaleTimeString();
  return (
    <div className="message">
      <div className="message-info">
        <div className="message-author">{author}</div>
        <div className="message-date">{date}</div>
      </div>
      <div className="message-content">{content}</div>
    </div>
  );
};

export default Message;
