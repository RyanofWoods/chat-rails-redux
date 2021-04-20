*Currently in-development:*

A **TDD** chat web-app created in **Ruby on Rails** using **React**. 

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

### Contains an RESTful API. Endpoints:
- `GET /api/v1/channels/`
- `POST /api/v1/channels/`
- `PATCH /api/v1/channels/<channel_name>/` (only channel owner and admins are authorized, and only name is editable)
- `DELETE /api/v1/channels/<channel_name>/` (only channel owner and admins are authorized)
- `GET /api/v1/channels/<channel_name>/messages`
- `POST /api/v1/channels/<channel_name>/messages`

### Useful gems used:
**Authentication and Authorisation:**
- [Devise](https://github.com/heartcombo/devise)
- [Simple Token Authentication](https://github.com/gonzalo-bulnes/simple_token_authentication)
- [Pundit](https://github.com/varvet/pundit)

**Debugging:**
- [Pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) (debugging)

**TDD:**
- [Capybara](https://github.com/teamcapybara/capybara)
- [RSPEC](https://github.com/rspec/rspec-rails) (built into Rails)

**TDD helpers:**
- [Faker](https://github.com/faker-ruby/faker)
- [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner)
- [Factory Bot](https://github.com/thoughtbot/factory_bot)
