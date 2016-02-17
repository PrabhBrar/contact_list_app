require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the database directly
class Contact

  @cs = "database"
  
  attr_accessor :name, :email, :phone_number
  attr_reader :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  # @param phone_number [String] The contact's phone number
  # @param id [Integer] The contact's unique id
  def initialize(name, email, phone_number, id = nil)
    @name = name
    @email = email
    @phone_number = phone_number
    @id = id
  end

  def save
    if persisted?
      Contact.connection.exec_params("UPDATE contacts SET name=$1, email=$2 WHERE id=$3;", [name, email, id])
    else
      result = Contact.connection.exec_params("INSERT INTO contacts(name, email) VALUES($1, $2) RETURNING id", [name, email])
      @id = result[0]["id"]
    end
  end

  # Find the Contact in the 'database' with the matching id.
  # @param id [Integer] the contact id
  # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
  def destroy
    Contact.connection.exec_params("DELETE FROM contacts WHERE id=$1::int", [id])
  end

  def update(contact, name, email, phone_numbers)
    contact.name = name if name
    contact.email = email if email
    contact.phone_number = phone_numbers if phone_numbers
    contact.save
  end

  def persisted?
    !id.nil?
  end

  # Provides functionality for managing contacts in the database.
  class << self

    # Establishes the connection (using the proper credentials) and returns the connection object.
    def connection
      conn = PG::Connection.new(host: 'localhost', dbname: 'contacts_list_app', user: 'development', password: 'development')
    end

    def record_count
      self.connection.exec_params("SELECT count(*) FROM contacts;")[0]["count"].to_i
    end

    # Opens 'database' and creates a Contact object for each row in the database(aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all(limit, offset)
      result = self.connection.exec_params("SELECT * FROM contacts LIMIT $1::int OFFSET $2::int;", [limit, offset])
      convert_pg_data_into_contacts(result)
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    # @param phone_number [Integer] the contact's phone number
    def create(name, email, phone_number)
      unless contact_exists?(email)
        new_contact = Contact.new(name, email, phone_number)
        new_contact.save
        new_contact
      end
    end
    
    # Checks if the given email already exists in the database, returns true or false.
    # @param email [String] the contact's email
    # @return [Boolean]
    def contact_exists?(email)
      result = Contact.connection.exec_params("SELECT * FROM contacts;")
      result.detect { |contact| contact["email"] == email}
    end 

    # Find the Contact in the 'database' with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      contact = Contact.connection.exec_params("SELECT * FROM contacts WHERE id = $1::int;", [id]).first
      Contact.new(contact["name"], contact["email"], "604-445-6081", contact["id"]) if contact
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      term = '%'+term+'%'
      result = Contact.connection.exec_params("SELECT * FROM contacts WHERE name LIKE $1 OR email LIKE $1;", [term])
      convert_pg_data_into_contacts(result)
    end

    def convert_pg_data_into_contacts(result)
      contacts = []
      result.each do |contact|
        contacts << Contact.new(contact["name"], contact["email"], "604-445-6081", contact["id"])
      end
      contacts 
    end
  end

end