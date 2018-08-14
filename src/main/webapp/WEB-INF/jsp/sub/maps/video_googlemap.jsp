<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>

<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAth-_FyQxRomNh2JkI_MvAWXRJuLOEXNI&v=3.exp&sensor=false&libraries=places,geometry&language=en&region=ER"></script>
<script type='text/javascript'>

/* --------------------- 내부 함수 --------------------*/
var map;

var marker;

var marker_latlng;

var vDMarkerLat = 0;		//default marker latitude
var vDMarkerLng = 0;		//default marker longitude
var vDMapZoom = 10;		//defalut map zoom

function init() {
	if(map == null){
		//set map option
		var myOptions = { mapTypeId: google.maps.MapTypeId.ROADMAP };
		//create map
		map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	}
}

//base map setting
function setDefaultData(dMarkerLat, dMarkerLng, dMapZoom){
	vDMarkerLat = dMarkerLat;
	vDMarkerLng = dMarkerLng;
	vDMapZoom = dMapZoom;
}

/* --------------------- 초기 설정 함수 --------------------*/

//촬영 지점 설정
function setCenter(lat, lng) {
	if(lat!=0 && lng!=0) {
		marker_latlng = new google.maps.LatLng(lat, lng); map.setZoom(16);
	}else {
		if(vDMarkerLat == null || vDMarkerLat == ""){
			vDMarkerLat = 37.5663889;
    	}
    	if(vDMarkerLng == null || vDMarkerLng == ""){
    		vDMarkerLng = 126.9997222;
    	}
		marker_latlng = new google.maps.LatLng(vDMarkerLat, vDMarkerLng);
		map.setZoom(vDMapZoom);
	}
	
	var marker_image = "<c:url value='/images/geoImg/maps/video_marker.png'/>";
	var marker_image2 = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";
	if(marker == null) {
		marker = new google.maps.Marker({
			position: marker_latlng,
			map: map,
			title: "Center",
			icon: marker_image,
			draggable: false
		});
	}
	else
	{
		marker.setPosition(marker_latlng);
	}
	console.log(marker_latlng  + ' lat : ' + lat + " lng : " + lng);
	map.setCenter(marker_latlng);
}

function resetCenter() {
	map.setCenter(marker_latlng);
}

function moveMarker(point) {
	if(isNaN(point)){
		return;
	}
	if(point > poly_arr.length-1){
		point = poly_arr.length-1;
	}
	marker.setPosition(poly_arr[point]);
	map.setCenter(poly_arr[point]);
}

//이동 거리를 표현 (polyline)
function setDirection(poly_arr) {
	console.log(poly_arr);
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
			if(i == 0) {
				setCenter(lat_arr[i], lng_arr[i]);
			}
		}
	}
// 	else { jAlert('GPS 파일의 Latitude 와 Longitude 가 맞지 않습니다.', '정보'); }
	else { jAlert('The Latitude and Longitude of the GPS file do not match.', 'Info'); }
	setDirection(poly_arr);
}


function abcde(lat_arr, lng_arr){
	for(var i=0; i<lat_arr.length; i++) {
		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(lat_arr[i], lng_arr[i]),
			map: map,
			title: "Center",
			icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
			draggable: false
		});
	}
}
</script>
</head>

<body style='margin:0px; padding:0px;' onload='init();'>
	<div id="map_canvas" style="width:100%; height:100%;"></div>
</body>
</html>
