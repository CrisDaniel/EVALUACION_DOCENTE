class TeacherSerializer < ActiveModel::Serializer
  attributes :id,
             :code,
             :fullname, 
             :email
end