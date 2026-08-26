<%@ Page Title="چاودێری دەوام و سێڵفی" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Attendance_Monitor.aspx.cs" Inherits="Attendance_MonitorPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    چاودێری ڕاستەوخۆی دەوام و وێنەی سێڵفی (Attendance & Selfie Monitor)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-filter"></i> فلتەری دەوام</span>
        </div>

        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label">بەرواری دەوام</label>
                <asp:TextBox ID="txtFilterDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>

            <div class="col-md-3">
                <label class="form-label">لقی دەرمانخانە</label>
                <asp:DropDownList ID="ddlFilterPlace" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-3">
                <label class="form-label">بارودۆخی دەوام</label>
                <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select">
                    <asp:ListItem Value="0" Text="هەموو بارودۆخەکان" />
                    <asp:ListItem Value="1" Text="لە کاتی خۆیدا (On Time)" />
                    <asp:ListItem Value="2" Text="دواکەوتوو (Late)" />
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <asp:Button ID="btnSearch" runat="server" Text="گەڕان و نوێکردنەوە" CssClass="btn btn-pharmacy w-100" OnClick="btnSearch_Click" />
            </div>
        </div>
    </div>

    <!-- Attendance Grid View with Selfies & Geofence Details -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-list-check"></i> لیستی تەواوی تۆمارەکانی دەوام</span>
            <span class="badge bg-teal text-dark border"><asp:Label ID="lblRecordCount" runat="server" Text="0" /> تۆمار</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" EmptyDataText="هیچ تۆمارێکی دەوام نەدۆزرایەوە بۆ ئەم فلتەرە.">
                <Columns>
                    <asp:TemplateField HeaderText="سێڵفی ڕاستەوخۆ">
                        <ItemTemplate>
                            <a href='<%# Eval("SelfieImagePath") %>' target="_blank" title="گەورەکردنی وێنە">
                                <div class="rounded-3 overflow-hidden border border-2 border-primary shadow-sm" style="width: 50px; height: 50px;">
                                    <img src='<%# Eval("SelfieImagePath") %>' alt="Selfie" class="w-100 h-100 object-fit-cover" onerror="this.src='Uploads/AttendanceSelfies/default_avatar.jpg';" />
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="FullName" HeaderText="ناوی کارمەند" />
                    <asp:BoundField DataField="Places_Name" HeaderText="دەرمانخانە / لق" />

                    <asp:TemplateField HeaderText="جۆری دەوام">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("CheckType")) == 1 
                                ? "<span class='badge bg-success'><i class='fa-solid fa-right-to-bracket'></i> هاتن (In)</span>" 
                                : "<span class='badge bg-danger'><i class='fa-solid fa-right-from-bracket'></i> چوون (Out)</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="کاتی تۆمارکردن">
                        <ItemTemplate>
                            <span class="fw-bold"><%# Convert.ToDateTime(Eval("CheckDateTime")).ToString("yyyy/MM/dd - hh:mm tt") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="مەودا لە دەرمانخانە">
                        <ItemTemplate>
                            <span class="badge bg-light text-dark border">
                                <i class="fa-solid fa-location-dot text-teal"></i> <%# string.Format("{0:F1} مەتر", Eval("DistanceMeters")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="ناسنامەی مۆبایل (Device ID)">
                        <ItemTemplate>
                            <span class="font-monospace text-muted small"><%# Eval("DeviceUUID") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="بارودۆخ">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("Status")) == 1 
                                ? "<span class='badge-status badge-ontime'>لە کاتی خۆیدا</span>" 
                                : "<span class='badge-status badge-late'>دواکەوتوو</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Notes" HeaderText="تێبینی" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
