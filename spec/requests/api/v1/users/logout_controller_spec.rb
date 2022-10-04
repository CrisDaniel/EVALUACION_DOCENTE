require 'swagger_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :request do
  include_context 'user_stuff'
  
  describe 'Inicia sesion' do
    path "/api/v1/logout" do
      delete 'Elimina la sesion' do
        tags 'Users'
        description 'retorna un status 200'

        response 200, 'success!!!' do
          run_test! do |response|
            expect(response.status).to eq(200)
          end
        end

      end
    end
  end
end
