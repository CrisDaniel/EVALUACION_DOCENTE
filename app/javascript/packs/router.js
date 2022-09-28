import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { useCookies } from "react-cookie"

import Navbar from 'components/shared/navbar'
import Login from 'pages/auth/login'
import Dashboard from 'pages/dashboard';
import Teachers from 'pages/teachers';
import Students from 'pages/students';
import Courses from 'pages/courses';
import Templates from 'pages/templates';
import PreviewTemplates from "pages/templates/preview";
import NewStudent from "pages/students/new";
import EditStudent from "pages/students/edit";
import NewTeachers from "pages/teachers/new";
import EditTeachers from "pages/teachers/edit";
import NewCourses from "pages/courses/new";
import EditCourses from "pages/courses/edit";
import SurveysStudent from "pages/surveys";
import SurveyId from "pages/surveys/id";

export default function Router() {
  const [cookies] = useCookies(["authorization"]);

  const currentUser = JSON.parse(localStorage.getItem("user"));

  return (
    <div className="antialiased">
      <Routes>
        {cookies.authorization ? (
          <>
            <Route path="/" element={<Navbar currentUser={currentUser} />}>
              <Route path="dashboard" element={<Dashboard />} />
              {currentUser.role === "admin" && (
                <>
                  <Route path="teachers">
                    <Route index element={<Teachers />} />
                    <Route path="new" element={<NewTeachers />} />
                    <Route path="edit/:teacher_id" element={<EditTeachers />} />
                  </Route>
                  <Route path="students">
                    <Route index element={<Students />} />
                    <Route path="new" element={<NewStudent />} />
                    <Route path="edit/:student_id" element={<EditStudent />} />
                  </Route>
                  <Route path="courses">
                    <Route index element={<Courses />} />
                    <Route path="new" element={<NewCourses />} />
                    <Route path="edit/:course_id" element={<EditCourses />} />
                  </Route>
                  <Route path="templates">
                    <Route index element={<Templates />} />
                    <Route
                      path=":template_id/preview"
                      element={<PreviewTemplates />}
                    />
                  </Route>
                </>
              )}
              {currentUser.role === "student" && (
                <Route path="student">
                  <Route path="surveys">
                    <Route index element={<SurveysStudent />} />
                    <Route path=":survey_id" element={<SurveyId />} />
                  </Route>
                </Route>
              )}
              <Route path="*" element={<Navigate to="/dashboard" />} />

              {/* <Navigate to="/dashboard" /> */}
            </Route>
          </>
        ) : (
          <>
            <Route path="/auth/login" element={<Login />} />
            <Route path="*" element={<Navigate to="/auth/login" />} />
          </>
        )}
      </Routes>
    </div>
  );
}