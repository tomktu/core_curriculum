A method that returns the sum of two integers:
```
Given two integers.

Save the sum of the two integers into a variable.
Return the variable.
```

```
START

SET result = value of first integer + value of second integer

PRINT result

END
```

A method that takes an array of strings, and returns a string that is all those strings concatenated together.
```
Given an array of strings.

Iterate through the array one by one.
  - save the first value to a variable initialized with an empty string
  - for each iteration, append the current value to variable

After iterating through the collection, return the variable.
```

```
START

SET result = ''

FOR element in array
  result = result + element

PRINT result

END
```

A method that takes an array of integers, and returns a new array with every other element.
```
Give an array of integers.

Initialize a variable with an empty array.

Iterate through the array one by one.
  - if the index of the array is even (assuming we start with first element)
    - append the value at that index to the variable
  - otherwise, skip to next iteration

After iterating through collection, return the variable.
```

```
START

SET result = []
SET index = 0

WHILE index < length of array
  SET current_number = value of the element at the current index value
  IF index is even
    Append current_number to result
  ELSE
    Skip to next iteration

PRINT result

END
```
