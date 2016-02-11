#!/usr/bin/env ruby
require_relative 'contact'
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
      display_all_contacts(Contact.all)
    when "show"
      id = ARGV[1].to_i
      display_one_contact(Contact.find(id))
    when "search"
      display_all_contacts(Contact.search(ARGV[1]))
    when "delete"
      id = ARGV[1].to_i
      display_one_contact(Contact.delete(id))
    else
      main_menu
    end
  end

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def main_menu
    puts "Here is a list of available commands:"
    puts "  new     - Create a new contact"
    puts "  list    - List all contacts"
    puts "  show    - Show a contact"
    puts "  search  - Search contacts"
    puts "  delete  - Deletes a contact"
  end

  # Displays all the contacts passed as argument on the screen.
  # @param contacts [Array<Contact>] Array of Contact objects.
  # @return [nil] .
  def display_all_contacts(contacts)
    count = 0
    contacts.each do |contact|
      if count < 5
        count += 1
        puts "#{contact.id}: #{contact.name} (#{contact.email}) (#{contact.phone_number})"
      else
        puts "Press Enter to continue."
        STDIN.gets
        # if user_input == "\n"
          count = 1
          system "clear"
          puts "#{contact.id}: #{contact.name} (#{contact.email}) (#{contact.phone_number})"
        # end
      end
    end
    puts ""
    puts "---------"
    puts "#{contacts.count} records total"
  end

  # Asks user to enter details for the new contact.
  # @return [nil].
  def get_new_contact
    puts "Enter details for the new contact: "
    print "Full Name: "
    name = STDIN.gets.chomp
    print "E-mail: "
    email = STDIN.gets.chomp
    print "Phone Numbers: \n"
    phone_numbers = get_phone_numbers
    contact = Contact.create(name, email, phone_numbers)
    if contact
      puts "Contact was created successfully, Id of the new contact: #{contact.id}."
    else
      puts "Contact already exists! New Contact can not be created."
    end
  end

  def get_phone_numbers
    choice = "y"
    phone_number = ""
    while choice == "y" do
      print "  Label: "
      phone_number += STDIN.gets.chomp + ": "
      print "  Number: "
      phone_number += STDIN.gets.chomp + " "
      print "Do you want to enter another number?(y/n) "
      choice = STDIN.gets.chomp.downcase
    end
    phone_number
  end

  # Displays one contact passed as argument on the screen.
  # @param contact [Array].
  # @return [nil].
  def display_one_contact(contact)
    if contact
      puts "Name: #{contact.name}"
      puts "E-mail: #{contact.email}"
      puts "Phone Number: #{contact.phone_number}"
    else
      puts "Not found!"
    end
  end

end

contact_list = ContactList.new
contact_list.start