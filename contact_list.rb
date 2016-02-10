require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  def start
    case ARGV[0]
    when "new"
      get_new_contact
    when "list"
      display_all_contacts(Contact.all)
    when "show"
      display_one_contact(Contact.find(ARGV[1]))
    when "search"
      display_all_contacts(Contact.search(ARGV[1]))
    when "delete"
      Contact.delete(ARGV[1])
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

  def display_all_contacts(contacts)
    contacts.each do |contact|
      puts "#{contact.id}: #{contact.name} (#{contact.email})"
    end
    puts ""
    puts "---------"
    puts "#{contacts.count} records total"
  end

  def get_new_contact
    puts "Enter details for the new contact: "
    print "Full Name: "
    name = STDIN.gets.chomp
    print "E-mail: "
    email = STDIN.gets.chomp
    puts "Contact was created successfully, Id of the new contact: #{Contact.create(name, email).id}."
  end

  def display_one_contact(contact)
    if contact
      puts "Name: #{contact[0]}"
      puts "E-mail: #{contact[1]}"
    else
      puts "Not found!"
    end
  end

end

contact_list = ContactList.new
contact_list.start