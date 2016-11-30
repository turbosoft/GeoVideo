package kr.co.turbosoft.video.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.co.turbosoft.video.util.XMLRW;

@Controller
public class XMLController {
	@RequestMapping(value = "/geoXml.do", method = RequestMethod.POST)
	public void geoVideoXml(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String[] buf = request.getParameter("file_name").split("\\/");
		String file_name = buf[2];
		String xml_data = request.getParameter("xml_data");
		
		String file_dir = request.getSession().getServletContext().getRealPath("/")+"upload\\";
		
		String result = "";
		XMLRW xmlRW = new XMLRW();
		result = xmlRW.write(file_dir, file_name, xml_data);
		System.out.println(result);
		
		//setContentType �� ���� �����ϰ� getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(result);
		
	}
}
