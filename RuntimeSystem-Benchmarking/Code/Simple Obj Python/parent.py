class parent():
    first = None
    sec = 4
    # The constructor for instance variables
    def __init__(self, third, forth):
        self.third = third
        self.forth = forth

    # This is the static method
    #The @staticmethod here is the decorator and not necessary
    # Since the function does not get any obj of class(self) as the frist
    # argument, it is automatically static
    #@statistics
    def rangeFunc(x):
        if len(x) < 9:
            print("Not in the range")
            return None
        return x[3,9]
    # This is the instance method
    # The @classmethod here is the decorator and not necessary
    # Since the function does gets an obj of class(self) as the frist
    # argument, it is automatically instance method
    #@classmethod
    def multiplier(self, x):
        print(x * self.third)
