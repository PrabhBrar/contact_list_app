require 'active_record'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the database directly
class Contact < ActiveRecord::Base

  validates :email, uniqueness: true,
            presence: true
  validates :name, presence: true

end