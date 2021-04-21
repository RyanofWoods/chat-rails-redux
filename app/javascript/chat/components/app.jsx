import React from 'react';
import ChannelList from '../containers/channel_list';
import MessageList from '../containers/message_list';
import MessageForm from '../containers/message_form';

const App = () => {
  return (
    <div className="app">
      <div className="nav-bar" />
      <ChannelList />
      <div className="message-container">
        <MessageList />
        <MessageForm />
      </div>
    </div>
  );
};

export default App;
