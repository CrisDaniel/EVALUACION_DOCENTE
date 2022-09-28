import React from 'react';
import Axios from "axios";
import { useCookies } from "react-cookie";
import { NavLink, Outlet } from "react-router-dom";
import { Disclosure, Menu, Transition } from "@headlessui/react";

import logo from "assets/img/sead_logo.png";

const styles = {
  desktopLink:
    "border-transparent text-white hover:border-gray-300 hover:text-gray-500 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium",
};

export default function Navbar(props) {
  const [, , removeCookie] = useCookies(['authorization'])
  const currentUser = props.currentUser

  function handleLogout() {
    Axios({
      method: "delete",
      url: "/api/v1/logout"
    })
    .then(response => {
      if(response.status === 200) {
        removeCookie("authorization", {path: "/"})
        localStorage.clear()
      }
    })
    .catch(error => {
      console.log(error.response.data)
    })
  }

  return (
    <div className='grid grid-rows-layout'>
      <Disclosure as="nav" className="bg-gray-800 shadow relative z-10">
        {({ open }) => (
          <>
            <div className='max-w-7xl mx-auto px-4 sm:px-6 lg:px-8'>
              <div className='flex justify-between h-16'>
                <div className='flex'>
                  <div className='flex-shrink-0 flex items-center'>
                    <img
                      className='block lg:hidden h-10 w-auto'
                      src={logo}
                      atl="logo"
                    />
                    <img
                      className="hidden lg:block h-10 w-auto"
                      src={logo}
                      alt="logo"
                    />
                  </div>
                  <div className='hidden md:ml-6 md:flex md:space-x-8'>
                    {/* Desktop links */}
                    <NavLink
                      to="/dashboard"
                      className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                    >
                      Dashboard
                    </NavLink>
                    {currentUser.role === "admin" && 
                      <>
                        <NavLink
                          to="/teachers"
                          className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                        >
                          Docentes
                        </NavLink>
                        <NavLink
                          to="/students"
                          className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                        >
                          Alumnos
                        </NavLink>
                        <NavLink
                          to="/courses"
                          className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                        >
                          Cursos
                        </NavLink>
                        <NavLink
                          to="/templates"
                          className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                        >
                          Templates
                        </NavLink> 
                      </>
                    }
                    {currentUser.role === "student" && 
                      <>
                        <NavLink
                          to="/student/surveys"
                          className={({ isActive }) => (isActive ? `active-navlink ${styles.desktopLink}` : styles.desktopLink)}
                        >
                          Encuestas de estudiante
                        </NavLink>  
                      </>
                    }                  
                  </div>
                </div>
                <div className='flex items-center'>
                  <div className='hidden md:ml-4 md:flex-shrink-0 md:flex md:items-center'>
                    {/* Profile dropdown */}
                    <Menu as="div" className="ml-3 relative">
                      {({ openProfile }) => (
                        <>
                          <div>
                            <Menu.Button className="bg-white rounded-full flex text-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                              <span className="sr-only">
                                Abrir menu de usuario
                              </span>
                              <span className="rounded-full bg-indigo-100 uppercase w-8 h-8 grid place-items-center font-bold text-lg text-indigo-900 leading-none">
                                A
                              </span>
                            </Menu.Button>
                          </div>
                          <Transition
                            show={openProfile}
                            as={React.Fragment}
                            enter="transition ease-out duration-200"
                            enterFrom="transform opacity-0 scale-95"
                            enterTo="transform opacity-100 scale-100"
                            leave="transition ease-in duration-75"
                            leaveFrom="transform opacity-100 scale-100"
                            leaveTo="transform opacity-0 scale-95"
                          >
                            <Menu.Items
                              static
                              className="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none"
                            >
                              <Menu.Item>
                                {({ active}) => (
                                  <button
                                    type="button"
                                    onClick={handleLogout}
                                    className={`${active ? 'bg-gray-100' : ''} block px-4 py-2 text-sm text-gray-700 w-full text-left`}
                                  >
                                    Cerrar sesión
                                  </button>
                                )}
                              </Menu.Item>
                            </Menu.Items>
                          </Transition>
                        </>
                      )}
                    </Menu>
                  </div>
                </div>
              </div>
            </div>
          </>
        )}
      </Disclosure>
      <div className="bg-gray-100 overflow-scroll">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-full">
          <Outlet />
        </div>
      </div>
    </div>
  );
}