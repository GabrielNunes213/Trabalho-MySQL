#1) Crie um banco de dados chamado SeuNomeSuaTurma.
CREATE DATABASE GabrielVieiraTII2002T;

#2) Use esse Banco de dados.
USE GabrielVieiraTII2002T;

#3) Crie as tabelas obedecendo o desenho acima, inclusive com as chaves primárias e estrangeiras.

CREATE TABLE produto(
	cod_produto INT PRIMARY KEY,
	nome_produto VARCHAR(40),
	qtd INT,
	valor FLOAT
);

CREATE TABLE vendedor(
	registro INT PRIMARY KEY,
	nome VARCHAR(45),
	sexo CHAR(1)
);

CREATE TABLE vendas(
	cod_venda INT PRIMARY KEY,
	data_venda DATE,
	valor_venda FLOAT,
	registro INT, 
	FOREIGN KEY (registro) REFERENCES vendedor (registro)
);

CREATE TABLE itens_de_venda(
	cod_venda INT,
	cod_produto INT,
	qtd_item INT,
	valor_item FLOAT,
    PRIMARY KEY (cod_venda,cod_produto),
	FOREIGN KEY (cod_venda) REFERENCES vendas (cod_venda),
	FOREIGN KEY (cod_produto) REFERENCES produto (cod_produto)
);

#4) Desenhe o banco no MySQL Workbench. (FEITO)

#5) Faça o povoamento do banco, conforme as informações das tabelas acima.

INSERT INTO produto
	(cod_produto,nome_produto,qtd,valor) VALUES
    (10, "Mouse",100,10.00),
    (11,"Office",30,790.50),
    (12,"HD Externo",80,225.99),
    (13,"Teclado",100,35.90);
    
INSERT INTO vendedor
	(registro,nome,sexo) VALUES
    (101,"Aldebaran Touro","M"),
    (102,"Carina Dias","F"),
    (103,"Paula Fernandes","F"),
    (104,"Seya","M");
    
INSERT INTO vendas
	(cod_venda,data_venda,valor_venda,registro) VALUES
    (1001,"2014-03-05",840.50,101),
    (1002,"2014-03-06",235.99,102),
    (1003,"2014-03-07",20.00,103);
    
INSERT INTO itens_de_venda
	(cod_venda,cod_produto,qtd_item,valor_item) VALUES
    (1001,11,1,790.50),
    (1001,10,5,10.00),
    (1002,12,1,225.99),
    (1002,10,1,10.00),
    (1003,10,2,10.00);
    
    
#6) Acrescentar na tabela vendedor uma coluna denominada loja varchar(50).
	
    ALTER TABLE vendedor ADD loja VARCHAR(50);
    
#7) Atribuir uma loja para cada funcionário cadastrado: 

	UPDATE vendedor SET loja = "loja Centro" WHERE registro = 101;
    UPDATE vendedor SET loja = "loja Santo Antonio" WHERE registro = 102;
    UPDATE vendedor SET loja = "loja Cruzeiro" WHERE registro = 103;
    
#8) Incluir um novo produto com cod_produto =14; nome=”Mouse sem Fio” e valor do produto=R$ 49

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (14,"Mouse sem Fio",0,49.00);
    
#9) Criar na tabela vendedor um atributo chamado email e faça o povoamento do
#mesmo seguindo a regra nome@praticabd.com.br; exemplo vendedor 102 ficaria
#carina@praticabd.com.br

	ALTER TABLE vendedor ADD email VARCHAR(50);    
    
    UPDATE vendedor SET email="AldebaranTouro@praticabd.com.br" WHERE registro=101;
    UPDATE vendedor SET email="CarinaDias@praticabd.com.br" WHERE registro=102;
    UPDATE vendedor SET email="PaulaFernandes@praticabd.com.br" WHERE registro=103;
    UPDATE vendedor SET email="Seya@praticabd.com.br" WHERE registro=104;
    
#10) Gerar uma tabela de preços, com código do produto, nome do produto e valor do mesmo.

	CREATE TABLE preco (
    codigo_produto INT,
    nome_produto VARCHAR(45),
    valor_produto FLOAT
    );
	
    INSERT INTO preco
    (codigo_produto,nome_produto,valor_produto) VALUES
    (10,"Mouse",10.00),
    (11,"Office",790.50),
    (12,"HD Externo",225.99),
    (13,"Teclado",35.90),
    (14,"Mouse sem Fio",49.00);
    
#11) Aumentar em 10% todos os produtos de nossa empresa.
    
    SET SQL_SAFE_UPDATES = 0;
    
    UPDATE produto SET valor = valor + (valor * 0.1) WHERE valor > 0;
	UPDATE itens_de_venda SET valor_item = valor_item + (valor_item * 0.1) WHERE valor_item > 0;
    UPDATE preco SET valor_produto = valor_produto + (valor_produto * 0.1) WHERE valor_produto > 0;
    
    SET SQL_SAFE_UPDATES = 1;
    
#12) Insira mais dois vendedores na tabela vendedor de sua livre escolha.

	INSERT INTO vendedor
    (registro,nome,sexo) VALUES
    (105,"Mario Silva","M"),
    (106,"Joana Almeida","F");
    
#13) Associe esses dois novos vendedores a loja centro.

	UPDATE vendedor SET loja = "loja Centro" WHERE registro = 105;
    UPDATE vendedor SET loja = "loja Centro" WHERE registro = 106;

#14) Listar o nome e matricula de todos os vendedores que trabalham na loja centro.

	SELECT * FROM vendedor WHERE loja = "Loja Centro";

#15) Listar o nome e matricula de todos os vendedores ordenados alfabeticamente.

	SELECT * FROM vendedor ORDER BY nome ASC;

#16) Listar o código, nome e quantidade de todos os produtos ordenados alfabeticamente.

	SELECT * FROM produto ORDER BY nome_produto ASC;

#17) Listar todas as vendas ordenados pelo valor da venda de forma decrescente.

	SELECT * FROM vendas ORDER BY valor_venda DESC;
    
#18) Listar o número de vendedores agrupados por sexo.

	SELECT * FROM vendedor WHERE sexo = "M";
    SELECT * FROM vendedor WHERE sexo = "F";
    
#19) Qual o produto mais caro?

    SELECT * FROM produto ORDER BY valor DESC LIMIT 1;

#20) Qual o produto mais barato?

	SELECT * FROM produto ORDER BY valor ASC LIMIT 1;
    
#21) Qual a média de preços dos produtos?

	SELECT AVG(valor) FROM produto;

#22) Qual a quantidade de produtos que temos cadastrados? – Total de registros na tabela de produtos.

	SELECT COUNT(*) FROM produto;
    
#23) Quais os produtos possuem seu preço superior a média de preços de nossa base.

	SELECT * FROM produto WHERE valor > (SELECT AVG(valor) FROM produto);

#24) Listar o nome dos produtos que nunca foram vendidos.

SELECT
        cod_produto,
        nome_produto,
        valor
        FROM
        produto
        WHERE
        NOT EXISTS (
        SELECT
        cod_produto,
        valor_item
        FROM
        itens_de_venda
        WHERE
        valor = valor_item 
        );

#25) Listar o nome de todos os produtos que já foram vendidos.

SELECT
        cod_produto,
        nome_produto,
        valor
        FROM
        produto
        WHERE
        EXISTS (
        SELECT
        cod_produto,
        valor_item
        FROM
        itens_de_venda
        WHERE
        valor = valor_item 
        );
        
#26) Listar o nome de todos os vendedores que nunca realizam uma venda.
        
	SELECT registro FROM vendedor WHERE registro NOT IN (SELECT registro FROM vendas);

#27) Atualizar o nome do produto de código 11 para Office 2013 e seu valor para 579.00

	UPDATE produto SET nome_produto = "Office 2013" WHERE cod_produto = 11;
    UPDATE produto SET valor = 579.00 WHERE cod_produto = 11;

#28) Listar o nome do produto mais caro.

	SELECT nome_produto FROM produto ORDER BY valor DESC LIMIT 1;

#29) Listar o nome do produto mais barato.

	SELECT nome_produto FROM produto ORDER BY valor ASC LIMIT 1;

#30) Listar o nome de todos os produtos que tenham seu preço inferior à média de preços.

    SELECT * FROM produto WHERE valor < (SELECT AVG(valor) FROM produto);

#31) Listar o nome de todos os produtos que iniciam com a letra M.

	SELECT * FROM produto WHERE nome_produto LIKE 'M%';

#32) Listar o nome de todos os vendedores que tenha a palavra Dias em seu nome.

	SELECT * FROM vendedor WHERE nome LIKE '%Dias%';

#33) Exibir o total de venda da empresa.

	SELECT * FROM vendas;
    SELECT SUM(valor_venda) FROM vendas;

#34) Exibir o total de vendas da empresa para o vendedor de matrícula 102.

	SELECT * FROM vendas WHERE registro = 102;

#35) Exibir o total de vendas realizadas em um determinado período.

	SELECT * FROM vendas WHERE data_venda BETWEEN '2014-03-05' AND '2014-03-06';

#36) Exiba o total de vendas realizadas no dia 05 de março de 2014.

	SELECT * FROM vendas WHERE data_venda = "2014-03-05";
    SELECT SUM(valor_venda) FROM vendas WHERE data_venda = "2014-03-05";
    
#37) Exiba os produtos vendidos no mês de março.

	SELECT * FROM vendas WHERE data_venda BETWEEN '2014-03-01' AND '2014-03-31';

#38) Inserir uma nova venda com código 1004, valor total de 45.90 associada ao
#vendedor 101 no dia 10/05/2013.

	INSERT INTO vendas
	(cod_venda,data_venda,valor_venda,registro) VALUES
	(1004,"2013-05-10",45.90,101);

#39) Insira a venda feita pela vendedora Carina Dias de 01 teclado e 01 mouse. Observe
#que para fazer isso é necessário inserir registros nas tabelas vendas e item de venda,
#de modo que o valor da venda feche com o total de itens vendidos.

	INSERT INTO vendas
    (cod_venda,data_venda,valor_venda,registro) VALUES
    (1005,"2014-05-21",50.49,102);

	INSERT INTO itens_de_venda
    (cod_venda,cod_produto,qtd_item,valor_item) VALUES
    (1005,10,1,11.00),
    (1005,13,1,39.49);
    

#40) Listar o nome de todos os vendedores que realizaram alguma venda.

	SELECT registro FROM vendedor WHERE registro IN (SELECT registro FROM vendas);
    

#41) Listar o nome de todos os vendedores do sexo masculino que tenha a palavra Dias em seu nome

	SELECT * FROM vendedor WHERE nome LIKE '%Dias%' AND sexo = "M";

#42) Listar o nome de todos os produtos e a quantidade vendida para a venda de número 1001

	SELECT cod_produto,qtd_item FROM itens_de_venda WHERE cod_venda = 1001; 

#43) Listar o nome e quantidade de todos os produtos vendidos na venda de número 1003

	SELECT cod_produto,qtd_item FROM itens_de_venda WHERE cod_venda = 1003;

#44) Listar o nome, matricula e sexo do vendedor responsável pela venda de número 1001

	SELECT registro,nome,sexo FROM vendedor WHERE registro = 101;

#45) Insira um produto da sua escolha . Invente todos os dados

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (15,"Headset HyperX",40,611.92);

#46) Insira um vendedor da sua escolha . Invente todos os dados

	INSERT INTO vendedor
    (registro,nome,sexo,loja,email) VALUES
    (107,"Marcos andrade","M","Loja Centro","Marcos@praticabd.com.br");

#47) Altere o nome do seu ultimo vendedor para Raimunda Souza, sexo feminino, email
#raiso@hotmail.com e loja cruzeiro

	UPDATE vendedor SET nome = "Raimunda Souza",sexo = "F",email = "raiso@hotmail.com", loja = "Loja Cruzeiro" WHERE registro = 107;

#48) Insira uma venda da sua escolha . Invente todos os dados

		INSERT INTO vendas
        (cod_venda,data_venda,valor_venda,registro) VALUES
        (1006,"2014-05-29","550.30",103);

#49) Exclua a ultima venda cadastrada

	DELETE FROM vendas WHERE cod_venda = 1006;

#50) Insira seus dados como sendo um vendedor da loja Santo Antônio

	INSERT INTO vendedor
    (registro,nome,sexo,loja,email) VALUES
    (108,"Gabriel","M","Loja Santo Antonio","Gabriel@praticabd.com.br");
    
#51) Busque o nome de todos os vendedores que comecem com a letra do seu nome.

	SELECT * FROM vendedor WHERE nome LIKE 'G%';

#52) Exiba na tela o nome de todos os vendedores que terminem com a primeira letra do seu nome

	SELECT * FROM vendedor WHERE nome LIKE '%G';

#53) Conte quantos vendedores do sexo masculino existem na base de dados

	SELECT COUNT(*) FROM vendedor WHERE sexo = "M";

#54) Exiba a quantidade de vendedores tem na loja Santo Antônio

	SELECT COUNT(*) FROM vendedor WHERE loja = "loja Santo Antonio";

#55) Insira os dados de um amigo como sendo da loja Santo Antônio e repita a consulta
#da questão anterior para testar

	INSERT INTO vendedor
    (registro,nome,sexo,loja,email) VALUES
    (109,"Pedro","M","loja Santo Antonio","Pedro@praticabd.com.br");
    
    SELECT COUNT(*) FROM vendedor WHERE loja = "loja Santo Antonio";

#56) Altere a loja do seu amigo de Santo Antônio para Cruzeiro e repita a consulta da
#questão 54 para testar

	UPDATE vendedor SET loja = "loja Cruzeiro" WHERE registro = 109;
    
    SELECT COUNT(*) FROM vendedor WHERE loja = "loja Santo Antonio";

#57) Exiba na tela os nomes dos vendedores da loja Cruzeiro

	SELECT nome FROM vendedor WHERE loja = "loja Cruzeiro";

#58) Insira um produto da sua escolha e invente

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (16,"Caixa de som",60,30.55);

#59) Aumente em 50% o valor do produto cadastrado na questão 58

	SET SQL_SAFE_UPDATES = 0;
    
    UPDATE produto SET valor = valor + (valor * 0.5) WHERE cod_produto = 16;
    
    SET SQL_SAFE_UPDATES = 1;

#60) Exclua o produto cadastrado na questão 58

	DELETE FROM produto WHERE cod_produto = 16;

#61) Acrescente o campo nascimento na tabela vendedor para receber a data de
#nascimento dos vendedores.

	ALTER TABLE vendedor ADD data_nascimento DATE;

#62) Insira na tabela vendedor as datas de nascimento de todos os vendedores. Você
#pode escolher uma data qualquer.

	UPDATE vendedor SET data_nascimento = "1998-02-02" WHERE registro = 101;
    UPDATE vendedor SET data_nascimento = "1993-12-20" WHERE registro = 102;
    UPDATE vendedor SET data_nascimento = "1992-11-22" WHERE registro = 103;
    UPDATE vendedor SET data_nascimento = "1995-10-05" WHERE registro = 104;
    UPDATE vendedor SET data_nascimento = "1989-09-06" WHERE registro = 105;
    UPDATE vendedor SET data_nascimento = "2000-03-09" WHERE registro = 106;
    UPDATE vendedor SET data_nascimento = "2001-04-10" WHERE registro = 107;
    UPDATE vendedor SET data_nascimento = "1999-05-15" WHERE registro = 108;
    UPDATE vendedor SET data_nascimento = "1999-08-17" WHERE registro = 109;

#63) Busque a data de nascimento do vendedor Aldebaran

	SELECT data_nascimento FROM vendedor WHERE nome LIKE "%Aldebaran%";

#64) Retorne a loja em que o vendedor Seya trabalha

	SELECT loja FROM vendedor WHERE nome LIKE "%Seya%";

#65) Insira um produto qualquer. Invente os dados.

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (17,"Mouse Pad Azul",50,10.95);

#66) Insira na tabela produto o pen drive 8GB, quantidade 30 valor 29.90

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (18,"Pen Drive 8GB",30,29.90);

#67) Diminua em 5% o valor do produto Pen drive 8 GB

	UPDATE produto SET valor = valor - (valor * 0.05) WHERE cod_produto = 18;

#68) Aumente em 25% o valor do produto que você inseriu na questão 65

	UPDATE produto SET valor = valor + (valor * 0.25) WHERE cod_produto = 17;

#69) Exiba na tela todos os produtos que tenham o número oito “8” no nome.

	SELECT * FROM produto WHERE nome_produto LIKE "%8%";

#70) Insira um produto qualquer. Invente os dados

	INSERT INTO produto
    (cod_produto,nome_produto,qtd,valor) VALUES
    (19,"Monitor Led 19.5",25,619.00);

#71) Insira um vendedor qualquer. Invente os dados

	INSERT INTO vendedor
    (registro,nome,sexo,loja,email,data_nascimento) VALUES
    (110,"Paulo","M","loja Cruzeiro","Paulo@praticabd.com.br","2000-07-01");

#72) Altere a loja do vendedor inserido na questão 71 para Cruzeiro.

	UPDATE vendedor SET loja = "loja Cruzeiro" WHERE registro = 110;

#73) Atualize a data de nascimento do vendedor inserido na questão 71 para 25 de dezembro de 1994

	UPDATE vendedor SET data_nascimento = "1994-12-25" WHERE registro = 110;

#74) Exiba na tela a data de nascimento do vendedor Seya

	SELECT data_nascimento FROM vendedor WHERE nome LIKE "%seya%";

#75) Exclua o produto inserido na questão 70.

	DELETE FROM produto WHERE cod_produto = 19;

#76) Efetue uma venda qualquer. Não se esqueça que para cada venda efetuada é
#necessário inserir registros na tabela item_de_venda

	INSERT INTO vendas
    (cod_venda,data_venda,valor_venda,registro) VALUES
    (1006,"2014-04-09",579.00,106);
    
    INSERT INTO itens_de_venda
    (cod_venda,cod_produto,qtd_item,valor_item) VALUES
    (1006,11,1,579.00);

#77) Quantos produtos a empresa comercializa

	SELECT COUNT(*) FROM produto;

#78) Qual é o produto mais caro que a empresa comercializa?

	SELECT nome_produto,valor FROM produto ORDER BY valor DESC LIMIT 1;

#79) Qual é o produto mais barato que a empresa comercializa?

	SELECT nome_produto,valor FROM produto ORDER BY valor ASC LIMIT 1;
    
#80) Qual foi a maior venda feita pela empresa até agora?

	SELECT * FROM vendas ORDER BY valor_venda DESC LIMIT 1;


    #SELECT * FROM vendas;
    #DROP DATABASE GabrielVieiraTII2002T;