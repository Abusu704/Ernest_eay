class InputError(Exception):
    pass
import secrets as ss
import string as st
class Librarysytem:
    def __init__(self):
        self.lib_name = print("Millenial Libraries")
    def user(self):
        name = input("Enter your name- ")  
        user_pin = st.digits + st.ascii_letters
         #Generating User password
    

        user_pass =   ''.join(ss.choice(user_pin) for i in range(5))
        print("This is your login code :",user_pass)
        login_code = input("Login code: ")
        if login_code == user_pass:
            print("Choose category of interest\n1.Literature\n2.Engineering\n3.Religion\n4.Politics")
            cat_input = int(input("Select your preferred category- "))

            #Inventory of Books

            books_shelf = {1:"Harry Potter\nBlack Hills\nBlack Hills\n",
                           2:"Digital Electronics\nAutocad\nCircuit Theory\n",
                           3:"The Law of Mosses\nThe Down Side of Religion\n",
                           4:"WWW3\nNeo-Colonialism\nThe Persian Gulf\n"}
            def getbook(cat_input):
                return books_shelf.get(cat_input, 0)
            print(getbook(cat_input))
            try:  
             
             select = input("Select book- ")
             num_days = int(input("How many days is the book going to be used- "))

            #The Price of the books selected
             price_of_book = {"Harry Potter" :20*num_days,
                             "Black Hill":20*num_days,
                           "Digital Electronics\n":30*num_days,
                           "Autocad":30*num_days,
                           "Circuit Theory":30*num_days,
                           "The Law of Mosses":30*num_days,
                           "The Down Side of Religion":45*num_days,
                           "WWW3":56*num_days,
                           "Neo-Colonialism":56*num_days,
                           "The Persian Gulf":56*num_days,
                           "WWW3":12*num_days,
                           "Neo-Colonialism":23*num_days,
                           "The Persian Gulf":14*num_days}
             def get(select):
                return price_of_book.get(select, 0)
             print("Your charge :","Ghc-",get(select))
             print("------------------------------------\n")
             print("Never stop learning\n")
             if select not in price_of_book:
                     raise InputError(f"'{select}' is not a valid book. Choose from: {list(price_of_book.keys())}")
            except InputError as e:
              print(e)

    def librarian(self):
        import secrets as ss
        import string as st
        lib_pin = st.digits  #Generating librarian password
        lib_pass =   ''.join(ss.choice(lib_pin) for i in range(5))
        print(lib_pass)
        print("Please login your librarian pin generated for you")
        lib_log = int(input("Login pin- "))  
        if lib_log == lib_pass:
            print("Library Interface")  
            ind = int(input("Enter number of books borrowed- ")) 
            id = int(input("Enter the number of users- ")) 
        elif lib_log != lib_pass:
            print("Invalid pin") 

p = Librarysytem()
key = input("Login as a user or librarian- ")
if key == "user":
    p.user() 
elif key == "librarian":
    p.librarian()
else:
    print("Identity not allowed")

