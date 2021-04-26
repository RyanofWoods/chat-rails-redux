const childText = (component, childSelector) => {
  return component.find(childSelector).text();
};

export { childText };