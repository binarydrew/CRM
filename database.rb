require_relative "contacts"

class Database

	attr_accessor :contacts

	def initialize
		@contacts=[]
	end

	def add_contact(profile)
		person = Contact.new(profile["First Name"], profile["Last Name"], profile["email"], 
			                 profile["Notes"], profile["ID"])
		@contacts << person

	end

	def delete_contact(id_number)
		@contacts.each do |c|
			@contacts.delete(c) if c.id == id_number
		end
	end

	def modify_contact(id_number, detail, modification)
		@contacts.each do |c|
			if c.id == id_number
				if detail == "First Name"
					c.first_name = modification
				elsif detail == "Last Name"
					c.last_name = modification
				elsif detail == "email"
					c.email = modification
				elsif detail == "Notes"
					c.notes = modification
				end
			end
		end
	end

	def return_all_contacts
		compile_contacts(@contacts)
	end

	def find_contacts(c_detail)
		result = []
		@contacts.each do |c|
			if (c.first_name == c_detail) || (c.last_name == c_detail) || (c.email == c_detail)\
			    || (c.notes == c_detail) || (c.id == c_detail)
			    result << c
			end
		end
		compile_contacts(result)
	end

	private

	def compile_contacts(contact_list)
		result = []
		contact_list.each do |c|
			profile_hash = {}

			profile_hash["ID"] = c.id if c.id != ""
			profile_hash["First Name"] = c.first_name
			profile_hash["Last Name"] = c.last_name if c.last_name != ""
			profile_hash["email"] = c.email if c.email != ""
			profile_hash["Notes"] = c.notes if c.notes != ""

			result << profile_hash
		end
		result
	end

end