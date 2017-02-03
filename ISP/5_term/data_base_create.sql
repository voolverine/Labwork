CREATE TABLE [dbo].[Questions] (
    [Id]       INT            NOT NULL,
    [Question] NVARCHAR (500) NOT NULL,
    [Answer]   NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_dbo.Questions] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[Tests] (
    [Id]         INT           NOT NULL,
    [Name]       NVARCHAR (50) NOT NULL,
    [Difficulty] FLOAT (53)    NULL,
    [Statictics] INT           NULL,
    CONSTRAINT [PK_dbo.Tests] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[Users] (
    [Id]        INT           NOT NULL,
    [User_Name] NVARCHAR (50) NOT NULL,
    [Email]     NVARCHAR (50) NOT NULL,
    [Password]  NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[All_tests] (
    [Id]          INT NOT NULL,
    [Test_Id]     INT NOT NULL,
    [Question_Id] INT NOT NULL,
    CONSTRAINT [PK_dbo.All_tests] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.All_tests_dbo.Questions_Question_Id] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[Questions] ([Id]),
    CONSTRAINT [FK_dbo.All_tests_dbo.Tests_Test_Id] FOREIGN KEY ([Test_Id]) REFERENCES [dbo].[Tests] ([Id])
);


CREATE NONCLUSTERED INDEX [IX_Test_Id]
    ON [dbo].[All_tests]([Test_Id] ASC);


CREATE NONCLUSTERED INDEX [IX_Question_Id]
    ON [dbo].[All_tests]([Question_Id] ASC);

CREATE TABLE [dbo].[Results] (
    [Id]          INT NOT NULL,
    [User_Id]     INT NOT NULL,
    [Test_Id]     INT NOT NULL,
    [User_score]  INT NOT NULL,
    [Total_score] INT NOT NULL,
    CONSTRAINT [PK_dbo.Results] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Results_dbo.Users_User_Id] FOREIGN KEY ([User_Id]) REFERENCES [dbo].[Users] ([Id]),
    CONSTRAINT [FK_dbo.Results_dbo.Tests_Test_Id] FOREIGN KEY ([Test_Id]) REFERENCES [dbo].[Tests] ([Id])
);


CREATE NONCLUSTERED INDEX [IX_User_Id]
    ON [dbo].[Results]([User_Id] ASC);


CREATE NONCLUSTERED INDEX [IX_Test_Id]
    ON [dbo].[Results]([Test_Id] ASC);

INSERT INTO Questions (Id, Question, Answer) VALUES (0, 'To include "iostream" you should...', '{"answer4": "include #iostream.h", "right": "#include<iostream>", "answer3": "#include<iostream.h>", "answer2": "include(iostream)"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (1, 'Which of the following entries - the correct comment in C ++?', '{"answer4": "*/comment*/", "right": "/*comment*/", "answer1": "**comment**", "answer3": "{comment}"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (2, 'What is a special symbol placed after the "case" statement?', '{"answer4": ".", "right": ":", "answer3": ";", "answer2": "-"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (3, 'Which of the following types is not the data type in C++?', '{"aswer1": "int64", "right": "real", "answer3": "float", "answer4": "int"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (4, 'What is the default value, that program returns to operating system of successful completion in c++?', '{"answer4": "-1", "right": "0", "answer3": "null", "answer2": "1"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (5, 'What is a function, that all programms implement in c++?', '{"answer1": "start()", "answer2": "program()", "answer3": "system()", "right": "main()"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (6, 'How to import module in python?', '{"answer1": "import "name"", "answer2": "#import name", "answer3": "import <name>", "right": "import name"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (7, 'To make simple modifications to functions, methods, and classes in Python, you use something called what?', '{"answer4": "boxes", "right": "decorators", "answer3": "operators", "answer2": "envelopes"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (8, 'What is the function or tool that is used to create iterators?', '{"answer4": "serialization", "right": "generators", "answer3": "loops", "answer2": "conditional arguments"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (9, 'What is the name of the Python data type that is used to store keys and values, as opposed to indexes?', '{"answer4": "object", "right": "dictionary", "answer3": "operator", "answer2": "string"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (10, 'What tag is used to specify a line of text that is no longer correct (it used to be the strike tag, but that no longer works in HTML5)?', '{"answer4": "<ul>", "right": "<s>", "answer3": "<u>", "answer2": "<li>"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (11, 'What tag is used to define a hyperlink, or link to another page?', '{"answer4": "<strong>", "right": "<a>", "answer3": "<blockquote>", "answer2": "<em>"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (12, 'What tag is used to specify a section of text that provides an example of computer code?', '{"answer4": "<embed>", "right": "<code>", "answer3": "<!DOCTYPE>", "answer2": "<caption>"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (13, 'What group of tags are used to define the text headers in the body of the HTML document?', '{"answer4": "<p>", "right": "<h1> to <h6>", "answer3": "<title>", "answer2": "<footer>"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (14, 'What tag defines a division or the beginning/end of an individual section in an HTML document?', '{"answer4": "<img>", "right": "<div>", "answer3": "<meta>", "answer2": "<table>"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (15, 'Whith CSS you can transform bland HTML menus into this property.', '{"answer4": "dialog boxes", "right": "navigation bars", "answer3": "comments", "answer2": "menus"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (16, 'What is the name of the property that is used to define the spcecial state of an element?', '{"answer4": "style", "right": "pseudo-class", "answer3": "alignment", "answer2": "syntax"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (17, 'What is the name of the stylesheet that defines the presentation of an HTML and XML document?', '{"answer4": "java", "right": "CSS", "answer3": "jQuery", "answer2": "PHP"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (18, 'All HTML elements are considered what?', '{"answer4": "code", "right": "boxes", "answer3": "objects", "answer2": "tables"}');
INSERT INTO Questions (Id, Question, Answer) VALUES (19, 'What is the name of the group of properties that allows you to control the height and width of elements?', '{"answer4": "size", "right": "dimension", "answer3": "block", "answer2": "box"}');
