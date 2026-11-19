
package javafile;

public class Report {

    private int report_id; //게시물 번호
    private String title; //게시물 제목
    private String user_name; //작성자 이름
    private String content; //내용
    private String latitude; //위도
    private String longitude; //경도
    private String status; //신고상태 --접수나 해결완료
    private String reg_date; // 작성시간
    private int admin_no; //담당 관리자
    
    
    
	public int getReport_Id() {
		return report_id;
	}
	public void seReport_Id(int report_id) {
		this.report_id = report_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getUser_Name() {
		return user_name;
	}
	public void setUser_Name(String user_name) {
		this.user_name = user_name;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	
	
	
	public int getAdmin_no() {
		return admin_no;
	}
	public void setAdmin_no(int admin_no) {
		this.admin_no = admin_no;
	}

	public Report(int report_id, 
			String title, 
			String user_name, 
			String content, 
			String latitude, 
			String longitude, 
			String status, 
			String reg_date, 
			int admin_no) 
	{
		super();
		this.report_id = report_id;
		this.title = title;
		this.user_name = user_name;
		this.content = content;
		this.latitude = latitude;
		this.longitude = longitude;
		this.status = status;
		this.reg_date = reg_date;
		this.admin_no = admin_no;

	}
	
	
    
    
    

}
