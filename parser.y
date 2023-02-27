%{

#include<bits/stdc++.h>
using namespace std;

int yylex();
int yyerror(char *s);


%}

%token <name> KEYWORD EOL SEPARATOR ASSIGNMENTOPERATOR LITERAL IDENTIFIER WHITESPACE OTHER
%token <name> OPROUND CLROUND OPSQR CLSQR THIS DOT SUPER NEW PLUS MINUS COLON SEMICOLON TILDA EX QUES ASTERIX FSLASH MOD LSHIFT RSHIFT URSHIFT LT GT LTE GTE INSTANCEOF DOUBLEEQ NOTEQ AND XOR OR DAND DOR 

%union{
	char* name;
}

%%
input: javasyntax;

javasyntax: keywords | javasyntax keywords
	| identifier | javasyntax identifier
;

Block:
	OPCURLY CLCURLY |
	OPCURLY BlockStatements CLCURLY 
;

BlockStatements: BlockStatement |
	BlockStatements BlockStatement
;

BlockStatement:
	LocalVariableDeclarationStatement
	Statement
;

LocalVariableDeclarationStatement:
	LocalVariableDeclaration
;

LocalVariableDeclaration:
	Type VariableDeclarators
;

Statement:
	StatementWithoutTrailingSubstatement|
	LabeledStatement|
	IfThenStatement|
	IfThenElseStatement|
	WhileStatement|
	ForStatement
;

StatementNoShortIf:
	StatementWithoutTrailingSubstatement|
	LabeledStatementNoShortIf|
	IfThenElseStatementNoShortIf|
	WhileStatementNoShortIf|
	ForStatementNoShortIf
;

StatementWithoutTrailingSubstatement:
	Block|
	EmptyStatement|
	ExpressionStatement|
	SwitchStatement|
	DoStatement|
	BreakStatement|
	ContinueStatement|
	ReturnStatement|
	SynchronizedStatement|
	ThrowStatement|
	TryStatement
%%

EmptyStatement:
	SEMICOLON
;

LabeledStatement:
	Identifier COLON Statement
;

LabeledStatementNoShortIf:
	Identifier COLON StatementNoShortIf
;

ExpressionStatement:
	StatementExpression SEMICOLON
;

StatementExpression:
	Assignment|
	PreIncrementExpression|
	PreDecrementExpression|
	PostIncrementExpression|
	PostDecrementExpression|
	MethodInvocation|
	ClassInstanceCreationExpression
;

IfThenStatement:
	IF OPROUND Expression CLROUND Statement
;

IfThenElseStatement:
	IF OPROUND Expression CLROUND StatementNoShortIf ELSE Statement
;

IfThenElseStatementNoShortIf:
	IF OPROUND Expression CLROUND StatementNoShortIf ELSE StatementNoShortIf
;

SwitchStatement:
	SWITCH OPROUND Expression CLROUND SwitchBlock
;

SwitchBlock:
	OPCURLY CLCURLY|
	OPCURLY SwitchLabels CLCURLY|
	OPCURLY SwitchBlockStatementGroups CLCURLY|
	OPCURLY SwitchBlockStatementGroups SwitchLabels CLCURLY
;

SwitchBlockStatementGroups:
	SwitchBlockStatementGroup|
	SwitchBlockStatementGroups SwitchBlockStatementGroup
;

SwitchBlockStatementGroup:
	SwitchLabels BlockStatements
;

SwitchLabels:
	SwitchLabel|
	SwitchLabels SwitchLabel
;

SwitchLabel
	CASE ConstantExpression COLON|
	DEFAULT COLON
;

WhileStatement:
	WHILE OPROUND Expression CLROUND Statement
;

WhileStatementNoShortIf:
	WHILE OPROUND Expression CLROUND StatementNoShortIf
;

DoStatement:
	DO Statement WHILE OPROUND Expression CLROUND SEMICOLON
;

ForStatement:
	FOR OPROUND ForInit SEMICOLON Expression SEMICOLON ForUpdate CLROUND Statement|
	FOR OPROUND         SEMICOLON Expression SEMICOLON ForUpdate CLROUND Statement|
	FOR OPROUND ForInit SEMICOLON            SEMICOLON ForUpdate CLROUND Statement|
	FOR OPROUND ForInit SEMICOLON Expression SEMICOLON           CLROUND Statement|
	FOR OPROUND         SEMICOLON            SEMICOLON ForUpdate CLROUND Statement|
	FOR OPROUND         SEMICOLON Expression SEMICOLON           CLROUND Statement|
	FOR OPROUND ForInit SEMICOLON            SEMICOLON           CLROUND Statement|
	FOR OPROUND         SEMICOLON            SEMICOLON           CLROUND Statement
;

ForStatementNoShortIf:
	FOR OPROUND ForInit SEMICOLON Expression SEMICOLON ForUpdate CLROUND StatementNoShortIf|
	FOR OPROUND         SEMICOLON Expression SEMICOLON ForUpdate CLROUND StatementNoShortIf|
	FOR OPROUND ForInit SEMICOLON            SEMICOLON ForUpdate CLROUND StatementNoShortIf|
	FOR OPROUND ForInit SEMICOLON Expression SEMICOLON           CLROUND StatementNoShortIf|
	FOR OPROUND         SEMICOLON            SEMICOLON ForUpdate CLROUND StatementNoShortIf|
	FOR OPROUND         SEMICOLON Expression SEMICOLON           CLROUND StatementNoShortIf|
	FOR OPROUND ForInit SEMICOLON            SEMICOLON           CLROUND StatementNoShortIf|
	FOR OPROUND         SEMICOLON            SEMICOLON           CLROUND StatementNoShortIf
;

ForInit:
	StatementExpressionList|
	LocalVariableDeclaration
;

ForUpdate:
	StatementExpressionList
;

StatementExpressionList:
	StatementExpression|
	StatementExpressionList COMMA StatementExpression
;

BreakStatement:
	BREAK Identifier SEMICOLON|
	BREAK SEMICOLON|
;

ContinueStatement:
	CONTINUE Identifier SEMICOLON|
	CONTINUE SEMICOLON
;

ReturnStatement:
	RETURN Expression SEMICOLON|
	RETURN SEMICOLON
;

ThrowStatement:
	THROW Expression SEMICOLON
;

SynchronizedStatement:
	SYNCHRONIZED OPROUND Expression CLROUND Block
;

TryStatement:
	TRY Block Catches|
	TRY Block Catches FINALLY| 
	TRY Block FINALLY| 
;

Catches:
	CatchClause|
	Catches CatchClause
;

CatchClause:
	CATCH OPROUND FormalParameter CLROUND Block
;

Finally:
	FINALLY Block
;

Primary:
	PrimaryNoNewArray
	| ArrayCreationExpression
;

PrimaryNoNewArray:
	LITERAL
	| THIS
	| OPROUND Expression CLROUND
	| ClassInstanceCreationExpression
	| FieldAccess
	| ArrayAccess
	| MethodInvocation
;

ClassInstanceCreationExpression:
	NEW ClassType OPROUND CLROUND
	| NEW ClassType OPROUND ArgumentList CLROUND
;

ArgumentList:
	Expression
	| ArgumentList COMMA Expression
;

ArrayCreationExpression:
	NEW PrimitiveType DimExprs
	| NEW PrimitiveType DimExprs Dims
	| NEW ClassOrInterfaceTypes DimExprs
	| NEW ClassOrInterfaceTypes DimExprs Dims
;

DimExprs:
	DimExpr
	| DimExprs DimExpr
;

DimExpr:
	OPSQR Expression CLSQR
;

Dims:
	OPSQR CLSQR
	| Dims OPSQR CLSQR
;

FieldAccess:
	Primary DOT identifier
	| SUPER DOT identifier
;

MethodInvocation:
	Name OPROUND CLROUND
	| Name OPROUND ArgumentList CLROUND
	| Primary DOT identifier OPROUND CLROUND
	| Primary DOT identifier OPROUND ArgumentList CLROUND
	| SUPER DOT identifier OPROUND CLROUND 
	| SUPER DOT identifier OPROUND ArgumentList CLROUND
;

ArrayAccess:
	Name OPSQR Expression CLSQR
	| PrimaryNoNewArray OPSQR Expression CLSQR
;

PostfixExpression:
	Primary
	| Name
	| PostIncrementExpression
	| PostDecrementExpression
;

PostIncrementExpression:
	PostfixExpression PLUS PLUS
;

PostDecrementExpression:
	PostfixExpression MINUS MINUS
;

UnaryExpression:
	PreIncrementExpression
	| PreDecrementExpression
	| PLUS UnaryExpression
	| MINUS UnaryExpression
	| UnaryExpressionNotPlusMinus
;

PreIncrementExpression:
	PLUS PLUS UnaryExpression
;

PreDecrementExpression:
	MINUS MINUS UnaryExpression
;

UnaryExpressionNotPlusMinus:
	PostfixExpression
	| TILDA UnaryExpression
	| EX UnaryExpression
	| CastExpression
;

CastExpression:
	OPROUND PrimitiveType CLROUND UnaryExpression
	| OPROUND PrimitiveType Dims CLROUND UnaryExpression
	| OPROUND Expression CLROUND UnaryExpressionNotPlusMinus
	| OPROUND Name Dims CLROUND UnaryExpressionNotPlusMinus
;

MultiplicativeExpression:
	UnaryExpression
	| MultiplicativeExpression ASTERIX UnaryExpression
	| MultiplicativeExpression FSLASH UnaryExpression
	| MultiplicativeExpression MOD UnaryExpression
;

AdditiveExpression:
	MultiplicativeExpression
	| AdditiveExpression PLUS MultiplicativeExpression
	| AdditiveExpression MINUS MultiplicativeExpression
;

ShiftExpression:
	AdditiveExpression
	| ShiftExpression LSHIFT AdditiveExpression
	| ShiftExpression RSHIFT AdditiveExpression
	| ShiftExpression URSHIFT AdditiveExpression
;

RelationalExpression:
	ShiftExpression
	| RelationalExpression LT ShiftExpression
	| RelationalExpression GT ShiftExpression
	| RelationalExpression LTE ShiftExpression
	| RelationalExpression GTE ShiftExpression
	| RelationalExpression INSTANCEOF ReferenceType
;

EqualityExpression:
	RelationalExpression
	| EqualityExpression DOUBLEEQ RelationalExpression
	| EqualityExpression NOTEQ RelationalExpression
;

AndExpression:
	EqualityExpression
	| AndExpression AND EqualityExpression
;

ExclusiveOrExpression:
	AndExpression
	| ExclusiveOrExpression XOR AndExpression
;

InclusiveOrExpression:
	ExclusiveOrExpression
	| InclusiveOrExpression OR ExclusiveOrExpression
;

ConditionalAndExpression:
	InclusiveOrExpression
	| ConditionalAndExpression DAND InclusiveOrExpression
;

ConditionalOrExpression:
	ConditionalAndExpression
	| ConditionalOrExpression DOR ConditionalAndExpression
;

ConditionalExpression:
	ConditionalOrExpression
	| ConditionalOrExpression QUES Expression COLON ConditionalExpression
;

AssignmentExpression:
	ConditionalExpression
	| Assignment
;

Assignment:
	LeftHandSide AssignmentOperator AssignmentExpression
;

LeftHandSide:
	Name
	| FieldAccess
	| ArrayAccess
;

Expression:
	AssignmentExpression
;

ConstantExpression: Expression;

keywords: KEYWORD ;

identifier: IDENTIFIER ;

AssignmentOperator: ASSIGNMENTOPERATOR;

ExpressionName: IDENTIFIER;

ArrayInitializer: OPCURLY VariableInitializers COMMA CLCURLY 
				| OPCURLY COMMA CLCURLY
				| OPCURLY VariableInitializers CLCURLY
				| OPCURLY CLCURLY
;

VariableInitializers: VariableInitializer
					| VariableInitializers COMMA VariableInitializer
;

InterfaceDeclaration: Modifiers interface Identifier ExtendsInterfaces InterfaceBody
					| interface Identifier ExtendsInterfaces InterfaceBody
					| Modifiers interface Identifier InterfaceBody
					| interface Identifier InterfaceBody
;

ExtendsInterfaces: extends InterfaceType
				 | ExtendsInterfaces COMMA InterfaceType
;

InterfaceBody: OPCURLY InterfaceMemberDeclarations CLCURLY
			 | OPCURLY CLCURLY
;

InterfaceMemberDeclarations: InterfaceMemberDeclaration
						   | InterfaceMemberDeclarations InterfaceMemberDeclaration
;

InterfaceMemberDeclaration: ConstantDeclaration 
						  |	AbstractMethodDeclaration
;

ConstantDeclaration: FieldDeclaration
;

AbstractMethodDeclaration: MethodHeader SEMICOLON
;

ClassDeclaration: Modifiers class Identifier Super Interfaces ClassBody
				| class Identifier Super Interfaces ClassBody
				| class Identifier Interfaces ClassBody
				| class Identifier Super ClassBody
				| class Identifier ClassBody
				| Modifiers class Identifier Interfaces ClassBody
				| Modifiers class Identifier Super ClassBody
				| Modifiers class Identifier ClassBody
;

Super: extends ClassType
;

Interfaces: implements InterfaceTypeList
;

InterfaceTypeList: InterfaceType
				 | InterfaceTypeList COMMA InterfaceType
;

ClassBody: OPCURLY ClassBodyDeclarationsopt CLCURLY
;

ClassBodyDeclarations: ClassBodyDeclaration
					 | ClassBodyDeclarations ClassBodyDeclaration
;

ClassBodyDeclaration: ClassMemberDeclaration
					| StaticInitializer
					| ConstructorDeclaration
;

ClassMemberDeclaration: FieldDeclaration
					  | MethodDeclaration
;

FieldDeclaration: Modifiers Type VariableDeclarators SEMICOLON
				| Type VariableDeclarators SEMICOLON
;

VariableDeclarators: VariableDeclarator
				   | VariableDeclarators COMMA VariableDeclarator
;

VariableDeclarator: VariableDeclaratorId
				  | VariableDeclaratorId EQUALTO VariableInitializer

VariableDeclaratorId: Identifier
					| VariableDeclaratorId OPSQR CLSQR
;

VariableInitializer: Expression
				   | ArrayInitializer
;

MethodDeclaration: MethodHeader MethodBody
;

MethodHeader: Modifiers Type MethodDeclarator Throws
			| Type MethodDeclarator Throws
			| Modifiers Type MethodDeclarator 
			| Type MethodDeclarator
			| Modifiers void MethodDeclarator Throws
			| Modifiers void MethodDeclarator 
			| void MethodDeclarator Throws
			| void MethodDeclarator
;

MethodDeclarator: Identifier OPROUND FormalParameterList CLROUND
				| Identifier OPROUND CLROUND
				| MethodDeclarator OPSQR CLSQR
;

FormalParameterList: FormalParameter
				   | FormalParameterList COMMA FormalParameter
;

FormalParameter: Type VariableDeclaratorId
;

Throws: throws ClassTypeList
;

ClassTypeList: ClassType
     		 | ClassTypeList COMMA ClassType
;

MethodBody: Block SEMICOLON
;

StaticInitializer: static Block
;

ConstructorDeclaration:	Modifiers ConstructorDeclarator Throws ConstructorBody
					  | ConstructorDeclarator Throws ConstructorBody
					  | ConstructorDeclarator ConstructorBody
					  | Modifiers ConstructorDeclarator ConstructorBody
;

ConstructorDeclarator: SimpleName OPROUND FormalParameterList CLROUND
					 | SimpleName OPROUND CLROUND
;

ConstructorBody: OPCURLY ExplicitConstructorInvocation BlockStatements CLCURLY
			   | OPCURLY BlockStatements CLCURLY
			   | OPCURLY ExplicitConstructorInvocation CLCURLY
			   | OPCURLY CLCURLY
;

ExplicitConstructorInvocation: this OPROUND ArgumentList CLROUND SEMICOLON
							 | this OPROUND CLROUND SEMICOLON
							 | super OPROUND ArgumentList CLROUND SEMICOLON
							 | super OPROUND CLROUND SEMICOLON
;

%%

int yyerror(char *s)
{
	printf("%s\n", s);
	return 0;
}

int main()
{
    yyparse();
    
    
    return 0;
}