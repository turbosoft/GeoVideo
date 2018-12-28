<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<%
request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("utf-8");

String loginId = request.getParameter("loginId");
String loginType = request.getParameter("loginType");
String loginToken = request.getParameter("loginToken");

String idx = request.getParameter("idx");			//idx
String user_id = request.getParameter("user_id");	//user id
String file_url = request.getParameter("file_url");	//file url
String projectUserId = request.getParameter("projectUserId");	//project User id
String linkView = request.getParameter("link");	//project User id

String linkType = request.getParameter("linkType");	//project User id
String urlData = request.getParameter("urlData");	//url data
%>
<style type="text/css">

.menuIcon:hover{
background-color: rgb(45, 120, 197);
}

.selectExifTabTitle{
	color:blue;
	border-top: 1px solid #d1d1d1;
	border-bottom: none;
/* 	border-left: 1px solid #d1d1d1; */
	border-right: 1px solid #d1d1d1;
	font-weight: bold;
	cursor: pointer;
}

.noSlectExifTabTitle{
	color:#555555;
	background-color : #fafafa;
	border-top: none;
	border-bottom: 1px solid #ebebeb;
	border-left: none;
	border-right: 1px solid #ebebeb;
	font-weight: bold;
	cursor: pointer;
}

.selectExifTabChild{
	display:block;
	font-weight: bold;
	font-size:13px;
}

.noSelectExifTabChild{
	display:none;
}

/* 버튼 스타일 */
.smallWhiteBtn {
	border: 1px solid;
	border-color : #b3b3b3;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : white;
	color: #656565;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallBlueBtn {
	border: 1px solid;
	border-color : #297acc;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : #297acc;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallGreyBtn {
	border: 1px solid;
	border-color : #6e778a;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : #6e778a;
	color: white;
	cursor: pointer;
	text-align: center;
	height: 30px;
}

.smallWhiteActiveBtn {
	border: 1px solid;
	border-color : #b3b3b3;
	border-radius : 3px;
	font-size: 12px;
	padding: 3px 15px; 
	background-color : white;
	color: #297acc;
	cursor: pointer;
	text-align: center;
	height: 30px;
}
/* 버튼 스타일 끝 */

/* 뷰어 스타일 */

.activeControlArea {
	background-color: #1e2b41;
	height : 200px;
}

.imgMoveBtn {
	width: 35px;
	height: 110px;
	background-color: #394458;
	float: left;
	color : #9ca2ac;
	font-size: 20pt;
	font-weight: bolder;
	margin-top: 10px;
	cursor: pointer;
}

.imgMoveBtnImg {
	margin-top: 40px;
}

.imageSlideBar {
	width: 90%;
	height: 100%;
	float: left;
}

.imgMoveArea {
	width:90%; 
	height:75%; 
	display:block; 
	overflow-y:hidden;
	margin-left : 75px;
}

.rightArea {
	float: left; 
	width: 27.5%; 
	height: 100%;
	background-color: white;
	color: #333333;
}

.infoTabs {
	height: 30px;
/* 	width: 120px; */
	width: 33%;
/* 	float: left;  */
	font-size: 13px; 
	text-align: center;
}

.moveAreaBar{
	width: 1%;
	height: 100%;
	background-color: #f5f5f5;
	float: left;
	cursor: e-resize;
	border-color: #b3b3b3;
	border-width : 0px 1px 0px 1px;
	border-style: solid;
}

.titleLabel {
	float:left;
	font-size: 10pt;
	color : white;
}

.normalTextInput {
	border: #d1d1d1 1px solid;
	color : #656565;
	font-size: 9pt;
	width: 100%;
}

.tableLabel {
	color : #333333;
	font-size: 9pt;
}

.editorSideBar tr{
/* 	border-bottom: 1px solid; */
/* 	border-color: #131b2a; */
}

.editor_side_btn {
	cursor : pointer;
	margin : auto;
	margin-top: 5px;
}

.menuIcon {
	padding-top: 5px;
}

.menuIconText {
	font-size: 8pt;
	color: white;
	text-align: center;
	margin-top: 10px;
}

.btn_td {
	height: 80px;
	width: 100%;
}

.writer_btn_class {
	height: 200px;
	background-color: white;
}
</style>
<script type="text/javascript">
var loginId = '<%= loginId %>';				// 로그인 아이디
var loginType = '<%= loginType %>';			// 로그인 타입
var loginToken = '<%= loginToken %>';		// 로그인 token
var projectUserId = '<%= projectUserId %>';		//project User id
var linkView = '<%= linkView %>';			//링크로 가기

var idx = '<%= idx %>';
var user_id = '<%= user_id %>';
var request = null;		//request;
var projectBoard = 0;	//GeoCMS 연동여부		0:연동안됨, 1:연동됨
var linkType = '<%= linkType %>';			//link type
var urlData = '<%= urlData %>';			//url data
var copyUserId = '';
var copyUrlIdx = 0;

var file_url = '<%= file_url %>';
var base_url = '';
var upload_url = '';
var editUserYN  = 0;						//편집가능여부

var video_child_len = 1;
var video0 = document.getElementById("video_player0");
var video1 = document.getElementById("video_player1");
var video2 = document.getElementById("video_player2");
var video3 = document.getElementById("video_player3");
var video4 = document.getElementById("video_player4");

var projectList = null;
var nowViewList = new Array();				//현재 리스트
var projectIdx = 0;
var nowIndexType = 'GeoVideo';
var moveWidthNum = 135;						//imageWidth + margin + border
var nowSelectIdx = 0;
var dMarkerLat = 0;		//default marker latitude
var dMarkerLng = 0;		//default marker longitude
var dMapZoom = 10;		//default map zoom

$(function() {
	callRequest();
	
	if(linkType == 'CP1'){
		$('.image_exif_area_head').remove();
	}
	
	if(linkType != 'CP3'){
		$('#image_view_group').parent().remove();
		if(linkType == 'CP1'){
			$('#video_map_area').remove();
		}
	}
	
	$('#copyUrlBtn').hover(
		function() {
			$('#copyUrlView').css('display','block');
		}, function() {
			$('#copyUrlView').css('display','none');
		}
	);
	$('#copyUrlView').hover(
		function() {
			$('#copyUrlView').css('display','block');
		}, function() {
			$('#copyUrlView').css('display','none');
		}
	);
	$('.copyUrlViewLi').hover(
		function(t) {
			$(this).css('font-weight','bold');
		}, function(t) {
			$(this).css('font-weight','normal');
		}
	);
});

//GeoCMS 연결여부 확인 function
function callRequest(){
	var textUrl = 'geoSetChkBoard.do';
	httpRequest(textUrl);
	request.open("POST", "http://"+location.host + "/GeoCMS/" + textUrl, true);
	request.send();
}

//GeoCMS 연결 여부 확인
function httpRequest(textUrl){
	if(window.XMLHttpRequest){
		try{
			request = new XMLHttpRequest();
		}catch(e){
			request = null;
		}

	}else if(window.ActiveXObject){
		//* IE
		try{
			request = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			//* Old Version IE
			try{
				request = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e){
				request = null;
			}
		}
	}

	request.onreadystatechange = function(){
		if(request.readyState == 4 && request.status == 200){
			projectBoard = 1;
		}
		
		if(request.readyState == 4){
			if(projectBoard == 1){
				base_url = 'http://'+ location.host + '/GeoCMS';
				upload_url = '/GeoVideo/';
				
				getVideoBase();
				getServer("");
			}else{
				base_url = '<c:url value="/"/>';
				upload_url = '/upload/';
// 				$('body').append('<button class="video_write_button" style="position:absolute; left:10px; top:530px; width:300px; height:35px; display:block; cursor: pointer;" onclick="videoWrite();">Edit Annotaion</button>');
				$('.viewerCloseBtn').css('display','block');
// 				$('#iframeSrc').text("<iframe width='760' height='500' src='"+ videoOutUrl() +"/GeoVideo/geoVideo/video_viewer.do?file_url="+ file_url+ "' frameborder='0' allowfullscreen></iframe>");
			}
			if(linkView == 'Y'){
				$('#image_view_group').parent().remove();	
				$('#viewerColstBtn').css('display','none');
			}
		}
	}
}

//초기 설정 데이터 불러오기
function getVideoBase() {
	var Url			= baseRoot() + "cms/getbase";
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			if(data.Code == '100'){
				var result = data.Data;
				if(result != null && result.length > 0){
					dMarkerLat = result[0].latitude;
					dMarkerLng = result[0].longitude;
					dMapZoom = result[0].mapzoom;
					if(linkType != 'CP1'){
						$('#googlemap').get(0).contentWindow.setDefaultData(dMarkerLat, dMarkerLng, dMapZoom);
					}
				}
			}else{
// 				jAlert(data.Message, 'Info');
			}
		}
	});
}

//get server
function getServer(tmpFileType){
	var Url			= baseRoot() + "cms/selectServerList/";
	var param		= loginToken + "/" + loginId +"/" +"Y";
	var callBack	= "?callback=?";
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			var tmpServerId = '';
			var tmpServerPass = '';
			var tmpServerPort = '';
			
			if(data.Code == '100'){
				b_serverUrl = response[0].serverurl;
				b_serverViewPort = response[0].serverviewport;
				b_serverPath = response[0].serverpath;
				if(b_serverUrl != null && b_serverUrl != "" && b_serverUrl != undefined){
					b_serverType = "URL";
				}else{
					b_serverType = "LOCAL";
				}
				tmpServerId = response[0].serverid;
				tmpServerPass = response[0].serverpass;
				tmpServerPort = response[0].serverport;
				
			}else if(data.Code != '200'){
				b_serverPath = "upload";
				jAlert(data.Message, 'Info');
			}else{
				b_serverPath = "upload";
			}
			
			if(tmpFileType != null){
				if(tmpFileType == 'XML'){
					loadXML2(tmpServerId, tmpServerPass, tmpServerPort);
				}else if(tmpFileType == 'GPS'){
					loadGPS2(tmpServerId, tmpServerPass, tmpServerPort);
				}
			}
		}
	});
}

function videoViewerInit() {
// 	callRequest();
	getCopyUrlDecode();
// 	//XML 데이터 설정
	loadXML();
}

function changeVideo() {
	//video object init
	$('#video_player1').attr('src','');
	$('#video_player2').attr('src','');
	$('#video_player3').attr('src','');
	$('#video_player4').attr('src','');
	$('#video_main_area').find('div').remove();
	$('#video_main_area').find('img').remove();
	$('#video_main_area').find('canvas').remove();
	
	$("#object_table > tbody > tr").each( function(tIdx, tVal){
		if(tIdx > 0){
			$(this).remove();
		}
	});
	
	if(projectBoard == 1){
		if(loginToken == null || loginToken == '' || loginToken == 'null'){
			loginToken = '&nbsp';
		}
		if(loginId == null || loginId == '' || loginId == 'null'){
			loginId = '&nbsp';
		}
		var Url			= baseRoot() + "cms/getContentChild/";
		var param		= loginToken + "/" + loginId + "/" +idx;
		var callBack	= "?callback=?";

		getCopyUrl();
		
		$.ajax({
			type	: "get"
			, url	: Url + param + callBack
			, dataType	: "jsonp"
			, async	: false
			, cache	: false
			, success: function(data) {
				if(data.Code == 100){
					var response = data.Data;
					video_child_len = 1;
					if(response != null && response != ''){
						video_child_len = response.length;
						$('#video_player2').css('background','none');
						$('#video_player3').css('background','none');
						$('#video_player4').css('background','none');
						
						for(var k=0;k<response.length; k++){
							var tmpFileName = response[k].filename;
							
							if(video_child_len > 1 ){
								$('.multi_class').css('display','block');
								$('#video_player0').css('display','none');
								var video = document.getElementById('video_player'+(k+1));
								video.src = videoBaseUrl() + upload_url + tmpFileName;
								video.load();
							}else{
								$('.multi_class').css('display','none');
								$('#video_player0').css('display','block');
								var video = document.getElementById('video_player0');
								video.src = videoBaseUrl() + upload_url + tmpFileName;
								video.load();
							}
							
// 							var video = document.getElementById('video_player'+(k+1));
// 							video.src = videoBaseUrl() + upload_url + tmpFileName;
// 							video.load();
							
							if(k == 0){
								var copyUrlData = $('#copyUrlText').val();
								file_url =  response[k].filename;
// 								$('#iframeSrc').text("<iframe width='760' height='500' src='"+ videoOutUrl() +"/GeoVideo/geoVideo/video_viewer.do?file_url="+ file_url+ "&idx="+idx+"&link=Y' frameborder='0' allowfullscreen></iframe>");
								$('#iframeSrc').text("<iframe width='760' height='500' src='"+ videoOutUrl() +"/GeoVideo/geoVideo/video_url_viewer.do?urlData="+ copyUrlData +"&linkType=CP1' frameborder='0' allowfullscreen></iframe>");
								projectIdx = response[k].projectidx;
								
								if(linkType != 'CP1'){
									$('#title_text').val(response[k].title);
									$('#content_text').val(response[k].contents);
									var nowShareTypeText = response[k].sharetype == 0? "private":response[k].sharetype== 1? "public":"sharing with friends";
									$('#share_text').val(nowShareTypeText);
									if(response[k].dronetype != null && response[k].dronetype =='Y'){
										$('#drone_text').val(response[k].dronetype);
									}else{
										$('#drone_text').val('N');
									}
								}
							}
						}
						
						
						//좌표
						if(linkType != 'CP1'){
							var gpsDataStr = response[0].gpsdata;
							if(gpsDataStr != null){
								gpsDataStr = gpsDataStr.gpsData
								loadGPSForData(gpsDataStr);
							}
						}
						
						if(video_child_len > 1){
							if(video_child_len < 4){
								var tmpHtmlStr = "<div style='width:385px; height:230px;'>No video</div>";
								$('#video_player4').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player4').css('board','none');
							}
							if(video_child_len < 3){
								var tmpHtmlStr = "<div style='width:385px; height:230px;'>No video</div>";
								$('#video_player3').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player3').css('board','none');
							}
							if(video_child_len < 2){
								var tmpHtmlStr = "<div style='width:385px; height:230px;'>No video</div>";
								$('#video_player2').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player2').css('board','none');
							}
						}
						
						video0 = document.getElementById("video_player0");
						video1 = document.getElementById("video_player1");
						video2 = document.getElementById("video_player2");
						video3 = document.getElementById("video_player3");
						video4 = document.getElementById("video_player4");
						
						setTimeout(function(){
							restart('first');
						},500);
						
						//프로젝트 리스트 가져오기
						if(linkType == 'CP3'){
							addImageMoveList();
						}
					}
				}else{
					jAlert(data.Message, 'Info');
				}
			}
		});
	}else{
//	 	//GPX or KML 데이터 설정
		if(linkType != 'CP1'){
			loadGPS();
		}
	}
}

//add bottom image list
function addImageMoveList(){
	var tmpCnt = 0;
	nowViewList = new Array();
	editContentArr = new Array();
	$('#img_move_list_long').empty();
	$('#moveSelectDiv').empty();
	
	var pageNum = '&nbsp';
	var contentNum = '&nbsp';
	
	var Url			= baseRoot() + "cms/getCopyDataUrl/";
	var param		= "PROJECT/" + linkType + "/" + file_url + "/" + projectIdx;
	var callBack	= "?callback=?";
	
	$.ajax({
		  type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(response) {
			if(response.Code == 100){
				var data = response.Data;
				var tmpLeft = 0;

				if(data != null && data.length > 0){
					nowViewList = data;
					var innerHTMLStr = '';
					
					for(var i=0; i<data.length;i++){
						var localAddress = videoBaseUrl() + "/"+ data[i].datakind +"/";
						if(data[i].filename != undefined){
							var tmpFileN = data[i].filename.substring(0,data[i].filename.lastIndexOf('.'));
							tmpFileN += '_thumbnail.png';
							if(data[i].datakind == "GeoPhoto"){
								localAddress += tmpFileN;
							}else if(data[i].datakind == "GeoVideo"){
								localAddress += data[i].thumbnail;
							}
						}

						innerHTMLStr += "<a class='imageTag' id='Pro_"+ data[i].datakind +"_"+data[i].idx +"' href='javascript:;' onclick="+'"';
						var tempArr = new Array; //mapCenterChange에 넘길 객체 생성
						tempArr.push(data[i].latitude);
						tempArr.push(data[i].longitude);
						tempArr.push(data[i].filename);
						tempArr.push(data[i].idx);
						tempArr.push(data[i].datakind);
						tempArr.push(data[i].originname);
						tempArr.push(data[i].thumbnail);
						tempArr.push(data[i].id);
						tempArr.push(data[i].projectuserid);
						if(data[i].markericon != null){
							data[i].markericon = data[i].markericon.replace('_','&ubsp');
						}
						tempArr.push(data[i].markericon);
						tempArr.push(data[i].u_date);
						tempArr.push(data[i].projectidx);
						tempArr.push(data[i].dronetype);
						innerHTMLStr += "imgMapCenterChange('"+ tempArr +"');";
						innerHTMLStr += '"'+" title='제목 : "+ data[i].title +"\n내용 : "+ data[i].content +"\n작성자 : "+ data[i].id +"\n작성일 : "+ data[i].u_date +"' border='0'>";

						var tmpMarginTop = '0';
						
						//이미지 자름
						innerHTMLStr += "<div ";
						var tmpViewId = "MOVE_"+ data[i].datakind + "_" + data[i].idx;

						if((idx == data[i].idx && data[i].datakind == 'GeoVideo') || (nowIndexType == '&empty' && idx == '&empty' && i == 0 )){
							innerHTMLStr += " style='border:2px solid #00b8b0;";
						}else{
							innerHTMLStr += " style='border:2px solid #888888;";
						}

						innerHTMLStr += " background: url(\""+ localAddress +"\") no-repeat center; display: inline-block; width: 110px; height:110px; background-size: 110px 110px; margin:10px 0 10px 0;'> ";
						innerHTMLStr += "</div>";
						
						//이미지 및 동영상 아이콘
						if(data[i].datakind == 'GeoPhoto'){
							innerHTMLStr += '<div style="position:relative; width:30px; height:30px; top:-146px;left:-163px; display:inline-block;  background-image:url(../images/geoImg/GeoPhoto_marker.png); zoom:0.7;"></div>';
						}else if(data[i].datakind == 'GeoVideo'){
							innerHTMLStr += '<div style="position:relative; width:30px; height:30px; top:-146px;left:-163px; display:inline-block;  background-image:url(../images/geoImg/GeoVideo_marker.png); zoom:0.7;"></div>';
						}
						
						innerHTMLStr += "</a>";

						if((idx == data[i].idx && data[i].datakind == 'GeoVideo') || (nowIndexType == '&empty' && idx == '&empty' && i == 0 )){
							if(nowIndexType == '&empty' && idx == '&empty' && i == 0 ){
								imgMapCenterChange("'"+ tempArr + "'");
							}
							tmpLeft  = totalMoveWidth;
							tmpCnt = i;
							idx = data[i].idx;
							
							imgDataSetting(data[i]);
						}

						totalMoveWidth += moveWidthNum;
					}

					$('#img_move_list_long').css('width', moveWidthNum*data.length +"px");
					$('#img_move_list_long').append(innerHTMLStr);
					

					//9개 이상일 경우 move btn 
					if(data.length > 8){
						$('#img_move_list').css('width','1035px');
						$('#img_move_list').css('left','40px');
						$('#img_move_list').css('top','0');
						$('.imgMoveBtn').css('display','block');
						
						if(tmpCnt > 4){
							var tmpNowIdx1 = -1;
							$.each(nowViewList, function(idxv, valv){
								if(valv.idx == idx){
									tmpNowIdx1 = idxv;
								}
							});
							if(tmpNowIdx1 > 4){
								var offset = 0;
								offset = $("#Pro_" + nowViewList[tmpNowIdx1].datakind +"_"+ nowViewList[tmpNowIdx1].idx).offset();
								var tmpMoveLeft1 = offset.left - (moveWidthNum*4);
								$('#img_move_list').animate({scrollLeft : tmpMoveLeft1});
							}
						}
					}

					//좌우 move btn
					if(tmpCnt > 0){
						$('#bigImgMoveL').css('display','block');
					}

					if(tmpCnt < data.length-1){
						$('#bigImgMoveR').css('display','block');
					}
					
				}else{
					$('.edit_btn_bottom').css('display','none');
				}
			}
		}
	});
	
	return editUserYN;
}

//data setting
function imgDataSetting(obj){
	projectIdx = obj.projectidx;
	user_id = obj.id;
	projectUserId = obj.projectuserid;
	nowIndexType = obj.datakind;

	$('#image_view_group').empty();
	var tmpGroup = '';
	var tmpGroupHTML = '';
	var projectNameTxt = '';
	var proShare = '';
	if(obj.sharetype == '1'){
// 		proShare = '공개';
		proShare = 'FULL';
	}else if(obj.sharetype == '0'){
// 		proShare = '비공개';
		proShare = 'NON';
	}else{
// 		proShare = '선택공개';
		proShare = 'SELECTIVE';
	}

	tmpGroup = obj.projectname;
	projectNameTxt = tmpGroup.length>18? tmpGroup.substring(0,18)+'...' : tmpGroup;
	var tmpLeft1 = '50px';
	
	tmpGroupHTML += '<div class="view_folderClass" style="margin:4px 5px;"></div>';
	tmpGroupHTML += '<div class="m_l_15" style="float:left; margin: 12px 0 0 10px; font-size:10px; color:#00b8b0;">'+ proShare +'</div>';
	tmpLeft1 = '10px';
	tmpGroupHTML += "<div class='titleLabel' style='float:left; margin: 8px 0 0 "+ tmpLeft1 +";' title='"+ tmpGroup +"'>"+ projectNameTxt +"</div>";
	
	$('#image_view_group').append(tmpGroupHTML);
}

var editContentArr = new Array();	//이동할 컨텐츠
//img center Change
function imgMapCenterChange(tmpArr){
	var tpAr = tmpArr.split(",");
	nowSelectIdx = tpAr[3];
	var tmpKind = tpAr[4];
	var tmpId = tpAr[7];
	var tmpProjectId = tpAr[8];
	var tmpMoveIdx = 0;
	
	$.each(nowViewList, function(idx1, val1){
		if(val1.idx == nowSelectIdx && val1.datakind == tmpKind){
			tmpMoveIdx = idx1;
		}
	});
	
	if(tmpKind != null && tmpKind == 'GeoPhoto'){
		videoViewClose();
		window.parent.imageViewer(tpAr[2], tmpId, nowSelectIdx, tmpProjectId)
		return;
	}else{
		idx = nowSelectIdx;
		videoViewerInit();
		return;
	}
	
	if(tmpMoveIdx == 0){
		$('#bigImgMoveL').css('display','none');
	}else{
		$('#bigImgMoveL').css('display','block');
	}
	
	if(tmpMoveIdx == nowViewList.length-1){
		$('#bigImgMoveR').css('display','none');
	}else{
		$('#bigImgMoveR').css('display','block');
	}

	if(nowViewList.length > 8){
		var tmpMoveLeft1 = 0;
		if(tmpMoveIdx > 4){
			tmpMoveLeft1 = (moveWidthNum * (tmpMoveIdx-3));
		}
		$('#img_move_list').animate({scrollLeft : tmpMoveLeft1});
	}

	imgDataSetting(nowViewList[tmpMoveIdx]);
	file_url = nowViewList[tmpMoveIdx].filename;

// 	$('#image_main_area').empty();
	changeImageNomal();
	var moveObj = new Object();
	moveObj.longitude = tpAr[0];
	moveObj.latitude = tpAr[1];
	moveObj.filename = tpAr[2];
	moveObj.dronetype = tpAr[12];
	loadExif(moveObj);
	$('#Pro_'+ tmpKind +'_'+ idx + " DIV").css('border', '2px solid #888888');
	idx = nowViewList[tmpMoveIdx].idx;
	$('#Pro_'+ tmpKind +'_'+ idx + " DIV").css('border', '2px solid #00b8b0');
}

var moveNum = 0;
var maxMoveNum = 0;
var totalMoveWidth = 0;
//하단 이미지 리스트 이동
function moveImgList(text){
	if(nowViewList.length <= 8){
		return;
	}
	
	var tmpLeft1 = 0;
	if(text == 'l'){
		tmpLeft1 = $('#img_move_list').scrollLeft() - (moveWidthNum);
	}else{
		tmpLeft1 += $('#img_move_list').scrollLeft() + (moveWidthNum);
	}
	if(tmpLeft1 < 0){
		tmpLeft1 = 0;
	}
	$('#img_move_list').animate({scrollLeft : tmpLeft1});
	
}

function videoViewClose(){
// 	jQuery.FrameDialog.closeDialog();	//뷰어 닫기
	var iframes = window.parent.document.getElementsByTagName("IFRAME");
	for (var i = 0; i < iframes.length; i++) {
		var id = iframes[i].id || iframes[i].name || i;
		if (window.parent.frames[id] == window && jQuery.type( id ) != 'number') {
			var tmpID = id.replace("-VIEW", "");
			window.parent.jQuery("#" + tmpID).dialog('close');
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/* map_start ----------------------------------- 맵 설정 ------------------------------------- */
var gps_size;
function loadGPS() {
	getServer('GPS');
}

function loadGPS2(tmpServerId, tmpServerPass, tmpServerPort) {
	var buf = file_url.split('.');
	var xml_file_name = buf[0] + '_modify.gpx';
	xml_file_name = upload_url + xml_file_name;
	xml_file_name = xml_file_name.substring(1);
	
	var lat_arr = new Array();
	var lng_arr = new Array();
	
	$.ajax({
		type: "POST",
		url: base_url + '/geoXml.do',
		data: 'file_name='+xml_file_name+'&type=load&serverType='+b_serverType+'&serverUrl='+b_serverUrl+
		'&serverPath='+b_serverPath+'&serverPort='+tmpServerPort+'&serverViewPort='+ b_serverViewPort +'&serverId='+tmpServerId+'&serverPass='+tmpServerPass,
		success: function(xml) {
			$(xml).find('trkpt').each(function(index) {
				var lat_str = $(this).attr('lat');
				var lng_str = $(this).attr('lon');
				lat_arr.push(parseFloat(lat_str));
				lng_arr.push(parseFloat(lng_str));
			});
			gps_size = lat_arr.length;
			$('#googlemap').get(0).contentWindow.setGPSData(lat_arr, lng_arr);
		},
		error: function(xhr, status, error) {
			$('#googlemap').get(0).contentWindow.setCenter(0, 0, 1);
		}
	});
}

function loadGPSForData(gpsData){
	$('#googlemap').get(0).contentWindow.map = null;
	$('#googlemap').get(0).contentWindow.marker = null;
	$('#googlemap').get(0).contentWindow.init();
	
	var lat_arr = new Array();
	var lng_arr = new Array();
	if(gpsData != null && gpsData.length > 0 ){
		for(var i=0; i<gpsData.length;i++){
			lat_arr.push(parseFloat($.trim(gpsData[i].lat)));
			lng_arr.push(parseFloat($.trim(gpsData[i].lon)));
		}
		gps_size = lat_arr.length;
		$('#googlemap').get(0).contentWindow.setGPSData(lat_arr, lng_arr);
	}else{
		$('#googlemap').get(0).contentWindow.setCenter(0, 0, 1);
	}
}

/* map_start ----------------------------------- 맵 버튼 설정 ------------------------------------- */

//맵 크기 조절
var resize_map_state = 1;
var resize_scale = 150;
var init_map_left, init_map_top, init_map_width, init_map_height;
// function resizeMap() {
// 	if(resize_map_state==1) {
// 		init_map_left = 800;
// 		init_map_top = 295;
// 		init_map_width = $('#video_map_area').width();
// 		init_map_height = $('#video_map_area').height();
// 		resize_map_state=2;
// 		$('#video_map_area').animate({left:init_map_left-resize_scale, top:init_map_top-resize_scale, width:init_map_width+resize_scale, height:init_map_height+resize_scale},"slow", function() {  $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_min.jpg"/>)');});
// 	}
// 	else if(resize_map_state==2) {
// 		resize_map_state=1;
// 		$('#video_map_area').animate({left:init_map_left, top:init_map_top, width:init_map_width, height:init_map_height},"slow", function() {  $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_max.jpg"/>)');});
// 	}
// 	else {}
// }

//저작
function videoWrite() {
	jAlert('This service requires login.', 'Info');
}

var thX;
var thY;
function loadXML() {
	getServer('XML');
}

function loadXML2(tmpServerId, tmpServerPass, tmpServerPort) {
	var file_arr = file_url.split(".");   		
	var xml_file_name = file_arr[0] + '.xml'; 
	xml_file_name = upload_url + xml_file_name;
	xml_file_name = xml_file_name.substring(1);
	$.ajax({
		type: "POST",
		url: base_url + '/geoXml.do',
		data: 'file_name='+xml_file_name+'&type=load&serverType='+b_serverType+'&serverUrl='+b_serverUrl+
		'&serverPath='+b_serverPath+'&serverPort='+tmpServerPort+'&serverViewPort='+ b_serverViewPort +'&serverId='+tmpServerId+'&serverPass='+tmpServerPass,
		success: function(xml) {
			var max_top = 0;
			$(xml).find('obj').each(function(index) {
				var frameline = $(this).find('frameline').text();
				if(max_top < parseInt(frameline)) max_top = parseInt(frameline);
			});
			var max_line = max_top / 25
			$(xml).find('obj').each(function(index) {
				var id = $(this).find('id').text();
				var frame_obj;
				if(id == "c" || id == "b") {
					var font_size = $(this).find('fontsize').text(); var font_color = $(this).find('fontcolor').text(); var bg_color = $(this).find('backgroundcolor').text();
					var bold = $(this).find('bold').text(); var italic = $(this).find('italic').text(); var underline = $(this).find('underline').text(); var href = $(this).find('href').text();
					var text = $(this).find('text').text(); var top = $(this).find('top').text(); var left = $(this).find('left').text();
					autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left);
					if(id == 'c') frame_obj = $('#frame'+auto_caption_str); else frame_obj = $('#frame'+auto_bubble_str);
					
				}
				else if(id == "i") {
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var width = $(this).find('width').text();
					var height = $(this).find('height').text();
					var src = $(this).find('src').text();
					
					createIcon(src);
					var obj = $('#'+auto_icon_str);
					obj.attr('style', 'position:absolute; display: block; top:'+top+'px; left:'+left+'px; width:'+width+'; height:'+height+';');
					frame_obj = $('#frame'+auto_icon_str);
				}
				else if(id == "g") {
					var buf = $(this).find('type').text();
					var type;
					if(buf=='circle') type = 1;
					else if(buf=='rect') type = 2;
					else if(buf=='point') type = 3;
					else {}
					
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var x_str = $(this).find('xstr').text();
					var y_str = $(this).find('ystr').text();
					var line_color = $(this).find('linecolor').text();
					var bg_color = $(this).find('backgroundcolor').text();
					var buf1 = x_str.split('_');
					for(var i=0; i<buf1.length; i++) { geometry_point_arr_1.push(parseInt(buf1[i])); }
					var buf2 = y_str.split('_');
					for(var i=0; i<buf2.length; i++) { geometry_point_arr_2.push(parseInt(buf2[i])); }
					createGeometry(type, line_color, bg_color);
					frame_obj = $('#frame'+auto_geometry_str);
				}
				else {}
				var frame_obj_top = parseInt($(this).find('frameline').text());
				var frame_obj_left = parseInt($(this).find('framestart').text());
				var frame_obj_width = parseInt($(this).find('frameend').text()) - frame_obj_left;
				frame_obj.css({top:frame_obj_top, left:frame_obj_left, width:frame_obj_width});
			});
		},
		error: function(xhr, status, error) {
			//alert('XML 호출 오류! 관리자에게 문의하여 주세요.');
		}
	});
}

//소스가 길어서 따로 함수로 생성
function autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left) {
	if(id == "c") {
		createCaption(id, font_size, font_color, bg_color, bold, italic, underline, href, text);
		var obj = $('#'+auto_caption_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
	else if(id == "b") {
		text = text.replace(/@line@/g, "\r\n");
		
		createBubble(id, font_size, font_color, bg_color, bold, italic, underline, href, text);
		var obj = $('#'+auto_bubble_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
}

var auto_caption_str;
var auto_caption_num = 0;
function createCaption(id, font_size, font_color, bg_color, bold, italic, underline, href, text) {
	auto_caption_str = "c" + auto_caption_num;
	
	if(bg_color=='none') bg_color = '';
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_caption_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="font-size:14px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_caption_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="font-size:18px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_caption_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="font-size:22px;background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_caption_str+'" style="color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold=='true') html_text = '<b id="b'+auto_caption_str+'">'+html_text+'</b>';
	if(italic=='true') html_text = '<i id="i'+auto_caption_str+'">'+html_text+'</i>';
	if(underline=='true') html_text = '<u id="u'+auto_caption_str+'">'+html_text+'</u>';
	if(href=='true') {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_caption_str+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_caption_str+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_caption_str); div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;'); 
	div_element.html(html_text); 
	div_element.appendTo('#video_main_area');
	
	auto_caption_num++;
	
	var data_arr = new Array();
	data_arr.push(auto_caption_str); data_arr.push("Caption"); data_arr.push(text);
	insertTableObject(data_arr);
	inputFrameObj('caption');
}

var auto_bubble_str;
var auto_bubble_num = 0;
function createBubble(id, font_size, font_color, bg_color, bold, italic, underline, href, text) {
	auto_bubble_str = "b" + auto_bubble_num;
	if(bg_color=='none') bg_color = '';
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:14px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:18px;background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="font-size:22px;background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_bubble_str+'" style="color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold=='true') html_text = '<b id="b'+auto_bubble_str+'">'+html_text+'</b>';
	if(italic=='true') html_text = '<i id="i'+auto_bubble_str+'">'+html_text+'</i>';
	if(underline=='true') html_text = '<u id="u'+auto_bubble_str+'">'+html_text+'</u>';
	if(href=='true') {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_bubble_str); div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;');
	div_element.html(html_text);
	div_element.appendTo('#video_main_area');

	auto_bubble_num++;
	
	var data_arr = new Array();
	data_arr.push(auto_bubble_str); data_arr.push("Bubble"); data_arr.push(text);
	insertTableObject(data_arr);
	inputFrameObj('bubble');
}

var auto_icon_str;
var auto_icon_num = 0;
function createIcon(img_src) {
	auto_icon_str = "i" + auto_icon_num;
	
	var img_element = $(document.createElement('img'));
	img_element.attr('id', auto_icon_str);
	img_element.attr('src', img_src);
	img_element.attr('style', 'position:absolute; display:block; left:30px; top:30px;');
	img_element.attr('width', 100);
	img_element.attr('height', 100);
	img_element.appendTo('#video_main_area');
	
	auto_icon_num++;
	
	var data_arr = new Array();
	data_arr.push(auto_icon_str); data_arr.push("Image"); data_arr.push(img_src);
	insertTableObject(data_arr);
	inputFrameObj('icon');
}

//Geometry Common Value
var auto_geometry_str; var auto_geometry_num = 0; var geometry_point_arr_1 = new Array(); var geometry_point_arr_2 = new Array();
var geometry_total_arr_1 = new Array(); var geometry_total_arr_2 = new Array();
var geometry_total_arr_buf_1 = new Array(); var geometry_total_arr_buf_2 = new Array();
//Geometry Circle & Rect Value
var geometry_click_move_val = false; var geometry_click_move_point_x = 0; var geometry_click_move_point_y = 0;
//Geometry Point Value
var geometry_point_before_x = 0; var geometry_point_before_y = 0; var geometry_point_num = 1;

function createGeometry(type, line_color, bg_color) {
	auto_geometry_str = "g" + auto_geometry_num;
	
	var min_x, max_x, min_y, max_y;
	if(type==1 || type==2) {
		if(geometry_point_arr_1[0] < geometry_point_arr_1[1]) { min_x = geometry_point_arr_1[0]; max_x = geometry_point_arr_1[1]; }
		else { min_x = geometry_point_arr_1[1]; max_x = geometry_point_arr_1[0]; }
		if(geometry_point_arr_2[0] < geometry_point_arr_2[1]) { min_y = geometry_point_arr_2[0]; max_y = geometry_point_arr_2[1]; }
		else { min_y = geometry_point_arr_2[1]; max_y = geometry_point_arr_2[0]; }
	}
	else {
		//좌표점에서 사각형 찾기
		min_x = Math.min.apply(Math, geometry_point_arr_1);
		max_x = Math.max.apply(Math, geometry_point_arr_1);
		min_y = Math.min.apply(Math, geometry_point_arr_2);
		max_y = Math.max.apply(Math, geometry_point_arr_2);
	}
	var left = min_x; var top = min_y; var width = max_x - min_x; var height = max_y - min_y;
	//
	var left_offset = 0; var top_offset = 0;
	left += left_offset; top += top_offset;
	//canvas 객체 삽입
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', auto_geometry_str);
	canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	canvas_element.attr('width', width);
	canvas_element.attr('height', height);
	canvas_element.mouseover(function() {
		mouseeventGeometry(this.id, true, type);
	});
	canvas_element.mouseout(function() {
		mouseeventGeometry(this.id, false, type);
	});
	canvas_element.appendTo('#video_main_area');

	//canvas 객체에 Geometry 그리기
	var canvas = $('#'+auto_geometry_str);
	var context = canvas[0].getContext("2d");
	
	var x, y;
	var x_str = auto_geometry_str+'@'+left+'@'; var y_str = auto_geometry_str+'@'+top+'@';
	var x_str_buf = auto_geometry_str+'@'+left+'@'; var y_str_buf = auto_geometry_str+'@'+top+'@';
	
	line_color = line_color.substring(1, line_color.length);
	bg_color = bg_color.substring(1, bg_color.length);
	context.strokeStyle = css3color(line_color, 1);
	context.lineWidth = 1;
	
	if(type==1) {
		x = 0;
		y = 0;
		width = max_x - min_x; height = max_y - min_y;
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath();
		context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath(); context.stroke();
		x_str += x + '_' + width + '@' + line_color; y_str += y + '_' + height + '@' + bg_color + '@circle';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@circle';
	}
	else if(type==2) {
		width = max_x - min_x; height = max_y - min_y;
		context.strokeRect(0, 0, width, height);
		x_str += 0 + '_' + width + '@' + line_color; y_str += 0 + '_' + height + '@' + bg_color + '@rect';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@rect';
	}
	else {
		context.beginPath();
		for(var i=0; i<geometry_point_arr_1.length; i++) {
			x = Math.abs(left - geometry_point_arr_1[i] - left_offset);
			y = Math.abs(top - geometry_point_arr_2[i] - top_offset);
			if(i==0) context.moveTo(x, y);
			else context.lineTo(x, y);
			if(i==geometry_point_arr_1.length-1) { x_str += x + '@' + line_color; y_str += y + '@' + bg_color + '@point'; }
			else { x_str += x + '_'; y_str += y + '_'; }
			if(i==geometry_point_arr_1.length-1) { x_str_buf += geometry_point_arr_1[i] + '@' + line_color; y_str_buf += geometry_point_arr_2[i] + '@' + bg_color + '@point'; }
			else { x_str_buf += geometry_point_arr_1[i] + '_'; y_str_buf += geometry_point_arr_2[i] + '_'; }
		}
		context.closePath();
		context.stroke();
	}
	auto_geometry_num++;
	
	//데이터 저장
	geometry_total_arr_1.push(x_str);
	geometry_total_arr_2.push(y_str);
	geometry_total_arr_buf_1.push(x_str_buf);
	geometry_total_arr_buf_2.push(y_str_buf);
	
	cancelGeometry();
	
	var data_arr = new Array();
	data_arr.push(auto_geometry_str); data_arr.push("Geometry");
	
	if(type==1) { data_arr.push("Circle"); }
	else if(type==2) { data_arr.push("Rectangle"); }
	else { data_arr.push("Point"); }
	insertTableObject(data_arr);
	inputFrameObj('geometry');
}

function mouseeventGeometry(id, over, type) {
	//좌표 배열에서 좌표 가져옴
	var x_arr, y_arr, x_str, y_str, line_color, bg_color;
	for(var i=0; i<geometry_total_arr_1.length; i++) {
		if(id==geometry_total_arr_1[i].split("\@")[0]) {
			line_color = geometry_total_arr_1[i].split("\@")[3]; bg_color = geometry_total_arr_2[i].split("\@")[3];
			x_str = geometry_total_arr_1[i].split("\@")[2]; y_str = geometry_total_arr_2[i].split("\@")[2];
			x_arr = x_str.split("_"); y_arr = y_str.split("_");
		}
	}
	
	var x, y, width, height;
	var canvas = $('#'+id);
	var context = canvas[0].getContext("2d");
	context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
	context.strokeStyle = css3color(line_color, 1); context.lineWidth = 1;
	
	if(type==1) {
		x = parseInt(x_arr[0]); y = parseInt(y_arr[0]); width = parseInt(x_arr[1]); height = parseInt(y_arr[1]);
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath(); context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
	else if(type==2) {
		x = x_arr[0]; y = y_arr[0]; width = x_arr[1]; height = y_arr[1];
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fillRect(x, y, width, height); }
		context.strokeRect(x, y, width, height);
	}
	else {
		context.beginPath();
		for(var i=0; i<x_arr.length; i++) { x = parseInt(x_arr[i]); y = parseInt(y_arr[i]); if(i==0) context.moveTo(x, y); else context.lineTo(x, y); }
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
}

function cancelGeometry() {
	//데이터 초기화
	geometry_point_arr_1 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = null; geometry_point_arr_2 = new Array();
}

//객체 테이블
function insertTableObject(data_arr) {
	var html_text = "";
	html_text += "<tr id='obj_tr"+data_arr[0]+"' bgcolor='#cccffc' style='font-size:12px;'>";
	html_text += "<td align='center'><label>"+data_arr[0]+"</label></td>";
	html_text += "<td align='center'><label>"+data_arr[1]+"</label></td>";
	html_text += "<td id='obj_td"+data_arr[0]+"'><label>"+data_arr[2]+"</label></td>";
	html_text += "</tr>";
	
	$('#object_table tr:last').after(html_text);
	$('.ui-widget-content').css('fontSize', 12);
}

function inputFrameObj(type) {
	var obj_str, obj_text;
	if(type=='caption') { obj_str = 'framec' + (auto_caption_num-1); obj_text = 'Caption'; }
	else if(type=='bubble') { obj_str = 'frameb' + (auto_bubble_num-1); obj_text = 'Bubble'; }
	else if(type=='icon') { obj_str = 'framei' + (auto_icon_num-1); obj_text = 'Icon'; }
	else if(type=='geometry') { obj_str = 'frameg' + (auto_geometry_num-1); obj_text = 'Geometry'; }
	else {}

	createFrameObj(obj_str, 0, 0, 100, obj_text);
}

// var frameline_obj_top;
function createFrameObj(id, left, top, width, text) {
	var div_element = $(document.createElement('div'));
	div_element.attr('id', id); div_element.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; width:'+width+'px; height:25px; background:#CCF; text-align:left; font-size:10px; overflow:hidden; z-index:1;');
	div_element.html('ID:'+id+' Type:'+text);
	div_element.draggable({ containment:'#video_obj_area', grid:[1,25]});
	div_element.resizable({ minHeight:25, maxHeight:25, minWidth:10 });
	div_element.appendTo('#video_obj_area');
}

// video play function
function timeUpdate(time, totaltime) {
	var point = time * 5;
	$('#video_guide').css({left:point});
	visibleFrameObj(point);
	if(linkType != 'CP1'){
		moveMap(time, totaltime);
	}
}

function visibleFrameObj(point) {
	console.log('poin  t : ' + point);
	var objCount = $('#video_obj_area').children().size();
	for(var i=0; i<objCount; i++) {
		var frame_obj = $('#video_obj_area').children().eq(i);
		var id = frame_obj.attr('id');
		if(id.length > 5) {
			if(id.substring(0, 5)=='frame') {
				var buf1 = frame_obj.css('left');
				buf1 = buf1.replace('px','');
				var start_point = parseInt(buf1);
				var buf2 = frame_obj.css('width');
				buf2 = buf2.replace('px','');
				var end_point = parseInt(buf1) + parseInt(buf2);
				var obj = $('#'+id.substring(5, id.length));
				if(start_point <= point && point <= end_point) { obj.css({visibility:'visible'}); }
				else { obj.css({visibility:'hidden'}); }
			}
		}
	}
}

function moveMap(time, totaltime) {
	var ratio = time * gps_size / totaltime;
	console.log('time : ' + time + ' gps_size : ' + gps_size + ' totaltime :'+ totaltime + ' ratio : ' + ratio);
	if(gps_size > 0){
		$('#googlemap').get(0).contentWindow.moveMarker(parseInt(ratio));
	}else{
		$('#googlemap').get(0).contentWindow.setCenter(0, 0);
	}
}

/* util_start ----------------------------------- Util ------------------------------------- */
hex_to_decimal = function(hex) {
	return Math.max(0, Math.min(parseInt(hex, 16), 255));
};
css3color = function(color, opacity) {
	if(color.length==3) { var c1, c2, c3; c1 = color.substring(0, 1); c2 = color.substring(1, 2); c3 = color.substring(2, 3); color = c1 + c1 + c2 + c2 + c3 + c3; }
	return 'rgba('+hex_to_decimal(color.substr(0,2))+','+hex_to_decimal(color.substr(2,2))+','+hex_to_decimal(color.substr(4,2))+','+opacity+')';
};

//소스보기
// function iframeSrcView(){
// 	if($('#iframeSrc').css('display') == 'none'){
// 		$('#iframeSrc').css('display','block');
// 	}else{
// 		$('#iframeSrc').css('display','none');
// 	}
// }

/* video button start ----------------------------------- 비디오 버튼 설정 ------------------------------------- */

var videoLoding = 0;
function vidplay() {
	
    var button = document.getElementById("play");
    if(videoLoding == 0){
    	
    	if(video_child_len == 1){
    		if(!video0.ended){
        		video0.play();
        	}
    	}else if(video_child_len > 1){
    		if(!video1.ended){
        		video1.play();
        	}
    		if(!video2.ended){
        		video2.play();
        	}
    	}
    	
    	if(video_child_len > 2 && !video3.ended){
    		video3.play();
    	}
    	if(video_child_len > 3 && !video4.ended){
    		video4.play();
    	}
    	
    	button.textContent = "||";
        videoLoding = 1;
    }else{
    	
    	if(video_child_len == 1){
    		video0.pause();
    	}else if(video_child_len > 1){
    		video1.pause();
    		video2.pause();
    	}
    	if(video_child_len > 2){video3.pause();}
    	if(video_child_len > 3){video4.pause();}
    	
        button.textContent = ">";
        videoLoding = 0;
    }
 }

 function restart(reType) {
	 if(video_child_len == 1){
		 video0.currentTime = 0;
	 }else if(video_child_len > 1){
		 video1.currentTime = 0;
		 video2.currentTime = 0;
	 }
	 if(video_child_len > 2){video3.currentTime = 0;}
 	 if(video_child_len > 3){video4.currentTime = 0;}
     
     if(reType == 'first'){
    	 timeUpdateVideo();
     }
 }

 function skip(value) {
	 if(video_child_len == 1){
		 video0.currentTime += value; 
 	 }else if(video_child_len > 1){
 		 video1.currentTime += value;
 		 video2.currentTime += value;
 	 }
	 if(video_child_len > 2){video3.currentTime += value;}
	 if(video_child_len > 3){video4.currentTime += value;}
 }
 
//볼륨조절        
 function updateVolume() {
	 if(video_child_len == 1){
		 video0.volume = volumecontrol.value;
 	 }else if(video_child_len > 1){
 		 video1.volume = volumecontrol.value;
 		 video2.volume = volumecontrol.value;
 	 }
	 if(video_child_len > 2){video3.volume = volumecontrol.value;}
	 if(video_child_len > 3){video4.volume = volumecontrol.value;}
 }
 
//음소거
 function mute(){
	 if(video_child_len == 1){
		 video0.muted = !video0.muted;
 	 }else if(video_child_len > 1){
 		 video1.muted = !video1.muted;
 		 video2.muted = !video2.muted;
 	 }
	 if(video_child_len > 2){video3.muted = !video3.muted;}
	 if(video_child_len > 3){video4.muted = !video4.muted;}
 }
 
 function timeUpdateVideo(){
     var mainVideo;
     var resdu = 0;
     
     var du1 = 0;
     var videoObject = new Object();
     
     if(video_child_len == 1){
    	 du1 = parseInt(video0.duration);
    	 videoObject.video = video0;
    	 mainVideo = video0;
 	 }else if(video_child_len > 1){
 		 du1 = parseInt(video1.duration);
 		 videoObject.video = video1;
 		 mainVideo = video1;
 	 }
     videoObject.duration = du1;
     resdu = du1;
     
     var tmpObjArr = new Array();
     tmpObjArr.push(videoObject);
     
     if(video_child_len > 1){
    	 var tmpDu = parseInt(video2.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video2;
    	 tmpObjArr.push(videoObject);
     }
     if(video_child_len > 2){
    	 var tmpDu = parseInt(video3.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video3;
    	 tmpObjArr.push(videoObject);
     }
     if(video_child_len > 3){
    	 var tmpDu = parseInt(video4.duration);
    	 videoObject = new Object();
         videoObject.duration = tmpDu;
         videoObject.video = video4;
    	 tmpObjArr.push(videoObject);
     }
     
     if(tmpObjArr != null && tmpObjArr.length > 1){
    	 for(k=1;k<tmpObjArr.length;k++){
        	 if(tmpObjArr[k].duration > resdu){
        		 resdu = tmpObjArr[k].duration;
        		 mainVideo = tmpObjArr[k].video;
        	 }
         }
     }
	
	 var seekBar = document.getElementById("seekBar");
	 seekBar.addEventListener("mousedown", function(e){
	     if(video_child_len == 1){
	    	 video0.pause();
	 	 }else if(video_child_len > 1){
	 		 video1.pause();
	 		 video2.pause();
	 	 }
	 	 if(video_child_len > 2){video3.pause();}
	 	 if(video_child_len > 3){video4.pause();}
	 });
	
	 seekBar.addEventListener("mouseup", function(e){
		var vTime = parseInt(mainVideo.duration * (this.value / 100), 10);
		if(video_child_len == 1){
			video0.currentTime = vTime;
	 	}else if(video_child_len > 1){
	 		video1.currentTime = vTime;
	 	}
	     
	    if(video_child_len > 1){
	    	if(vTime > video2.dutation){
	    		video2.currentTime = video2.dutation;
	    	}else{
	    		video2.currentTime = vTime;
	    	}
	    }
	    if(video_child_len > 2){
	    	if(vTime > video3.dutation){
	    		video3.currentTime = video3.dutation;
	    	}else{
	    		video3.currentTime = vTime;
	    	}
	    }
	    if(video_child_len > 3){
	    	if(vTime > video4.dutation){
	    		video4.currentTime = video4.dutation;
	    	}else{
	    		video4.currentTime = vTime;
	    	}
	    }
	     
	    vidplay();
	 });
	 
	 mainVideo.addEventListener("timeupdate", function(){
	     seekBar.value = (100 / mainVideo.duration) * mainVideo.currentTime;
	     timeUpdate(parseInt(this.currentTime), parseInt(this.duration));
	 });
 }
 
//copy Url
 function getCopyUrlDecode(){
 	var Url			= baseRoot() + "cms/encrypt";
 	var param		= "/" + urlData + "/decrypt";
 	var callBack	= "?callback=?";
 	
 	$.ajax({
 		type	: "get"
 		, url	: Url + param + callBack
 		, dataType	: "jsonp"
 		, async	: false
 		, cache	: false
 		, success: function(data) {
 			if(data.returnStr != null && data.returnStr != ''){
 				var  tmpStr = data.returnStr;
 				tmpStr = tmpStr.split("&");
 				$.each(tmpStr, function(idx2, val2){
 					if(val2.indexOf('file_url') > -1){
 						file_url = val2.split('=')[1];
 					}else if(val2.indexOf('loginId') > -1){
 						copyUserId = val2.split('=')[1];
 					}else if(val2.indexOf('idx') > -1){
 						copyUrlIdx = val2.split('=')[1];
 						idx = copyUrlIdx;
 					}
 				});
 			}else{
 				jAlert(data.Message, 'Info');
 			}
 		}
 	});
 	//비디오 설정
	changeVideo();
 }
 
 function copyFn(CopyType){
 	var copyUrlData = $('#copyUrlText').val();
 	var copyUrlStr = 'http://'+location.host + '/GeoVideo/geoVideo/video_url_viewer.do?urlData='+ copyUrlData +'&linkType='+CopyType;
 	
 	$('#copyUrlAll').val(copyUrlStr);
 	$("#copyUrlAll").select();
 	document.execCommand('copy');
 	$('#copyUrlView').css('display','none');
 	jAlert('uri address copied.', 'Info');
 }

 function getCopyUrl(){
 	$('#copyUrlText').val('');
 	var encrypText = 'file_url='+ file_url +'&loginId='+ loginId +'&idx='+ idx;
 	
 	var Url			= baseRoot() + "cms/encrypt";
 	var param		= "/" + encrypText + "/encrypt";
 	var callBack	= "?callback=?";
 	$.ajax({
 		type	: "get"
 		, url	: Url + param + callBack
 		, dataType	: "jsonp"
 		, async	: false
 		, cache	: false
 		, success: function(data) {
 			if(data.returnStr != null && data.returnStr != ''){
 				$('#copyUrlText').val(data.returnStr);
 			}else{
 				jAlert(data.Message, 'Info');
 			}
 		}
 	});
 }
 
 function exifViewFunction(sType){
		if(sType == 'on'){
			$('#exifViewOn').css('display','none');
			$('#exifViewOff').css('display','block');
			$('#image_exif_area').css('display','block');
			$('#image_exif_area').maxZIndex({inc:1});
//	 		$('#image_map_area').css('top','220px');
//	 		$('#image_map_area').css('height','51%');
		}else{
			$('#exifViewOn').css('display','block');
			$('#exifViewOff').css('display','none');
			$('#image_exif_area').css('display','none');
//	 		$('#image_map_area').css('top','10px');
//	 		$('#image_map_area').css('height','94%');
//	 		$('#exifViewOn').maxZIndex({inc:1});
		}
	}

	//right image infomation view type change
	function fnViewTabs(tempTabId){
		$('.selectExifTabTitle').addClass('noSlectExifTabTitle');
		$('.selectExifTabTitle').removeClass("selectExifTabTitle");
		$('.selectExifTabChild').addClass('noSelectExifTabChild');
		$('.selectExifTabChild').removeClass("selectExifTabChild");
		
		$('#tabs_'+tempTabId).removeClass('noSlectExifTabTitle');
		$('#tabs_'+tempTabId).addClass('selectExifTabTitle');
		
		$('#tabsChild_'+tempTabId).removeClass("noSelectExifTabChild");
		$('#tabsChild_'+tempTabId).addClass("selectExifTabChild");
		
	}
</script>

</head>

<body onload='videoViewerInit();' bgcolor='#FFF' style="margin:0px;">

<!---------------------------------------------------- 메인 영역 시작 ------------------------------------------------>

<!-- 비디오 영역 -->
<div id='video_main_area' style='position:absolute; left:0px; top:0px; width:780px; height:545px; display:block; border-right:1px solid #ebebeb; overflow: hidden;'>
<!-- 	<video id='video_player' width='760' height='500' controls='true' style='position:absolute; left:10px; top:10px;'> -->
<!-- 		<source id='video_src' src='' type='video/ogg'></source> -->
<!-- 		<source src="http://localhost:8088/GeoCMS/upload/GeoVideo/aaaaa(1)_ogg.ogg" type="video/ogg" /> -->
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
<!-- 	</video> -->
	<video id='video_player0' width='760' height='460' style='position:absolute; left:0px; top:0px; border: 1px solid gray;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	
	<video id='video_player1' class='multi_class' width='387' height='230' style='position:absolute; left:0px; top:0px; display: none;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player2' class='multi_class' width='387' height='230' style='position:absolute; left:393px; top:0px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player3' class='multi_class' width='387' height='230' style='position:absolute; left:0px; top:230px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player4' class='multi_class' width='387' height='230' style='position:absolute; left:393px; top:230px; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
</div>

<div id="buttonbar" style="position: absolute; left: 20px; top:510px;">
    <button id="restart" onclick="restart('');" style="display: block;float: left;">[]</button> 
    <button id="rew" onclick="skip(-10)" style="display: block;float: left; margin-left: 10px;">&lt;&lt;</button>
    <button id="play" onclick="vidplay()" style="display: block;float: left; margin-left: 10px;">&gt;</button>
    <button id="fastFwd" onclick="skip(10)" style="display: block;float: left; margin-left: 10px;">&gt;&gt;</button>
    <input type="range" id="seekBar" value="0" style="display: block;float: left; margin-left: 10px;">
    <input type="range" id="volumecontrol" min="0" max="1" step="0.1" value="1" style="display: block;float: left; margin-left: 270px;" onchange="updateVolume();">
    <button onclick="mute();" style="margin-left: 10px;">Mute</button> 
</div> 

<div id="video_obj_area" style="display:none;"></div>

<div style="width:1143px; height: 205px; margin: 550px 0 0 -10px;background:#1e2b41;">
	<div id="image_view_group" style="color:#ffffff; font-size: 16px; position: absolute; top:547px; left:10px; width:1110px; height: 38px;"></div>
	<div id="moveSelectDiv" style="position: absolute; left:410px; top:585px; width:200px; max-height: 76px; border:1px solid #00b8b0; overflow-y:auto; display:none; color:gray;"></div>
	
	<div id='img_move_area' style='position:absolute; left:10px; top:585px; width:1115px; height:160px; display:block; overflow-y:hidden;'>
		<img src='<c:url value='/images/geoImg/viewer/right_arrow.png'/>' style='float:right; display: none; margin-top: 10px;cursor: pointer;' class="imgMoveBtn" onclick="moveImgList('r')"> 
		<div id='img_move_list' style='position:absolute; height:100%; left:20px; top:10px; width: 1075px; display:block;overflow-x:auto; overflow-y:hidden;'>
			<div id='img_move_list_long' style='position:absolute; height:100%; display:block;'></div>
		</div>
		<img src='<c:url value='/images/geoImg/viewer/left_arrow.png'/>' style='float:left; display: none; margin-top: 10px; cursor: pointer;' class="imgMoveBtn" onclick="moveImgList('l')"> 
	</div>
</div>

<!-- EXIF 삽입 다이얼로그 객체 -->
	<div class="image_exif_area_head" style="position:absolute; left:781px; top:0px; width:352px; display:block; font-size:13px; height: 30px; border-bottom : 1px solid #ebebeb;">
		<label style="padding: 5px 10px;line-height: 30px;font-size: 13px;">Video Infomation</label>
		<button id="exifViewOff" class="smallWhiteBtn" onclick="exifViewFunction('off');" style="display:none; float: right;height:20px; margin: 5px 10px;" align="center">HIDE</button>
		<button id="exifViewOn" class="smallWhiteActiveBtn" onclick="exifViewFunction('on');" style="display:block;height:20px;float: right;margin: 5px 10px;" align="center">SHOW</button>
	</div>
	<div id='image_exif_area' style='display:none; width: 352px; background: #ffffff;position: absolute;top: 31px;border-bottom: 1px solid rgb(235, 235, 235);left: 781px;z-index:2;'>
		<!-- EXIF 삽입 다이얼로그 객체 -->
		<table style="width: 100%;">
			<tr>
				<td id="tabs_1" onclick="fnViewTabs(1);" class="infoTabs selectExifTabTitle">
					<label style="padding: 5px;display: inline-block;">Data Info</label>
				</td>
				<td id="tabs_2" onclick="fnViewTabs(2);" class="infoTabs noSlectExifTabTitle">
					<label style="padding: 5px;display: inline-block;">Object Data</label>
				</td>
				<td style="padding: 0px; width:34%;border-bottom: 1px solid #ebebeb;">
					<div id="tabs_3"></div>
				</td>
			</tr>
		</table>
		<div id="tabsChild_1" style='height: 195px;' class="selectExifTabChild">
			<table id='normal_exif_table' style="margin-top: 10px;">
				<tr><td width='15'></td><td width='100'><label class="tableLabel">Title</label></td><td width='200'><input class="normalTextInput" id='title_text' name='text' type='text' readonly/></td></tr>
				<tr><td width='15'></td><td width='100'><label class="tableLabel">Content</label></td><td width='200'><textarea class="normalTextInput" id='content_text' name='text' style='font-size:12px;width: 98%;height: 50px;' readonly></textarea></td></tr>
				<tr><td width='15'></td><td width='100'><label class="tableLabel">Sharing settings</label></td><td width='200'><input class="normalTextInput" id='share_text' name='text' type='text' readonly/></td></tr>
				<tr><td width='15'></td><td width='100'><label class="tableLabel">Drone Type</label></td><td width='200'><input class="normalTextInput" id='drone_text' name='text' type='text' readonly/></td></tr>
				<tr><td colspan="4">
					<button class="smallWhiteBtn" style="width:115px; height:25px; display:block;float: right;" onclick="videoWrite();" id="makeImageBtn">Edit Annotaion</button>
				</td></tr>		
			</table>
		</div>
		<div id="tabsChild_2" style='height: 235px; overflow-y:scroll;' class="noSelectExifTabChild">
			<table id='object_table'>
				<tr style='font-size:12px; height:20px;' class='col_black'>
					<td width=50 class='anno_head_tr'>ID</td>
					<td width=80 class='anno_head_tr'>Type</td>
					<td width=170 class='anno_head_tr'>Data</td>
				</tr>
			</table>
		</div>
	</div>

<!-- 지도 영역 -->
<div id='video_map_area' style='position: absolute;left: 781px;top: 31px;width: 352px;height: 514px;display: block;z-index: 1;'>
	<iframe id='googlemap' src='<c:url value="/geoVideo/video_googlemap.do"/>' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
</div>

<div id="copyUrlBtn" class="smallGreyBtn" style="width: 60px;height: 20px;float: right;border-radius:5px;text-align: center;position: absolute;top: 470px;left: 680px;cursor: pointer;font-size: 13px;">copy URI</div>
<div id="copyUrlView" class="contextMenu" style="display: block;position: absolute;width: 205px;height: 80px;background-color: rgb(228, 228, 228);left: 576px;top: 498px;border-radius: 5px;cursor: pointer;font-size: 13px;z-index:999;">
	<ul style="margin-left: -10px;">
		<li id="copyTypePhoto" onclick="copyFn('CP1');" class="copyUrlViewLi">Video URI</li>
		<li id="copyTypeMap" onclick="copyFn('CP2');" class="copyUrlViewLi">Video + Map URI</li>
		<li id="copyTypeProject" onclick="copyFn('CP3');" class="copyUrlViewLi">Video + Map + Layer URI</li>
	</ul>
</div>
<input type="hidden" id="copyUrlText">
<input type="text" id="copyUrlAll" style="position: absolute;left:30px; top: 30px; opacity:0;">

<!-- 저작 버튼 -->
<!-- 	<button style="position:absolute; left:580px; top:780px; width:140px; height:35px; display:none; cursor: pointer;" onclick="videoViewClose();" class="viewerCloseBtn">Close</button> -->
</body>

</html>
