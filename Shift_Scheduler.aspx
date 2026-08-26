<%@ Page Title="خشتەی شیفتەکان" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Shift_Scheduler.aspx.cs" Inherits="Shift_SchedulerPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    خشتەی شیفتەکان و دابەشکردنی دەوام (Shift Scheduler)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Label ID="lblAlertMsg" runat="server" />
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="row g-4">
        <!-- Assign Shift Form -->
        <div class="col-lg-5">
            <div class="card-custom">
                <div class="card-title-custom">
                    <i class="fa-solid fa-calendar-plus"></i> دیاریکردنی شیفتی کارمەند
                </div>

                <div class="mb-3">
                    <label class="form-label">کارمەند / دەرمانساز <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlEmp" runat="server" CssClass="form-select" />
                </div>

                <div class="mb-3">
                    <label class="form-label">جۆری شیفت <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlShift" runat="server" CssClass="form-select" />
                </div>

                <div class="mb-3">
                    <label class="form-label">بەرواری دەوام <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtShiftDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">لقی دەرمانخانە <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlShiftPlace" runat="server" CssClass="form-select" />
                </div>

                <asp:Button ID="btnAssignShift" runat="server" Text="تۆمارکردنی شیفت" CssClass="btn btn-pharmacy btn-full-width mt-3" OnClick="btnAssignShift_Click" />
            </div>

            <!-- Shift Types Reference Card -->
            <div class="card-custom">
                <div class="card-title-custom">
                    <i class="fa-solid fa-business-time"></i> شیفتە پێناسەکراوەکان
                </div>
                <asp:Repeater ID="rptShiftTypes" runat="server">
                    <ItemTemplate>
                        <div class="d-flex justify-content-between align-items-center p-2 mb-2 bg-light rounded border">
                            <div>
                                <strong class="text-dark"><%# Eval("ShiftName") %></strong>
                                <small class="d-block text-muted">مۆڵەتی دواکەوتن: <%# Eval("LateGraceMinutes") %> خولەک</small>
                            </div>
                            <span class="badge bg-teal text-white"><%# Eval("StartTime") %> - <%# Eval("EndTime") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Employee Shifts Schedule Grid -->
        <div class="col-lg-7">
            <div class="card-custom">
                <div class="card-title-custom justify-content-between">
                    <span><i class="fa-solid fa-table-list"></i> خشتەی دەوامی کارمەندان</span>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvEmployeeShifts" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" DataKeyNames="EmpShift_ID" OnRowCommand="gvEmployeeShifts_RowCommand" EmptyDataText="هیچ شیفتێک دیاری نەکراوە.">
                        <Columns>
                            <asp:BoundField DataField="ShiftDate" HeaderText="بەروار" DataFormatString="{0:yyyy/MM/dd}" />
                            <asp:BoundField DataField="FullName" HeaderText="کارمەند" />
                            <asp:BoundField DataField="Places_Name" HeaderText="دەرمانخانە" />
                            
                            <asp:TemplateField HeaderText="شیفت">
                                <ItemTemplate>
                                    <span class="badge bg-primary"><%# Eval("ShiftName") %></span>
                                    <small class="d-block text-muted"><%# Eval("StartTime") %> - <%# Eval("EndTime") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="کردار">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDelShift" runat="server" CommandName="DeleteShift" CommandArgument='<%# Eval("EmpShift_ID") %>' CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('دڵنیایت لە لابردنی ئەم شیفتە؟');">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
