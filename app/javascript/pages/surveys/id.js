import React from "react";
import { Link } from "react-router-dom";

export default function SurveyId() {
  return (
    <section className="flex justify-around">
      <div className="mt-9 w-full">
        <div className="flex flex-col mb-6 ">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            Mg. PEREZ GARCÍA, Juan
          </h3>
          <p className="text-sm text-gray-500">
            ISO202135 | <span>FISICA CUÁNTICA 3</span>
          </p>
        </div>

        <div className="mt-10 py-5 px-7 sm:mt-0 bg-white rounded-md">
          <div id="cat_and_questions" className="mb-5">
            <h5 className="font-bold text-2xl" id="category_name">
              Dominio del profesor sobre su curso
            </h5>

            {/* Table */}
            <div className="flex flex-col mt-3">
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
                            preguntas
                          </th>
                          <th
                            scope="col"
                            className="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                          >
                            muy deficiente
                          </th>
                          <th
                            scope="col"
                            className="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                          >
                            deficiente
                          </th>
                          <th
                            scope="col"
                            className="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                          >
                            aceptable
                          </th>
                          <th
                            scope="col"
                            className="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                          >
                            buena
                          </th>
                          <th
                            scope="col"
                            className="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                          >
                            excelente
                          </th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        <tr>
                          <td className="px-6 py-3 whitespace-nowrap text-sm font-medium text-gray-500">
                            1. Las respuestas del docente frente a las preguntas
                            del estudiante.
                          </td>
                          <td className="px-3 py-3 text-center whitespace-nowrap">
                            <input
                              type="radio"
                              name="option"
                              value="muy deficiente"
                              className="text-gray-900 font-semibold"
                            />
                          </td>
                          <td className="px-3 py-3 text-center whitespace-nowrap">
                            <input
                              type="radio"
                              name="option"
                              value="deficiente"
                              className="text-gray-900 font-semibold"
                            />
                          </td>
                          <td className="px-3 py-3 text-center whitespace-nowrap">
                            <input
                              type="radio"
                              name="option"
                              value="aceptable"
                              className="text-gray-900 font-semibold"
                            />
                          </td>
                          <td className="px-3 py-3 text-center whitespace-nowrap">
                            <input
                              type="radio"
                              name="option"
                              value="buena"
                              className="text-gray-900 font-semibold"
                            />
                          </td>
                          <td className="px-3 py-3 text-center whitespace-nowrap">
                            <input
                              type="radio"
                              name="option"
                              value="excelente"
                              className="text-gray-900 font-semibold"
                            />
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="flex justify-end">
            <Link
              to="/student/surveys"
              className="py-2 px-4 md:py-2.5 md:px-5 md:text-base bg-gray-200 text-gray-900 text-sm font-medium rounded-md shadow-md hover:bg-gray-300"
            >
              Cancelar
            </Link>
            <button className="px-4 py-2 ml-4 border-0 border-transparent text-sm font-medium rounded-md text-white bg-indigo-500 hover:bg-indigo-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Terminado
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
