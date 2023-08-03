# quiz-mobile-app
This is a Quiz app.  It's expected that the player will be able to:

- Insert words and have them counted as a hit as soon as the player types the last letter of each word.
- After a hit, the input box will be cleared and the focus will remain on the input box.
- There will be a 5 min timer to finish the game.
    - If the player completes the quiz in less than 5 min, an alert will tell praise him.
    - If the player doesn't complete within 5 min, an alert will tell him his score.
 
- There will be a button to start the timer.

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
