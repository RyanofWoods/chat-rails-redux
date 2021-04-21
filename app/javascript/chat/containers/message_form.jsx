/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { createMessage } from '../actions/index';

class MessageForm extends Component {
  constructor(props) {
    super(props);
    this.state = { value: '' };
  }

  handleChange = (event) => {
    this.setState({ value: event.target.value });
  }

  handleSubmit = (event) => {
    event.preventDefault();
    this.props.createMessage(this.props.selectedChannel, this.props.currentUser, this.state.value);
    this.setState({ value: '' });
  }

  render() {
    return (
      <form action="POST" onSubmit={this.handleSubmit} >
        <div className="input-group input-group-lg">
          <input type="text" className="form-control" placeholder="Write a message" value={this.state.value} onChange={this.handleChange} />
          <div className="input-group-append">
            <button className="btn btn-primary" type="submit">Send</button>
          </div>
        </div>
      </form>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ createMessage }, dispatch);
}

function mapStateToProps(state) {
  return {
    currentUser: state.currentUser,
    selectedChannel: state.selectedChannel
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MessageForm);
