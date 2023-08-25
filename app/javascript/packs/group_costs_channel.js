import consumer from "../channels/consumer"

let urlEntityId = (entity) => {
  let parsedUrl = parseUrl()
  let entityIndex = parsedUrl.indexOf(entity) 
  return parsedUrl[entityIndex + 1];
}

let parseUrl = () => {
  const url = window.location.href;
  return url.split('/');
}

let urlGroupId = urlEntityId('groups')
let urlUserId = urlEntityId('users')

let channelRoom = () => {
  return `Group ${urlGroupId} User ${urlUserId}`
}

let groupUserRowId = () => `row-group-${urlGroupId}-user-${urlUserId}`

let findGroupUserRow = () => {
  return document.getElementById(groupUserRowId());
}

let updateGroupUserRow = (renderedGroupUserRow) => {
  const newRow = document.createElement('tr');
  newRow.innerHTML = renderedGroupUserRow;

  const groupUserRow = findGroupUserRow()
  groupUserRow.parentNode.replaceChild(newRow, groupUserRow);
}


consumer.subscriptions.create(
  {
    channel: "GroupCostsChannel",
    room: channelRoom()
  },
  {
    connected() {
      console.log(`Connected: group id: ${urlGroupId}, user id: ${urlUserId}`)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      updateGroupUserRow(data['group_user_row'])
    }
  }
);
