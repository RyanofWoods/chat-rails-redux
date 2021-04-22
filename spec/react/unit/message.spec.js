import React from "react";
import Message from "chat/components/message";
import { shallow } from "enzyme";

describe("<Message/>", () => {
  const message = {
    author: "ryan",
    content: "hello",
    created_at: new Date(Date.UTC(1995, 11, 17, 3, 24, 0)), // Sunday, 17th dec 1995 03:24:00 UTC
  };
  const wrapper = shallow(<Message message={message} />);

  it("should the author in a div with the class .message-author", () => {
    const authorResult = wrapper.find(".message-author").text();
    expect(authorResult).toBe(message.author);
  });

  it("should the message content in a div with the class .message-content", () => {
    const contentResult = wrapper.find(".message-content").text();
    expect(contentResult).toBe(message.content);
  });

  it("should have the message created_at date formatted in a div with the class .message-date", () => {
    // we want the expected date to be in the user's local time, so we made the created_at in UTC
    // however, if it gets changed to locale time ca only be checked if have a different time to UTC
    const expTime = new Intl.DateTimeFormat("en-GB", {
      timeStyle: "short",
    }).format(message.created_at);
    const expDate = new Intl.DateTimeFormat("en-GB", {
      dateStyle: "short",
    }).format(message.created_at);

    const expectedDateStr = `${expTime}, ${expDate}`;
    const dateResult = wrapper.find(".message-date").text();
    expect(dateResult).toBe(expectedDateStr);
  });
});
