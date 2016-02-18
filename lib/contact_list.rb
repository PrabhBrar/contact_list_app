#!/usr/bin/env ruby
require_relative 'contact'
require_relative 'connection'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # Checks the user input arguments and then performs a specific task.
  def start
    system "clear"
    case ARGV[0]
    when "new"
      get_new_contact
    when "list"
      list
    when "show"
      find
    when "search"
      search
    when "update"
      update
    when "destroy"
      destroy
    else
      show_commands
    end
  end

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def show_commands
    puts "Here is a list of available commands:"
    puts "  new     - Create a new contact"
    puts "  list    - List all contacts"
    puts "  show    - Show a contact"
    puts "  search  - Search contacts"
    puts "  update  - Update a contact"
    puts "  destroy - Deletes a contact"
  end

  def find
    id = ARGV[1].to_i
    display_one_contact(Contact.find(id))
  end

  def search
    term = '%'+ARGV[1]+'%'
    display_multiple_contacts(Contact.where("name LIKE ? OR email LIKE ?", term, term))
  end

  def update
    id = ARGV[1].to_i
    contact = Contact.find(id)
    get_update_information(contact)
  end

  def destroy
    id = ARGV[1].to_i
    contact = Contact.find(id)
    puts "Deleted the below entry from database: "
    display_one_contact(contact)
    contact.destroy
    contact = nil
  end

  # Displays all the contacts in the database.
  def list
    limit = 3
    offset = 0
    total_contacts = Contact.count
    while offset < total_contacts
      display_multiple_contacts(Contact.all.limit(limit).offset(offset))
      offset += limit
      wait_for_user_response(offset, total_contacts)
    end
  end

  # Asks user to enter details for the new contact.
  # @return [nil].
  def get_new_contact
    puts "Enter details for the new contact: "
    name, email = get_name, get_email
    contact = Contact.create(name: name, email: email)
    if contact
      puts "Contact was created successfully, Id of the new contact: #{contact.id}."
    else
      puts "Contact already exists! New Contact can not be created."
    end
  end

  def get_update_information(contact)
    if contact
      display_one_contact(contact)
      print "Do you want to update the name?(y/n) "
      choice = STDIN.gets.chomp
      name = get_name if choice == 'y'
      print "Do you want to update the email?(y/n) "
      choice = STDIN.gets.chomp
      email = get_email if choice == 'y'
      #print "Do you want to update the phone numbers?(y/n) "
      #choice = STDIN.gets.chomp
      #phone_numbers = get_phone_numbers if choice == 'y'
      contact.update(name: name, email: email)
      puts "Contact updated."
      display_one_contact(contact)
    else
      puts "Not Found!"
    end
  end

  def get_name
    print "Full Name: "
    name = STDIN.gets.chomp
  end

  def get_email
    print "E-mail: "
    email = STDIN.gets.chomp
  end

  def get_phone_numbers
    phone_numbers = []
    print "Do you want to add phone number?(y/n) "
    choice = STDIN.gets.chomp
    while choice == "y" do
      print "  Label: "
      label = STDIN.gets.chomp 
      print "  Number: "
      number = STDIN.gets.chomp
      phone_numbers << PhoneNumber.new(label, number)
      print "Do you want to add another number?(y/n) "
      choice = STDIN.gets.chomp.downcase
    end
    phone_numbers
  end

  # Displays one contact passed as argument on the screen.
  # @param contact [Array].
  # @return [nil].
  def display_one_contact(contact)
    if contact
      puts "Name: #{contact.name}"
      puts "E-mail: #{contact.email}"
    else
      puts "Not found!"
    end
  end

  # Displays all the contacts passed as argument on the screen.
  # @param contacts [Array<Contact>] Array of Contact objects.
  # @return [Array<Contact>] .
  def display_multiple_contacts(contacts)
    contacts.each do |contact|
      puts "#{contact.id}: #{contact.name} (#{contact.email})"
    end
  end

  def wait_for_user_response(offset, total_contacts)
    if offset < total_contacts
      puts "Press Enter to continue."
      STDIN.gets
      system "clear"
    else
      puts ""
      puts "---------"
      puts "#{total_contacts} records total."
    end
  end

end

contact_list = ContactList.new
contact_list.start