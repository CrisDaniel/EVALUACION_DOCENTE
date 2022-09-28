import React from "react"

import { Link, useNavigate } from "react-router-dom";
import Toastr from 'toastr'
import Axios from "axios"

export default function NewCourses() {
  const [dataCourse, setDataCourse] = React.useState({
    code: "",
    name: "",
  })

  let navigate = useNavigate();

  function handleChange(event) {
    event.preventDefault()
    setDataCourse({
      ...dataCourse,
      [event.target.name]: event.target.value
    })
  }

  function handleSubmit(event) {
    event.preventDefault()

    Axios({
      method: 'post',
      url: '/api/v1/courses',
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
        <h1 className='text-lg md:text-2xl font-semibold'>Nuevo Curso</h1>
        <p className='text-sm md:text-base text-gray-500'>Llena los datos indicados para crear un nuevo curso.</p>
      </div>
      <form onSubmit={handleSubmit}>
        <div className='pt-8 px-8 max-w-sm mx-auto rounded-lg bg-white border shadow-md'>
          <div>
            <label className="text-sm font-medium">Código</label>
            <input
              type="text"
              name="code"
              value={dataCourse.code}
              placeholder='Código del curso'
              className="mt-1 block w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
              onChange={handleChange} />
          </div>

          <div className='mt-4'>
            <label className="text-sm font-medium">Nombre</label>
            <input
              type="text"
              name="name"
              value={dataCourse.name}
              placeholder='Nombre del curso'
              className="mt-1 block w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm"
              onChange={handleChange} />
          </div>

          <div className="mt-8 py-4 text-right">
            <Link to="/courses" className="py-1.5 px-4 md:py-2.5 md:px-5 text-sm md:text-base bg-gray-200 text-gray-900 leading-5 rounded-md shadow-md hover:bg-gray-300">
              Cancelar
            </Link>
            <button type="submit" className="py-1.5 px-4 ml-4 md:py-2.5 md:px-5 text-sm md:text-base bg-indigo-600 text-white leading-5 rounded-md shadow-md hover:bg-indigo-700">
              Crear curso
            </button>
          </div>
        </div>
      </form>
    </div>
  )
}