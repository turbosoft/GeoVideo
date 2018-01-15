package kr.co.turbosoft.video.util;

import java.io.File;
import java.io.PrintWriter;

public class XMLRW {
	public String write(String file_dir, String file_name, String xml_data) {
		String result = "";
		String[] file_name_arr = file_name.split("\\.");
		
		File xml_file = new File(file_dir+file_name_arr[0]+".xml");
		PrintWriter printWriter = null;
		try {
			printWriter = new PrintWriter(xml_file);
			printWriter.println(xml_data);
			printWriter.flush();
			result = "XML_SAVE_SUCCESS";
		}catch(Exception e) { e.printStackTrace(); result = "XML ���忡 �����Ͽ����ϴ�. �����ڿ��� �����Ͽ� �ּ���."; }
		
		return result;
	}
}
