﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.DataAccess.Client;
namespace BLL
{
    public class Cliente
    {

        private static string SQL;
        private static OracleDataReader dr;

        private int _ID_CLIENTE;

        public int ID_CLIENTE
        {
            get { return _ID_CLIENTE; }
            set { _ID_CLIENTE = value; }
        }

        private int _ID_ASSENTO;

        public int ID_ASSENTO
        {
            get { return _ID_ASSENTO; }
            set { _ID_ASSENTO = value; }
        }

        private int _ID_EVENTO;

        public int ID_EVENTO
        {
            get { return _ID_EVENTO; }
            set { _ID_EVENTO = value; }
        }

        private int _ID_TIPO_PESSOA;

        public int ID_TIPO_PESSOA
        {
            get { return _ID_TIPO_PESSOA; }
            set { _ID_TIPO_PESSOA = value; }
        }

        private int _ID_PESSOA;

        public int ID_PESSOA
        {
            get { return _ID_PESSOA; }
            set { _ID_PESSOA = value; }
        }

        private string _Nome;
        public string Nome
        {
            get { return _Nome; }
            set { _Nome = value.ToUpper(); }
        }

        private DateTime _DataDeCriacao;

        public DateTime DataDeCriacao
        {
            get { return _DataDeCriacao; }
            set { _DataDeCriacao = value; }
        }

        private DateTime _DataListarFinal;

        public DateTime DataListarFinal
        {
            get { return _DataListarFinal; }
            set { _DataListarFinal = value; }
        }

        private DateTime _DataListarInicio;

        public DateTime DataListarInicio
        {
            get { return _DataListarInicio; }
            set { _DataListarInicio = value; }
        }

        private string _DataNasc;

        public string DataNasc
        {
            get { return _DataNasc; }
            set { _DataNasc = value; }
        }

        private int _Ativo;

        public int Ativo
        {
            get { return _Ativo; }
            set { _Ativo = value; }
        }

        private string _CPF;
        public string CPF
        {
            get { return _CPF; }
            set { _CPF = value; }
        }

        private string _Email;
        public string Email
        {
            get { return _Email; }
            set { _Email = value; }
        }
        public OracleDataReader ConsultarPessoa()
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "SELECT P.ATIVO,P.NOME FROM TB_CLIENTE C INNER JOIN TB_PESSOA P ON P.ID_PESSOA= C.ID_PESSOA WHERE C.ID_CLIENTE = " + _ID_CLIENTE;
                return c.RetornarDataReader(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public OracleDataReader ConsultarValorMaximo()
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "SELECT MAX(ID_CLIENTE) AS ID FROM TB_CLIENTE";
                return c.RetornarDataReader(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public OracleDataReader ConsultarPorCliente()
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "SELECT TB_PESSOA.NOME, TB_ITEM_VENDA.ID_VENDA, TB_ASSENTO_CLI.ID_ASSENTO,TB_EVENTO_INGRESSO.ID_EVENTO FROM TB_ASSENTO_CLI INNER JOIN TB_EVENTO_INGRESSO ON TB_EVENTO_INGRESSO.ID_EVENTO=TB_ASSENTO_CLI.ID_EVENTO INNER JOIN TB_ITEM_VENDA ON TB_ITEM_VENDA.ID_EI= TB_EVENTO_INGRESSO.ID_EI INNER JOIN TB_VENDA_INGRESSO VD ON VD.ID_VENDA= TB_ITEM_VENDA.ID_VENDA INNER JOIN TB_CLIENTE ON TB_CLIENTE.ID_CLIENTE = TB_ASSENTO_CLI.ID_CLIENTE INNER JOIN TB_PESSOA ON TB_PESSOA.ID_PESSOA= TB_CLIENTE.ID_PESSOA WHERE TB_ASSENTO_CLI.ID_EVENTO=" + _ID_EVENTO+" AND TB_ITEM_VENDA.ID_ASSENTO="+_ID_ASSENTO+ " AND TB_ASSENTO_CLI.ID_ASSENTO=" + _ID_ASSENTO + " AND VD.SITUACAO!='Cancelado' GROUP BY TB_PESSOA.NOME, TB_ITEM_VENDA.ID_VENDA, TB_ASSENTO_CLI.ID_ASSENTO,TB_EVENTO_INGRESSO.ID_EVENTO"; 
                return c.RetornarDataReader(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       
        public OracleDataReader Consultar()
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "  SELECT CLI.ID_CLIENTE, CLI.EMAIL, P.ID_PESSOA,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO,CLI.CPF, L.USUARIO, L.SENHA ,PS.DESCRICAO AS PERGUNTA, PS.RESPOSTA, L.ID_LOGIN, PS.ID_PERGUNTASECRETA FROM TCCSHOW.TB_PESSOA P INNER JOIN TCCSHOW.TB_CLIENTE CLI ON CLI.ID_PESSOA = P.ID_PESSOA  INNER JOIN TCCSHOW.TB_LOGIN L ON L.ID_PESSOA= P.ID_PESSOA INNER JOIN TCCSHOW.TB_PERGUNTASECRETA PS ON PS.ID_PERGUNTASECRETA = L.ID_PERGUNTASECRETA WHERE CLI.ID_CLIENTE= " + _ID_CLIENTE;
                return c.RetornarDataReader(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Ativar(Byte Valor)
        { //Valor 1 = Reativar    Valor 0 = Desativar
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "UPDATE TB_PESSOA SET ATIVO = '" + Valor + "' WHERE ID_PESSOA = (SELECT ID_PESSOA FROM TB_CLIENTE WHERE ID_CLIENTE=" + _ID_CLIENTE + ")";
                c.ExecutarComando(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
     


        public DataSet ListarGeral(string texto, int ativo, string tipo, string tipo2, string tTitulo, int tID)
        {
            DAO.ClasseConexao c = new DAO.ClasseConexao();
            string comando = string.Empty;
            string Where=string.Empty;
            if (tID >0)
            {
                Where = " INNER JOIN TB_VENDA_INGRESSO ON TB_VENDA_INGRESSO.ID_CLIENTE= CLI.ID_CLIENTE INNER JOIN TB_ITEM_VENDA ON TB_ITEM_VENDA.ID_VENDA= TB_VENDA_INGRESSO.ID_VENDA INNER JOIN TB_EVENTO_INGRESSO ON TB_EVENTO_INGRESSO.ID_EI = TB_ITEM_VENDA.ID_EI INNER JOIN TB_EVENTO EV ON EV.ID_EVENTO = TB_EVENTO_INGRESSO.ID_EVENTO WHERE EV.ID_EVENTO= " + tID + " ";
            }
           

            if (tipo2 != string.Empty && tipo2 != null)//COM DATA ESPECIFICA
            {
                if (ativo == 2 && texto.Length == 0)
                {
                    if (Where !=string.Empty)
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                    }
                    else
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE " + tipo2+" >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND "+tipo2+" <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                    }
                   

                    return c.RetornarDataSet(comando);
                }
                else if (ativo == 2 && texto.Length != 0)
                {
                    if (Where != string.Empty)
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND " + tipo + " LIKE '%" + texto + "%' AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                    }
                    else
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA  WHERE " + tipo + " LIKE '%" + texto + "%' AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                    }
                    
                    return c.RetornarDataSet(comando);
                }
                else
                {
                    if (texto.Length == 0) // texto == null || texto == ""
                    {
                        if (Where != string.Empty)
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND P.ATIVO=" + ativo + " AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                        }
                        else
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF, CLI.EMAIL,P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE P.ATIVO=" + ativo + " AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                        }
                        
                        return c.RetornarDataSet(comando);
                    }
                    else
                    {
                        if (Where != string.Empty)
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND " + tipo + " LIKE '%" + texto + "%' AND P.ATIVO = " + ativo + " AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                        }
                        else
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF, CLI.EMAIL,P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE " + tipo + " LIKE '%" + texto + "%' AND P.ATIVO = " + ativo + " AND " + tipo2 + " >= TO_DATE('" + _DataListarInicio + "', ' dd/mm/yyyy hh24:mi:ss') AND " + tipo2 + " <= TO_DATE('" + _DataListarFinal + "', ' dd/mm/yyyy hh24:mi:ss') ORDER BY " + tipo + "";
                        }
                       
                        return c.RetornarDataSet(comando);
                    }
                }
            }
            else// SEM DATA ESPECIFICA
            {
                if (ativo == 2 && texto.Length == 0)
                {
                    if (Where != string.Empty)
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" ORDER BY " + tipo + "";
                    }
                    else
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA ORDER BY " + tipo + "";
                    }
                   

                    return c.RetornarDataSet(comando);
                }
                else if (ativo == 2 && texto.Length != 0)
                {
                    if (Where != string.Empty)
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND " + tipo + " LIKE '%" + texto + "%' ORDER BY " + tipo + "";
                    }
                    else
                    {
                        comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE " + tipo + " LIKE '%" + texto + "%' ORDER BY " + tipo + "";
                    }
                    
                    return c.RetornarDataSet(comando);
                }
                else
                {
                    if (texto.Length == 0) // texto == null || texto == ""
                    {
                        if (Where != string.Empty)
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND P.ATIVO=" + ativo + " ORDER BY " + tipo + "";
                          
                        }
                        else
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE P.ATIVO=" + ativo + " ORDER BY " + tipo + "";
                           

                        }
                        return c.RetornarDataSet(comando);
                    }
                    else
                    {
                        if (Where != string.Empty)
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA " + Where+" AND " + tipo + " LIKE '%" + texto + "%' AND P.ATIVO = " + ativo + " ORDER BY " + tipo + "";
                        }
                        else
                        {
                            comando = "SELECT DISTINCT CLI.ID_CLIENTE ,P.NOME,P.SEXO, P.DATA_NASC,P.ATIVO, CLI.CPF,CLI.EMAIL, P.DATA_CRIACAO  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_LOGIN LG ON LG.ID_PESSOA= P.ID_PESSOA WHERE " + tipo + " LIKE '%" + texto + "%' AND P.ATIVO = " + ativo + " ORDER BY " + tipo + "";
                        }
                       
                        return c.RetornarDataSet(comando);
                    }
                }
            }
               
        }

        public DataSet ListarHistorico()
        {
            DAO.ClasseConexao c = new DAO.ClasseConexao();
            string comando = string.Empty;

            comando = "SELECT TB_VENDA_INGRESSO.DATAVENDA,TB_VENDA_INGRESSO.SITUACAO,EV.DATA_EVENTO,CONCAT(CONCAT( SUBSTR(EV.HORARIO_INICIO,10,5),' até '),SUBSTR(EV.HORARIO_FINAL,10,5)) as HORARIO,EV.TITULO, CONCAT(CONCAT(AST.ASSENTO_FILEIRA,' ') , AST.ASSENTO_NUMER) as ASSENTO,EV.ID_EVENTO,TB_VENDA_INGRESSO.ID_VENDA  FROM TCCSHOW.TB_PESSOA P INNER JOIN TB_CLIENTE CLI ON CLI.ID_PESSOA= P.ID_PESSOA INNER JOIN TB_VENDA_INGRESSO ON TB_VENDA_INGRESSO.ID_CLIENTE= CLI.ID_CLIENTE INNER JOIN TB_ITEM_VENDA ITV ON ITV.ID_VENDA= TB_VENDA_INGRESSO.ID_VENDA INNER JOIN TB_EVENTO_INGRESSO ON TB_EVENTO_INGRESSO.ID_EI = ITV.ID_EI INNER JOIN TB_EVENTO EV ON EV.ID_EVENTO = TB_EVENTO_INGRESSO.ID_EVENTO INNER JOIN TB_ASSENTO AST ON AST.ID_ASSENTO= ITV.ID_ASSENTO WHERE CLI.ID_CLIENTE= " + _ID_CLIENTE+ "  AND TO_DATE(SUBSTR(TB_VENDA_INGRESSO.DATAVENDA,0,9), 'dd/mm/yy') BETWEEN  TO_DATE('" + _DataListarInicio.ToString().Substring(0, 10) + "', ' dd/mm/yy') AND  TO_DATE('" + _DataListarFinal.ToString().Substring(0, 10) + "', ' dd/mm/yy') ORDER BY TB_VENDA_INGRESSO.ID_VENDA";
            return c.RetornarDataSet(comando);

        }
        public void Cliente_crud(char opr)
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "SP_CLIENTE";
                List<OracleParameter> p = new List<OracleParameter>();
                p.Add(new OracleParameter("vID_CLIENTE", Oracle.DataAccess.Client.OracleDbType.Int32) { Value = _ID_CLIENTE });
                p.Add(new OracleParameter("vCPF", Oracle.DataAccess.Client.OracleDbType.Varchar2) { Value = _CPF });             
                p.Add(new OracleParameter("vID_PESSOA", Oracle.DataAccess.Client.OracleDbType.Int32) { Value = _ID_PESSOA });
                p.Add(new OracleParameter("vEMAIL", Oracle.DataAccess.Client.OracleDbType.Varchar2) { Value = _Email });
                p.Add(new OracleParameter("vOPR", Oracle.DataAccess.Client.OracleDbType.Char) { Value = opr });
                c.ExecutarStoredProcedureParametro(SQL, p.ToArray());
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public OracleDataReader ConsultarCPF()
        {
            try
            {
                DAO.ClasseConexao c = new DAO.ClasseConexao();
                SQL = "  SELECT CLI.ID_CLIENTE,CLI.CPF FROM TB_CLIENTE CLI WHERE CLI.CPF= '" + _CPF + "' ";
                return c.RetornarDataReader(SQL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /////////////////////////////
    }
}
