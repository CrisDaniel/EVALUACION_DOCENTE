import React from "react"
import { useCookies } from "react-cookie"
import Axios from "axios"
import { Link } from "react-router-dom"

export default function SurveysStudent(){

  const [cookies] = useCookies(["authorization"])
  const [listSurveys, setListSurveys] = React.useState([])

  React.useEffect(() => {
    handleGetListSurveys()
  }, []);

  function handleGetListSurveys() {
    Axios({
      method: "get",
      url: `/api/v1/users/surveys`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': cookies.authorization
      }
    })
    .then(response => {
      if( response.data.success ) {
        setListSurveys(response.data.data)
      }
    }).catch( error => {
      console.log(error.response.data)
    })

  }

  return (

    <div className="">
      <div className="max-w-2xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:max-w-7xl lg:px-8">
        <h2 className="sr-only">Listado de encuestas del Estudiante</h2>
        <div className="flex flex-wrap ">
          {listSurveys.map((survey) => (
            <div
              key={survey.id}
              className="bg-white w-1/2 md:w-1/4 m-5 p-4 rounded-md"
            >
              <p className="mb-4 text-sm text-gray-700 ">{survey.teacher}</p>
              <p className="mb-4 text-sm text-gray-700">{survey.course.id}</p>
              <p className="mb-4 text-sm text-gray-700">{survey.course.name}</p>
              <Link
                to={`${survey.id}`}
                className="py-2 flex justify-center shadow-sm text-sm rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Realizar Encuesta
              </Link>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}