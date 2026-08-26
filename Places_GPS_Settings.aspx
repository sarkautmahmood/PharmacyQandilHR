<%@ Page Title="ڕێکخستنی شوێنی دەرمانخانەکان" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Places_GPS_Settings.aspx.cs" Inherits="Places_GPS_SettingsPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    ڕێکخستنی شوێنی لقەکانی دەرمانخانە و GPS Geofencing
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Label ID="lblAlertMsg" runat="server" />
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Branch GPS Setup Form -->
    <div class="card-custom">
        <div class="card-title-custom">
            <i class="fa-solid fa-map-location-dot"></i> <asp:Literal ID="litFormTitle" runat="server" Text="دیاریکردنی لۆکەیشنی دەرمانخانە" />
        </div>

        <asp:HiddenField ID="hfPlacesGpsID" runat="server" Value="0" />

        <div class="row g-3">
            <div class="col-md-3">
                <label class="form-label">ناوی لقی دەرمانخانە <span class="text-danger">*</span></label>
                <asp:DropDownList ID="ddlPlaces" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-3">
                <label class="form-label">هێڵی پانی (Latitude) <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtLatitude" runat="server" CssClass="form-control" placeholder="35.565800" />
            </div>

            <div class="col-md-3">
                <label class="form-label">هێڵی درێژی (Longitude) <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtLongitude" runat="server" CssClass="form-control" placeholder="45.421500" />
            </div>

            <div class="col-md-3">
                <label class="form-label">مەودای ڕێگەپێدراو (بە مەتر) <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtRadius" runat="server" TextMode="Number" CssClass="form-control" placeholder="50" Text="50" />
            </div>

            <div class="col-12">
                <label class="form-label">تێبینی</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" placeholder="ناونیشانی دەرمانخانە و تێبینی..." />
            </div>

            <div class="col-12 mt-3">
                <asp:Button ID="btnSaveGps" runat="server" Text="پاشەکەوتکردنی شوێنی دەرمانخانە" CssClass="btn btn-pharmacy btn-full-width py-2" OnClick="btnSaveGps_Click" />
            </div>
        </div>
    </div>

    <!-- Active Branches GPS Grid -->
    <div class="card-custom">
        <div class="card-title-custom justify-content-between">
            <span><i class="fa-solid fa-location-crosshairs"></i> لقە تۆمارکراوەکان لەسەر نەخشە</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvPlacesGps" runat="server" AutoGenerateColumns="false" CssClass="table-custom" GridLines="None" DataKeyNames="Places_GPS_ID" OnRowCommand="gvPlacesGps_RowCommand" EmptyDataText="هیچ لقێک تۆمار نەکراوە.">
                <Columns>
                    <asp:BoundField DataField="Places_Name" HeaderText="دەرمانخانە / لق" />
                    
                    <asp:TemplateField HeaderText="پۆوتانەکانی GPS">
                        <ItemTemplate>
                            <span class="badge bg-light text-dark border font-monospace">
                                Lat: <%# Eval("Latitude") %> | Lng: <%# Eval("Longitude") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="بازنەی ڕێگەپێدراو">
                        <ItemTemplate>
                            <span class="badge bg-teal text-dark"><%# Eval("AllowedRadiusMeters") %> مەتر</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Notes" HeaderText="تێبینی" />

                    <asp:TemplateField HeaderText="کردار">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditGps" CommandArgument='<%# Eval("Places_GPS_ID") %>' CssClass="btn btn-sm btn-outline-primary">
                                <i class="fa-solid fa-pen-to-square"></i> دەستکاری
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
