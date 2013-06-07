require_relative "database"

class CRMRunner

	BACK_TO_MAIN = "=" * 50
	NEXT_CONTACT = "-" * 50
	@@counter = 1000
	@@db = Database.new
	# def initialize
	# end

	def self.run
		puts "Welcome to the CRM Application."
		user_input = ""
		while user_input != "7"
			puts "Type one of the following options\n \tAdd - 1\n \tModify - 2\n \tDisplay All "\
			     "- 3\n \tDisplay Contact - 4\n \tDisplay Attribute - 5\n\tDelete - 6\n \tExit - 7"
			user_input = gets.chomp
			if user_input == "1"
				CRMRunner.add
			elsif user_input == "2"
				CRMRunner.modify
			elsif user_input == "3"
				CRMRunner.display_all
			elsif user_input == "4"
				CRMRunner.display_contact
			elsif user_input == "5"
				CRMRunner.display_attribute
			elsif user_input =="6"
				CRMRunner.delete
			elsif user_input == "7"
				puts "Thanks for using the CRM!!\n #{BACK_TO_MAIN}"
			end
		end
	end

	def self.add
		profile = {"First Name" => "", "Last Name" => "", "email" => "", "Notes" => "", 
			       "ID" => @@counter.to_s}
		@@counter += 1

		while profile["First Name"] == ""
			puts "First Name:-"
			profile["First Name"] = gets.chomp
		end

		puts "Last Name:-"
		profile["Last Name"] = gets.chomp

		puts "email:-"
		profile["email"] = gets.chomp

		puts "Notes:-"
		profile["Notes"] = gets.chomp
	
		@@db.add_contact(profile)
		puts "Contact added successfully.\n #{BACK_TO_MAIN}"
	end

	def self.delete
		return puts "No contacts in database!\n #{BACK_TO_MAIN}" if @@db.contacts == []
		puts "Please type in any contact detail of the contact you wish to delete:-"
		relevant_contacts = search_contacts
		return puts "No such contact found :(\n #{BACK_TO_MAIN}" if relevant_contacts.length == 0
		CRMRunner.display_these(relevant_contacts) if relevant_contacts != []	
		if relevant_contacts.length == 1
			puts "Type in 'Yes' to delete this contact, or anything else to abort"
			user_input = gets.chomp
			return if user_input != "Yes"
			@@db.delete_contact(relevant_contacts[0]["ID"])
		else
			puts "Please enter the ID of the contact you wish to delete, or type anything else"\
			     " to abort:-"
			id_number = gets.chomp
			id_list = []
			relevant_contacts.each do |profile|
				id_list << profile["ID"]
				if id_number == profile["ID"]
					@@db.delete_contact(id_number)
				end
			end
			return puts "Incorrect ID given.....\n #{BACK_TO_MAIN}" if !id_list.include? id_number
		end
		puts "Contact deleted successfully.\n #{BACK_TO_MAIN}"
	end

	def self.modify
		return puts "No contacts in the database!\n #{BACK_TO_MAIN}" if @@db.contacts == []
		puts "Please enter a contact detail of the contact you wish to modify:-"
		contact = search_contacts
		return puts "No such contact found :(\n#{BACK_TO_MAIN}" if contact == []
		CRMRunner.display_these(contact)

		if contact.length != 1
			puts "Please enter the ID number of one of these contacts"
			id_number = gets.chomp
			id_in_here = false
			contact.each do |profile|
				if profile["ID"] == id_number
					id_in_here = true
					CRMRunner.display_these(profile)
				end
			end
			return puts "Invalid input, even though I gave you all the options.......fuck you\n #{BACK_TO_MAIN}" if\
			 id_in_here != true
		else
			id_number = contact[0]["ID"]
		end

		puts "Is this the selection you want?\n        -Yes, -No"
		yes_no = gets.chomp
		if yes_no == "No"
			return puts "#{BACK_TO_MAIN}"
		elsif yes_no != "Yes" && yes_no != "No"
			return puts "Invalid input, even though I gave you all the options.......fuck you\n #{BACK_TO_MAIN}"
		end
		puts "Which of it's attributes d'you want to change?\n        -First Name, -Last Name,"\
		     " -email, -Notes"
		options  = ["First Name", "Last Name", "email", "Notes"]
		detail_choice = gets.chomp
		return puts "Invalid input, even though I gave you all the options.......fuck you\n #{BACK_TO_MAIN}" if \
		!options.include? detail_choice

		puts "Enter the change you want to make\n #{detail_choice}:-"
		modification = gets.chomp
		@@db.modify_contact(id_number, detail_choice, modification)
		puts "The change has been made y'all!!\n#{BACK_TO_MAIN}"
	end

	def self.display_all
		all_profiles = @@db.return_all_contacts
		if all_profiles == []
			return puts "No contacts to display!\n #{BACK_TO_MAIN}"
		end
		CRMRunner.display_these(all_profiles)
	end

	def self.display_contact
		return puts "No contacts in database!\n #{BACK_TO_MAIN}" if @@db.contacts == []
		puts "Please type in any contact detail of the contact you wish to display"
		required_profile = search_contacts
		CRMRunner.display_these(required_profile)
	end

	def self.display_attribute
		return puts "No contacts in database!\n #{BACK_TO_MAIN}" if @@db.contacts == []
		puts "Which of these would you like me to display?\n        -First Name, -Last Name,"\
		     " -email, -Notes, -ID"
		user_choice = gets.chomp
		if user_choice != "id" && user_choice != "email" && user_choice != "ID"
			user_choice = user_choice.split(" ").each{|word| word.capitalize!}.join(" ")
		elsif user_choice == "id"
			user_choice = user_choice.upcase
		end
		options  = ["First Name", "Last Name", "email", "Notes", "ID"]
		puts "Invalid input, even though I gave you all the options.......fuck you\n #{BACK_TO_MAIN}" if \
		!options.include? user_choice 
		all_contacts = @@db.return_all_contacts
		all_contacts.each do |profile|
			puts profile[user_choice]
			puts "#{NEXT_CONTACT}"
		end
	end

	private

	def self.display_these(profiles)
		profiles.each do |p|
			p.each do |key, value|
				puts "#{key}: #{value}"
			end
			puts "\n #{NEXT_CONTACT}\n"
		end
		puts "#{BACK_TO_MAIN}"
	end

	def self.search_contacts
		c_detail = gets.chomp
		result = @@db.find_contacts(c_detail)
	end

		
end


CRMRunner.run