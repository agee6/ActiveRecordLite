# Austen Record

Welcome to the Austen Record documentation. Austen Record is a rub library for doing SQL database queries. This can be used in a similar way to Active Record that is implemanted natively in the Rails framework. 


## Class Methods
The SQL object class has several class methods. 
For example we assume we create a Book class that inherits from the SQLobject class. 

### #all
- returns all instanes of that SQL object. 

- Example: Book.all() would return all instances of Book in the database, i.e. all columns with all row information. 

### #find(id)
- returns an instance of an SQL object with the given id

- Example: Book.find(2) would find the Book from the SQL table with id 2. 

### #where(params)
- equivalent to doing an SQL querry using "WHERE", where the params passed in the params hash are the limiting factors. 

- Example: Book.where({title: "Our Mutual Friend"}) returns all book instances where the title is "Our Mutual Friend" Book.where({author: "Dickens"}) returns all book instances where the author is "Dickens"

## InstanceMethods

### #new(params)
- this creates a new instance of the class, passing it the params necessary to create the object. This does not save the instance to the database.  
- Example: new_book = Book.new({title: "The Lord of the Rings", author: "J.R.R. Tolkien", genre: "fantasy"}), this would create a Book instance, but would not save it to the database unless new_book.save was called. 

### #save
- saves the book to the database
- new_book.save would save the instance new_book to the data base

### #update(params)
- takes an existing book object and updates according to new params. 
```ruby
book_to_change = Book.where({title:"Lord of the Rings"})[0] #finds the appropriate book
new_params= {genre: "High Fantasy"} #the paramaters I want to change about the book
book_to_change.update(new_params) #updates the database to appropriate values 

```

