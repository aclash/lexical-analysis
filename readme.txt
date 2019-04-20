I use flex to tokenizer the source code, and use some C++11 features.
So, please use command as follows to compile the .lex file and .c file:

flex -o sample1.c sample1.lex
g++ -std=c++11 sample1.c

And please take the whole .fp file as input instead of copy-paste input into console. 
The command as follows:
./a.out < sample1.fp
