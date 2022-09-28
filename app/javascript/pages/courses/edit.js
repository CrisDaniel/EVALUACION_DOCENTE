import React from "react"

import { useParams, useNavigate, Link } from "react-router-dom"
import { useCookies } from "react-cookie"

import Axios from "axios"
import Toastr from 'toastr'

export default function EditCourses() {

  const { course_id } = useParams()

  const [cookies] = useCookies(['authorization'])

  const [dataCourse, setDataCourse] = React.useState({
    id: "",
    code: "",
    name: "",
  })

  let navigate = useNavigate();

  React.useEffect(() => {
    handleGetDataCourse()
  }, [])

  function handleChange(event) {
    event.preventDefault()
    setDataCourse({
      ...dataCourse,
      [event.target.name]: event.target.value
    })
  }

  function handleGetDataCourse() {
    Axios({
      method: 'get',
      url: `/api/v1/courses/${course_id}`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': cookies.authorization
      }
    })
      .then(response => {
        if (response.data.success) {
          setDataCourse(response.data.data)
        }
      })
      .catch(error => {
        console.log(error.response.data)
      })
  }

  function handleSubmit(event) {
    event.preventDefault()

    Axios({
      method: 'patch',
      url: `/api/v1/courses/${dataCourse.id}`,
      data: { course: dataCourse }
    })
      .then(response => {
        if (response.data.success) {
          Toastr.options.closeButton = true;
          Toastr.options.timeOut = 5000;
          Toastr.options.extendedTimeOut = 1000;
          Toastr.options.positionClass = "toast-bottom-right";
          Toastr.success(response.data.message);
          navigate("/courses");
        }
      })
      .catch(error => {
        Toastr.options.closeButton = true;
        Toastr.options.timeOut = 5000;
        Toastr.options.extendedTimeOut = 1000;
        Toastr.options.positionClass = "toast-bottom-right";
        Toastr.error(error.response.data.message);
      })
  }

  return (
    <div className='px-4 w-full h-full text-justify'>
      <div className='my-10 mx-auto max-w-sm'>
        <h1 className='text-lg md:text-2xl font-semibold'>{dataCourse.code} - {dataCourse.name}</h1>
        <p className='text-sm md:text-base text-gray-500'>Actualiza los datos del curso.</p>
      </div>
      <form onSubmit={handleSubmit}>
        <div className='pt-8 px-8 max-w-sm mx-auto rounded-lg bg-white border shadow-md'>
          <div>
            <label className="text-sm font-medium">Código</label>
            <input
              type="text"
              name="code"
              value={dataCourse.code}
              onChange={handleChange}
              placeholder='Código del curso'
              className="mt-1 block w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm" />
          </div>

          <div className='mt-4'>
            <label className="text-sm font-medium">Nombre</label>
            <input type="text"
              name="name"
              value={dataCourse.name}
              onChange={handleChange}
              placeholder='Nombre del curso'
              className="mt-1 block w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm" />
          </div>

          <div className="mt-8 py-4 text-right">
            <Link to="/courses" className="py-1.5 px-4 md:py-2.5 md:px-5 text-sm md:text-base bg-gray-200 text-gray-900 leading-5 rounded-md shadow-md hover:bg-gray-300">
              Cancelar
            </Link>
            <button type="submit" className="py-1.5 px-4 ml-4 md:py-2.5 md:px-5 text-sm md:text-base bg-indigo-600 text-white leading-5 rounded-md shadow-md hover:bg-indigo-700">
              Actualizar curso
            </button>
          </div>
        </div>
      </form>
    </div>
  )
}