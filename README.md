# SEAD

![Link to E/R database image](/app/assets/images/ER-SEAD-v4.png)

To setup the project:

First use `bundle` to install all the gems for the rails project

    bundle install

And use `yarn` to install all package for the frontend

    yarn install


Create file named `master.key` into the `config/` directory.

    Request the 'master key code' to the dev team

Duplicate the `database.yml.example` file and rename it to `database.yml`
Now configure it according to your need.

*Note: You could leave all this by default, in case you did not modify anything at the time of installing postgres on your local machine*

Then you should setup the database with

    rails db:create
    rails db:migrate
    rails db:seed

or

    rails db:setup  

Which is a shortcut to run the 3 rails commands above.


Finally run Foreman to start project

    foreman start -f Procfile.dev -p 3000

*Or run these commands separately to start the backend and frontend servers*

This in one terminal to start backend

    rails s

And this in another terminal to start frontend

    bin/webpack-dev-server

## Test

To run al test using this command

    rspec

## Docs

### API

To run the api documentation generator use the following command

    rails rswag

And now you can visit `{defaultHost}/api-docs/index.html`

### Frontend
- [tailwind](https://tailwindcss.com/docs/guides/create-react-app) - For the styles
- [react-router-dom](https://github.com/remix-run/react-router/blob/f59ee5488bc343cf3c957b7e0cc395ef5eb572d2/docs/installation/getting-started.md) - For the routes in the front
- [react-cookie](https://github.com/reactivestack/cookies/tree/master/packages/react-cookie) - Use cookies with react hooks
- [axios](https://github.com/axios/axios) - For the requests
- [toastr](https://codeseven.github.io/toastr/demo.html) - Simple javascript toast notifications 
- [react-feather](https://github.com/feathericons/react-feather) - For [feather icons](https://feathericons.com/)
- [headlessui](https://github.com/tailwindlabs/headlessui) - Completely unstyled, fully accessible UI components, designed to integrate beautifully with Tailwind CSS.
- [heroicons](https://github.com/tailwindlabs/heroicons) - A set of free MIT-licensed high-quality SVG icons for UI development.
- [react-tooltip](https://github.com/wwayne/react-tooltip) - Use a tooltip in react.

### Backend
- [rspec](https://github.com/rspec/rspec-rails) - Unit test in rails
- [rack-cors](https://github.com/cyu/rack-cors) - Rack Middleware for handling Cross-Origin Resource Sharing (CORS)
- [devise](https://github.com/heartcombo/devise) - Flexible authentication solution for Rails with Warden.
- [devise-jwt](https://github.com/waiting-for-dev/devise-jwt) - JWT token authentication with devise and rails
- [rolify](https://github.com/RolifyCommunity/rolify) - Role management library with resource scoping
- [pry](https://github.com/pry/pry) - to debug in rails
- [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner) - Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing.
- [active_model_serializers](https://github.com/rails-api/active_model_serializers) - customize our json return
- [kaminari](https://github.com/kaminari/kaminari) - A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Ruby webapps
- [annotate](https://github.com/ctran/annotate_models) - Annotate Rails classes with schema and routes info
