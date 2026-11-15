
package javafile;

public class Report {

    private int id;
    private String title;
    private String name;
    private String content;
    private String latitude;
    private String longitude;
    private String status;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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

	public Report(int id, String title, String name, String content, String latitude, String longitude, String status) {
		super();
		this.id = id;
		this.title = title;
		this.name = name;
		this.content = content;
		this.latitude = latitude;
		this.longitude = longitude;
		this.status = status;

	}
	
	
    
    
    

}
