/* 
            COMEDY HOUSE
            
    Tema: CASA DE SHOW DE STAND-UP
    
    Turma: INF3AM
    
    Grupo: Arthur Porto                 01
           Diego Gomes                  07
           Gabriel Leandro              11
           Lucas Camargo                19
           Marcos Santos                26
*/

----------------------------------------------------------------------
create or replace procedure SP_PESSOA
(
vID_PESSOA integer,
vNOME varchar2,
vDATA_NASC date,
vSEXO varchar2,
vATIVO number,
vID_TIPO_PESSOA integer,
vOPR char)
IS
  vEXCEPTION EXCEPTION;------------ PENSAR SOBRE: SE DAR� PRA ALTERAR ID_TIPO_PESSOA
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_PESSOA WHERE ID_PESSOA = vID_PESSOA;              
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_PESSOA SET NOME = vNOME, DATA_NASC= vDATA_NASC, SEXO= vSEXO ,ATIVO = vATIVO, ID_TIPO_PESSOA= vID_TIPO_PESSOA
                    WHERE ID_PESSOA = vID_PESSOA;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_PESSOA(ID_PESSOA, NOME, DATA_NASC, SEXO, ATIVO ,ID_TIPO_PESSOA ,DATA_CRIACAO)
                    VALUES (SQ_PESSOA.NEXTVAL, vNOME, vDATA_NASC, vSEXO, vATIVO,vID_TIPO_PESSOA, SYSDATE);               
    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_PESSOA;
---------------------------------------------------------------------
create or replace procedure SP_CLIENTE
(
vID_CLIENTE integer,
vCPF varchar2,
vID_PESSOA integer,
vEMAIL varchar2,
vOPR char)
IS
  vPESSOA integer;
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_PERGUNTASECRETA WHERE ID_PERGUNTASECRETA= (SELECT ID_PERGUNTASECRETA FROM TB_PERGUNTASECRETA WHERE 
                    ID_PERGUNTASECRETA= (SELECT ID_PERGUNTASECRETA FROM TB_LOGIN WHERE ID_LOGIN= (SELECT ID_LOGIN FROM TB_LOGIN WHERE ID_PESSOA=(SELECT ID_PESSOA FROM TB_CLIENTE WHERE 
                    ID_CLIENTE= vID_CLIENTE))));
                    DELETE FROM TB_LOGIN WHERE ID_PESSOA=(SELECT ID_PESSOA FROM TB_CLIENTE WHERE 
                    ID_CLIENTE= vID_CLIENTE);
                  
    
                  
                    DELETE FROM TB_DESCONTOS_CLIENTE WHERE ID_CLIENTE=vID_CLIENTE;
                    DELETE FROM TB_ASSENTO_CLI WHERE ID_CLIENTE= vID_CLIENTE;
                    
                    SELECT ID_PESSOA INTO vPESSOA FROM TB_CLIENTE WHERE ID_CLIENTE=vID_CLIENTE;
                    DELETE FROM TB_CLIENTE WHERE ID_CLIENTE= vID_CLIENTE;
                    
                     DELETE FROM TB_PESSOA WHERE ID_PESSOA = vPESSOA;

    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_CLIENTE SET CPF=vCPF, EMAIL= vEMAIL WHERE ID_CLIENTE= vID_CLIENTE;
    ELSE
    IF(vOPR='I')THEN -- INCLUIR

                    INSERT INTO TB_CLIENTE(ID_CLIENTE, CPF, ID_PESSOA, EMAIL)
                    VALUES (SQ_CLIENTE.NEXTVAL, vCPF ,(SELECT MAX(ID_PESSOA) FROM TB_PESSOA), vEMAIL);


    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_CLIENTE;
---------------------------------------------------------------------
create or replace procedure SP_ARTISTA
(
vID_ARTISTA_GERAL integer,
vID_REDESOCIAL integer,
vFACEBOOK varchar2,
vTWITTER varchar2,
vINSTAGRAM varchar2,
vID_PESSOA integer,
vID_TIPO_PESSOA integer,
vURL_IMG varchar2,
vID_AGENTE integer,
vID_ENDERECO integer,
vTELEFONE varchar2,
vCPF varchar2,
vEMAIL varchar2,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   
IF(vID_TIPO_PESSOA=4)THEN--ARTISTA FIXO


IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_REDESOCIAL WHERE ID_REDESOCIAL= (SELECT ID_REDESOCIAL FROM TB_ARTISTA_GERAL WHERE 
                    ID_ARTISTA_GERAL= vID_ARTISTA_GERAL);
                    DELETE FROM TB_PESSOA WHERE ID_PESSOA = (SELECT ID_PESSOA FROM TB_ARTISTA_GERAL WHERE 
                    ID_ARTISTA_GERAL= vID_ARTISTA_GERAL);
                    DELETE FROM TB_ENDERECO WHERE ID_ENDERECO= (SELECT ID_ENDERECO FROM TB_ARTISTA_FIXO WHERE 
                    ID_ARTISTA_GERAL = vID_ARTISTA_GERAL);
                    DELETE FROM TB_ARTISTA_FIXO WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;
                    DELETE FROM TB_ARTISTA_GERAL WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;


    ELSE
    IF(vOPR='A')THEN -- ALTERAR   
                    
                 
    
                    UPDATE TB_ARTISTA_GERAL SET ID_REDESOCIAL= vID_REDESOCIAL,
                    URL_IMG= vURL_IMG
                    WHERE ID_PESSOA = vID_PESSOA;

                    UPDATE TB_REDESOCIAL SET FACEBOOK= vFACEBOOK, TWITTER=vTWITTER,
                    INSTAGRAM= vINSTAGRAM WHERE ID_REDESOCIAL= vID_REDESOCIAL;
                    
                    UPDATE TB_ARTISTA_FIXO SET ID_ENDERECO= vID_ENDERECO, TELEFONE= vTELEFONE,
                    CPF= vCPF, EMAIL= vEMAIL 
                    WHERE ID_ARTISTA_GERAL = vID_ARTISTA_GERAL;
                    
                    
    ELSE
    IF(vOPR='AN')THEN -- ALTERAR DE ARTISTA PRA ARTISTA FIXO
                    
                   DELETE FROM TB_ARTISTA WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;
    
                    UPDATE TB_ARTISTA_GERAL SET ID_REDESOCIAL= vID_REDESOCIAL,
                    URL_IMG= vURL_IMG
                    WHERE ID_PESSOA = vID_PESSOA;

                    UPDATE TB_REDESOCIAL SET FACEBOOK= vFACEBOOK, TWITTER=vTWITTER,
                    INSTAGRAM= vINSTAGRAM WHERE ID_REDESOCIAL= vID_REDESOCIAL;
    
                    INSERT INTO TB_ARTISTA_FIXO(ID_ARTISTA_GERAL, ID_ENDERECO, TELEFONE, CPF, EMAIL)
                    VALUES (vID_ARTISTA_GERAL,(SELECT MAX(ID_ENDERECO) FROM TB_ENDERECO), vTELEFONE,
                    vCPF, vEMAIL); 
                    
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_REDESOCIAL(ID_REDESOCIAL,FACEBOOK,TWITTER, INSTAGRAM)
                    VALUES (SQ_REDESOCIAL.NEXTVAL, vFACEBOOK, vTWITTER, vINSTAGRAM); 

                   INSERT INTO TB_ARTISTA_GERAL(ID_ARTISTA_GERAL, ID_REDESOCIAL, ID_PESSOA, URL_IMG)
                    VALUES (SQ_ARTISTA_GERAL.NEXTVAL,(SELECT MAX(ID_REDESOCIAL) FROM TB_REDESOCIAL) , (SELECT MAX(ID_PESSOA) FROM TB_PESSOA)
                    , vURL_IMG); 

                    INSERT INTO TB_ARTISTA_FIXO(ID_ARTISTA_GERAL, ID_ENDERECO, TELEFONE, CPF, EMAIL)
                    VALUES ((SELECT MAX(ID_ARTISTA_GERAL) FROM TB_ARTISTA_GERAL),(SELECT MAX(ID_ENDERECO) FROM TB_ENDERECO), vTELEFONE,
                    vCPF, vEMAIL); 


    END IF;
    END IF;
    END IF;
    END IF;

ELSE-- ARTISTA

IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_REDESOCIAL WHERE ID_REDESOCIAL= (SELECT ID_REDESOCIAL FROM TB_ARTISTA_GERAL WHERE 
                    ID_ARTISTA_GERAL= vID_ARTISTA_GERAL);
                    
                    DELETE FROM TB_ARTISTA_FIXO WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;

                    DELETE FROM TB_PESSOA WHERE ID_PESSOA = (SELECT ID_PESSOA FROM TB_ARTISTA_GERAL WHERE 
                    ID_ARTISTA_GERAL= vID_ARTISTA_GERAL);
                    DELETE FROM TB_ARTISTA WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;
                    DELETE FROM TB_ARTISTA_GERAL WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;


    ELSE
    IF(vOPR='A')THEN -- ALTERAR    
            
    
                   UPDATE TB_ARTISTA_GERAL SET ID_REDESOCIAL= vID_REDESOCIAL,
                    URL_IMG= vURL_IMG
                    WHERE ID_PESSOA = vID_PESSOA;

                    UPDATE TB_REDESOCIAL SET FACEBOOK= vFACEBOOK, TWITTER=vTWITTER,
                    INSTAGRAM= vINSTAGRAM WHERE ID_REDESOCIAL= vID_REDESOCIAL;
                        
                    UPDATE TB_ARTISTA SET ID_AGENTE= vID_AGENTE
                    WHERE ID_ARTISTA_GERAL = vID_ARTISTA_GERAL;
    ELSE
    IF(vOPR='AN')THEN -- ALTERAR DE ARTISTA FIXO PARA ARTISTA  
                    DELETE FROM TB_ENDERECO WHERE ID_ENDERECO= (SELECT ID_ENDERECO FROM TB_ARTISTA_FIXO
                    WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL);
    
                   DELETE FROM TB_ARTISTA_FIXO WHERE ID_ARTISTA_GERAL= vID_ARTISTA_GERAL;
    
                   UPDATE TB_ARTISTA_GERAL SET ID_REDESOCIAL= vID_REDESOCIAL,
                    URL_IMG= vURL_IMG
                    WHERE ID_PESSOA = vID_PESSOA;

                    UPDATE TB_REDESOCIAL SET FACEBOOK= vFACEBOOK, TWITTER=vTWITTER,
                    INSTAGRAM= vINSTAGRAM WHERE ID_REDESOCIAL= vID_REDESOCIAL;

                    INSERT INTO TB_ARTISTA(ID_ARTISTA_GERAL, ID_AGENTE)
                    VALUES (vID_ARTISTA_GERAL,vID_AGENTE);  

    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                     INSERT INTO TB_REDESOCIAL(ID_REDESOCIAL,FACEBOOK,TWITTER, INSTAGRAM)
                    VALUES (SQ_REDESOCIAL.NEXTVAL, vFACEBOOK, vTWITTER, vINSTAGRAM); 

                   INSERT INTO TB_ARTISTA_GERAL(ID_ARTISTA_GERAL, ID_REDESOCIAL, ID_PESSOA, URL_IMG)
                    VALUES (SQ_ARTISTA_GERAL.NEXTVAL,(SELECT MAX(ID_REDESOCIAL) FROM TB_REDESOCIAL) , (SELECT MAX(ID_PESSOA) FROM TB_PESSOA)
                    ,vURL_IMG); 

                    INSERT INTO TB_ARTISTA(ID_ARTISTA_GERAL, ID_AGENTE)
                    VALUES ((SELECT MAX(ID_ARTISTA_GERAL) FROM TB_ARTISTA_GERAL),vID_AGENTE); 


    END IF;
    END IF;
    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_ARTISTA;
--------------------------------------------------
create or replace procedure SP_AGENTE
(
vID_AGENTE integer,
vID_ENDERECO integer,
vTELEFONE varchar2,
vTIPO_PESSOA varchar2,
vDOCUMENTO varchar2,
vEMAIL varchar2,
vNOME_PRINCIPAL varchar2,
vNOME_SECUNDARIO varchar2,
vATIVO number,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
    
                   DELETE FROM TB_ENDERECO WHERE ID_ENDERECO= (SELECT ID_ENDERECO FROM TB_AGENTE WHERE
                    ID_AGENTE= vID_AGENTE);
                    DELETE FROM TB_AGENTE WHERE ID_AGENTE= vID_AGENTE;

    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_AGENTE SET TELEFONE= vTELEFONE, TIPO_PESSOA= vTIPO_PESSOA, DOCUMENTO= vDOCUMENTO, EMAIL= vEMAIL,
                    NOME_PRINCIPAL= vNOME_PRINCIPAL, NOME_SECUNDARIO= vNOME_SECUNDARIO, ATIVO= vATIVO
                    WHERE ID_AGENTE = vID_AGENTE;
    ELSE
    IF(vOPR='I')THEN -- INCLUIR

                   INSERT INTO TB_AGENTE(ID_AGENTE, ID_ENDERECO, TELEFONE, TIPO_PESSOA, DOCUMENTO,EMAIL,NOME_PRINCIPAL
                   , NOME_SECUNDARIO,ATIVO,DATA_CRIACAO)
                    VALUES (SQ_AGENTE.NEXTVAL,(SELECT MAX(ID_ENDERECO) FROM TB_ENDERECO) , vTELEFONE  , vTIPO_PESSOA,
                    vDOCUMENTO, vEMAIL, vNOME_PRINCIPAL,vNOME_SECUNDARIO,vATIVO,SYSDATE ); 


    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_AGENTE;
-----------------------------------------------------
create or replace procedure SP_ENDERECO
(
vID_ENDERECO integer,
vCEP varchar2,
vNUMERO number,
vCOMPLEMENTO varchar2,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_ENDERECO WHERE ID_ENDERECO= vID_ENDERECO;
                    
    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_ENDERECO SET CEP= vCEP, NUMERO= vNUMERO, COMPLEMENTO= vCOMPLEMENTO
                    WHERE ID_ENDERECO = vID_ENDERECO;
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    
                   INSERT INTO TB_ENDERECO(ID_ENDERECO,CEP,NUMERO,COMPLEMENTO)
                    VALUES (SQ_ENDERECO.NEXTVAL,vCEP, vNUMERO  , vCOMPLEMENTO); 
                     

    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_ENDERECO;
------------------------------------------------------
create or replace procedure SP_LOGIN      
(
vID_LOGIN integer,
vID_NIVELACESSO integer,
vID_PERGUNTASECRETA integer,
vUSUARIO varchar2,
vSENHA varchar2,
vDATAULTIMOACESSO date,
vID_PESSOA integer,
vDESCRICAO varchar2,
vRESPOSTA varchar2,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_LOGIN WHERE ID_LOGIN= vID_LOGIN;

                    DELETE FROM TB_PERGUNTASECRETA WHERE ID_PERGUNTASECRETA= vID_PERGUNTASECRETA;
    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_LOGIN SET ID_NIVELACESSO= vID_NIVELACESSO, USUARIO= vUSUARIO, SENHA= vSENHA
                    WHERE ID_LOGIN = vID_LOGIN;

                     UPDATE TB_PERGUNTASECRETA SET DESCRICAO= vDESCRICAO, RESPOSTA= vRESPOSTA
                    WHERE ID_PERGUNTASECRETA = (SELECT ID_PERGUNTASECRETA FROM TB_LOGIN WHERE ID_LOGIN= vID_LOGIN);
    ELSE
    IF(vOPR='N')THEN -- ALTERAR                  
                    UPDATE TB_LOGIN SET ID_NIVELACESSO= vID_NIVELACESSO, USUARIO= vUSUARIO, SENHA= vSENHA
                    WHERE ID_LOGIN = vID_LOGIN;

                
    ELSE
    IF(vOPR='I')THEN -- INCLUIR

                    INSERT INTO TB_PERGUNTASECRETA(ID_PERGUNTASECRETA,DESCRICAO, RESPOSTA)
                    VALUES (SQ_PERGUNTASECRETA.NEXTVAL,vDESCRICAO,vRESPOSTA); 


                   INSERT INTO TB_LOGIN(ID_LOGIN,ID_NIVELACESSO,ID_PERGUNTASECRETA,USUARIO, SENHA, DATAULTIMOACESSO, ID_PESSOA)
                    VALUES (SQ_LOGIN.NEXTVAL,vID_NIVELACESSO,(SELECT MAX(ID_PERGUNTASECRETA) FROM TB_PERGUNTASECRETA),
                    vUSUARIO  , vSENHA, SYSDATE,(SELECT MAX(ID_PESSOA) FROM TB_PESSOA) ); 


    END IF;
    END IF;
    END IF;
    END IF;



  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_LOGIN;
---------------------------------------------------------
create or replace procedure SP_CONTAS    
(
vID_CONTAS integer,
vID_DATA_CONTA integer,
vDATA_CONTA date,
vTIPO_DATA varchar2,
vTIPO_CONTA varchar2,
vDATA_LANCAMENTO date,
vDATA_ENTREGUE date,
vDESCRICAO varchar2,
vSITUACAO varchar2,
vDEPARTAMENTO varchar2,
vVALOR_TOTAL number,
vATIVO number,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_DETALHE_CONTA WHERE ID_CONTAS= vID_CONTAS;
                    DELETE FROM TB_DETALHE_CONTA_VENDA WHERE ID_CONTAS= vID_CONTAS;
                    DELETE FROM TB_CONTAS WHERE ID_CONTAS= vID_CONTAS;
                    DELETE FROM TB_DATA_CONTA WHERE ID_DATA_CONTA = vID_DATA_CONTA;
                    
    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_CONTAS SET TIPO_CONTA= vTIPO_CONTA, DESCRICAO= vDESCRICAO,
                    SITUACAO= vSITUACAO,DATA_ENTREGUE= vDATA_ENTREGUE, DEPARTAMENTO= vDEPARTAMENTO, VALOR_TOTAL= vVALOR_TOTAL, ATIVO= vATIVO
                    WHERE ID_CONTAS = vID_CONTAS;

                     UPDATE TB_DATA_CONTA SET DATA_CONTA= vDATA_CONTA, TIPO_DATA= vTIPO_DATA
                    WHERE ID_DATA_CONTA = vID_DATA_CONTA;
    ELSE
    IF(vOPR='I')THEN -- INCLUIR

                    INSERT INTO TB_DATA_CONTA(ID_DATA_CONTA,DATA_CONTA, TIPO_DATA)
                    VALUES (SQ_DATA_CONTA.NEXTVAL,vDATA_CONTA,vTIPO_DATA); 


                   INSERT INTO TB_CONTAS(ID_CONTAS,ID_DATA_CONTA,TIPO_CONTA,DATA_LANCAMENTO,DATA_ENTREGUE,DESCRICAO,SITUACAO,
                   DEPARTAMENTO, VALOR_TOTAL, ATIVO)
                    VALUES (SQ_CONTAS.NEXTVAL,(SELECT MAX(ID_DATA_CONTA) FROM TB_DATA_CONTA),vTIPO_CONTA,
                SYSDATE, vDATA_ENTREGUE  , vDESCRICAO, vSITUACAO, vDEPARTAMENTO, vVALOR_TOTAL, vATIVO ); 


    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_CONTAS;
---------------------------------------------------------
create or replace procedure SP_FORMA_PAGAMENTO
(
vID_FORMA_PAGAMENTO integer,
vFORMA_PAGAMENTO varchar2,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   
  
    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_PAGAMENTO WHERE ID_PAGAMENTO IN (SELECT ID_PAGAMENTO FROM TB_PAGAMENTO WHERE ID_FORMA_PAGAMENTO= vID_FORMA_PAGAMENTO);
                    DELETE FROM TB_DETALHE_CONTA WHERE ID_DETALHE IN (SELECT ID_DETALHE FROM TB_DETALHE_CONTA WHERE ID_FORMA_PAGAMENTO= vID_FORMA_PAGAMENTO);
                    DELETE FROM TB_FORMA_PAGAMENTO WHERE ID_FORMA_PAGAMENTO = vID_FORMA_PAGAMENTO;              
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_FORMA_PAGAMENTO SET FORMA_PAGAMENTO = vFORMA_PAGAMENTO
                    WHERE ID_FORMA_PAGAMENTO = vID_FORMA_PAGAMENTO;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_FORMA_PAGAMENTO(ID_FORMA_PAGAMENTO, FORMA_PAGAMENTO)
                    VALUES (SQ_FORMA_PAGAMENTO.NEXTVAL, vFORMA_PAGAMENTO);               
    END IF;
    END IF;
    END IF;


  

  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_FORMA_PAGAMENTO;
---------------------------------------------------------
create or replace procedure SP_FUNCAO
(
vID_FUNCAO integer,
vFUNCAO varchar2,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   
  
    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_FUNCAO WHERE ID_FUNCAO = vID_FUNCAO;              
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_FUNCAO SET FUNCAO = vFUNCAO
                    WHERE ID_FUNCAO = vID_FUNCAO;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_FUNCAO(ID_FUNCAO, FUNCAO)
                    VALUES (SQ_FUNCAO.NEXTVAL, vFUNCAO);               
    END IF;
    END IF;
    END IF;


  

  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_FUNCAO;
---------------------------------------------------------
create or replace procedure SP_FUNCIONARIO
(
vID_FUNC integer,
vID_FUNCAO integer,
vID_ENDERECO integer,
vCPF varchar2,
vEMAIL varchar2,
vTELEFONE varchar2,
vID_PESSOA integer,
vOPR char)
IS
  vPESSOA integer;
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
    
                    DELETE FROM TB_PERGUNTASECRETA WHERE ID_PERGUNTASECRETA= (SELECT ID_PERGUNTASECRETA FROM TB_PERGUNTASECRETA WHERE 
                    ID_PERGUNTASECRETA= (SELECT ID_PERGUNTASECRETA FROM TB_LOGIN WHERE ID_LOGIN= (SELECT ID_LOGIN FROM TB_LOGIN WHERE ID_PESSOA=(SELECT ID_PESSOA FROM TB_FUNCIONARIO WHERE 
                    ID_FUNC= vID_FUNC))));
                    DELETE FROM TB_LOGIN WHERE ID_PESSOA=(SELECT ID_PESSOA FROM TB_FUNCIONARIO WHERE 
                    ID_FUNC= vID_FUNC);
    
    
                    DELETE FROM TB_ENDERECO WHERE ID_ENDERECO= (SELECT ID_ENDERECO FROM TB_FUNCIONARIO WHERE
                    ID_FUNC= vID_FUNC);
                    SELECT ID_PESSOA INTO vPESSOA FROM TB_FUNCIONARIO WHERE ID_FUNC=vID_FUNC;
                    
                    DELETE FROM TB_FUNCIONARIO WHERE ID_FUNC = vID_FUNC;  
                    
                    DELETE FROM TB_PESSOA WHERE ID_PESSOA = vPESSOA;
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_FUNCIONARIO SET ID_FUNCAO = vID_FUNCAO, CPF= vCPF, EMAIL= vEMAIL, TELEFONE= vTELEFONE
                    WHERE ID_FUNC = vID_FUNC;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_FUNCIONARIO(ID_FUNC, ID_FUNCAO, ID_ENDERECO, CPF, EMAIL, TELEFONE, ID_PESSOA)
                    VALUES (SQ_FUNCIONARIO.NEXTVAL, vID_FUNCAO, (SELECT MAX(ID_ENDERECO) FROM TB_ENDERECO) , vCPF, vEMAIL,
                    vTELEFONE, (SELECT MAX(ID_PESSOA) FROM TB_PESSOA) );               
    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_FUNCIONARIO;
---------------------------------------------------------
create or replace procedure SP_EVENTO    
(
vID_EVENTO integer,
vTITULO varchar2,
vDATA_EVENTO date,
vDESCRICAO varchar2,
vHORARIO_INICIO timestamp,
vHORARIO_FINAL timestamp,
vDURACAO varchar2,
vN_ARTISTAS number,
vTIPO_PAG varchar2,
vATIVO number,
vVALOR_EVENTO number,
vID_ARTISTA_GERAL integer,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_EVENTO WHERE ID_EVENTO= vID_EVENTO;
                    
                    DELETE FROM TB_EVENTO_ARTISTA WHERE ID_EVENTO= vID_EVENTO;
                    
                    DELETE FROM TB_EVENTO_INGRESSO WHERE ID_EVENTO= vID_EVENTO;

    ELSE
    IF(vOPR='A')THEN -- ALTERAR                  
                    UPDATE TB_EVENTO SET TITULO=vTITULO, DATA_EVENTO=vDATA_EVENTO, DESCRICAO=vDESCRICAO,
                    HORARIO_INICIO=vHORARIO_INICIO, HORARIO_FINAL= vHORARIO_FINAL, N_ARTISTAS=vN_ARTISTAS, DURACAO=vDURACAO,
                    TIPO_PAG = vTIPO_PAG, ATIVO=vATIVO, VALOR_EVENTO= vVALOR_EVENTO WHERE ID_EVENTO= vID_EVENTO;
    ELSE
    IF(vOPR='I')THEN -- INCLUIR

                    INSERT INTO TB_EVENTO (ID_EVENTO, TITULO, DATA_EVENTO, DESCRICAO, HORARIO_INICIO,
                    HORARIO_FINAL,DURACAO ,N_ARTISTAS,TIPO_PAG,ATIVO, VALOR_EVENTO) 
                    VALUES (SQ_EVENTO.NEXTVAL, vTITULO ,vDATA_EVENTO ,
                    vDESCRICAO, vHORARIO_INICIO, vHORARIO_FINAL ,vDURACAO,vN_ARTISTAS,vTIPO_PAG,vATIVO, vVALOR_EVENTO);


    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_EVENTO;
---------------------------------------------------------
create or replace procedure SP_DESCONTOS
(
vID_DESCONTO integer,
vDESCONTO number,
vCOD_PROMOCIONAL varchar2,
vATIVO number,
vID_CLIENTE integer,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   
  
    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_DESCONTOS WHERE ID_DESCONTO = vID_DESCONTO;              
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_DESCONTOS SET DESCONTO = vDESCONTO, COD_PROMOCIONAL=vCOD_PROMOCIONAL,ATIVO=vATIVO
                    WHERE ID_DESCONTO = vID_DESCONTO;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_DESCONTOS(ID_DESCONTO, DESCONTO, COD_PROMOCIONAL,N_USOS,ATIVO)
                    VALUES (SQ_DESCONTOS.NEXTVAL, vDESCONTO, vCOD_PROMOCIONAL,0, vATIVO);  
   ELSE
   IF(vOPR='U')THEN --USAR DESCONTO
                    INSERT INTO TB_DESCONTOS_CLIENTE(ID_DESCONTO, ID_CLIENTE)
                    VALUES (vID_DESCONTO, vID_CLIENTE);  
                    UPDATE TB_DESCONTOS SET N_USOS= N_USOS+1 WHERE ID_DESCONTO= vID_DESCONTO;
    END IF;
    END IF;
    END IF;
    END IF;


  

  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_DESCONTOS;
---------------------------------------------------------
create or replace procedure SP_INICIAR
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

      UPDATE TB_CONTAS SET ATIVO=0 WHERE TB_CONTAS.ID_CONTAS IN (SELECT ID_CONTAS FROM TB_CONTAS
    INNER JOIN TB_DATA_CONTA DTC ON DTC.ID_DATA_CONTA= TB_CONTAS.ID_CONTAS 
    WHERE TB_CONTAS.SITUACAO='Recebida' OR TB_CONTAS.SITUACAO='Paga' AND DTC.DATA_CONTA > SYSDATE);

    UPDATE TB_EVENTO SET ATIVO=0 WHERE TO_CHAR(DATA_EVENTO,'dd/mm/yy')<TO_CHAR(SYSDATE,'dd/mm/yy') AND ATIVO=1;
  
    UPDATE TB_EVENTO SET ATIVO=0 WHERE TO_CHAR(DATA_EVENTO,'dd/mm/yy')<TO_CHAR(SYSDATE, 'dd/mm/yy') AND TO_CHAR(HORARIO_FINAL,'hh24:mi') <TO_CHAR(SYSDATE, 'hh24:mi')AND CAST(SUBSTR(HORARIO_FINAL,10,5) AS VARCHAR(5))!='00:00' AND ATIVO=1;
    
    UPDATE TB_EVENTO SET ATIVO=0 WHERE TO_CHAR(DATA_EVENTO,'dd/mm/yy')<TO_CHAR(SYSDATE, 'dd/mm/yy') AND TO_CHAR(HORARIO_FINAL+1,'hh24:mi') <TO_CHAR(SYSDATE, 'hh24:mi')AND CAST(SUBSTR(HORARIO_FINAL,10,5) AS VARCHAR(5)) ='00:00' AND ATIVO=1;
    
    UPDATE TB_PESSOA SET ATIVO=0 WHERE TB_PESSOA.ID_PESSOA IN (SELECT ID_PESSOA FROM TB_ARTISTA_GERAL 
    INNER JOIN TB_ARTISTA ON TB_ARTISTA.ID_ARTISTA_GERAL= TB_ARTISTA_GERAL.ID_ARTISTA_GERAL
    INNER JOIN TB_AGENTE ON TB_AGENTE.ID_AGENTE= TB_ARTISTA.ID_AGENTE
    WHERE TB_AGENTE.ATIVO=0);

    UPDATE TB_EVENTO SET ATIVO=0 WHERE TB_EVENTO.ID_EVENTO IN (SELECT TB_EVENTO.ID_EVENTO FROM TB_EVENTO 
    INNER JOIN TB_EVENTO_ARTISTA ON TB_EVENTO_ARTISTA.ID_EVENTO= TB_EVENTO.ID_EVENTO
    INNER JOIN TB_PESSOA ON TB_PESSOA.ID_PESSOA= TB_EVENTO_ARTISTA.ID_PESSOA
    WHERE TB_PESSOA.ATIVO=0);




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Problema na base de dados!', FALSE);
END SP_INICIAR;
---------------------------------------------------------
create or replace procedure SP_LOG
(
vTIPO_LOG varchar,
vID_FUNC integer,
vTABELA_LOG varchar2,
vID_MODIFICADO integer,--ALTERADO,EXCLUIDO,INSERIDO
vDESCRICAO varchar2,
vOPR char)
IS
  vID_TIPO_LOG integer;
  vID_TABELA_LOG integer;
  vID_LOG integer;
  vEXCEPTION EXCEPTION;
  BEGIN   

    SELECT ID_TIPO_LOG INTO vID_TIPO_LOG FROM TB_TIPO_LOG WHERE TIPO_LOG=vTIPO_LOG; 

    SELECT ID_TABELA_LOG INTO vID_TABELA_LOG FROM TB_TABELAS_LOG WHERE TABELA=vTABELA_LOG; 

    INSERT INTO TB_LOG (ID_LOG,DATA_LOG,ID_TIPO_LOG,ID_FUNC)
    VALUES(SQ_LOG.NEXTVAL, SYSDATE, vID_TIPO_LOG, vID_FUNC);

    SELECT MAX(ID_LOG) INTO vID_LOG FROM TB_LOG; 

    IF(vOPR='D')THEN -- DELETAR
                     INSERT INTO TB_LOG_EXCLUSAO (ID_LOG_EXCL,ID_LOG,ID_TABELA_LOG,ID_EXCLUIDO, DESCRICAO)
                     VALUES(SQ_LOG_EXCL.NEXTVAL, vID_LOG, vID_TABELA_LOG, vID_MODIFICADO, vDESCRICAO);   
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                     INSERT INTO TB_LOG_ALTERACAO (ID_LOG_ALTER,ID_LOG,ID_TABELA_LOG,ID_ALTERADO)
                     VALUES(SQ_LOG_ALTER.NEXTVAL, vID_LOG, vID_TABELA_LOG, vID_MODIFICADO);              
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                      INSERT INTO TB_LOG_INSERCAO (ID_LOG_INSER,ID_LOG,ID_TABELA_LOG,ID_INSERIDO)
                     VALUES(SQ_LOG_INSER.NEXTVAL, vID_LOG, vID_TABELA_LOG, vID_MODIFICADO);  

    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_LOG;
---------------------------------------------------------
create or replace procedure SP_NOVIDADE
(
vID_BANNER integer,
vURL_IMG varchar2,
vINDEX_BANNER number,
vATIVO number,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='D')THEN -- DELETAR
                    DELETE FROM TB_BANNER WHERE ID_BANNER = vID_BANNER;              
    ELSE
    IF(vOPR='A')THEN -- ALTERAR
                    UPDATE TB_BANNER SET URL_IMG = vURL_IMG, INDEX_BANNER=vINDEX_BANNER, ATIVO= vATIVO
                    WHERE ID_BANNER = vID_BANNER;                       
    ELSE
    IF(vOPR='I')THEN -- INCLUIR
                    INSERT INTO TB_BANNER(ID_BANNER,URL_IMG, INDEX_BANNER, ATIVO)
                    VALUES (SQ_NOVIDADE.NEXTVAL, vURL_IMG, vINDEX_BANNER, vATIVO);               
    END IF;
    END IF;
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_NOVIDADE;
---------------------------------------------------------
create or replace procedure SP_CANCELAR_VENDA
(
vID_VENDA integer,
vMOTIVO varchar2,
vID_FUNC number,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  BEGIN   

    IF(vOPR='C')THEN -- CANCELAR
                   UPDATE TB_VENDA_INGRESSO SET SITUACAO= 'Cancelado'  WHERE ID_VENDA= vID_VENDA; 
                   
                   INSERT INTO TB_CANCELA_VENDA(ID_CANCELA_VENDA, ID_VENDA,MOTIVO,DATA_CANCELAMENTO, ID_FUNC) VALUES
                   (SQ_CANCELA_VENDA.NEXTVAL, vID_VENDA, vMOTIVO, SYSDATE, vID_FUNC);
 
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_CANCELAR_VENDA;
---------------------------------------------------------
EXEC proc_Pessoa (1,'teste','A','I');
select * from TB_PESSOA;

---------------------------------------------------------
create or replace procedure SP_CANCELAR_VENDA
(
vID_VENDA integer,
vMOTIVO varchar2,
vID_FUNC number,
vOPR char)
IS
  vEXCEPTION EXCEPTION;
  vID_CONTAS integer;
  BEGIN   

    IF(vOPR='C')THEN -- CANCELAR
                   UPDATE TB_VENDA_INGRESSO SET SITUACAO= 'Cancelado'  WHERE ID_VENDA= vID_VENDA; 
                   
                   UPDATE TB_ASSENTO_CLI SET ATIVO=0 WHERE ID_EVENTO= (SELECT DISTINCT TB_EVENTO_INGRESSO.ID_EVENTO FROM TB_VENDA_INGRESSO
                   INNER JOIN TB_ITEM_VENDA ITV ON ITV.ID_VENDA= TB_VENDA_INGRESSO.ID_VENDA
                   INNER JOIN TB_EVENTO_INGRESSO ON TB_EVENTO_INGRESSO.ID_EI = ITV.ID_EI
                   INNER JOIN TB_EVENTO EV ON EV.ID_EVENTO = TB_EVENTO_INGRESSO.ID_EVENTO WHERE TB_VENDA_INGRESSO.ID_VENDA= vID_VENDA) 
                   AND ID_CLIENTE = (SELECT DISTINCT ID_CLIENTE FROM TB_VENDA_INGRESSO WHERE ID_VENDA= vID_VENDA);
                   
                   INSERT INTO TB_CANCELA_VENDA(ID_CANCELA_VENDA, ID_VENDA,MOTIVO,DATA_CANCELAMENTO, ID_FUNC) VALUES
                   (SQ_CANCELA_VENDA.NEXTVAL, vID_VENDA, vMOTIVO, SYSDATE, vID_FUNC);
                   
                   SELECT ID_CONTAS INTO vID_CONTAS FROM TB_DETALHE_CONTA_VENDA WHERE ID_VENDA= vID_VENDA;
                   
                   DELETE FROM TB_DETALHE_CONTA WHERE ID_CONTAS= vID_CONTAS;
                   DELETE FROM TB_DETALHE_CONTA_VENDA WHERE ID_CONTAS= vID_CONTAS;
                   DELETE FROM TB_CONTAS WHERE ID_CONTAS = vID_CONTAS;
                   
            
 
    END IF;




  EXCEPTION
    WHEN vEXCEPTION THEN
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A.', FALSE);
END SP_CANCELAR_VENDA;
