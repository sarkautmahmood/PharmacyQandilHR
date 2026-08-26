<%@ Page Title="بەڕێوەبردنی کارمەندان" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Employee_Manager.aspx.cs" Inherits="Employee_ManagerPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    بەڕێوەبردنی کارمەندان و ناسنامەی ئامێر (Employee & Device Manager)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Message Notification -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Label ID="lblAlertMsg" runat="server" />
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Add / Edit Employee Form (adhering to create-form skill) -->
    <div class="card-custom">
        <div class="card-title-custom">
            <i class="fa-solid fa-user-plus"></i> <asp:Literal ID="litFormTitle" runat="server" Text="تۆمارکردنی کارمەندی نوێ" />
        </div>

        <asp:HiddenField ID="hfEmpID" runat="server" Value="0" />

        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">ناوی تەواوی کارمەند / دەرمانساز <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="بۆ نموونە: د. ئاراس کەمال مەحموود" />
            </div>

            <div class="col-md-4">
                <label class="form-label">لقی دەرمانخانە <span class="text-danger">*</span></label>
                <asp:DropDownList ID="ddlPlace" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-4">
                <label class="form-label">ناونیشانی کار (Job Title)</label>
                <asp:DropDownList ID="ddlJob" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-3">
                <label class="form-label">ژمارەی مۆبایل</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="0770XXXXXXX" />
            </div>

            <div class="col-md-3">
                <label class="form-label">ئیمەیڵ</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@pharmacyqandil.com" />
            </div>

            <div class="col-md-3">
                <label class="form-label">مووچەی بنەڕەتی (دینار / دۆلار)</label>
                <asp:TextBox ID="txtBaseSalary" runat="server" TextMode="Number" CssClass="form-control" placeholder="750000" />
            </div>

            <div class="col-md-3">
                <label class="form-label">بەرواری دەستبەکاربوون</label>
                <asp:TextBox ID="txtHireDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>

            <div class="col-md-6">
                <label class="form-label">ناسنامەی مۆبایل (Locked Device UUID) <i class="fa-solid fa-lock text-warning" title="تەنها لەم ئامێرەوە دەتوانێت دەوام تۆمار بکات"></i></label>
                <asp:TextBox ID="txtDeviceUUID" runat="server" CssClass="form-control" placeholder="بۆ نموونە: DEV-IPHONE-15-002 یان بە بەتاڵی جێیبهێڵە بۆ خۆکار قوفڵبوون لە یەکەم لۆگین" />
            </div>

            <div class="col-md-6">
                <label class="form-label">تێبینی</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" placeholder="تێبینی دەربارەی کارمەند..." />
            </div>

            <div class="col-12 mt-4">
                <asp:Button ID="btnSave" runat="server" Text="پاشەکەوتکردنی زانیارییەکان" CssClass="btn btn-pharmacy btn-full-width py-2 fs-6" OnClick="btnSave_Click" />
            </div>
        </div>
    </div>

    <!-- Employees List GridView -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-users"></i> لیستی کارمەندانی دەرمانخانە</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" DataKeyNames="Emp_ID" OnRowCommand="gvEmployees_RowCommand" EmptyDataText="هیچ کارمەندێک تۆمار نەکراوە.">
                <Columns>
                    <asp:BoundField DataField="Emp_ID" HeaderText="کۆد" />
                    <asp:BoundField DataField="FullName" HeaderText="ناوی کارمەند" />
                    <asp:BoundField DataField="Places_Name" HeaderText="دەرمانخانە" />
                    <asp:BoundField DataField="JobTitle" HeaderText="ناونیشانی کار" NullDisplayText="دیاری نەکراوە" />
                    <asp:BoundField DataField="Phone" HeaderText="مۆبایل" />
                    
                    <asp:TemplateField HeaderText="مووچەی بنەڕەتی">
                        <ItemTemplate>
                            <span class="fw-bold text-success"><%# string.Format("{0:N0}", Eval("BaseSalary")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="ئامێری مۆبایل">
                        <ItemTemplate>
                            <%# !string.IsNullOrEmpty(Eval("DeviceUUID").ToString()) 
                                ? "<span class='badge bg-success'><i class='fa-solid fa-mobile-screen-button'></i> بەستراوە</span>" 
                                : "<span class='badge bg-secondary'>بەستنەوە چاوەڕوانە</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="کردارەکان">
                        <ItemTemplate>
                            <div class="d-flex gap-2">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditEmp" CommandArgument='<%# Eval("Emp_ID") %>' CssClass="btn btn-sm btn-outline-primary">
                                    <i class="fa-solid fa-pen-to-square"></i> دەستکاری
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteEmp" CommandArgument='<%# Eval("Emp_ID") %>' CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('دڵنیایت لە سڕینەوەی ئەم کارمەندە؟');">
                                    <i class="fa-solid fa-trash-can"></i> سڕینەوە
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
