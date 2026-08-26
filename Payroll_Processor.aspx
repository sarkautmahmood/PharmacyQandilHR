<%@ Page Title="بەڕێوەبردنی مووچە" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Payroll_Processor.aspx.cs" Inherits="Payroll_ProcessorPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    بەڕێوەبردنی مووچە و شایستە داراییەکان (Payroll & Financials)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Label ID="lblAlertMsg" runat="server" />
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Filter by Month and Year -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-filter"></i> هەڵبژاردنی مانگ و ساڵی مووچە</span>
        </div>

        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label">ساڵ</label>
                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select">
                    <asp:ListItem Value="2026" Text="2026" Selected="True" />
                    <asp:ListItem Value="2025" Text="2025" />
                </asp:DropDownList>
            </div>

            <div class="col-md-4">
                <label class="form-label">مانگ</label>
                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-select">
                    <asp:ListItem Value="1" Text="کانوونی دووەم (1)" />
                    <asp:ListItem Value="2" Text="شوبات (2)" />
                    <asp:ListItem Value="3" Text="ئازار (3)" />
                    <asp:ListItem Value="4" Text="نیسان (4)" />
                    <asp:ListItem Value="5" Text="ئایار (5)" />
                    <asp:ListItem Value="6" Text="حوزەیران (6)" />
                    <asp:ListItem Value="7" Text="تەممووز (7)" Selected="True" />
                    <asp:ListItem Value="8" Text="ئاب (8)" />
                    <asp:ListItem Value="9" Text="ئەیلوول (9)" />
                    <asp:ListItem Value="10" Text="تشرینی یەکەم (10)" />
                    <asp:ListItem Value="11" Text="تشرینی دووەم (11)" />
                    <asp:ListItem Value="12" Text="کانوونی یەکەم (12)" />
                </asp:DropDownList>
            </div>

            <div class="col-md-4">
                <asp:Button ID="btnLoadPayroll" runat="server" Text="پیشاندانی لیستی مووچە" CssClass="btn btn-pharmacy w-100" OnClick="btnLoadPayroll_Click" />
            </div>
        </div>
    </div>

    <!-- Payroll Table Grid -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-money-check-dollar"></i> خشتەی مووچەی مانگانەی دەرمانسازان و کارمەندان</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvPayroll" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" EmptyDataText="هیچ مووچەیەک بۆ ئەم مانگە تۆمار نەکراوە.">
                <Columns>
                    <asp:BoundField DataField="FullName" HeaderText="ناوی کارمەند" />
                    <asp:BoundField DataField="Places_Name" HeaderText="دەرمانخانە" />
                    
                    <asp:TemplateField HeaderText="مووچەی بنەڕەتی">
                        <ItemTemplate>
                            <span class="fw-bold"><%# string.Format("{0:N0}", Eval("BaseSalary")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="TotalDaysPresent" HeaderText="ڕۆژانی ئامادەبوون" />

                    <asp:TemplateField HeaderText="پاداشت">
                        <ItemTemplate>
                            <span class="text-success fw-bold">+ <%# string.Format("{0:N0}", Eval("RewardAmount")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="بڕین / سزا">
                        <ItemTemplate>
                            <span class="text-danger fw-bold">- <%# string.Format("{0:N0}", Eval("DeductionAmount")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="کۆی گشتی مووچە (Net Salary)">
                        <ItemTemplate>
                            <span class="badge bg-success fs-6 py-2 px-3"><%# string.Format("{0:N0}", Eval("NetSalary")) %> دینار</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="دۆخی پێدان">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("IsPaid")) == 1 
                                ? "<span class='badge bg-success'><i class='fa-solid fa-circle-check'></i> دراوە</span>" 
                                : "<span class='badge bg-warning text-dark'><i class='fa-solid fa-clock'></i> نەدراوە</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
