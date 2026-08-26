<%@ Page Title="داواکارییەکانی مۆڵەت" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Leave_Management.aspx.cs" Inherits="Leave_ManagementPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    داواکارییەکانی مۆڵەت و نەهاتن (Leave Management)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Label ID="lblAlertMsg" runat="server" />
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Leaves GridView -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-calendar-check"></i> لیستی داواکارییەکانی مۆڵەتی دەرمانسازان و کارمەندان</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvLeaves" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" DataKeyNames="Leave_ID" OnRowCommand="gvLeaves_RowCommand" EmptyDataText="هیچ داواکارییەکی مۆڵەت بوونی نییە.">
                <Columns>
                    <asp:BoundField DataField="Leave_ID" HeaderText="ژمارە" />
                    <asp:BoundField DataField="FullName" HeaderText="ناوی کارمەند" />
                    <asp:BoundField DataField="TypeName" HeaderText="جۆری مۆڵەت" />
                    <asp:BoundField DataField="StartDate" HeaderText="دەستپێک" DataFormatString="{0:yyyy/MM/dd}" />
                    <asp:BoundField DataField="EndDate" HeaderText="کۆتایی" DataFormatString="{0:yyyy/MM/dd}" />
                    
                    <asp:TemplateField HeaderText="ماوە">
                        <ItemTemplate>
                            <span class="badge bg-light text-dark border"><%# Eval("TotalDays") %> ڕۆژ</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Reason" HeaderText="هۆکاری مۆڵەت" NullDisplayText="هیچ" />

                    <asp:TemplateField HeaderText="دۆخی داواکاری">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("Status")) == 1 
                                ? "<span class='badge-status badge-pending'>چاوەڕوان (Pending)</span>" 
                                : Convert.ToInt32(Eval("Status")) == 2 
                                ? "<span class='badge-status badge-approved'>پەسەندکراو (Approved)</span>"
                                : "<span class='badge-status badge-rejected'>ڕەتکراوە (Rejected)</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="بڕیاری بەڕێوەبەر">
                        <ItemTemplate>
                            <div class="d-flex gap-2">
                                <asp:LinkButton ID="btnApprove" runat="server" CommandName="ApproveLeave" CommandArgument='<%# Eval("Leave_ID") %>' CssClass="btn btn-sm btn-success" Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>'>
                                    <i class="fa-solid fa-check"></i> پەسەندکردن
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnReject" runat="server" CommandName="RejectLeave" CommandArgument='<%# Eval("Leave_ID") %>' CssClass="btn btn-sm btn-danger" Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>'>
                                    <i class="fa-solid fa-xmark"></i> ڕەتکردنەوە
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
