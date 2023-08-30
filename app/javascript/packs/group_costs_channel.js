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


let findElement = (elementId) => {
  return document.getElementById(elementId)
}

let entityCostsSumValueElement = (entity) => {
  let valueElement = ''
  switch (entity) {
    case 'users':
      valueElement = `group-${urlGroupId}-user-${urlUserId}-costs-sum-value-element`
      break;

    case 'groups':
      valueElement = 'group-cost-row-value-element'
      break;
  }

  return valueElement
}

let updateEntityCostValue = (entity, renderedHtml) => {
  const element = findElement(entityCostsSumValueElement(entity))
  element.innerHTML = renderedHtml;
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
      updateEntityCostValue('users', data['group_user_row_costs_sum_value'])
      updateEntityCostValue('groups', data['group_cost_row_value_element'])
    }
  }
);
