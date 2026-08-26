<%@ Page Title="داشبۆردی سەرەکی" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="DefaultPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    داشبۆردی سەرەکی و چاودێری گشتی
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Quick Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card-custom h-100 border-start border-4 border-primary">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted fw-bold d-block mb-1">کۆی کارمەندان</span>
                        <h2 class="fw-bold mb-0 text-primary"><asp:Label ID="lblTotalEmployees" runat="server" Text="0" /></h2>
                    </div>
                    <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                        <i class="fa-solid fa-users-gear fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-custom h-100 border-start border-4 border-success">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted fw-bold d-block mb-1">دەوامی ئەمڕۆ (هاتن)</span>
                        <h2 class="fw-bold mb-0 text-success"><asp:Label ID="lblTodayAttendance" runat="server" Text="0" /></h2>
                    </div>
                    <div class="p-3 bg-success-subtle text-success rounded-circle">
                        <i class="fa-solid fa-user-check fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-custom h-100 border-start border-4 border-warning">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted fw-bold d-block mb-1">مۆڵەتە چاوەڕوانکراوەکان</span>
                        <h2 class="fw-bold mb-0 text-warning"><asp:Label ID="lblPendingLeaves" runat="server" Text="0" /></h2>
                    </div>
                    <div class="p-3 bg-warning-subtle text-warning rounded-circle">
                        <i class="fa-solid fa-calendar-days fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-custom h-100 border-start border-4 border-info">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted fw-bold d-block mb-1">لقەکانی دەرمانخانە</span>
                        <h2 class="fw-bold mb-0 text-info"><asp:Label ID="lblTotalBranches" runat="server" Text="0" /></h2>
                    </div>
                    <div class="p-3 bg-info-subtle text-info rounded-circle">
                        <i class="fa-solid fa-hospital-user fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Live Attendance Stream & Today Shifts Grid -->
    <div class="row g-4">
        <!-- Live Attendance with Selfies -->
        <div class="col-lg-8">
            <div class="card-custom h-100">
                <div class="card-title-custom justify-content-between">
                    <span><i class="fa-solid fa-camera-rotate"></i> تۆماری دەوامی ئەمڕۆ لەگەڵ وێنەی سێڵفی</span>
                    <a href="Attendance_Monitor.aspx" class="btn btn-sm btn-outline-secondary">بینینی تەواوی دەوام <i class="fa-solid fa-arrow-left"></i></a>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvTodayAttendance" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" EmptyDataText="هیچ تۆمارێکی دەوام بۆ ئەمڕۆ بوونی نییە.">
                        <Columns>
                            <asp:TemplateField HeaderText="وێنەی سێڵفی">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="rounded-circle overflow-hidden border border-2 border-primary" style="width: 44px; height: 44px;">
                                            <img src='<%# Eval("SelfieImagePath") %>' alt="Selfie" class="w-100 h-100 object-fit-cover" onerror="this.src='Uploads/AttendanceSelfies/default_avatar.jpg';" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="FullName" HeaderText="ناوی دەرمانساز / کارمەند" />
                            <asp:BoundField DataField="Places_Name" HeaderText="لق" />

                            <asp:TemplateField HeaderText="جۆری دەوام">
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("CheckType")) == 1 
                                        ? "<span class='badge bg-success'><i class='fa-solid fa-arrow-right-to-bracket'></i> هاتن</span>" 
                                        : "<span class='badge bg-danger'><i class='fa-solid fa-arrow-right-from-bracket'></i> چوون</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="کاتی تۆمارکردن">
                                <ItemTemplate>
                                    <span class="text-dark fw-bold"><%# Convert.ToDateTime(Eval("CheckDateTime")).ToString("hh:mm tt") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="مەودای GPS">
                                <ItemTemplate>
                                    <span class="badge bg-light text-dark border">
                                        <i class="fa-solid fa-location-crosshairs text-teal"></i> <%# string.Format("{0:F1} مەتر", Eval("DistanceMeters")) %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="بارودۆخ">
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("Status")) == 1 
                                        ? "<span class='badge-status badge-ontime'>لە کاتی خۆیدا</span>" 
                                        : "<span class='badge-status badge-late'>دواکەوتوو</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Today Shifts & Quick Actions -->
        <div class="col-lg-4">
            <div class="card-custom mb-4">
                <div class="card-title-custom">
                    <i class="fa-solid fa-calendar-day"></i> شیفتەکانی ئەمڕۆ
                </div>
                <asp:Repeater ID="rptTodayShifts" runat="server">
                    <ItemTemplate>
                        <div class="d-flex align-items-center justify-content-between p-2 mb-2 bg-light rounded-3 border">
                            <div>
                                <span class="d-block fw-bold text-dark"><%# Eval("FullName") %></span>
                                <small class="text-muted"><i class="fa-solid fa-store text-teal"></i> <%# Eval("Places_Name") %></small>
                            </div>
                            <div class="text-end">
                                <span class="badge bg-primary"><%# Eval("ShiftName") %></span>
                                <small class="d-block text-muted mt-1"><%# Eval("StartTime") %> - <%# Eval("EndTime") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Quick Navigation & Mobile Integration Info -->
            <div class="card-custom bg-light border-2 border-teal">
                <div class="card-title-custom">
                    <i class="fa-solid fa-mobile-screen-button"></i> خزمەتگوزاری مۆبایل ئەپ (ASMX)
                </div>
                <p class="text-muted small">
                    خزمەتگوزارییەکانی وێب چالاکن بۆ ئەپڵیکەیشنی کارمەندان (Android / iOS):
                </p>
                <div class="d-grid gap-2">
                    <a href="Services/HR_AttendanceService.asmx" target="_blank" class="btn btn-sm btn-outline-teal text-start">
                        <i class="fa-solid fa-code"></i> HR_AttendanceService.asmx
                    </a>
                    <a href="Services/HR_PortalService.asmx" target="_blank" class="btn btn-sm btn-outline-teal text-start">
                        <i class="fa-solid fa-code"></i> HR_PortalService.asmx
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
