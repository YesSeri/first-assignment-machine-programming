---
title: "Assignment 1 - Machine Programming"
date: March 9, 2023
geometry: margin=3cm
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyfoot[CO,CE]{Group 22 - Assignment 1 - D. 14. March 2023}
  \fancyfoot[LE,RO]{\thepage}
---

# Rapport

## Intro

Group members:

- Henrik Zenkert

- Jakob Hansen

- Frederik Rolsted

- Tobias Schønau

All tasks was completed in collaboration between all group members.

## Mandatory

We have done all the mandatory and optional assignments.

Below we have attached flowcharts describing our solutions to the mandatory assignments.

### 1st - midpoint

![Flowchart of assignment 1](../flowcharts/1st%20assignment%20flowchart.png "Flowchart for assignment 1")
figure 1: This flowchart describes first assignment

### 2nd - readS

![Flowchart of assignment 2](../flowcharts/2nd-assignment-plantuml.png "Flowchart for assignment 2"){height=700px}

figure 2: This flowchart describes our implementation of the readS subroutines.

### 3rd - isPrime

![Flowchart of assignment 3](./media/isPrimeHandwrittenEdited.jpg "Flowchart for assignment 3"){height=700px}

figure 3: This flowchart shows the subroutine isPrime. In this subroutine, the inner workings of the subroutines “divide”, etc. is hidden. To see the implementation of these subroutines, see the appendix for a full overview of the 3rd assignment.

### 4th - resultS

![Flowchart of assignment 4](../flowcharts/4th%20assignment%20flowchart.png "Flowchart for assignment 4"){height=700px}

figure 4: This flowchart shows our implementation of the resultS function.

### 5th - full program

![Flowchart of assignment 5](../flowcharts/5th%20assignment%20flowchart.png "Flowchart for assignment 5"){height=700px}

figure 5: This flowchart shows how all the subroutines forms the finished program.

## Optional

### 1st - 5 digits

We do this almost identically to assignment two, but with two differences.

1. We save input digits to memory location DIGITS and keep track of how many digits we have.

2. We then loop through the DIGITS and if we have received n digits we multiply the 1st digit by 10 (n-1) times, the 2nd digit by 10 (n-2) times and each time we add the result to our output register.

### 2nd - input validation

This is almost identical to the previous one with two differences. We add two input validations.

1. After having converted the ascii value to number, n: If `n - 9 < 0` or `-n + 9 > 0` then we know that the ascii input was not a valid digit and jump to our error handling for invalid input.

2. If our loop counter is negative then we have received to many digits, and go to error handling.

## Appendix

![Flowchart of assignment 3](../flowcharts/3rd%20assignment%20flowchart.png "Flowchart for assignment 3")

figure 6: Flowchart describing the full implementation of the isPrime function.
