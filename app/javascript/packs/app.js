import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import { GlobalProvider } from "contexts/global";

import Router from "./router"

export default function App() {
  return (
    <GlobalProvider>
      <BrowserRouter>
        <Router/>
      </BrowserRouter>
    </GlobalProvider>
  );
}

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <App />,
    document.body.appendChild(document.createElement("div")),
  );
});