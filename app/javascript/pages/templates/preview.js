import React from "react";
import Axios from "axios";
import { useParams, Link } from "react-router-dom";
import { useCookies } from "react-cookie";
import TemplateQuestion from "./template_question";


export default function PreviewTemplates() {
  const { template_id } = useParams();
  const [cookies] = useCookies(["authorization"]);
  const [data, setData] = React.useState([]);

  const domain = data.filter((item) => item.category == "domain");
  const methodology = data.filter((item) => item.category == "methodology");
  const relationship = data.filter((item) => item.category == "relationship");
  const puntuality = data.filter((item) => item.category == "puntuality");
  const contents = data.filter((item) => item.category == "contents");
  const dedication = data.filter((item) => item.category == "dedication");
  const discipline = data.filter((item) => item.category == "discipline");

  const questionsByCategory = {
    domain: {
      title: "Dominio del curso",
      value: domain,
    },
    methodology: {
      title: "Metodología del curso",
      value: methodology,
    },
    relationship: {
      title: "Relación con el curso",
      value: relationship,
    },
    puntuality: {
      title: "Puntualidad del curso",
      value: puntuality,
    },
    contents: {
      title: "Contenidos del curso",
      value: contents,
    },
    dedication: {
      title: "Dedicación del curso",
      value: dedication,
    },
    discipline: {
      title: "Disciplina del curso",
      value: discipline,
    },
  };

  function handleGetDataTemplate() {
    Axios({
      method: "get",
      url: `/api/v1/templates/${template_id}`,
      headers: {
        "Content-Type": "application/json",
        Authorization: cookies.authorization,
      },
    })
      .then((response) => {
        if (response.data.success) {
          setData(response.data.template.template_questions);
        }
      })
      .catch((error) => {
        console.log(error.response.data);
      });
  }

  React.useEffect(() => {
    handleGetDataTemplate();
  }, []);

  return (
    <section className="flex justify-around">
      <div className="mt-9 w-full">
        <div className="flex flex-col mb-6 ">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            NOMBRE DEL DOCENTE
          </h3>
          <p className="text-sm text-gray-500">
            COD. CURSO | <span>NOMBRE DEL CURSO</span>
          </p>
        </div>

        <div className="mt-10 py-5 px-7 sm:mt-0 bg-white rounded-md">
          {Object.entries(questionsByCategory).map((templateCat, index) => {
            return (
              // console.log(templateCat[1].value)
              <div key={index} id="cat_and_questions" className="mb-5">
                <h5 className="font-bold text-2xl" id="category_name">
                  {templateCat[1].title}
                </h5>

                <div className="flex flex-col mt-3 overflow-hidden">
                  <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
                    <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                      <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                        <table className="min-w-full divide-y divide-gray-200">
                          <thead className="bg-gray-50">
                            <tr>
                              <th
                                scope="col"
                                className="w-full px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider overflow-hidden"
                              >
                                preguntas
                              </th>
                              <th
                                scope="col"
                                className="w-8 px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                muy deficiente
                              </th>
                              <th
                                scope="col"
                                className="py-3 px-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                deficiente
                              </th>
                              <th
                                scope="col"
                                className="py-3 px-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                aceptable
                              </th>
                              <th
                                scope="col"
                                className="py-3 px-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                buena
                              </th>
                              <th
                                scope="col"
                                className="py-3 px-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                excelente
                              </th>
                            </tr>
                          </thead>
                          <tbody className="bg-white divide-y divide-gray-200">
                            <TemplateQuestion
                              key={index}
                              templateCat={templateCat[1].value}
                            />
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}

          <div className="flex justify-end">
            <Link
              to="/templates "
              className="py-2 px-4 md:py-2.5 md:px-5 md:text-base bg-gray-200 text-gray-900 text-sm font-medium rounded-md shadow-md hover:bg-gray-300"
            >
              Cancelar
            </Link>
            <button className="px-4 py-2 ml-4 border-0 border-transparent text-sm font-medium rounded-md text-white bg-indigo-500 hover:bg-indigo-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Publicar | Clonar
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
