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
%>

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
var imgEditMode = 0;						//편집모드 : 1, 아니면 0;
var moveWidthNum = 135;						//imageWidth + margin + border
var nowSelectIdx = 0;
var dMarkerLat = 0;		//default marker latitude
var dMarkerLng = 0;		//default marker longitude
var dMapZoom = 10;		//default map zoom

$(function() {
	callRequest();
	
	$("#video_object_area .accordionButton:eq(1)").trigger('click');
	
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
				
				btnViewCheck();
				getVideoBase();
				getServer("");
			}else{
				base_url = '<c:url value="/"/>';
				upload_url = '/upload/';
// 				$('body').append('<button class="video_write_button" style="position:absolute; left:800px; top:530px; width:300px; height:35px; display:block; cursor: pointer;" onclick="videoWrite();">Edit Annotaion</button>');
				$('.viewerCloseBtn').css('display','block');
				$('#iframeSrc').text("<iframe width='760' height='500' src='"+ videoOutUrl() +"/GeoVideo/geoVideo/video_viewer.do?file_url="+ file_url+ "' frameborder='0' allowfullscreen></iframe>");
			}
			if(linkView == 'Y'){
				$('#image_view_group').parent().remove();	
				$('#viewerColstBtn').css('display','none');
			}
		}
	}
}

function btnViewCheck(){
// 	$('.video_write_button').remove();
	$('.viewerCloseBtn').css('display','none');
	$('#copyTypeEditor').remove();
	
	if(loginId != null && loginId != '' && loginId != 'null' && ((loginId == user_id && loginType != 'WRITE') || loginType == 'ADMIN')){
// 		$('body').append('<button class="video_write_button" style="position:absolute; left:800px; top:530px; width:300px; height:35px; display:block; cursor: pointer;" onclick="videoWrite();">Edit Annotaion</button>');
		$('.viewerCloseBtn').css('display','block');
		$('#copyUrlView ul').append('<li id="copyTypeEditor" onclick="copyFn(\'CP4\');">Editor Url</li>');
		$('#copyUrlView').css('height','90px');
		$('#copyTypeEditor').hover(
			function(t) {
				$(this).css('font-weight','bold');
			}, function(t) {
				$(this).css('font-weight','normal');
			}
		);
	}else if(editUserCheck() == 1 ||  (loginId != null && loginId != '' && loginId != 'null' && projectUserId == loginId)){
// 		$('body').append('<button class="video_write_button" style="position:absolute; left:800px; top:530px; width:300px; height:35px; display:block; cursor: pointer;" onclick="videoWrite();">Edit Annotaion</button>');
		$('.viewerCloseBtn').css('display','block');
		$('#copyUrlView ul').append('<li id="copyTypeEditor" onclick="copyFn(\'CP4\');">Editor Url</li>');
		$('#copyUrlView').css('height','90px');
		$('#copyTypeEditor').hover(
			function(t) {
				$(this).css('font-weight','bold');
			}, function(t) {
				$(this).css('font-weight','normal');
			}
		);
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
					$('#googlemap').get(0).contentWindow.setDefaultData(dMarkerLat, dMarkerLng, dMapZoom);
				}
			}else{
				jAlert(data.Message, 'Info');
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

//편집 가능 유저 확인
function editUserCheck(){
	var Url			= baseRoot() + "cms/getShareUser/";
	var param		= loginToken + "/" + loginId + "/" + idx + "/GeoVideo";
	var callBack	= "?callback=?";
	editUserYN  = 0;
	
	$.ajax({
		  type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(response) {
			if(response.Code == 100 && response.Data[0].shareedit == 'Y'){
				editUserYN = 1;
			}
		}
	});
	
	return editUserYN;
}

function videoViewerInit() {
// 	//비디오 설정
	changeVideo();

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
	
	getCopyUrl();
	
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
								
								$('#title_text').val(response[k].title);
								$('#content_text').val(response[k].content);
								var nowShareTypeText = response[k].sharetype == 0? "private":response[k].sharetype== 1? "public":"sharing with friends";
								$('#share_text').val(nowShareTypeText);
								if(response[k].dronetype != null && response[k].dronetype =='Y'){
									$('#drone_text').val(response.dronetype);
								}else{
									$('#drone_text').val('N');
								}
							}
						}
						
						
						//좌표
						var gpsDataStr = response[0].gpsdata;
						if(gpsDataStr != null){
							gpsDataStr = gpsDataStr.gpsData
							loadGPSForData(gpsDataStr);
						}
						
						if(video_child_len > 1){
							if(video_child_len < 4){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
								$('#video_player4').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player4').css('board','none');
							}
							if(video_child_len < 3){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
								$('#video_player3').css('background','url("../images/geoImg/novideo.png")');
								$('#video_player3').css('board','none');
							}
							if(video_child_len < 2){
								var tmpHtmlStr = "<div style='width:380px; height:230px;'>No video</div>";
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
						getProjectGroupViewList();
						addImageMoveList();
					}
				}else{
					jAlert(data.Message, 'Info');
				}
			}
		});
	}else{
//	 	//GPX or KML 데이터 설정
	 	loadGPS();
	 	
	}
}

//get projectList
function getProjectGroupViewList(){
	var tmpOIdx = '&nbsp';
	var tmpSEdit = '&nbsp';
	
	var Url			= baseRoot() + "cms/getProjectList/";
	var param		= loginToken + "/" + loginId +"/" +tmpOIdx + "/" +tmpSEdit;
	var callBack	= "?callback=?";
	
	$.ajax({
		type	: "get"
		, url	: Url + param + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(data) {
			var response = data.Data;
			if(data.Code == '100'){
				projectList = response;
			}
// 			else if(data.Code != '203'){
// 				jAlert(data.Message, 'Info');
// 			}
		}
	});
}

function addImageMoveList(){
	var tmpCnt = 0;
	nowViewList = new Array();
	editContentArr = new Array();
	$('#img_move_list_long').empty();
	$('#moveSelectDiv').empty();
	
	var pageNum = '&nbsp';
	var contentNum = '&nbsp';
	
	var Url			= baseRoot() + "cms/getProjectContent/";
	var param		= loginToken + "/" + loginId + "/list/" + projectIdx + "/" + pageNum + '/' + contentNum;
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

	tmpGroupHTML += "<img src='<c:url value='/images/geoImg/viewer/setting_btn_pop.png'/>' style='float:right; margin:8px 10px 0 20px; width:30px; height:26px; display: none; cursor:pointer;' id='mv_setting' onclick='imageControllView(\"Y\")'>";
	
	tmpGroupHTML += "<img src='<c:url value='/images/geoImg/viewer/close_btn_pop.png'/>' style='float:right; margin:8px 10px 0 20px; width:30px; height:26px; display: none; cursor:pointer;' class='mv_setting_on' onclick='imageControllView(\"N\")'>";
	tmpGroupHTML += "<img src='<c:url value='/images/geoImg/viewer/picdel_btn_viewer.png'/>' style='float:right; margin:8px 0 0 20px; width:47px; height:27px; display: none; cursor:pointer;' class='mv_setting_on' onclick='removeMoveList()'>";
	tmpGroupHTML += "<img src='<c:url value='/images/geoImg/viewer/picmove_btn_viewer.png'/>' style='float:right; margin:8px 0 0 20px; width:47px; height:27px; display: none; cursor:pointer;' id='view_category' class='mv_setting_on' onclick='getMoveList()'>";
	
	$('#image_view_group').append(tmpGroupHTML);

	if(imgEditMode == 1){
		$('.mv_setting_on').css('display','block');
		$('#moveSelectDiv').empty();
	}
	
	if(loginId != null && loginId != '' && loginId != 'null' && loginId != '&nbsp' && ((loginId == user_id && loginType != 'WRITE') || loginType == 'ADMIN' || (user_id == null || user_id == '' || user_id == 'null'))){
		$('.edit_btn_bottom').css('display', 'block');
		if(imgEditMode != 1){
			$('#mv_setting').css('display', 'block');
		}
	}else if(editUserCheck() == 1 ||  projectUserId == loginId){
		$('.edit_btn_bottom').css('display', 'block');
		if(imgEditMode != 1 && projectUserId == loginId){
			$('#mv_setting').css('display', 'block');
		}
	}else{
		$('.edit_btn_bottom').css('display', 'none');
		$('#mv_setting').css('display', 'none');
	}
}

//img modify mode
function imageControllView(type){
	$('.checkAreaClass').remove();
	$('#copyUrlView').maxZIndex({inc:1});
	
	if(type == 'Y'){
		imgEditMode = 1;
		addImageMoveList();
		
		$('#mv_setting').css('display','none');
		$('.mv_setting_on').css('display','block');

		var tmpDiv = '<div id="grayDivArea" style="position:absolute; width:100%; height:576px; background:gray; opacity:0.5; left:0; top:0;" ></div>';
		$('body').append(tmpDiv);
		
		$('#image_view_group').maxZIndex({inc:1});
		$('#img_move_area').maxZIndex({inc:1});
		$('#moveSelectDiv').maxZIndex({inc:1});
		
	}else{
		imgEditMode = 0;
		addImageMoveList();
		$('.mv_setting_on').css('display','none');
		$('#grayDivArea').remove();
		$('#moveSelectDiv').empty();
		$('#moveSelectDiv').css('display','none');
	}
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
	
	if(imgEditMode == 1){
		if(!(loginId != null && loginId != '' && loginId != 'null' && loginId != '&nbsp' && (((loginId == tmpId && loginType != 'WRITE') || loginType == 'ADMIN' || (tmpId == null || tmpId == '' || tmpId == 'null')) || (editUserCheck() == 1 ||  tmpProjectId == loginId)))){
			return;
		}

		var tmp1 = $.inArray(tmpKind+"_"+nowSelectIdx, editContentArr);
		if(tmp1 > -1 ){
			editContentArr.splice(tmp1,1);
			$('#checkArea_'+tmpKind+"_"+nowSelectIdx).remove();
		}else{
			var tmpLeft = tmpMoveIdx*moveWidthNum;
			editContentArr.push(tmpKind+"_"+nowSelectIdx);
			var tmpDiv = '<div id="checkArea_'+ tmpKind+"_"+nowSelectIdx +'" class="checkAreaClass" style="position:absolute; width:112px; height:112px; background-image: url(../images/geoImg/viewer/select_photo_btn_pop.png); background-repeat:no-repeat;cursor:pointer; top:10px; left:'+ tmpLeft +'px;" ></div>';
			$('#Pro_'+ tmpKind +'_'+nowSelectIdx).append(tmpDiv);
		}
		return;
	}
	
	if(tmpKind != null && tmpKind == 'GeoPhoto'){
		videoViewClose();
		window.parent.imageViewer(tpAr[2], tmpId, nowSelectIdx, tmpProjectId)
		return;
	}else{
		idx = nowSelectIdx;
		btnViewCheck();
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

function getMoveList(){
	var moveUrl = '';
	moveUrl = 'cms/getProjectList/'+ loginToken +'/'+ loginId +'/&nbsp/Y';
	
	if($('#moveSelectDiv').css('display') == 'none'){
		var Url			= baseRoot() + moveUrl;
		var callBack	= "?callback=?";
		
		$.ajax({
			  type	: "get"
			, url	: Url + callBack
			, dataType	: "jsonp"
			, async	: false
			, cache	: false
			, success: function(response) {
				if(response.Code == 100){
					var result = response.Data; 
					if(result != null && result.length>1){
						var tmpHtml = '';
						
						for(var i=0; i<result.length; i++){
							var tmpTabName = result[i].projectname;
							var proShare = '';
							if(result[i].sharetype == '1'){
// 								proShare = '공개';
								proShare = 'FULL';
							}else if(result[i].sharetype == '0'){
// 								proShare = '비공개';
								proShare = 'NON';
							}else{
// 								proShare = '선택공개';
								proShare = 'SELECTIVE';
							}
							
							if(result[i].idx != projectIdx){
								var tmpTabNameShot = tmpTabName.length>10? tmpTabName.substring(0,10)+'...' : tmpTabName;
								
								tmpHtml += '<div style="height:26px; background:#4f3639; cursor:pointer;" onclick="modifyCategory('+ result[i].idx +');" class="proNameMouseDiv">';
								tmpHtml += "<div class='m_l_15' style='float:left; margin: 6px 0 0 10px; font-size:10px; color:#00b8b0;'>"+ proShare +"</div>";
								tmpHtml += "<div style='padding: 5px 0 0 60px; font-size:12px;' title='"+ tmpTabName +"'>"+ tmpTabNameShot +"</div></div>";
							}
						}
						
						$('#moveSelectDiv').append(tmpHtml);
						$('.proNameMouseDiv').hover(
							function() {
								$(this).css('background','#25323c');
							}, function() {
								$(this).css('background','#4f3639');
							}
						);
						
						var  tmpLeft2 = $('#view_category').offset().left -33;
						$('#moveSelectDiv').css('display','block');
						$('#moveSelectDiv').css('left',tmpLeft2);
						var tmpToh2 = $('#view_category').offset().top - $('#moveSelectDiv').height()-7;
						$('#moveSelectDiv').css('top',tmpToh2);
					}else{
// 						jAlert('이동할 프로젝트 정보가 없습니다', '정보');
						jAlert('No project information to move.', 'Info');
					}
				}else if(response.Code == 200){
// 					jAlert('이동할 프로젝트 정보가 없습니다', '정보');
					jAlert('No project information to move.', 'Info');
				}
			}
		});
	}else{
		$('#moveSelectDiv').empty();
		$('#moveSelectDiv').css('display','none');
	}
}

//move Content
function modifyCategory(tmpProIdx){
	if(editContentArr == null || editContentArr.length <= 0){
// 		jAlert('이동할 컨텐츠를 선택해 주세요', '정보');
		jAlert('Please select content to move.', 'Info');
		$('#popup_container').maxZIndex({inc:1});
		return;
	}
	
	$('#moveSelectDiv').css('display','none');
	
	var moveUrl = moveUrl = 'cms/moveProject/'+ loginToken +'/'+ loginId +'/'+ tmpProIdx + "/" + editContentArr;
	
	var Url			= baseRoot() + moveUrl;
	var callBack	= "?callback=?";
	
	$.ajax({
		  type	: "POST"
		, url	: Url + callBack
		, dataType	: "jsonp"
		, async	: false
		, cache	: false
		, success: function(response) {
			if(response.Code == 100){
				makeViewOrd();
			}
		}
	});
}

function removeMoveList(){
	if(editContentArr == null || editContentArr.length <= 0){
// 		jAlert('삭제할 사진을 선택해 주세요', '정보');
		jAlert('Please select a photo to delete.', 'Info');
		$('#popup_container').maxZIndex({inc:1});
		return;
	}
	
// 	jConfirm('정말 삭제하시겠습니까?', '정보', function(type){
	jConfirm('Are you sure you want to delete?', 'Info', function(type){
		if(type){
			var rmPhotoList = new Array();
			var rmVideoList = new Array();
			$.each(editContentArr, function(eIdx, eVal){
				if(eVal != null && eVal != '' && eVal != undefined){
					var tmpEval = eVal.split('_');
					if(tmpEval[0] == 'GeoPhoto'){
						rmPhotoList.push(tmpEval[1]);
					}else if(tmpEval[0] == 'GeoVideo'){
						rmVideoList.push(tmpEval[1]);
					}
				}
			});
			if(rmPhotoList != null && rmPhotoList.length > 0){
				var moveUrl = 'cms/deleteContent/'+ loginToken +'/'+ loginId +'/GeoPhoto/' + rmPhotoList;
				var Url			= baseRoot() + moveUrl;
				var callBack	= "?callback=?";
				
				$.ajax({
					  type	: "POST"
					, url	: Url + callBack
					, dataType	: "jsonp"
					, async	: false
					, cache	: false
					, success: function(response) {
						if(response.Code == 100){
							if(rmVideoList != null && rmVideoList.length > 0){
								var moveUrl = 'cms/deleteContent/'+ loginToken +'/'+ loginId +'/GeoVideo/' + rmVideoList;
								var Url			= baseRoot() + moveUrl;
								var callBack	= "?callback=?";
								
								$.ajax({
									  type	: "POST"
									, url	: Url + callBack
									, dataType	: "jsonp"
									, async	: false
									, cache	: false
									, success: function(response) {
										if(response.Code == 100){
											makeViewOrd();
										}
									}
								});
							}else{
								makeViewOrd();
							}
						}
					}
				});
			}else if(rmVideoList != null && rmVideoList.length > 0){
				var moveUrl = 'cms/deleteContent/'+ loginToken +'/'+ loginId +'/GeoVideo/' + rmVideoList;
				var Url			= baseRoot() + moveUrl;
				var callBack	= "?callback=?";
				
				$.ajax({
					  type	: "POST"
					, url	: Url + callBack
					, dataType	: "jsonp"
					, async	: false
					, cache	: false
					, success: function(response) {
						if(response.Code == 100){
							makeViewOrd();
						}
					}
				});
				
			}
		}
	});
}

function makeViewOrd(){
	var chkData = true;
	if(nowViewList.length != editContentArr.length){
		for(var i=0;i<nowViewList.length;i++){
			if(nowViewList[i] != null){
				chkData = true;
				for(var j=0;j<editContentArr.length;j++){
					if(nowViewList[i].datakind+"_"+nowViewList[i].idx == editContentArr[j]){
						chkData = false;
					}
				}
				if(chkData){
					nowIndexType = nowViewList[i].datakind;
					idx = nowViewList[i].idx;
					break;
				}
			}
		}
	}

	if(nowViewList.length == editContentArr.length){
		window.parent.viewMyProjects(null);
		
// 		jAlert('불러올 컨텐츠가 없습니다.', '정보', function(res){
		jAlert('There is no content to import.', 'Info', function(res){
			videoViewClose();
		});
	}
	
	addImageMoveList();
	
	imgEditMode = 0;
	$('.checkAreaClass').remove();
	$('#grayDivArea').remove();
	
	$.each(nowViewList, function(idx1, val1){
		if(val1.idx == idx && val1.datakind == nowIndexType){
			var tempArr = new Array; //mapCenterChange에 넘길 객체 생성
			tempArr.push(val1.latitude);
			tempArr.push(val1.longitude);
			tempArr.push(val1.filename);
			tempArr.push(val1.idx);
			tempArr.push(val1.datakind);
			tempArr.push(val1.originname);
			tempArr.push(val1.thumbnail);
			tempArr.push(val1.id);
			tempArr.push(val1.projectuserid);
			if(val1.projectmarkericon != null){
				val1.projectmarkericon = val1.projectmarkericon.replace('_','&ubsp');
			}
			tempArr.push(val1.projectmarkericon);
			tempArr.push(val1.u_date);
			tempArr.push(val1.projectidx);
			tempArr.push(val1.dronetype);
			imgMapCenterChange("'"+ tempArr +"'");
		}
	});
	
	imageControllView('Y');
	
	window.parent.viewMyProjects(null);
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

//큰 이미지 좌우 이동
function changeImg(text){
	var tmpMoveIdx = 0;
	var nextIdx = 0;
	var tmpKind = 'GeoPhto';
	$.each(nowViewList, function(idx1, val1){
		if(val1.idx == idx){
			tmpMoveIdx = idx1;
			tmpKind = val1.datakind;
		}
	});
	
	if(text == "l"){
		if(tmpMoveIdx == 1){
			$('#bigImgMoveL').css('display','none');
		}
		if(tmpMoveIdx == nowViewList.length-1){
			$('#bigImgMoveR').css('display','block');
		}
		nextIdx = tmpMoveIdx - 1;
	}else if(text == "r"){
		if(tmpMoveIdx == nowViewList.length-2){
			$('#bigImgMoveR').css('display','none');
		}
		if(tmpMoveIdx == 0){
			$('#bigImgMoveL').css('display','block');
		}
		nextIdx = tmpMoveIdx + 1;
	}
	
	if(nowViewList.length > 8){
		var tmpMoveLeft1 = 0;
		if(nextIdx > 4){
			tmpMoveLeft1 = (moveWidthNum * (nextIdx-3));
		}
		$('#img_move_list').animate({scrollLeft : tmpMoveLeft1});
	}

	imgDataSetting(nowViewList[nextIdx]);
	file_url = nowViewList[nextIdx].filename;
	changeImageNomal();
	
	$('#Pro_'+ tmpKind +'_'+ idx + " DIV").css('border', '2px solid #888888');
	idx = nowViewList[nextIdx].idx;
	$('#Pro_'+ tmpKind +'_'+ idx + " DIV").css('border', '2px solid #00b8b0');
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
	var writeCheck = false;
	if(loginId != null && loginId != '' && loginId != 'null' && loginId != '&nbsp' && ((loginId == user_id && loginType != 'WRITE') || loginType == 'ADMIN')){	
		writeCheck = true;
	}else if(editUserCheck() == 1 ||  (loginId != null && loginId != '' && loginId != 'null' && projectUserId == loginId)){
		writeCheck = true;
	}else if(projectBoard != 1){
		writeCheck = true;
	}
	
	if(writeCheck){
//	 	jConfirm('뷰어를 닫고 저작을 수행하시겠습니까?', '정보', function(type){
		jConfirm('Do you want to close the viewer and author?', 'Info', function(type){
			if(type) {
				//뷰어 닫기 수행
				videoViewClose();
				openVideoWrite();
			}
		});
	}else{
		if(loginId != null && loginId != '' && loginId != 'null'&& loginId != '&nbsp'){
			jAlert('You do not have permission to author the content.', 'Info');		
		}else{
			jAlert('This service requires login.', 'Info');
		}
	}
}


// //새창 띄우기 (저작)
function openVideoWrite() {
	if(editUserYN == 0 && (projectUserId == loginId && projectUserId != user_id)){
		editUserYN = 1;
	}
	
	window.open('', 'video_write_page', 'width=1145, height=926');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action',"<c:url value='/geoVideo/video_write_page.do'/>?loginToken="+loginToken+"&loginId="+loginId+"&projectBoard="+projectBoard+'&editUserYN='+editUserYN+'&projectUserId='+projectUserId);
	form.setAttribute('target','video_write_page');
	document.body.appendChild(form);
	
	var insert = document.createElement('input');
	insert.setAttribute('type','hidden');
	insert.setAttribute('name','file_url');
	insert.setAttribute('value',file_url);
	form.appendChild(insert);
	
	var insertIdx = document.createElement('input');
	insertIdx.setAttribute('type','hidden');
	insertIdx.setAttribute('name','idx');
	insertIdx.setAttribute('value',idx);
	form.appendChild(insertIdx);
	
	form.submit();
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
	moveMap(time, totaltime);
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
function iframeSrcView(){
	if($('#iframeSrc').css('display') == 'none'){
		$('#iframeSrc').css('display','block');
		$('#iframeSrc').maxZIndex({inc:1});
	}else{
		$('#iframeSrc').css('display','none');
	}
}

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
 function copyFn(CopyType){
 	var copyUrlData = $('#copyUrlText').val();
 	var copyUrlStr = 'http://'+location.host + '/GeoVideo/geoVideo/video_url_viewer.do?urlData='+ copyUrlData +'&linkType='+CopyType;
 	if(CopyType == "CP4"){
 		copyUrlStr = 'http://'+location.host + '/GeoVideo/geoVideo/video_write_page.do?urlData='+ copyUrlData +'&linkType='+CopyType;
 	}
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
 
</script>

</head>

<body onload='videoViewerInit();' bgcolor='#FFF'>

<!---------------------------------------------------- 메인 영역 시작 ------------------------------------------------>

<!-- 비디오 영역 -->
<div id='video_main_area' style='position:absolute; left:0px; top:15px; width:780px; height:555px; display:block; border:1px solid #999999;'>
<!-- 	<video id='video_player' width='760' height='500' controls='true' style='position:absolute; left:10px; top:10px;'> -->
<!-- 		<source id='video_src' src='' type='video/ogg'></source> -->
<!-- 		<source src="http://localhost:8088/GeoCMS/upload/GeoVideo/aaaaa(1)_ogg.ogg" type="video/ogg" /> -->
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
<!-- 	</video> -->
	<video id='video_player0' width='760' height='460' style='position:absolute; left:10px; top:10px; border: 1px solid gray;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	
	<video id='video_player1' class='multi_class' width='380' height='230' style='position:absolute; left:10px; top:10px; border: 1px solid gray; display: none;' preload="metadata">
		<source type='video/mp4'></source>
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player2' class='multi_class' width='380' height='230' style='position:absolute; left:390px; top:10px; border: 1px solid gray; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player3' class='multi_class' width='380' height='230' style='position:absolute; left:10px; top:240px; border: 1px solid gray; display: none;' preload="metadata" >
		<source type="video/mp4" />
<!-- 		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다. -->
		Supported in HTML5-enabled browsers (Firefox 3.6 or later or Chrome).
	</video>
	<video id='video_player4' class='multi_class' width='380' height='230' style='position:absolute; left:390px; top:240px; border: 1px solid gray; display: none;' preload="metadata" >
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

<button  onclick='iframeSrcView();' style='position:absolute; left:20px; top:545px;'>Source Code</button>
<textarea id="iframeSrc" style='position:absolute; left:340px; top:565px; width:660px; height:35px; overflow-x:hidden; line-height: 17px; font-size:12px; display:none;' readonly="readonly">
</textarea>

<div id="video_obj_area" style="display:none;"></div>

<!-- 이미지 리스트 영역 -->
<div style="width:1104px; height: 195px; margin: 575px 0 0 -10px; background: #25323c;">
	<div id="image_view_group" style="color:#ffffff; font-size: 16px; position: absolute; top:567px; left:10px; width:1093px; height: 38px;"></div>
	<div id="moveSelectDiv" style="position: absolute; left:410px; top:600px; width:200px; max-height: 76px; border:1px solid #00b8b0; overflow-y:auto; display:none; color:gray;"></div>
	
	<div id='img_move_area' style='position:absolute; left:10px; top:600px; width:1093px; height:160px; display:block; overflow-y:hidden;'>
		<img src='<c:url value='/images/geoImg/viewer/next_photo_pop.png'/>' style='float:right; display: none; margin-top: 10px;cursor: pointer;' class="imgMoveBtn" onclick="moveImgList('r')"> 
		<div id='img_move_list' style='position:absolute; height:100%; left:20px; top:10px; width: 1075px; display:block;overflow-x:auto; overflow-y:hidden;'>
			<div id='img_move_list_long' style='position:absolute; height:100%; display:block;'></div>
		</div>
		<img src='<c:url value='/images/geoImg/viewer/back_photo_pop.png'/>' style='float:left; display: none; margin-top: 10px; cursor: pointer;' class="imgMoveBtn" onclick="moveImgList('l')"> 
	</div>
</div>


<!-- 추가 객체 영역 -->
<div id="ioa_title" style='position:absolute; left:800px; top:300px; width:300px; height:20px;'><img src="<c:url value='/images/geoImg/title_02.jpg'/>" alt="Add Object List"></div>
<!-- <div id='video_object_area' style='position:absolute; left:800px; top:320px; width:300px; height:200px; display:block; border:1px solid #999999; overflow-y:scroll;'> -->
<!-- 	<table id='object_table'> -->
<!-- 		<tr style='font-size:12px; height:20px;' class='col_black'> -->
<!-- 			<td width=50 class='anno_head_tr'>ID</td> -->
<!-- 			<td width=80 class='anno_head_tr'>Type</td> -->
<!-- 			<td width=170 class='anno_head_tr'>Data</td> -->
<!-- 		</tr> -->
<!-- 	</table> -->
<!-- </div> -->

<div id='video_object_area' style='position:absolute; left:800px; top:320px; width:300px; height:200px; border:1px solid #999999; display:block; font-size:13px;'>
	<div class='accordionButton col_black' style="background-color: #444444;">&nbsp;Data Info</div>
	<div class='accordionContent' style='height:157px; overflow-y:scroll;'>
		<table id='normal_exif_table'>
			<tr><td width='15'></td><td width='100'><label style='font-size:12px;'>Title</label></td><td width='150'><input id='title_text' name='text' type='text' style='font-size:12px;' readonly/></td></tr>
			<tr><td width='15'></td><td width='100'><label style='font-size:12px;'>Content</label></td><td width='150'><textarea id='content_text' name='text' style='font-size:12px;width: 144px;height: 50px;' readonly></textarea></td></tr>
			<tr><td width='15'></td><td width='100'><label style='font-size:12px;'>Sharing settings</label></td><td width='150'><input id='share_text' name='text' type='text' style='font-size:12px;' readonly/></td></tr>
			<tr><td width='15'></td><td width='100'><label style='font-size:12px;'>Drone Type</label></td><td width='150'><input id='drone_text' name='text' type='text' style='font-size:12px;' readonly/></td></tr>
		</table>
	</div>
	
	<div class='accordionButton col_black' style="background-color: #444444;">&nbsp;OBJECT DATA</div>
	<div class='accordionContent' id='video_object_area' style='height:155px; overflow-y:scroll;'>
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
<div id="ima_title"><img src="<c:url value='/images/geoImg/title_04.gif'/>" style="position:absolute; left:800px; top:12px;" alt="Map"></div>
<div id='video_map_area' style='position:absolute; left:800px; top:33px; width:300px; height:260px; display:block; background-color:#999; border:1px solid #999999;'>
	<iframe id='googlemap' src='<c:url value="/geoVideo/video_googlemap.do"/>' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
<%-- 	<div id='resize_map_btn' onclick='resizeMap();' style='position:absolute; left:0px; top:0px; width:30px; height:30px; cursor:pointer; background-image:url(<c:url value='/images/geoImg/icon_map_max.jpg'/>);'> --%>
<!-- 	</div> -->
</div>

<!-- <div style="width:1104px; height: 30px; position: absolute;top:0;left:0;"> -->
	<div id="copyUrlBtn" style="width: 70px;height: 20px;background-color: #25323c;border-radius:5px;text-align: center;position: absolute;top: 545px;left: 700px;cursor: pointer;color: #ffffff;">copy URI</div>
<!-- </div> -->
<div id="copyUrlView" class="contextMenu" style="display: none; position: absolute; width: 205px; height: 80px; background-color: rgb(228, 228, 228); left: 565px; top: 565px; border-radius: 5px; cursor: pointer;z-index:999;">
	<ul style="margin-left: -10px;">
		<li id="copyTypePhoto" onclick="copyFn('CP1');" class="copyUrlViewLi">Video URI</li>
		<li id="copyTypeMap" onclick="copyFn('CP2');" class="copyUrlViewLi">Video + Map URI</li>
		<li id="copyTypeProject" onclick="copyFn('CP3');" class="copyUrlViewLi">Video + Map + Layer URI</li>
	</ul>
</div>
<input type="hidden" id="copyUrlText">
<input type="text" id="copyUrlAll" style="position: absolute;left:30px; top: 30px; opacity:0;">

<button class="video_write_button" style="position:absolute; left:800px; top:530px; width:300px; height:35px; display:block; cursor: pointer;" onclick="videoWrite();">Edit Annotaion</button>
<!----------------------------------------------------- 메인 영역 끝 ----------------------------------------------- -->

</body>

</html>
