import re

class Task031():

  def __init__(self):
    self.matrix = []
    self.mines = []

  def isNum(self, char):
    return char >= '0' and char <= '9'

  def wipe(self, y, x):
    if (self.isNum(self.matrix[y][x])):
      # Delete to the left
      pos = x-1
      while (pos >= 0 and self.isNum(self.matrix[y][pos])):
        self.matrix[y][pos] = ' '
        pos = pos-1
      # Delete to the right
      pos = x
      while (pos < len(self.matrix[0]) and self.isNum(self.matrix[y][pos])):
        self.matrix[y][pos] = ' '
        pos = pos + 1

  def execute(self):
    # Step 1: build 2D array of values and track all coordinates of special chars within the matrix.
    with open('parts.txt', mode='rb') as partsFile:
      while True:
        partsRow = partsFile.readline().decode("utf-8")
        if not partsRow:
          break;
        row = []
        for char in partsRow:
          if (char == '.'):
            row.append(' ')
          elif (self.isNum(char)):
            row.append(char)
          elif (char >= ' '): # Ascii 0x20h or higher, to ignore CR/LF
            self.mines.append([len(self.matrix), len(row)]) # Track coords with special chars
            row.append('X')
        self.matrix.append(row)
    partsFile.close()

    # Add up all the numbers.
    grandsum = 0;
    for row in self.matrix:
      templine = ''
      for char in row:
        templine = templine + char
      print(templine)
      line = templine.strip()
      vals = re.sub(r"[^0-9]+", ",", line).split(",")
      for val in vals:
        if len(val) > 0:
          grandsum = grandsum + int(val)

    # Just like in a minefield, remove numbers adjacent from the special chars, basically check the 8 positions around it.
    for coords in self.mines:
      if (coords[0] > 0 and coords[1] > 0): # top-left
        self.wipe(coords[0]-1, coords[1]-1)
      if (coords[0] > 0): # top
        self.wipe(coords[0]-1, coords[1])
      if (coords[0] > 0 and coords[1]+1 < len(self.matrix[0])): # top-right
        self.wipe(coords[0]-1, coords[1]+1)
      if (coords[1] > 0): # left
        self.wipe(coords[0], coords[1]-1)
      if (coords[1]+1 < len(self.matrix[0])): # right
        self.wipe(coords[0], coords[1]+1)
      if (coords[0]+1 < len(self.matrix) and coords[1] > 0): # bottom-left
        self.wipe(coords[0]+1, coords[1]-1)
      if (coords[0]+1 < len(self.matrix)): # bottom
        self.wipe(coords[0]+1, coords[1])
      if (coords[0]+1 < len(self.matrix) and coords[1]+1 < len(self.matrix[0])): # bottom-right
        self.wipe(coords[0]+1, coords[1]+1)
      # Wipe the character itself.
      self.matrix[coords[0]][coords[1]] = ' '
      
    # Extract all the numbers that are left and add them up.
    midsum = 0;
    for row in self.matrix:
      templine = ''
      for char in row:
        templine = templine + char
      print(templine)
      line = templine.strip()
      if len(line) > 0:
        vals = re.sub(r" +", ",", line).split(",")
        for val in vals:
          midsum = midsum + int(val)
        
    print(f"Sum: {grandsum - midsum}")

if __name__ == '__main__':
  task = Task031()
  task.execute()
