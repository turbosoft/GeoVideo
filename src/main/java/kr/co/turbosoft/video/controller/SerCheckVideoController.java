package kr.co.turbosoft.video.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class SerCheckVideoController {
	@RequestMapping(value = "/geoSetChkVideo.do", method = RequestMethod.POST)
	public void geoSetChkVideo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//setContentType À» ¸ÕÀú ¼³Á¤ÇÏ°í getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		System.out.println("SetCheckVideoServlet");
		out.print("SetCheckVideoServlet");
	}
}

