# Case closed
Case based auto completion

This VIM auto-completion plugin enables word completion based on capitals. This allows accurate and fast autocompletion in
combination with camel-case.

If your file contains a word `VeryLongFunctionName` it can be auto-completed by typing the capitals `VLFN` followed
by `<c-x><c-u>`.

Lower cases can be added to refine and reduce the number of hits. Suppose another word
`VeryLongFractionalNumber` exists, then `VLFuN` followed by `<c-x><c-u>` will only match the first word.

## Installation with Pathogen
Clone this repository to ~/vim/bundle
