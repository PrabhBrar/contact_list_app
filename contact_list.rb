require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def main_menu
    puts "Here is a list of available commands:"
    puts "  new     - Create a new contact"
    puts "  list    - List all contacts"
    puts "  show    - Show a contact"
    puts "  search  - Search contacts"
    user_input
  end

  def user_input
    user_input = gets.chomp.downcase

    case user_input
    when "new"
      Contact.create
    when "list"
      display(Contact.all)
    when "show"
    when "search"
    else
    end
  end

  def display(contacts)
    contacts.each_with_index do |contact, index|
      puts "#{index + 1}: #{contact.name} (#{contact.email})"
    end
    puts "---------"
    puts "#{contacts.count} records total"
  end

end

ContactList.new.main_menu