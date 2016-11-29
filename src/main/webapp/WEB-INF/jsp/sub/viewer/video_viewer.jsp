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

String idx = request.getParameter("idx");
String user_id = request.getParameter("user_id");
String file_url = request.getParameter("file_url");
String b_contentTabArr = request.getParameter("b_contentTabArr");	//contentTab array
%>

<script type="text/javascript">
var loginId = '<%= loginId %>';				// 로그인 아이디
var loginType = '<%= loginType %>';			// 로그인 타입
var loginToken = '<%= loginToken %>';		// 로그인 token

var idx = '<%= idx %>';
var user_id = '<%= user_id %>';
var b_contentTabArr = "<%=b_contentTabArr%>";	//content tab array
var request = null;		//request;
var projectBoard = 0;	//GeoCMS 연동여부		0:연동안됨, 1:연동됨

var file_url = '<%= file_url %>';
var base_url = '';
var upload_url = '';

$(function() {
	$('.video_write_button').button();
	$('.video_write_button').width(80);
	$('.video_write_button').height(25);
	$('.video_write_button').css('fontSize', 12);
	
	$('.video_setting_button').button();
	$('.video_setting_button').width(80);
	$('.video_setting_button').height(25);
	$('.video_setting_button').css('fontSize', 12);
	
	callRequest();
	
	//비디오 플레이어 이벤트 설정
	$("#video_player").bind("timeupdate", function() {
		timeUpdate(parseInt(this.currentTime), parseInt(this.duration));
	});
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
				upload_url = '/upload/GeoVideo/';
				if(loginId != null && loginId != '' && ((loginId == user_id && loginType != 'WRITE') || loginType == 'ADMIN' || (user_id == null || user_id == '' || user_id == 'null'))){
					$('.video_write_button').parent().css('display', 'block');
				}
			}else{
				base_url = '<c:url value="/"/>';
				upload_url = '/upload/';
				$('.video_write_button').parent().css('display', 'block');
			}
		}
	}
}

function videoViewerInit() {
// 	//비디오 설정
	changeVideo();
// 	//GPX or KML 데이터 설정
	loadGPS();
// 	//XML 데이터 설정
	loadXML();
}

function changeVideo() {
	var video = document.getElementById('video_player');
	video.src = base_url + upload_url + file_url;
	video.load();
}

/* map_start ----------------------------------- 맵 설정 ------------------------------------- */
var gps_size;
function loadGPS() {
	var buf = file_url.split('.');
	var xml_file_name = buf[0] + '.gpx';
// 	for(var i=0; i<buf.length-1; i++) {
// 		if(i==buf.length-2) file_name += buf[i] + '.gpx';
// 		else file_name += buf[i] + '.';
// 	}
	
	var lat_arr = new Array(); var lng_arr = new Array();
	$.ajax({
		type: "GET",
		url: base_url + upload_url + xml_file_name,
		dataType: "xml",
		cache: false,
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
			//KML 파일 처리
			$('#googlemap').get(0).contentWindow.setCenter(0, 0, 1);
		}
	});
	
}

/* map_start ----------------------------------- 맵 버튼 설정 ------------------------------------- */
function reloadMap(type) {
	var arr = readMapData();
// 	$('#googlemap').get(0).contentWindow.setCenter(arr[0], arr[1], 1);
	if(type==2) { $('#googlemap').get(0).contentWindow.setAngle(arr[2], arr[3]); }
}

readMapData = function() {
	var direction_str = $('#gps_direction_text').val();
	var lon_text = $('#lon_text').val();
	var lat_text = $('#lat_text').val();
	var focal_str = $('#focal_text').val();
	
	var buf_arr = new Array();
	buf_arr.push(lat_text);
	buf_arr.push(lon_text);
	buf_arr.push(direction_str);
	buf_arr.push(focal_str);
	return buf_arr;
};

//맵 크기 조절
var resize_map_state = 1;
var resize_scale = 150;
var init_map_left, init_map_top, init_map_width, init_map_height;
function resizeMap() {
	if(resize_map_state==1) {
		init_map_left = 800;
		init_map_top = 295;
		init_map_width = $('#video_map_area').width();
		init_map_height = $('#video_map_area').height();
		resize_map_state=2;
		$('#video_map_area').animate({left:init_map_left-resize_scale, top:init_map_top-resize_scale, width:init_map_width+resize_scale, height:init_map_height+resize_scale},"slow", function() {  $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_min.jpg"/>)'); reloadMap(1); });
	}
	else if(resize_map_state==2) {
		resize_map_state=1;
		$('#video_map_area').animate({left:init_map_left, top:init_map_top, width:init_map_width, height:init_map_height},"slow", function() {  $('#resize_map_btn').css('background-image','url(<c:url value="/images/geoImg/icon_map_max.jpg"/>)'); reloadMap(1); });
	}
	else {}
}

//저작
function videoWrite() {
	jConfirm('뷰어를 닫고 저작을 수행하시겠습니까?', '정보', function(type){
		if(type) {
			//뷰어 닫기 수행
			jQuery.FrameDialog.closeDialog();	//뷰어 닫기
			openVideoWrite();
		}
	});
}

//뷰어에서 호출되는 다이얼로그 닫기 기능
// function closeVideoViewer() {
// 	//강제로 페이지 이동 시키며 뷰어 닫기
// 	location.href = '/GeoVideo'; 
// }

// //새창 띄우기 (저작)
function openVideoWrite() {
// 	var conv_full_url = encodeURIComponent(full_url);
	
	window.open('', 'video_write_page', 'width=1145, height=926');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action',"<c:url value='/geoVideo/video_write_page.do'/>?loginToken="+loginToken+"&loginId="+loginId+"&projectBoard="+projectBoard);
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
	
	var insertContentArr = document.createElement('input');
	insertContentArr.setAttribute('type','hidden');
	insertContentArr.setAttribute('name','b_contentTabArr');
	insertContentArr.setAttribute('value',b_contentTabArr);
	form.appendChild(insertContentArr);
	
	form.submit();
}

var thX;
var thY;
function loadXML() {
	var file_arr = file_url.split(".");   		
	var xml_file_name = file_arr[0] + '.xml'; 
	
	$.ajax({
		type: "GET",
		url: base_url + upload_url + xml_file_name,
		dataType: "xml",
		cache: false,
		success: function(xml) {
			jAlert('객체 정보를 로드 합니다.', '정보');
			var max_top = 0;
			$(xml).find('obj').each(function(index) {
				var frameline = $(this).find('frameline').text();
				if(max_top < parseInt(frameline)) max_top = parseInt(frameline);
			});
			var max_line = max_top / 25
// 			for(var i=0; i<max_line; i++) { createFrameLine(2); }
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
// 					obj.parent().position().top = top;
// 					obj.parent().position().left = left;
// 					var leftX = left/590 * 780;
// 					var topY = top/360 * 580;
// 					obj.parent().attr('style', 'overflow: hidden; position: absolute; width:'+width+'; height:'+height+'; top:'+top+'px; left:'+left+'px; margin:0px;');
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
// 					$('#geometry_line_color').val(line_color);
// 					$('#geometry_bg_color').val(bg_color);
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
// 		left = Math.floor(left*(760/570));
// 		top = Math.floor(top*(500/340));
		createCaption(id, font_size, font_color, bg_color, bold, italic, underline, href, text);
		var obj = $('#'+auto_caption_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
	else if(id == "b") {
		text = text.replace(/@line@/g, "\r\n");
		
// 		left = Math.floor(left*(760/570));
// 		top = Math.floor(top*(500/340));
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
	if(font_size=='H3') html_text = '<font id="f'+auto_caption_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_caption_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_caption_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
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
// 	div_element.dblclick(function() { inputCaption(div_element.attr('id'), text); }); 
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
	if(font_size=='H3') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
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
// 	div_element.dblclick(function() { inputBubble(div_element.attr('id'), text); });
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
// 	$('#'+img_element.attr('id')).resizable().parent().draggable();
// 	$('#'+img_element.attr('id')).contextMenu('context2', {
// 		bindings: {
// 			'context_delete': function(t) {
// 				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); });
// 			}
// 		}
// 	});
	
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
// 	left = left/590 * 780;
// 	top = top/360 * 580;
	//
	var left_str = $('#video_player').css('left'); var top_str = $('#video_player').css('top');
	var left_offset = parseInt(left_str.replace('px','')); var top_offset = parseInt(top_str.replace('px',''));
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
	
// 	left = left/590 * 780;
// 	top = top/360 * 580;
// 	canvas.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	
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

// 	var top = $('#video_obj_line').css('top');
// 	top = top.replace('px','');
// 	createFrameObj(obj_str, 0, parseInt(top), 100, obj_text);
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
	$('#googlemap').get(0).contentWindow.moveMarker(parseInt(ratio));
}

/* util_start ----------------------------------- Util ------------------------------------- */
hex_to_decimal = function(hex) {
	return Math.max(0, Math.min(parseInt(hex, 16), 255));
};
css3color = function(color, opacity) {
	if(color.length==3) { var c1, c2, c3; c1 = color.substring(0, 1); c2 = color.substring(1, 2); c3 = color.substring(2, 3); color = c1 + c1 + c2 + c2 + c3 + c3; }
	return 'rgba('+hex_to_decimal(color.substr(0,2))+','+hex_to_decimal(color.substr(2,2))+','+hex_to_decimal(color.substr(4,2))+','+opacity+')';
};

</script>

</head>

<body onload='videoViewerInit();' bgcolor='#FFF'>

<!---------------------------------------------------- 메인 영역 시작 ------------------------------------------------>

<!-- 비디오 영역 -->
<div id='video_main_area' style='position:absolute; left:10px; top:15px; width:780px; height:580px; display:block; border:1px solid #999999;'>
	<video id='video_player' width='760' height='500' controls='true' style='position:absolute; left:10px; top:10px;'>
		<source id='video_src' src='' type='video/ogg'></source>
		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다.
	</video>
</div>

<textarea style='position:absolute; left:20px; top:540px; width:760px; height:35px; line-height: 20px;' readonly="readonly">
<iframe width='760' height='500' src='http://turbosoft1.iptime.org:2125/GeoVideo/upload/a1_ogg.ogg' frameborder='0' allowfullscreen></iframe>
</textarea>
<%-- <input type="text" value="<iframe width='760' height='500' src='http://turbosoft1.iptime.org:2125/GeoVideo/upload/a1_ogg.ogg' frameborder='0' allowfullscreen></iframe>" --%>
<!-- 	style='position:absolute; left:10px; top:530px; width:778px;'/> -->

<div id="video_obj_area" style="display:none;"></div>

<!-- 추가 객체 영역 -->
<div id="ioa_title" style='position:absolute; left:797px; top:12px; width:330px; height:245px;'><img src="<c:url value='/images/geoImg/title_02.jpg'/>" alt="객체추가리스트"></div>
<div id='video_object_area' style='position:absolute; left:800px; top:33px; width:300px; height:230px; display:block; border:1px solid #999999; overflow-y:scroll;'>
	<table id='object_table'>
		<tr style='font-size:12px; height:20px;' class='col_black'>
			<td width=50 class='anno_head_tr'>ID</td>
			<td width=80 class='anno_head_tr'>Type</td>
			<td width=170 class='anno_head_tr'>Data</td>
		</tr>
	</table>
</div>

<!-- 지도 영역 -->
<div id="ima_title"><img src="<c:url value='/images/geoImg/title_04.gif'/>" style="position:absolute; left:800px; top:272px;" alt="지도"></div>
<div id='video_map_area' style='position:absolute; left:800px; top:295px; width:300px; height:260px; display:block; background-color:#999; border:1px solid #999999;'>
	<iframe id='googlemap' src='<c:url value="/geoVideo/video_googlemap.do"/>' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
	<div id='resize_map_btn' onclick='resizeMap();' style='position:absolute; left:0px; top:0px; width:30px; height:30px; cursor:pointer; background-image:url(<c:url value='/images/geoImg/icon_map_max.jpg'/>);'>
	</div>
</div>

<!----------------------------------------------------- 메인 영역 끝 ----------------------------------------------- -->

<!-- 저작 버튼 -->
<div style='position:absolute; left:920px; top:570px; display:none;'>
	<button class='video_write_button' onclick='videoWrite();'>Write</button>
</div>

</body>

</html>
