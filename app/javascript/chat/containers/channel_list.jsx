/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from "redux";
import { connect } from 'react-redux';
import { selectChannel, setMessages } from "../actions/index";

class ChannelList extends Component {
  handleClick = () => {
    if (this.props.channel !== this.props.selectedChannel) {
      this.props.selectChannel(this.props.channel);
      this.props.setMessages(this.props.channel);
    }
  };

  render_channel(channel) {
    let classes = "list-group-item";

    if (channel === this.props.selectedChannel) {
      classes += " selected";
    }
    return (
      <li key={channel} className={classes} onClick={this.handleClick}>
        #{channel}
      </li>
    );
  }

  render() {
    return (
      <div className="channel-container">
        <div className="channel-container-header">
          Channel List
        </div>
        <ul className="list-group">
          {
            this.props.channels.map((channel) => {
              return this.render_channel(channel)
            })
          }
        </ul>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ selectChannel, setMessages }, dispatch);
}

function mapStateToProps(state) {
  return {
    channels: state.channels
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(ChannelList);
