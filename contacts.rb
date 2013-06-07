class Contact
	attr_accessor :first_name, :last_name, :email, :notes, :id

  def initialize(first_name, last_name, email, notes, id)
	@first_name = first_name
	@last_name = last_name
	@email = email
	@notes = notes
	@id = id
  end


end