import React from 'react'
import Axios from 'axios'
import Toastr from 'toastr'
import { useCookies } from 'react-cookie'
import { GlobalContext } from 'contexts/global'

import logo from "assets/img/robot.svg";

export default function Login() {
  const global = React.useContext(GlobalContext)
  const [, setCookie] = useCookies(["authorization"])
  const [login, setLogin] = React.useState({
    email: "",
    password: "",
  })

  function handleSuccessfulAuth(response) {
    setCookie("authorization", response.headers.authorization, {
      maxAge: 24 * 60 * 60,
      sameSite: "lax",
      path: "/",
    })
  }

  function handleSubmit(event){
    event.preventDefault();
    Axios({
      method: "post",
      url: "/api/v1/login",
      data: {
        user: {
          email: login.email,
          password: login.password,
        }
      }
    })
    .then(response => {
      if (response.data.success) {
        global.setUser(response.data.user);
        localStorage.setItem("user", JSON.stringify(response.data.user))
        handleSuccessfulAuth(response)
      }
    }).catch(errorResponse => {
      Toastr.options.closeButton = true;
      Toastr.options.timeOut = 5000;
      Toastr.options.extendedTimeOut = 1000;
      Toastr.options.positionClass = "toast-bottom-right";
      Toastr.error(errorResponse.response.data);
    })
  }

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <img className="mx-auto" src={logo} alt="Workflow" width="80" />
        <h2 className="uppercase mt-6 text-center text-3xl font-extrabold text-gray-900">
          SEAD
        </h2>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <form className="space-y-6" onSubmit={handleSubmit}>
            <div>
              <label
                htmlFor="email"
                className="block text-sm font-medium text-gray-700"
              >
                Email
              </label>

              <div className="mt-1">
                <input
                  id="email"
                  onChange={event =>
                    setLogin({ ...login, email: event.target.value })
                  }
                  value={login.email}
                  pattern="[a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*@[a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*[.][a-zA-Z]{1,5}"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  className="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                />
              </div>
            </div>

            <div>
              <label
                htmlFor="password"
                className="block text-sm font-medium text-gray-700"
              >
                Contraseña
              </label>
              <div className="mt-1">
                <input
                  id="password"
                  name="password"
                  type="password"
                  value={login.password}
                  autoComplete="current-password"
                  className="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  onChange={event =>
                    setLogin({ ...login, password: event.target.value })
                  }
                  required
                />
              </div>
            </div>

            <div>
              <button
                type="submit"
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Iniciar sesión
              </button>
            </div>
            {/* <div className="text-center">
              <a
                href="#"
                className="font-medium text-indigo-600 hover:text-indigo-500"
              >
                Forgot your password?
              </a>
            </div> */}
          </form>
        </div>
      </div>
    </div>
  )
}