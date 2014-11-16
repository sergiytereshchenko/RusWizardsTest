<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RusWizardsTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee table</title>
<%--    <link rel="stylesheet" href="CSS\default.css" />--%>

    <!-- jQuery -->
    <script type="text/javascript" src="Scripts/jquery-2.1.1.js"></script>
    
    <!-- Google charts -->
    <script src="http://www.google.com/jsapi" type="text/javascript"></script>
    

    <!-- BootStrap -->
    <link rel="stylesheet" href="Content/bootstrap.min.css"/>
    <link rel="stylesheet" href="Content/bootstrap-theme.min.css"/>
    <script src="Scripts/bootstrap.min.js"></script>
    

    <script type="text/javascript">
        // Global variable to hold data
        google.load('visualization', '1', { packages: ['corechart'] });
    </script>
    
    <script type="text/javascript">
        $(function() {
            reloadgooglechart();
        });


        function reloadgooglechart() {
            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                url: 'Default.aspx/GetChartData',
                data: '{}',
                success:
                    function (response) {
                        drawchart(response.d);
                    },

                error: function () {
                }
            });
        }

            function drawchart(dataValues) {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Column Name');
                data.addColumn('number', 'Column Value');

                var options = {
                    title: '',
                    is3D: true,
                };

                for (var i = 0; i < dataValues.length; i++) {
                    
                    data.addRow([dataValues[i].EmployeeName, dataValues[i].Salary]);
                }
                new google.visualization.PieChart(document.getElementById('chartdiv')).draw(data, options);
            }
    </script>

    <script type="text/javascript">

        $(document).ready(function () {

            calculateTotal();

            //Employee delete
            $("a[id*='btnDelete']").click(function () {
                var customID = $(this).attr('myCustomID');
                var elem = $("a[myCustomID='" + customID + "']").parent().parent();

                var btnDelete = $("a[myCustomID='" + customID + "']").eq(1);
                var curText = btnDelete.text();
                
                if (curText == "Delete") {

                    if (confirm("The employee will be deleted. Continue?") == true)
                    {

                    }
                    else
                    {
                        return false;
                    }

                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        url: "Default.aspx/DelEmployee",
                        data: "{'employeeId':'" + customID + "'}",
                        success: function (result) {

                            calculateTotal();
                            reloadgooglechart();

                        },
                        error: function (xhr, textStatus, error) {
                            alert(error);
                        }
                    });

                    elem.remove();
                }

                if (curText=="Cancel") {
                    removeEditElements(false);
                }

                return false;
            });

            //Add new employee
            $("#ButtonAddNewEmployee").click(function () {
                var tdFNValue = $("#txtBoxFirstName").val();
                var tdLNValue = $("#txtBoxLastName").val();
                var tdPosValue = $("#txtBoxPosition").val();
                var tdSalValue = $("#txtBoxSalary").val();

                var errorValidationText = "You should fill: ";
                var isValidationError = false;

                if (tdFNValue == "") {
                    if (isValidationError) {
                        errorValidationText = errorValidationText + ", ";
                    }
                    isValidationError = true;
                    errorValidationText = errorValidationText + "First Name";
                }
                if (tdLNValue == "") {
                    if (isValidationError) {
                        errorValidationText = errorValidationText + ", ";
                    }
                    isValidationError = true;
                    errorValidationText = errorValidationText + "Last Name";
                }
                if (tdPosValue == "") {
                    if (isValidationError) {
                        errorValidationText = errorValidationText + ", ";
                    }
                    isValidationError = true;
                    errorValidationText = errorValidationText + "Position";
                }
                if (tdSalValue == "") {
                    if (isValidationError) {
                        errorValidationText = errorValidationText + ", ";
                    }
                    isValidationError = true;
                    errorValidationText = errorValidationText + "Salary";
                }

                if (!isValidationError) {
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        url: "Default.aspx/InsEmployee",
                        data: "{'FirstName':'" + tdFNValue + "', 'LastName':'" + tdLNValue + "', 'Position':'" + tdPosValue + "', 'Salary':'" + tdSalValue.replace(",", ".") + "'}",
                        success: function (result) {

                            location.reload();
                        },
                        error: function (xhr, textStatus, error) {
                            alert(error);
                        }
                    });
                } else {
                    alert(errorValidationText);
                }


                return false;
            });

            //Edit employee
            $("a[id*='btnEdit']").click(function () {
                var customID = $(this).attr('myCustomID');

                var elem = $("a[myCustomID='" + customID + "']").parent().parent();

                var btnEdit = $("a[myCustomID='" + customID + "']").eq(0);

                var curText = btnEdit.text();
               
                if (curText == "Edit") {
                    removeEditElements(false);

                    btnEdit.text("Update");
                    btnEdit.removeClass("btn btn-warning");
                    btnEdit.addClass("btn btn-primary");

                    var btnDelete = elem.find("a:contains(\"Delete\")");
                    btnDelete.text("Cancel");
                    btnDelete.removeClass("btn btn-danger");
                    btnDelete.addClass("btn btn-success");


                    elem.attr("id", "RowUnderEdit");

                    var tdFN = elem.children(["#txtFN"]).eq(1);
                    var tdFNValue = tdFN.text();
                    tdFN.text("");
                    $("<input name='txtFNInput' type='text' id='txtFNInput'>").appendTo(tdFN);
                    $("#txtFNInput").val(tdFNValue);
                    var tdFNOldValueHiddenElement = $("<span id='txtFNOld'>" + tdFNValue + "</span>");
                    tdFNOldValueHiddenElement.hide();
                    tdFNOldValueHiddenElement.appendTo(tdFN);

                    var tdLN = elem.children(["#txtLN"]).eq(2);
                    var tdLNValue = tdLN.text();
                    tdLN.text("");
                    $("<input name='txtLNInput' type='text' id='txtLNInput'>").appendTo(tdLN);
                    $("#txtLNInput").val(tdLNValue);
                    var tdLNOldValueHiddenElement = $("<span id='txtLNOld'>" + tdLNValue + "</span>");
                    tdLNOldValueHiddenElement.hide();
                    tdLNOldValueHiddenElement.appendTo(tdLN);

                    var tdPos = elem.children(["#txtPos"]).eq(3);
                    var tdPosValue = tdPos.text();
                    tdPos.text("");
                    $("<input name='txtPosInput' type='text' id='txtPosInput'>").appendTo(tdPos);
                    $("#txtPosInput").val(tdPosValue);
                    var tdPosOldValueHiddenElement = $("<span id='txtPosOld'>" + tdPosValue + "</span>");
                    tdPosOldValueHiddenElement.hide();
                    tdPosOldValueHiddenElement.appendTo(tdPos);

                    var tdSal = elem.children(["#txtSal"]).eq(4);
                    var tdSalValue = tdSal.text();
                    tdSal.text("");
                    $("<input name='txtSalInput' type='text' id='txtSalInput'>").appendTo(tdSal);
                    $("#txtSalInput").val(tdSalValue);
                    var tdSalOldValueHiddenElement = $("<span id='txtSalOld'>" + tdSalValue + "</span>");
                    tdSalOldValueHiddenElement.hide();
                    tdSalOldValueHiddenElement.appendTo(tdSal);
                }
                else
                {
                    if (curText == "Update") {

                        var tdId = elem.children(["#txtID"]).eq(0).text();
                        var tdFNValue = $("#txtFNInput").val();
                        var tdLNValue = $("#txtLNInput").val();
                        var tdPosValue = $("#txtPosInput").val();
                        var tdSalValue = $("#txtSalInput").val();

                        var errorValidationText = "You should fill: ";
                        var isValidationError = false;

                        if (tdFNValue == "") {
                            if (isValidationError) {
                                errorValidationText = errorValidationText + ", ";
                            }
                            isValidationError = true;
                            errorValidationText = errorValidationText + "First Name";
                        }
                        if (tdLNValue == "") {
                            if (isValidationError) {
                                errorValidationText = errorValidationText + ", ";
                            }
                            isValidationError = true;
                            errorValidationText = errorValidationText + "Last Name";
                        }
                        if (tdPosValue == "") {
                            if (isValidationError) {
                                errorValidationText = errorValidationText + ", ";
                            }
                            isValidationError = true;
                            errorValidationText = errorValidationText + "Position";
                        }
                        if (tdSalValue == "") {
                            if (isValidationError) {
                                errorValidationText = errorValidationText + ", ";
                            }
                            isValidationError = true;
                            errorValidationText = errorValidationText + "Salary";
                        }

                        if (!isValidationError) {
                            $.ajax({
                                type: "POST",
                                dataType: "json",
                                contentType: "application/json; charset=utf-8",
                                url: "Default.aspx/UpdEmployee",
                                data: "{'Id':'" + tdId + "', 'FirstName':'" + tdFNValue + "', 'LastName':'" + tdLNValue + "', 'Position':'" + tdPosValue + "', 'Salary':'" + tdSalValue.replace(",", ".") + "'}",
                                success: function (result) {

                                    removeEditElements(true);
                                    calculateTotal();
                                    reloadgooglechart();

                                },
                                error: function (xhr, textStatus, error) {

                                    removeEditElements(false);
                                }
                            });
                        } else {
                            alert(errorValidationText);
                        }
                    }
                }
                return false;
            });

        });

        function removeEditElements(succes) {

            var elem = $("#RowUnderEdit");
            
            if (elem!=null) {
                if (succes) {

                    elem.children(["#txtFN"]).eq(1).text($("#txtFNInput").val());
                    elem.children(["#txtLN"]).eq(2).text($("#txtLNInput").val());
                    elem.children(["#txtPos"]).eq(3).text($("#txtPosInput").val());
                    elem.children(["#txtSal"]).eq(4).text($("#txtSalInput").val());

                } else {

                    elem.children(["#txtFN"]).eq(1).text($("#txtFNOld").text());
                    elem.children(["#txtLN"]).eq(2).text($("#txtLNOld").text());
                    elem.children(["#txtPos"]).eq(3).text($("#txtPosOld").text());
                    elem.children(["#txtSal"]).eq(4).text($("#txtSalOld").text());
                }

                $("#txtFNInput").remove();
                $("#txtFNOld").remove();

                $("#txtLNInput").remove();
                $("#txtLNOld").remove();

                $("#txtPosInput").remove();
                $("#txtPosOld").remove();

                $("#txtSalInput").remove();
                $("#txtSalOld").remove();

                var btnUpdate = $("a:contains(\"Update\")");
                btnUpdate.removeClass("btn btn-primary");
                btnUpdate.addClass("btn btn-warning");
                btnUpdate.text("Edit");

                var btnCancel = $("a:contains(\"Cancel\")");
                btnCancel.removeClass("btn btn-success");
                btnCancel.addClass("btn btn-danger");
                btnCancel.text("Delete");

                elem.attr("id", null);
            }

            return false;
        }

        function calculateTotal() {

            var total = 0;

            $('#tblMain > tbody  > tr').each(function(i, row) {
                var $row = $(row);
                var $curSal = $row.find("#lblTotal").text();
                if ($curSal == "") {
                    $curSal = $row.find("#txtSal").text().replace(",", ".");

                    var curSalNum = parseFloat($curSal);

                    if (!isNaN(curSalNum)) {
                        total = total + curSalNum;
                    }
                }
            });

            $('#txtTotal').text(total.toFixed(4));

            return false;
        }
    </script>

</head>
<body>

    <form id="form1" runat="server">
    <div>
        <h3 class="bg-primary">Employees report</h3>

        <asp:Repeater ID="Repeater" runat="server" DataSourceID="SqlDataSource">
            <HeaderTemplate>
                <table id="tblMain" class="table table-striped">
                    <tr>
                        <th class="col-md-1">EmployeeID</th>
                        <th class="col-md-2">FirstName</th>
                        <th class="col-md-2">LastName</th>
                        <th class="col-md-2">Position</th>
                        <th class="col-md-2">Salary</th>
                        <th class="col-md-1"></th>
                        <th class="col-md-1"></th>
                    </tr>
            </HeaderTemplate>

            <ItemTemplate>
                <tr>
                    <td id="txtID"><%# Eval("EmployeeID") %></td>
                    <td id="txtFN"><%# Eval("FirstName") %></td>
                    <td id="txtLN"><%# Eval("LastName") %></td>
                    <td id="txtPos"><%# Eval("Position") %></td>
                    <td id="txtSal"><%# Eval("Salary") %></td>
                    <td><asp:LinkButton id="btnEdit" myCustomID='<%# Eval("EmployeeID")%>' CssClass="btn btn-warning" runat="server" Text="Edit" /></td>
                    <td><asp:LinkButton id="btnDelete" myCustomID='<%# Eval("EmployeeID")%>' CssClass="btn btn-danger" runat="server" Text="Delete" /></td>
                </tr>
            </ItemTemplate>

            <FooterTemplate>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td id="lblTotal">Total:</td>
                        <td id="txtTotal"></td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:RusWizardsTestConnectionString %>" SelectCommand="spGetEmployee"></asp:SqlDataSource>
    
    </div>
        
    <div>

        <h3 class="bg-success">Add a new employee</h3>
        
        <table id="tblAddNew" class="table table-striped">
            <tr>
                <th class="col-md-2">First name</th>
                <th class="col-md-2">Last name</th>
                <th class="col-md-2">Position</th>
                <th class="col-md-2">Salary</th>
                <th class="col-md-1"></th>
            </tr>
            <tr>
                <td><asp:TextBox ID="txtBoxFirstName" runat="server"></asp:TextBox></td>
                <td><asp:TextBox ID="txtBoxLastName" runat="server"></asp:TextBox></td>
                <td><asp:TextBox ID="txtBoxPosition" runat="server"></asp:TextBox></td>
                <td><asp:TextBox ID="txtBoxSalary" runat="server"></asp:TextBox></td>
                <td><asp:Button ID="ButtonAddNewEmployee" runat="server" CssClass="btn btn-success" Text="Add" OnClientClick="return false;" /></td>
            </tr>
        </table>

    </div>    
        
    <h3 class="bg-info">Salary distribution</h3>        

    <div id="chartdiv" style="width: 600px; height: 350px;"></div>
        
    </form>
</body>
</html>
