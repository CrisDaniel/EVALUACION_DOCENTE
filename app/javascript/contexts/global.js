import React from 'react'

const GlobalContext =  React.createContext()

function GlobalProvider(props) {
  const [user, setUser] = React.useState( JSON.parse(localStorage.getItem("user") || '{}' ))

  const value = {
    user,
    setUser
  }

  return <GlobalContext.Provider value={value} {...props} />
}

export { GlobalProvider, GlobalContext }