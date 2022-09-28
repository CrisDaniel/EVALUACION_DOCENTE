import React from "react";
import Axios from "axios";
import ReactTooltip from "react-tooltip";
import { useCookies } from "react-cookie";
import {
  CheckIcon,
  ChevronDownIcon,
  PlusIcon,
  SearchIcon,
  SortAscendingIcon,
  SortDescendingIcon,
} from "@heroicons/react/solid";
import { Listbox, Transition } from "@headlessui/react";

import Pagination from "components/shared/pagination";

const order = [
  { id: 1, label: "A-Z", by: "ASC" },
  { id: 2, label: "Z-A", by: "DESC" },
];

function CategoryAverage({ type, average }) {
  let averageName = "";

  switch (true) {
    case average < 1.0:
      averageName = "Muy Deficiente";
      break;
    case average >= 1.0 && average < 2.0:
      averageName = "Deficiente";
      break;
    case average >= 2.0 && average < 3.0:
      averageName = "Aceptable";
      break;
    case average >= 3.0 && average < 4.0:
      averageName = "Bueno";
      break;

    default:
      averageName = "Excelente";
      break;
  }

  return (
    <td key={type} className="px-6 py-4 whitespace-nowrap">
      <div
        data-tip
        data-for="registerTip"
        className="text-sm text-gray-600 font-semibold cursor-pointer"
      >
        {averageName}
      </div>

      <ReactTooltip id="registerTip" place="top" effect="solid" type="light">
        <b>
          Promedio:&nbsp;
          <span
            className={`${average < 3.5 ? "text-red-600" : "text-blue-600"}`}
          >
            {average}
          </span>
        </b>
      </ReactTooltip>
    </td>
  );
}

export default function Index() {
  const [cookies] = useCookies(["authorization"]);
  const [selectedStudent, setSelectedStudent] = React.useState(order[0]);
  const [data, setData] = React.useState([]);
  const [filter, setFilter] = React.useState({
    q: "",
    order_by: "ASC",
    current_page: 1,
  });

  React.useEffect(() => {
    handleGetStudents();
  }, [filter]);

  function handleOrder(order) {
    setSelectedStudent(order);
    setFilter({
      ...filter,
      order_by: order["by"],
    });
  }

  function handleFilter(event) {
    event.preventDefault();
    setFilter({
      ...filter,
      [event.target.name]: event.target.value,
    });
  }

  function handleGetStudents() {
    Axios({
      method: "get",
      url: `api/v1/reports/teachers?q=${filter.q}&order_by=${filter.order_by}&page=${filter.current_page}`,
      headers: {
        "Content-Type": "application/json",
        Authorization: cookies.authorization,
      },
    })
      .then((response) => {
        if (response.data.success) {
          setData(response.data.data);
        }
      })
      .catch((error) => {
        console.log(error.response.data);
      });
  }

  return (
    <section className="pt-10 h-full gap-6 pb-6">
      <div className="flex justify-between items-center mb-6 ">
        <h3 className="text-lg leading-6 font-medium text-gray-900">
          Reporte de Docentes
        </h3>
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
                placeholder="Buscar Alumno"
                type="search"
                value={filter.q}
              />
            </div>
          </div>

          <Listbox value={selectedStudent} onChange={handleOrder}>
            {({ open }) => (
              <>
                <div className="relative">
                  <Listbox.Button className="bg-white relative w-full border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <span className="block truncate">
                      {selectedStudent.label == "A-Z" ? (
                        <SortAscendingIcon
                          className="h-5 w-5 text-gray-400 inline-block"
                          aria-hidden="true"
                        />
                      ) : (
                        <SortDescendingIcon
                          className="h-5 w-5 text-gray-400 inline-block"
                          aria-hidden="true"
                        />
                      )}
                      &nbsp; Orden:&nbsp;
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
                      {order.map((order, index) => (
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
                                  <CheckIcon
                                    className="w-5 h-5"
                                    aria-hidden="true"
                                  />
                                </span>
                              ) : null}
                              <span
                                className={`truncate pl-2 ${
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

          {/* <Link
            to="new"
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            &nbsp;
            <PlusIcon className="-ml-1 mr-2 h-3 w-3" aria-hidden="true" />
            Nuevo Alumno
          </Link> */}
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
                    {/* <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Código
                    </th> */}
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
                      Encuestas
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat1"
                    >
                      CAT.1
                      <ReactTooltip
                        id="cat1"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Dominio del profesor sobre el curso</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat2"
                    >
                      CAT.2
                      <ReactTooltip
                        id="cat2"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Metodos de ensañanza</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat3"
                    >
                      CAT.3
                      <ReactTooltip
                        id="cat3"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Relación del profesor con los estudiantes</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat4"
                    >
                      CAT.4
                      <ReactTooltip
                        id="cat4"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Puntualidad y cumplimiento</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat5"
                    >
                      CAT.5
                      <ReactTooltip
                        id="cat5"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Contenido del curso para la formación profesional</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat6"
                    >
                      CAT.6
                      <ReactTooltip
                        id="cat6"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Esfuerzo y dedicación</b>
                      </ReactTooltip>
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer"
                      data-tip
                      data-for="cat7"
                    >
                      CAT.7
                      <ReactTooltip
                        id="cat7"
                        place="top"
                        effect="solid"
                        type="light"
                      >
                        <b>Mantenimiento de la disciplina en clase</b>
                      </ReactTooltip>
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {data.teachers &&
                    data.teachers.map((teacher, index) => (
                      <tr key={index}>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div 
                            className="text-sm text-gray-900 font-semibold cursor-pointer"
                            data-tip
                            data-for="teacher"
                          >
                            {teacher.fullname}
                          </div>
                          <ReactTooltip
                            id="teacher"
                            place="top"
                            effect="solid"
                            type="light"
                          >
                            <p><b>Código:&nbsp;</b>{teacher.code}</p>
                            <p><b>Email:&nbsp;</b>{teacher.email}</p>
                          </ReactTooltip>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-center">
                          <div className="text-sm text-gray-900 font-semibold">
                            <span
                              className="text-red-600 cursor-pointer"
                              data-tip
                              data-for="incompleted"
                            >
                              {teacher.surveys.incompleted}
                            </span>
                            <ReactTooltip
                              id="incompleted"
                              place="top"
                              effect="solid"
                              type="light"
                            >
                              <span className="text-red-600 font-light">
                                Incompletadas
                              </span>
                            </ReactTooltip>
                            /
                            <span
                              className="text-blue-600 cursor-pointer"
                              data-tip
                              data-for="completed"
                            >
                              {teacher.surveys.completed}
                            </span>
                            <ReactTooltip
                              id="completed"
                              place="top"
                              effect="solid"
                              type="light"
                            >
                              <span className="text-blue-600 font-light">Completadas</span >
                            </ReactTooltip>
                          </div>
                        </td>
                        <CategoryAverage
                          type="domain"
                          average={teacher.categories["domain"]}
                        />
                        <CategoryAverage
                          type="methodology"
                          average={teacher.categories["methodology"]}
                        />
                        <CategoryAverage
                          type="relationship"
                          average={teacher.categories["relationship"]}
                        />
                        <CategoryAverage
                          type="puntuality"
                          average={teacher.categories["puntuality"]}
                        />
                        <CategoryAverage
                          type="contents"
                          average={teacher.categories["contents"]}
                        />
                        <CategoryAverage
                          type="dedication"
                          average={teacher.categories["dedication"]}
                        />
                        <CategoryAverage
                          type="discipline"
                          average={teacher.categories["discipline"]}
                        />
                      </tr>
                    ))}
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
  );
}
