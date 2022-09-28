import React from "react"

export default function TemplateQuestion({ templateCat }) {
  return (
    <>
      {templateCat.map((templateQuest, index) => {
        return (
          <tr key={index}>
            <td className="px-4 py-3 whitespace-nowrap text-sm font-medium text-gray-500">
              {templateQuest.question.content}
            </td>
            <td className="py-3 text-center whitespace-nowrap">
              <input
                type="radio"
                disabled
                name={`option-${templateQuest.question.id}`}
                value="muy deficiente"
                className="text-gray-900 font-semibold"
              />
            </td>
            <td className="py-3 text-center whitespace-nowrap">
              <input
                type="radio"
                disabled
                name={`option-${templateQuest.question.id}`}
                value="deficiente"
                className="text-gray-900 font-semibold"
              />
            </td>
            <td className="py-3 text-center whitespace-nowrap">
              <input
                type="radio"
                disabled
                name={`option-${templateQuest.question.id}`}
                value="aceptable"
                className="text-gray-900 font-semibold"
              />
            </td>
            <td className="py-3 text-center whitespace-nowrap">
              <input
                type="radio"
                disabled
                name={`option-${templateQuest.question.id}`}
                value="buena"
                className="text-gray-900 font-semibold"
              />
            </td>
            <td className="py-3 text-center whitespace-nowrap">
              <input
                type="radio"
                disabled
                name={`option-${templateQuest.question.id}`}
                value="excelente"
                className="text-gray-900 font-semibold"
              />
            </td>
          </tr>
        );
      })}
    </>
  );
}
