import React from 'react';
import { Provider } from 'react-redux';
import renderer from 'react-test-renderer';
import configureStore from 'redux-mock-store';
import ChannelList from 'chat/containers/channel_list';

const mockStore = configureStore([]);

describe('<ChannelList/>', () => {
  let store;
  let component;
  const channels = ['general', 'ruby', 'javascript'];

  beforeEach(() => {
    store = mockStore({
      channels
    });

    component = renderer.create(
      <Provider store={store}>
        <ChannelList selectedChannel='ruby' />
      </Provider>
    );
  });

  const channelListItems = () => {
    const { children } = component.toJSON();
    const ul = children.find((element) => element.type === 'ul');

    return ul.children;
  };

  it('should render with given state from Redux store', () => {
    expect(component.toJSON()).toMatchSnapshot();
  });

  it('should contain one <ul>', () => {
    expect(component.root.findAllByType('ul').length).toBe(1);
  });

  it('should render a <li> for each channel and <ul> be the parent', () => {
    expect(component.root.findAllByType('li').length).toBe(3);
  });

  it('each channel <li> should be prefixed with a #', () => {
    channelListItems().forEach((channelInstance, index) => {
      expect(channelInstance.children.join('')).toBe(`#${channels[index]}`);
    });
  });

  it('the selected channel should have .selected class', () => {
    channelListItems().forEach((channelInstance, index) => {
      if (index === 1) {
        expect(channelInstance.props.className).toEqual(
          expect.stringContaining('selected')
        );
      } else {
        expect(channelInstance.props.className).toEqual(
          expect.not.stringContaining('selected')
        );
      }
    });
  });
});
