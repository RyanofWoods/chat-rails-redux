/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { setMessages } from '../actions/index';
import Message from '../components/message';

class MessageList extends Component {
  componentWillMount() {
    this.props.setMessages(this.props.selectedChannel);
  }


  render() {
    let content = '';
    content = this.props.messages.map((message) => {
      return (<Message key={message} message={message} />);
    });

    return (
      <div>
        <div className="message-list-header">Channel: #{this.props.selectedChannel}</div>
        <ul className="message-list">
          {content}
        </ul>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ setMessages }, dispatch);
}

function mapStateToProps(state) {
  return {
    messages: state.messages,
    selectedChannel: state.selectedChannel
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MessageList);
