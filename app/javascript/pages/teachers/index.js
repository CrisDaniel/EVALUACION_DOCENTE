import React from "react"
import Axios from "axios"
import Toastr from 'toastr'
import { useCookies } from "react-cookie"
import Pagination from "components/shared/pagination"
import { 
  CheckIcon, 
  ChevronDownIcon, 
  PlusIcon, 
  SearchIcon,
  SortAscendingIcon,
  SortDescendingIcon
} from "@heroicons/react/solid";
import { Listbox, Transition } from "@headlessui/react";
import { Link } from "react-router-dom";

const order = [
  { id: 1, label: "A-Z", by: "ASC" },
  { id: 2, label: "Z-A", by: "DESC" },
]

const courses = [
  {
    code: '20180190',
    name: 'Diseño de BD',
  },
  {
    code: '20180240',
    name: 'Construcción de Software',
  },
]

export default function Teachers(){

  const [cookies] = useCookies(["authorization"])
  const [selectedStudent, setSelectedStudent] = React.useState(order[0])
  const [data, setData] = React.useState([])
  const [filter, setFilter] = React.useState({
    q: '',
    order_by: "ASC",
    current_page: 1
  })

  React.useEffect(() => {
    handleGetTeachers()
  }, [filter])

  function handleOrder(order) {
    setSelectedStudent(order)
    setFilter({
      ...filter,
      order_by: order["by"]
    })
  }

  function handleFilter(event){
    event.preventDefault()
    setFilter({
      ...filter,
      [event.target.name]: event.target.value
    })
  }

  function handleGetTeachers(){
    Axios({
      method: "get",
      url: `api/v1/users/teachers?q=${filter.q}&order_by=${filter.order_by}&page=${filter.current_page}`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': cookies.authorization
      }
    })
    .then(response => {
      if( response.data.success ) {
        setData(response.data.data)
      }
    }).catch( error => {
      console.log(error.response.data)
    })
  }

  function handleDelete(teacher_id){
    Axios({
      method: "delete",
      url: `/api/v1/users/teachers/${teacher_id}`
    })
    .then(response => {
      if( response.data.success ) {
        Toastr.options.closeButton = true;
        Toastr.options.timeOut = 5000;
        Toastr.options.extendedTimeOut = 1000;
        Toastr.options.positionClass = "toast-bottom-right";
        Toastr.success(response.data.message);
        handleGetTeachers()
      }
    }).catch( error => {
      Toastr.options.closeButton = true;
      Toastr.options.timeOut = 5000;
      Toastr.options.extendedTimeOut = 1000;
      Toastr.options.positionClass = "toast-bottom-right";
      Toastr.error(error.response.data);
    })
  }

  return (
    <section className="pt-10 h-full gap-6 pb-6">
        <div className="mb-6 flex justify-between items-center">
          <h3 className="text-lg leading-6 font-medium text-gray-900" >Docentes</h3>
          <div className="flex gap-4">
            {/* Searchbar */}
            <div className="w-64">
              <label htmlFor="search" className="sr-only">
                Buscar Docente
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <SearchIcon
                      className="h-5 w-5 text-gray-400"
                      aria-hidden="true"
                    />
                </div>
                <input
                  onChange={handleFilter}
                  id="search"
                  name="q"
                  className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="Buscar Docente"
                  type="search"
                  value={filter.q}
                />
              </div>
            </div>

            <Listbox value={selectedStudent} onChange={handleOrder} >
              {({ open }) => (
                <>
                  <div className="relative">
                    <Listbox.Button className="bg-white relative w-full border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                      <span className="block truncate">
                        {selectedStudent.label == 'A-Z' ? 
                          <SortAscendingIcon
                            className="h-5 w-5 text-gray-400 inline-block"
                            aria-hidden="true"
                          />
                          :
                          <SortDescendingIcon
                            className="h-5 w-5 text-gray-400 inline-block"
                            aria-hidden="true"
                          />
                        }
                        &nbsp;
                        Orden:&nbsp;
                        {selectedStudent.label}
                      </span>
                      <span className="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
                        <ChevronDownIcon
                          className="h-5 w-5 text-gray-400"
                          aria-hidden="true"
                        />
                      </span>
                    </Listbox.Button>

                    <Transition
                        show={open}
                        as={React.Fragment}
                        leave="transition ease-in duration-100"
                        leaveFrom="opacity-100"
                        leaveTo="opacity-0"
                      >
                        <Listbox.Options
                          static
                          className="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
                        >
                          { order.map((order, index) => (
                            <Listbox.Option
                              key={index}
                              className={({ active }) =>
                                `cursor-default select-none inline-flex relative py-2 pl-3 pr-9 ${
                                  active ? "text-indigo-600" : "text-gray-900"
                                }`
                              }
                              value={order}
                            >
                              {({ selected }) => (
                                <>
                                  {selected ? (
                                    <span className="flex items-center text-indigo-600">
                                      <CheckIcon className="w-5 h-5" aria-hidden="true" />
                                    </span>
                                  ) : null}
                                  <span className={`truncate pl-2 ${
                                    selected ? "font-medium" : "pl-7 font-normal"
                                  }`}
                                  >
                                    {order.label}
                                  </span>
                                </>
                              )}
                            </Listbox.Option>
                          ))}
                        </Listbox.Options>
                    </Transition>
                  </div>
                </>
              )}
            </Listbox>

            <Link
              to="new"
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              &nbsp;
              <PlusIcon className="-ml-1 mr-2 h-3 w-3" aria-hidden="true" />
              Nuevo Docente
            </Link>
          </div>
        </div>
              
        {/* Table */}
        <div className="flex flex-col">
          <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
            <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
              <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th
                        scope="col"
                        className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                      >
                        Codigo
                      </th>
                      <th
                        scope="col"
                        className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                      >
                        Nombre
                      </th>
                      <th
                        scope="col"
                        className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                      >
                        # Cursos
                      </th>
                      <th scope="col" className="relative px-6 py-3">
                        <span className="sr-only">Editar</span>
                        <span className="sr-only">Reporte</span>
                        <span className="sr-only">Eliminar</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {data.teachers && (data.teachers.map((teacher, index) => (
                      <tr key={index}>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            <div className="text-sm font-medium text-gray-900">{teacher.code}</div>
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-900 font-semibold">{teacher.fullname}</div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-900 font-semibold">2</div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                          <Link to={`edit/${teacher.id}`} className="px-2 text-indigo-600 hover:text-indigo-900">Editar</Link>
                          <a href="#" className="px-2 text-indigo-600 hover:text-indigo-900">
                            Reporte
                          </a>
                          <a type="button" onClick={() => handleDelete(teacher.id)} className="px-2 cursor-pointer text-red-600 hover:text-red-800">
                            Eliminar
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
      {data.total_pages > 1 && (
          <Pagination
            onPageChange={handleFilter}
            current_page={data.current_page}
            total_pages={data.total_pages}
          />
        )}
    </section>
  )
}