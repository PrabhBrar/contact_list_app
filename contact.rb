require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @csvfile = "contacts.csv"

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)
    # TODO: Assign parameter values to instance variables.
    @id = id
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      contacts = []
      CSV.foreach(@csvfile) do |row|
        contacts.push(Contact.new($INPUT_LINE_NUMBER - 1, row[0], row[1])) unless $INPUT_LINE_NUMBER == 1
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contacts = CSV.read(@csvfile)
      new_contact = Contact.new(contacts.length, name, email)
      CSV.open(@csvfile, "ab") { |csv| csv << [new_contact.name, new_contact.email] }
      new_contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      contacts = CSV.read(@csvfile)
      contacts[id.to_i]
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def delete(id)
      table = CSV.table(@csvfile)
      table.delete(id.to_i - 1)

      File.open(@csvfile, 'w') do |f|
        f.write(table.to_csv)
      end
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      searched_contacts = []
      CSV.foreach(@csvfile) do |row|
        searched_contacts.push(Contact.new($INPUT_LINE_NUMBER - 1, row[0], row[1])) if row.join(" ").downcase.include?(term.downcase)
      end
      searched_contacts
    end
  end

end