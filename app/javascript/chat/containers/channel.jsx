/* eslint-disable jsx-a11y/no-noninteractive-element-interactions */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { selectChannel, setMessages } from '../actions/index';

class Channel extends Component {
  handleClick = () => {
    if (this.props.channel !== this.props.selectedChannel) {
      this.props.selectChannel(this.props.channel);
      this.props.setMessages(this.props.channel);
    }
  }

  render() {
    const { channel } = this.props;
    let classes = 'list-group-item';
    if (channel === this.props.selectedChannel) {
      classes += ' selected';
    }
    return (
      <li className={classes} onClick={this.handleClick} >
        #{channel}
      </li>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ selectChannel, setMessages }, dispatch);
}

function mapStateToProps(state) {
  return {
    selectedChannel: state.channel
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Channel);
