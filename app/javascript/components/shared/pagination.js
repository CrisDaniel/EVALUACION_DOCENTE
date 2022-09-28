import React from 'react'
import { 
  ChevronLeft, 
  ChevronsLeft, 
  ChevronRight, 
  ChevronsRight 
} from "react-feather";

export default function Pagination({
  onPageChange,
  current_page,
  total_pages
}) {

  return (
    <div className="flex items-center justify-end my-5">
      <button
        onClick={onPageChange}
        disabled={current_page === 1}
        name="current_page"
        value={1}
        className={`${
          current_page === 1 &&
          "opacity-50 cursor-not-allowed"
        } rounded-md shadow-lg px-2 py-1 mr-1 text-primary focus:outline-none`}
      >
        <ChevronsLeft className="pointer-events-none" />
      </button>
      <button
        onClick={onPageChange}
        disabled={current_page === 1}
        name="current_page"
        value={current_page - 1}
        className={`${
          current_page === 1 &&
          "opacity-50 cursor-not-allowed"
        } rounded-md shadow-lg px-2 py-1 mr-2 text-primary focus:outline-none`}
      >
        <ChevronLeft className="pointer-events-none" />
      </button>
      {current_page > 2 &&
        <span className="self-end mr-2" >...</span>
      }
      {current_page > 1 &&
      <>
        {current_page - 2 !== 0 && 
          <button
            onClick={onPageChange}
            name="current_page"
            value={current_page - 2}
            className="hidden md:block hover:bg-primary-light px-2 py-1 rounded-md focus:outline-none"
          >
            {current_page - 2}
          </button>
        }
        <button
          onClick={onPageChange}
          name="current_page"
          value={current_page - 1}
          className="hover:bg-primary-light px-2 py-1 rounded-md focus:outline-none"
        >
          {current_page - 1}
        </button>
      </>
      }
      <button
        onClick={onPageChange}
        name="current_page"
        value={current_page}
        className="bg-primary text-white px-3 py-1 rounded-md focus:outline-none"
      >
        {current_page}
      </button>
      {current_page < total_pages &&
        <>
          <button
            onClick={onPageChange}
            name="current_page"
            value={current_page + 1}
            className="hover:bg-primary-light px-2 py-1 rounded-md focus:outline-none"
          >
            {current_page + 1}
          </button>
          { current_page + 2 < total_pages + 1 && 
            <button
              onClick={onPageChange}
              name="current_page"
              value={current_page + 2}
              className="hidden md:block hover:bg-primary-light px-2 py-1 rounded-md focus:outline-none"
            >
              {current_page + 2}
            </button>
          }
        </>
      }
      {current_page < (total_pages - 1) &&
        <span className="self-end ml-2">...</span>
      }
      <button
        onClick={onPageChange}
        disabled={current_page === total_pages}
        name="current_page"
        value={current_page + 1}
        className={`${
          current_page === total_pages &&
          "opacity-50 cursor-not-allowed"
        } rounded-md shadow-lg px-2 py-1 ml-2 text-primary focus:outline-none`}
      >
        <ChevronRight className="pointer-events-none" />
      </button>
      <button
        onClick={onPageChange}
        disabled={current_page === total_pages}
        name="current_page"
        value={total_pages}
        className={`${
          current_page === total_pages &&
          "opacity-50 cursor-not-allowed"
        } rounded-md shadow-lg px-2 py-1 ml-1 text-primary focus:outline-none`}
      >
        <ChevronsRight className="pointer-events-none" />
      </button>
    </div>
  )
}