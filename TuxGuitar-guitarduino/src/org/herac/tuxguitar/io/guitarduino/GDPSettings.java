package org.herac.tuxguitar.io.guitarduino;

public class GDPSettings {
	
	public static final String DEFAULT_SERIAL_PORT = "/dev/ttyACM0";
	
	private String port;
	
	public GDPSettings(){
		// por defecto podria ser segun SO
		this.port = DEFAULT_SERIAL_PORT;
		System.out.println("Setting ctor");
	}
	
	public String getPort() {
		return this.port;
	}
	
	public void setPort(String port) {
		this.port = port;
	}
}
