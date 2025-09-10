--Simple Calculator Program
#Task1-Simple Calculator Program
def addition(num1,num2):
    return num1 + num2
def subtraction(num1,num2):
    return num1 - num2
def multiply(num1,num2):
    return num1*num2
def divide(num1,num2):

    if num2 == 0:
        print("Number can not be divisible by 0")
    else :
     return num1/num2

print("Simple Calculator ")
num1 = int(input("Enter your first digit- "))
num2 = int(input("Enter your second digit- "))


operand = input("Select arithmetic operand of your choice(+,-,*,/) - ")
if operand == '+' :
    print("Result: ",addition(num1,num2))
elif operand == '-':
    print("Result: ",subtraction(num1,num2))   
elif operand == '*': 
    print("Result:",multiply(num1,num2))  
elif operand == '/': 
    print("Result:",divide(num1,num2))   
else :
    print("Invalid input ")        
