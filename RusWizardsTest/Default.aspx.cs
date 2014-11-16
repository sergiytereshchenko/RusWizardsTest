using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RusWizardsTest
{

    public partial class Default : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public class ChartSalaryDetails
        {
            public string EmployeeName { get; set; }
            public float Salary { get; set; }
        }


         [WebMethod]
        public static List<ChartSalaryDetails> GetChartData()
        {

             List<ChartSalaryDetails> dataList = new List<ChartSalaryDetails>();

            try
            {
                

                using (RusWizardsDbContextDataContext rwdb = new RusWizardsDbContextDataContext())
                {
                    var result = rwdb.spGetEmployee();

                    foreach (var row in result)
                    {
                        ChartSalaryDetails details = new ChartSalaryDetails();
                        details.EmployeeName = String.Format("{0} {1}", row.FirstName, row.LastName);
                        details.Salary = float.Parse(row.Salary.ToString());
                        dataList.Add(details);
                    }
                }
            }
            catch (Exception)
            {
            }

        return dataList;
        
        }
        
        [WebMethod]
        public static string GetEmployee()
        {
            string Result = "";

            try
            {
                using (RusWizardsDbContextDataContext rwdb = new RusWizardsDbContextDataContext())
                {
                    var result = rwdb.spGetEmployee();

                    foreach (var row in result)
                    {
                        Result += String.Format("<p>{0} - {1}</p>", row.FirstName, row.LastName);
                    }

                }
            }
            catch (Exception)
            {
            }

            return Result;
        }

        [WebMethod]
        public static void DelEmployee(Int32 employeeId)
        {

            try
            {
                using (RusWizardsDbContextDataContext rwdb = new RusWizardsDbContextDataContext())
                {
                    rwdb.spDelEmployee(employeeId);
                }
            }
            catch (Exception)
            {
            }
        }

        [WebMethod]
        public static string InsEmployee(string FirstName, string LastName, string Position, decimal? Salary)
        {
            Int32 result = 0;

            try
            {
                using (RusWizardsDbContextDataContext rwdb = new RusWizardsDbContextDataContext())
                {
                    result = rwdb.spUpdEmployee(null, FirstName, LastName, Position, Salary);
                }
            }
            catch (Exception)
            {
            }

            return result.ToString();
        }

        [WebMethod]
        public static void UpdEmployee(int? Id, string FirstName, string LastName, string Position, decimal? Salary)
        {

            try
            {
                using (RusWizardsDbContextDataContext rwdb = new RusWizardsDbContextDataContext())
                {
                    rwdb.spUpdEmployee(Id, FirstName, LastName, Position, Salary);
                }
            }
            catch (Exception)
            {
            }
        }

    }
}