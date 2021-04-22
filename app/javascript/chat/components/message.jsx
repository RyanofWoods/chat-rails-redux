import React from 'react';

const Message = (props) => {
  const { author, content, created_at } = props.message;

  const formattedTime = new Intl.DateTimeFormat("en-GB", {
    timeStyle: "short",
  }).format(created_at);

  const formattedDate = new Intl.DateTimeFormat("en-GB", {
    dateStyle: "short",
  }).format(created_at);

  const formattedDateStr = `${formattedTime}, ${formattedDate}`;

  return (
    <div className="message">
      <div className="message-info">
        <div className="message-author">{author}</div>
        <div className="message-date">{formattedDateStr}</div>
      </div>
      <div className="message-content">{content}</div>
    </div>
  );
};

export default Message;
