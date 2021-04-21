// external modules
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import { logger } from 'redux-logger';
import reduxPromise from 'redux-promise';

// internal modules
import App from './components/app';

// reducers
import messagesReducer from './reducers/messages_reducer';
const baseReducer = (state = null) => state;

const initialState = {
  messages: [],
  channels: ['general', 'ruby', 'javascript', 'react', 'social']
};

// State and reducers
const reducers = combineReducers({
  messages: messagesReducer,
  channels: baseReducer
});

// Root element, store and middlewars
const composeEnhancers = __REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
const middlewares = composeEnhancers(applyMiddleware(logger, reduxPromise));
const store = createStore(reducers, initialState, middlewares);
const root = document.getElementById("root");;

// render an instance of the component in the DOM
ReactDOM.render(
  <Provider store={store}>
    <BrowserRouter>
      <Switch>
        <Route path='/channels/:channel' component={App} />
      </Switch>
    </BrowserRouter>
  </Provider>,
  root
);