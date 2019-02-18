%{
int stackIdx = 0;
YY_BUFFER_STATE stateBuffer[10] = { 0 };
#define MAX_DEPTH 10
%}

%x include

%%

incl                BEGIN(include); 
<include>[a-z0-9]*     {  
    
    yyin = fopen(yytext, "r"); 
    if (!yyin)
        exit(1);

    stateBuffer[stackIdx++] = YY_CURRENT_BUFFER;

    yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
     
    BEGIN(INITIAL); 
} 

[a-z0-9]* { printf("CONTENT: %s\n", yytext); }

[\n ]+
[\t ]+

<<EOF>> {
    if (--stackIdx < 0) {
        yyterminate();    
    } else {
        yy_delete_buffer(YY_CURRENT_BUFFER);
        yy_switch_to_buffer(stateBuffer[stackIdx]);
    }     
}
%%

int yywrap() {
    return 1;    
}

int main() {
    yyin = fopen("file1", "r");
    if (!yyin)
        exit(1);
    
    yylex();    

    return 0;
}

