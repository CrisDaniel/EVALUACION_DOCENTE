import React from "react"
import {
  TrashIcon
} from "@heroicons/react/outline";
import { useNavigate } from "react-router-dom";
import Toastr from 'toastr'
import Axios from "axios"
import { useCookies } from "react-cookie"

import { Combobox, Transition  } from '@headlessui/react';
import { CheckIcon, SelectorIcon } from '@heroicons/react/solid';

import { Fragment, useState } from "react";


export default function NewTeachers(){
  const [cookies] = useCookies(["authorization"])

  const [dataCourses, setDataCourses] = React.useState([])
  const [listCourseSelected, setListCourseSelected] = React.useState([])

  const [selectedCourse, setSelectedCourse] = useState(dataCourses[0])
  const [query, setQuery] = useState('')

  const [dataTeacher, setDataTeacher] = React.useState({
    fullname: "",
    code: "",
    email: "",
    role_name: "teacher",
    course_ids: [0]
  })

  let navigate = useNavigate();

  React.useEffect(() => {
    handleGetCourses()
  }, [query]);

  React.useEffect(() => {
    setDataTeacher({
      ...dataTeacher,
      course_ids: listCourseSelected.map(course => course.id)
    })
  }, [listCourseSelected])

  function handleGetCourses(){
    Axios({
      method: "get",
      url: `/api/v1/courses?q=${query}&order_by=ASC&page=1`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': cookies.authorization
      }
    })
    .then(response => {
      if( response.data.success ) {
        setDataCourses(response.data.data.courses)
      }
    }).catch( error => {
      console.log(error.response.data)
    })
  }

  function handleChange(event){
    event.preventDefault()
    setDataTeacher({
      ...dataTeacher,
      [event.target.name]: event.target.value
    })
  }

  function handleSubmit(e) {
    e.preventDefault();

      Axios({
        method: 'post',
        url: '/api/v1/users',
        data: { user: dataTeacher}
      })
      .then(response => {
        if( response.data.success ) {
          Toastr.options.closeButton = true;
          Toastr.options.timeOut = 5000;
          Toastr.options.extendedTimeOut = 1000;
          Toastr.options.positionClass = "toast-bottom-right";
          Toastr.success(response.data.message);
          navigate("/teachers");
        }
      }).catch( error => {
        Toastr.options.closeButton = true;
        Toastr.options.timeOut = 5000;
        Toastr.options.extendedTimeOut = 1000;
        Toastr.options.positionClass = "toast-bottom-right";
        Toastr.error(error.response.data.message);
      })
  }

  function handleSelectedCourse(course) {
    setSelectedCourse(course)
    setListCourseSelected([...listCourseSelected, course])
  }


  function handleDelete(courseDelete){
    setListCourseSelected(listCourseSelected.filter(course => course !== courseDelete))
  }

  function handleListTeacher(event){
    setQuery(event.target.value)
  }

  return (
    <div className="w-full h-full">
      <div className="my-10 mx-auto max-w-3xl">
        <h1 className='text-lg md:text-2xl font-semibold'>Nuevo Docente</h1>
        <p className='text-sm md:text-base text-gray-500'>Llena los datos indicados para crear un docente.</p>
        
      </div>
      <form method="POST" onSubmit={handleSubmit} className="pt-8 px-8 max-w-3xl mx-auto rounded-lg bg-white border shadow-md">
        <div className="grid grid-cols-1 md:gap-8 md:grid-cols-2 md:grid-rows-1">
          <div>
            <div>
              <label className="text-sm font-medium">Código</label>
              <input 
                type="text" 
                name="code"
                value={dataTeacher.code}
                placeholder="Código del docente" 
                className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                onChange={handleChange}
              />
            </div>

            <div className="mt-4">
              <label className="text-sm font-medium">Nombre</label>
              <input 
                type="text" 
                name="fullname"
                value={dataTeacher.fullname}
                placeholder="Nombre del docente"
                className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                onChange={handleChange}
              />
            </div>
            <div className="mt-4">
              <label className="text-sm font-medium">Email</label>
              <input 
                type="text" 
                name="email"
                value={dataTeacher.email}
                placeholder="Email del docente"
                className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                onChange={handleChange}
              />
            </div>
          </div>

          <div className="mt-4 md:mt-0">
            <div className="w-full">
              <label className="text-sm font-medium">Asignar Curso</label>
              <Combobox value={selectedCourse} onChange={handleSelectedCourse}>
                <div className="relative mt-1">
                  <div className="relative w-full cursor-default overflow-hidden rounded-lg bg-white text-left shadow-md focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75 focus-visible:ring-offset-2 focus-visible:ring-offset-teal-300 sm:text-sm">
                    <Combobox.Input
                      className="w-full border-none py-2 pl-3 pr-10 text-sm leading-5 text-gray-900 focus:ring-0"
                      displayValue={(course) => course ? course.name : ""}
                      onChange={handleListTeacher}
                    />
                    <Combobox.Button className="absolute inset-y-0 right-0 flex items-center pr-2">
                      <SelectorIcon
                        className="h-5 w-5 text-gray-400"
                        aria-hidden="true"
                      />
                    </Combobox.Button>
                  </div>
                  <Transition
                    as={Fragment}
                    leave="transition ease-in duration-100"
                    leaveFrom="opacity-100"
                    leaveTo="opacity-0"
                    afterLeave={() => setQuery('')}
                  >
                    <Combobox.Options className="absolute mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm">
                      {dataCourses.length === 0 && query !== '' ? (
                        <div className="relative cursor-default select-none py-2 px-4 text-gray-700">
                          Nothing found.
                        </div>
                      ) : (
                        dataCourses.map((course) => (
                          <Combobox.Option
                            key={course.id}
                            className={({ active }) =>
                              `relative cursor-default select-none py-2 pl-10 pr-4 ${
                                active ? 'bg-teal-600 text-white' : 'text-gray-900'
                              }`
                            }
                            value={course}
                          >
                            {({ selectedCourse, active }) => (
                              <>
                                <span
                                  className={`block truncate ${
                                    selectedCourse ? 'font-medium' : 'font-normal'
                                  }`}
                                >
                                  {course.name}
                                </span>
                                {selectedCourse ? (
                                  <span
                                    className={`absolute inset-y-0 left-0 flex items-center pl-3 ${
                                      active ? 'text-white' : 'text-teal-600'
                                    }`}
                                  >
                                    <CheckIcon className="h-5 w-5" aria-hidden="true" />
                                  </span>
                                ) : null}
                              </>
                            )}
                          </Combobox.Option>
                        ))
                      )}
                    </Combobox.Options>
                  </Transition>
                </div>
              </Combobox>
            </div>

            <div className="mt-4 w-full overflow-x-auto">
              <label className="text-sm font-medium">Lista de cursos seleccionados</label>
              <table className="mt-2">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="py-2 pr-2.5 text-xs font-medium text-center text-gray-500 uppercase tracking-wider">
                      Código
                    </th>
                    <th scope="col" className="py-2 pr-2.5 text-xs font-medium text-center text-gray-500 uppercase tracking-wider">
                      Nombre
                    </th>
                    <th scope="col" className="py-2 pr-2.5 text-xs font-medium text-center text-gray-500">
                      -
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {listCourseSelected.map((course, index)  => (
                    <tr key={`course#${index}`}>
                      <td className="px-4 py-3 whitespace-nowrap">
                        <div className="text-sm text-gray-500"> {course.code} </div>
                      </td>
                      <td className="px-4 py-3 w-full whitespace-nowrap">
                        <div className="text-sm text-gray-900"> {course.name} </div>
                      </td>
                      <td className="px-4 py-3 whitespace-nowrap text-right text-sm font-medium">
                        <a type="button" onClick={() => handleDelete(course)}  className="text-red-500 hover:text-red-700" title="Eliminar">
                          <TrashIcon className="w-5 h-5" aria-hidden="true" />
                        </a>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div className="mt-8 py-4 text-right">
          <a href="/teachers" className="py-1.5 px-4 md:py-2.5 md:px-5 text-sm md:text-base bg-gray-200 text-gray-900 leading-5 rounded-md shadow-md hover:bg-gray-300">
            Cancelar
          </a>
          <button type="submit" className="py-1.5 px-4 ml-4 md:py-2.5 md:px-5 text-sm md:text-base bg-indigo-600 text-white leading-5 rounded-md shadow-md hover:bg-indigo-700">
            Crear docente
          </button>
        </div>
      </form>
    </div>
  )
}