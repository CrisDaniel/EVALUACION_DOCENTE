import React from "react"
import { useParams } from "react-router-dom"

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

export default function EditStudent(){

  const {student_id} = useParams()

  const [cookies] = useCookies(["authorization"])

  const [dataStudent, setDataStudent] = React.useState({
    id: "",
    fullname: "",
    code: "",
    email: "",
    role: "student",
    course_ids: [0]
  })

  const [dataCourses, setDataCourses] = React.useState([])
  const [listCourseSelected, setListCourseSelected] = React.useState([])

  const [selectedCourse, setSelectedCourse] = React.useState(dataCourses[0])
  const [query, setQuery] = React.useState('')

  let navigate = useNavigate();

  React.useEffect(() => {
    handleGetStudent()
  }, []);

  React.useEffect(() => {
    handleGetCourses()
  }, [query]);

  React.useEffect(() => {
    setDataStudent({
      ...dataStudent,
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

  function handleGetStudent(){
    Axios({
      method: "get",
      url: `/api/v1/users/students/${student_id}`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': cookies.authorization
      }
    })
    .then(response => {
      if( response.data.success ) {
        setDataStudent({
          ...dataStudent,
          id: response.data.data.id,
          fullname: response.data.data.fullname,
          code: response.data.data.code,
          email: response.data.data.email,
          role: response.data.data.role,
          course_ids: response.data.data.courses.map(course => course.id)

        })
        setListCourseSelected(response.data.data.courses)
      }
    }).catch( error => {
      console.log(error.response.data)
    })
  }


  function handleChange(event){
    event.preventDefault()
    setDataStudent({
      ...dataStudent,
      [event.target.name]: event.target.value
    })
  }

  function handleListCourses(event){
    setQuery(event.target.value)
  }

  function handleSelectedCourse(course) {
    setSelectedCourse(course)
    setListCourseSelected([...listCourseSelected, course])
  }



  function handleSubmit(e) {
    e.preventDefault();

      Axios({
        method: 'patch',
        url: `/api/v1/users/${dataStudent.id}` ,
        data: { user: dataStudent}
      })
      .then(response => {
        if( response.data.success ) {
          Toastr.options.closeButton = true;
          Toastr.options.timeOut = 5000;
          Toastr.options.extendedTimeOut = 1000;
          Toastr.options.positionClass = "toast-bottom-right";
          Toastr.success(response.data.message);
          navigate("/students");
        }
      }).catch( error => {
        Toastr.options.closeButton = true;
        Toastr.options.timeOut = 5000;
        Toastr.options.extendedTimeOut = 1000;
        Toastr.options.positionClass = "toast-bottom-right";
        Toastr.error(error.response.data.message);
      })
  }

  function handleDelete(courseDelete){
    setListCourseSelected(listCourseSelected.filter(course => course !== courseDelete))
  }

  return (
    
    <section className="flex justify-around">
      <div className="w-3/4 mt-9">
        <div className="flex flex-col mb-6 ">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            Editar Alumno {student_id}
          </h3>
          <p className="text-sm text-gray-500">Editar los datos del alumno.</p>
        </div>

        <div className="mt-10 sm:mt-0">
          <div>
            <div className="mt-5 md:mt-0">
              <form onSubmit={handleSubmit} >
                <div className="shadow overflow-hidden sm:rounded-md">
                  <div className="px-4 py-5 bg-white flex justify-between sm:p-6">
                    <div  className="w-1/3">
                      <div className="mb-6">
                        <label htmlFor="codigo" className="block text-sm font-medium text-gray-700">
                          Codigo
                        </label>
                        <input
                          type="text"
                          name="code"
                          value={dataStudent.code}
                          placeholder="Código del alumno" 
                          className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                          onChange={handleChange}
                        />
                      </div>

                      <div>
                        <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                          Nombre
                        </label>
                        <input
                          type="text"
                          name="fullname"
                          value={dataStudent.fullname}
                          placeholder="Nombre del alumno"
                          className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                          onChange={handleChange}
                        />
                      </div>

                      <div>
                        <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                          Email
                        </label>
                        <input
                          type="text"
                          name="email"
                          value={dataStudent.email}
                          placeholder="Email del alumno"
                          className="mt-2 w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
                          onChange={handleChange}
                        />
                      </div>

                    </div>

                    <span className="block border-r border-dashed border-gray-200 mx-6">
                    </span>

                    <div>
                      <div className="mb-6">
                        <label htmlFor="asignar-curso" className="block text-sm font-medium text-gray-700">
                          Asignar Curso
                        </label>
                        <Combobox value={selectedCourse} onChange={handleSelectedCourse}>
                          <div className="relative mt-1">
                            <div className="relative w-full cursor-default overflow-hidden rounded-lg bg-white text-left shadow-md focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75 focus-visible:ring-offset-2 focus-visible:ring-offset-teal-300 sm:text-sm">
                              <Combobox.Input
                                className="w-full border-none py-2 pl-3 pr-10 text-sm leading-5 text-gray-900 focus:ring-0"
                                displayValue={(course) => course ? course.name : ""}
                                onChange={handleListCourses}
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

                      {/* Table */}
                      <div className="flex flex-col">
                        <label className="text-sm font-medium text-gray-700">
                          Lista de cursos matriculados
                        </label>
                        <div className="-my-2 overflow-x-auto mt-2 sm:-mx-6 lg:-mx-8">
                          <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                            <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                              <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                  <tr>
                                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                      Código
                                    </th>
                                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                      Nombre
                                    </th>
                                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                      Docente
                                    </th>
                                    <th scope="col" className="relative px-6 py-3">
                                      <span className="sr-only">Eliminar</span>
                                    </th>
                                  </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                  { listCourseSelected && (
                                    listCourseSelected.map((course, index) => (
                                    <tr key={index}>
                                      <td className="px-6 py-4 whitespace-nowrap">
                                        <div className="text-sm font-medium text-gray-500">
                                          {course.code}
                                        </div>
                                      </td>
                                      <td className="px-6 py-4 whitespace-nowrap">
                                        <div className="text-sm text-gray-900 font-semibold">{course.name}</div>
                                      </td>
                                      <td className="px-6 py-4 whitespace-nowrap">
                                        <div className="text-sm text-gray-900 font-semibold">{course.teacher}</div>
                                      </td>
                                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a type="button" onClick={() => handleDelete(course)} className="text-red-500 hover:text-red-700" title="Eliminar">
                                          <TrashIcon className="w-5 h-5" aria-hidden="true" />
                                        </a>
                                      </td>
                                    </tr>
                                    ))
                                  )}
                                </tbody>
                              </table>
                            </div>
                          </div>
                        </div>
                      </div>

                    </div>

                  </div>
                  <div className="px-4 py-3 bg-gray-50 text-right sm:px-6">
                    <a href="/students" className="py-1.5 px-4 md:py-2.5 md:px-5 text-sm md:text-base bg-gray-200 text-gray-900 leading-5 rounded-md shadow-md hover:bg-gray-300">
                      Cancelar
                    </a>
                    <button
                      type="submit"
                      className="inline-flex justify-center py-2 px-4 ml-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                      Actualizar Alumno
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

    </section>
  )
}