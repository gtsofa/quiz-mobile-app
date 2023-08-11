# Quiz Mobile App

[![CI-macOS](https://github.com/gtsofa/quiz-mobile-app/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gtsofa/quiz-mobile-app/actions/workflows/CI.yml)

This is a Quiz app.  It's expected that the player will be able to:

- Insert words and have them counted as a hit as soon as the player types the last letter of each word.
- After a hit, the input box will be cleared and the focus will remain on the input box.
- There will be a 5 min timer to finish the game.
    - If the player completes the quiz in less than 5 min, an alert will tell praise him.
    - If the player doesn't complete within 5 min, an alert will tell him his score.
 
- There will be a button to start the timer.


## Use Cases

### Load Question From Remote Use Case

#### Data:
- URL

#### Primary Course(Happy path):
1. Execute "Load Question" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates question from valid data.
5. System delivers question and correct answers.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity - error course (sad path):
1. System delivers connectivty error.

### Start Game Use Case

#### Primary course:
1. Execute "Start" command
2. System starts the counter.
3. Counter delivers start message.
4. Counter delivers current seconds.
5. System enables the user to insert guesses.

### Add User Guess Use Case

#### Data:
- String

#### Primary course:
1. Execute "Add guess" command with the above data.
2. System validates the user guess
3. System saves the user guess.

### Finish Game Use Case

#### Primary course:
1. Execute "Validate user guesses" command with the above data.
2. System verify the user guesses.
3. System informs if the game is finished.

## PayLoad Contract

```
GET *url* 

200 RESPONSE

{
  "question": "What are all the java keywords?",
  "answer": [
    "abstract",
    "assert",
    "boolean",
    "break",
    "byte",
    "case",
    "catch",
    "char",
    "class",
    "const",
    "continue",
    "default",
    "do",
    "double",
    "else",
    "enum",
    "extends",
    "final",
    "finally",
    "float",
    "for",
    "goto",
    "if",
    "implements",
    "import",
    "instanceof",
    "int",
    "interface",
    "long",
    "native",
    "new",
    "package",
    "private",
    "protected",
    "public",
    "return",
    "short",
    "static",
    "strictfp",
    "super",
    "switch",
    "synchronized",
    "this",
    "throw",
    "throws",
    "transient",
    "try",
    "void",
    "volatile",
    "while"
  ]
}

```
