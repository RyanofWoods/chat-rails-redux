/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { connect } from 'react-redux';
import Channel from './channel';

class ChannelList extends Component {
  render() {
    return (
      <div className="channel-container">
        <div className="channel-container-header">Redux Group</div>
        <div className="list-group">
          {
            this.props.channels.map((channel) => {
              return (<Channel key={channel} channel={channel} />);
            })
          }
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    channels: state.channels,
    selectedChannel: state.selectedChannel
  };
}

export default connect(mapStateToProps, null)(ChannelList);
