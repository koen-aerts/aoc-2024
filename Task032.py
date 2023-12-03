import re

class Task032():

  def __init__(self):
    self.matrix = []
    self.mines = []

  def isNum(self, char):
    return char >= '0' and char <= '9'

  def getNum(self, y, x):
    num = None
    if (self.isNum(self.matrix[y][x])):
      # Move to the left, beginning of the number
      pos = x
      potpos = x-1
      while (potpos >= 0 and self.isNum(self.matrix[y][potpos])):
        potpos = potpos-1
        pos = pos-1
      strval = ''
      # Read the number
      while (pos < len(self.matrix[0]) and self.isNum(self.matrix[y][pos])):
        strval = strval + self.matrix[y][pos]
        pos = pos + 1
      num = int(strval)
    return num

  def execute(self):
    # Step 1: build 2D array of values and track all coordinates of asterisk chars within the matrix.
    with open('parts.txt', mode='rb') as partsFile:
      while True:
        partsRow = partsFile.readline().decode("utf-8")
        if not partsRow:
          break;
        row = []
        for char in partsRow:
          if (self.isNum(char)):
            row.append(char)
          elif (char == '*'):
            self.mines.append([len(self.matrix), len(row)]) # Track coords with asterisks
            row.append('X')
          else:
            row.append(' ')
        self.matrix.append(row)
    partsFile.close()

    # Find all numbers around the asterisks
    sum = 0
    for coords in self.mines:
      nums = []
      if (coords[0] > 0 and coords[1] > 0): # top-left
        potNum = self.getNum(coords[0]-1, coords[1]-1)
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if (coords[0] > 0): # top
        potNum = self.getNum(coords[0]-1, coords[1])
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if (coords[0] > 0 and coords[1]+1 < len(self.matrix[0])): # top-right
        potNum = self.getNum(coords[0]-1, coords[1]+1)
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if (coords[1] > 0): # left
        potNum = self.getNum(coords[0], coords[1]-1)
        if not potNum == None:
          nums.append(potNum)
      if (coords[1]+1 < len(self.matrix[0])): # right
        potNum = self.getNum(coords[0], coords[1]+1)
        if not potNum == None:
          nums.append(potNum)
      if (coords[0]+1 < len(self.matrix) and coords[1] > 0): # bottom-left
        potNum = self.getNum(coords[0]+1, coords[1]-1)
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if (coords[0]+1 < len(self.matrix)): # bottom
        potNum = self.getNum(coords[0]+1, coords[1])
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if (coords[0]+1 < len(self.matrix) and coords[1]+1 < len(self.matrix[0])): # bottom-right
        potNum = self.getNum(coords[0]+1, coords[1]+1)
        if not potNum == None and not potNum in nums:
          nums.append(potNum)
      if len(nums) == 2:
        sum = sum + (nums[0] * nums[1])
      
    print(f"Sum: {sum}")

if __name__ == '__main__':
  task = Task032()
  task.execute()
