ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'contacts_list_app',
  username: 'development',
  password: 'development'
)