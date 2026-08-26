<%@ Page Title="مۆبایل ئەپ - تاقیکردنەوەی ڕاستەوخۆ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Mobile_Simulator.aspx.cs" Inherits="Mobile_SimulatorPage" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitleContent" runat="server">
    تاقیکردنەوەی ڕاستەوخۆی مۆبایل ئەپ (Live Mobile App Simulator)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .mobile-device-frame {
            width: 380px;
            height: 740px;
            background: #0f172a;
            border-radius: 44px;
            padding: 12px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35), 0 0 0 1px rgba(255, 255, 255, 0.1);
            margin: 0 auto;
            position: relative;
        }

        .mobile-device-screen {
            width: 100%;
            height: 100%;
            background: #f8fafc;
            border-radius: 34px;
            overflow-y: auto;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .mobile-notch {
            width: 140px;
            height: 22px;
            background: #0f172a;
            border-radius: 0 0 14px 14px;
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: 100;
        }

        .mobile-header {
            background: linear-gradient(180deg, #134e4a 0%, #0f766e 100%);
            color: #ffffff;
            padding: 34px 18px 18px;
            border-radius: 34px 34px 20px 20px;
        }

        .camera-circle-preview {
            width: 220px;
            height: 220px;
            border-radius: 50%;
            border: 4px solid #14b8a6;
            overflow: hidden;
            margin: 0 auto;
            position: relative;
            background: #000;
        }

        .camera-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transform: scaleX(-1);
        }

        .btn-check-in-big {
            background: linear-gradient(135deg, #0d9488, #0f766e);
            color: #ffffff;
            border-radius: 16px;
            padding: 14px;
            font-weight: 800;
            border: none;
            box-shadow: 0 4px 12px rgba(13, 148, 136, 0.3);
            transition: all 0.2s ease;
        }

        .btn-check-in-big:hover {
            transform: scale(1.02);
            color: #fff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-4">
        <!-- Simulator Frame -->
        <div class="col-lg-6">
            <div class="card-custom text-center">
                <div class="card-title-custom justify-content-between">
                    <span><i class="fa-solid fa-mobile-screen"></i> پیشاندەری مۆبایل ئەپی دەرمانخانە</span>
                    <span class="badge bg-success">Online & Connected</span>
                </div>

                <div class="mobile-device-frame">
                    <div class="mobile-notch"></div>
                    <div class="mobile-device-screen">
                        <!-- Mobile Header -->
                        <div class="mobile-header text-end">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-teal text-white">HR Mobile v1.0</span>
                                <small class="text-light" id="mobileTime">12:00 PM</small>
                            </div>
                            <h5 class="fw-bold mb-0 text-white" id="empNameDisplay">د. ئاراس کەمال</h5>
                            <small class="text-light opacity-75" id="branchDisplay">دەرمانخانەی قەندیل - لقی سەرەکی</small>
                        </div>

                        <!-- Mobile Body Content -->
                        <div class="p-3 text-start" dir="rtl">
                            <!-- GPS Status Widget -->
                            <div class="p-2 mb-3 bg-light rounded-3 border d-flex align-items-center gap-2">
                                <div class="p-2 bg-success-subtle text-success rounded-circle">
                                    <i class="fa-solid fa-location-dot"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <strong class="d-block text-dark small" id="gpsStatusText">لۆکەیشن دیاریکرا</strong>
                                    <small class="text-muted" id="gpsDistanceText">مەودا: 3.8 مەتر لە دەرمانخانە</small>
                                </div>
                                <span class="badge bg-success" id="geofenceBadge">لە ناو بازنەیە</span>
                            </div>

                            <!-- Live Camera Box -->
                            <div class="text-center my-2">
                                <div class="camera-circle-preview shadow mb-2">
                                    <video id="videoElement" class="camera-video" autoplay playsinline></video>
                                    <canvas id="canvasElement" style="display:none;"></canvas>
                                </div>
                                <small class="text-muted d-block mb-3">وێنەی سێڵفی ڕاستەوخۆ بە کامێرا</small>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-grid gap-2">
                                <button type="button" class="btn btn-check-in-big" onclick="performAttendance(1)">
                                    <i class="fa-solid fa-camera"></i> تۆماری هاتن (Check-In)
                                </button>
                                <button type="button" class="btn btn-outline-danger py-2 fw-bold" onclick="performAttendance(2)">
                                    <i class="fa-solid fa-arrow-right-from-bracket"></i> تۆماری چوون (Check-Out)
                                </button>
                            </div>

                            <!-- Result Alert Box -->
                            <div id="resultBox" class="mt-3 alert alert-success d-none" role="alert">
                                <strong id="resultMsg">دەوام تۆمارکرا</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Testing & Controls Panel -->
        <div class="col-lg-6">
            <div class="card-custom">
                <div class="card-title-custom">
                    <i class="fa-solid fa-sliders"></i> ڕێکخستنی تێست و کۆنترۆڵەکان
                </div>

                <div class="mb-3">
                    <label class="form-label">دیاریکردنی کارمەند بۆ تێست</label>
                    <asp:DropDownList ID="ddlTestEmp" runat="server" CssClass="form-select" onchange="updateEmpSelection(this)" />
                </div>

                <div class="mb-3">
                    <label class="form-label">دیاریکردنی لقی دەرمانخانە</label>
                    <asp:DropDownList ID="ddlTestPlace" runat="server" CssClass="form-select" />
                </div>

                <div class="mb-3">
                    <label class="form-label">تاقیکردنەوەی شوێنی GPS</label>
                    <div class="btn-group w-100" role="group">
                        <button type="button" class="btn btn-outline-success active" onclick="setTestGps(35.565810, 45.421510, 'لە ناو دەرمانخانە (3.8m)')">
                            لە ناو دەرمانخانە (Near)
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="setTestGps(35.580000, 45.450000, 'لە دەرەوەی دەرمانخانە (3.0km)')">
                            لە دەرەوەی دەرمانخانە (Far)
                        </button>
                    </div>
                </div>

                <hr />

                <h6><i class="fa-solid fa-code"></i> پەیوەندی بە ASMX SOAP:</h6>
                <p class="text-muted small">
                    کاتێک دوگمەی دەوام دادەگریت لە ناو سیمولەیتەرەکە، ڕاستەوخۆ داواکاری بە شێوازی SOAP XML / JSON دەڕوات بۆ خزمەتگوزاری:
                    <code>/Services/HR_AttendanceService.asmx/Check_Attendance</code>
                    و لە داتابەیسی <code>PharmacyQandilDB</code> پاشەکەوت دەبێت.
                </p>

                <div class="d-grid gap-2">
                    <a href="Attendance_Monitor.aspx" class="btn btn-outline-primary">
                        <i class="fa-solid fa-table"></i> چوون بۆ چاودێری دەوام و بینینی تۆمارەکان
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        let currentLat = 35.565810;
        let currentLng = 45.421510;
        let video = document.getElementById('videoElement');
        let canvas = document.getElementById('canvasElement');

        // Initialize WebCam
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' }, audio: false })
            .then(stream => { video.srcObject = stream; })
            .catch(err => { console.warn("Camera fallback:", err); });

        function setTestGps(lat, lng, desc) {
            currentLat = lat;
            currentLng = lng;
            document.getElementById('gpsDistanceText').innerText = 'مەودا: ' + desc;
            if (desc.includes('دەرەوە')) {
                document.getElementById('geofenceBadge').className = 'badge bg-danger';
                document.getElementById('geofenceBadge').innerText = 'لە دەرەوەیە';
            } else {
                document.getElementById('geofenceBadge').className = 'badge bg-success';
                document.getElementById('geofenceBadge').innerText = 'لە ناو بازنەیە';
            }
        }

        function updateEmpSelection(select) {
            document.getElementById('empNameDisplay').innerText = select.options[select.selectedIndex].text;
        }

        function performAttendance(checkType) {
            let empId = document.getElementById('<%= ddlTestEmp.ClientID %>').value;
            let placeId = document.getElementById('<%= ddlTestPlace.ClientID %>').value;

            // Capture image from video
            canvas.width = video.videoWidth || 320;
            canvas.height = video.videoHeight || 240;
            let ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            let selfieBase64 = canvas.toDataURL('image/jpeg', 0.7);

            let payload = {
                empID: parseInt(empId),
                placeID: parseInt(placeId),
                checkType: checkType,
                latitude: currentLat,
                longitude: currentLng,
                selfieBase64: selfieBase64,
                deviceUUID: 'DEV-SIMULATOR-001'
            };

            fetch('Services/HR_AttendanceService.asmx/Check_Attendance', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify(payload)
            })
            .then(res => res.json())
            .then(data => {
                let result = data.d || data;
                let box = document.getElementById('resultBox');
                box.classList.remove('d-none', 'alert-success', 'alert-danger');
                if (result.Success) {
                    box.classList.add('alert-success');
                    document.getElementById('resultMsg').innerText = result.Message + ' (مەودا: ' + result.DistanceInMeters + 'م)';
                } else {
                    box.classList.add('alert-danger');
                    document.getElementById('resultMsg').innerText = result.Message;
                }
            })
            .catch(err => {
                let box = document.getElementById('resultBox');
                box.classList.remove('d-none', 'alert-success');
                box.classList.add('alert-danger');
                document.getElementById('resultMsg').innerText = 'کێشەی پەیوەندی بە سێرڤەر: ' + err;
            });
        }
    </script>
</asp:Content>
