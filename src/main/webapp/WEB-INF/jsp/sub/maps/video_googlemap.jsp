<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>

<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAth-_FyQxRomNh2JkI_MvAWXRJuLOEXNI"></script>
<script type='text/javascript'>

/* --------------------- 내부 함수 --------------------*/
var map;

var marker;

var marker_latlng;

function init() {
	//set map option
	var myOptions = { mapTypeId: google.maps.MapTypeId.ROADMAP };
	//create map
	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

/* --------------------- 초기 설정 함수 --------------------*/

//촬영 지점 설정
function setCenter(lat, lng) {
	if(lat>0 && lng>0) { marker_latlng = new google.maps.LatLng(lat, lng); map.setZoom(16); }
	else { marker_latlng = new google.maps.LatLng(37.5663889, 126.9997222); map.setZoom(10); }
	
	var marker_image = "<c:url value='/images/geoImg/maps/video_marker.png'/>";
	
	if(marker==null) {
		marker = new google.maps.Marker({
			position: marker_latlng,
			map: map,
			title: "Center",
			icon: marker_image,
			draggable: false
		});
	}
	else {
		marker.setPosition(marker_latlng);
	}
	map.setCenter(marker_latlng);
}

function resetCenter() {
	map.setCenter(marker_latlng);
}

function moveMarker(point) {
	marker.setPosition(poly_arr[point]);
	map.setCenter(poly_arr[point]);
}

//이동 거리를 표현 (polyline)
function setDirection(poly_arr) {
	var draw_direction = new google.maps.Polyline({
		path: poly_arr,
		strokeColor: "#FF0000",
		strokeOpacity: 0.8,
		strokeWeight: 2
	});
	draw_direction.setMap(map);
}
//파일 바인드
var poly_arr;
function setGPSData(lat_arr, lng_arr) {
	poly_arr = new Array();
	if(lat_arr.length == lng_arr.length) {
		for(var i=0; i<lat_arr.length; i++) {
			poly_arr.push(new google.maps.LatLng(lat_arr[i], lng_arr[i]));
			if(i==0) setCenter(lat_arr[i], lng_arr[i]);
		}
	}
	else {
// 		jAlert('GPS 파일의 Latitude 와 Longitude 가 맞지 않습니다.', '정보');
		jAlert('Latitude and Longitude of the GPS file do not match.', 'Info');
	}
	setDirection(poly_arr);
}
</script>
</head>

<body style='margin:0px; padding:0px;' onload='init();'>
	<div id="map_canvas" style="width:100%; height:100%;"></div>
</body>
</html>
