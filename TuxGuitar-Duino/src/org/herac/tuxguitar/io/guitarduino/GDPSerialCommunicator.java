package org.herac.tuxguitar.io.guitarduino;

import gnu.io.*;
//import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.TooManyListenersException;
import java.lang.System.*;

public class GDPSerialCommunicator implements SerialPortEventListener {

	//for containing the ports that will be found
    private List ports = new ArrayList();
    //map the port names to CommPortIdentifiers
    private HashMap portMap = new HashMap();

    //this is the object that contains the opened port
    private CommPortIdentifier selectedPortIdentifier = null;
    private SerialPort serialPort = null;

    //input and output streams for sending and receiving data
    private InputStream input = null;
    private OutputStream output = null;

    //just a boolean flag that i use for enabling
    //and disabling buttons depending on whether the program
    //is connected to a serial port or not
    private boolean bConnected = false;

    //the timeout value for connecting with the port
    final static int TIMEOUT = 5000;
	final static int DATA_RATE = 9600;
    
    //some ascii values for for certain things
    final static int SPACE_ASCII = 32;
    final static int DASH_ASCII = 45;
    final static int NEW_LINE_ASCII = 10;

    String logText = "";
    String selectedPort = ""; 

    public GDPSerialCommunicator() {
    	searchForPorts();
    	GDPSettingsUtil.instance().setAvailablePorts(this.ports);
    }

    public void searchForPorts()
    {
    	String fp = File.pathSeparator;
    	String tmpl = "/dev/ttyACM0";
    	tmpl += fp + "/dev/ttyUSB0";
    	tmpl += fp + "/dev/ttyUSB1";
    	tmpl += fp + "/dev/ttyACM1";
    	// podria hacerse segun SO
    	// Acordarse de poner los puertos de windows y mac COM1..5 etc 
    	//XXX acordarse de sacar los pts! 
    	tmpl += fp + "/dev/pts/1";
    	tmpl += fp + "/dev/pts/6";
    	tmpl += fp + "/dev/pts/7";
    	tmpl += fp + "/dev/pts/8";

    	System.clearProperty("gnu.io.rxtx.SerialPorts");
    	fillPortList();
    	//Ignora los puertos del SO si hacemos esto antes:
    	System.setProperty("gnu.io.rxtx.SerialPorts", tmpl);
    	fillPortList();
    }
    
    private void fillPortList(){
    	Enumeration portsIds = CommPortIdentifier.getPortIdentifiers();

        while (portsIds.hasMoreElements())
        {
            CommPortIdentifier curPort = (CommPortIdentifier)portsIds.nextElement();
            if (curPort.getPortType() == CommPortIdentifier.PORT_SERIAL) {
            	this.ports.add(curPort.getName());
            	this.portMap.put(curPort.getName(), curPort);
            }
        }
	}

    public List getPorts() {
    	return this.ports;
    }
    
    
    //connect to the selected port in the combo box
    //pre: ports are already found by using the searchForPorts method
    //post: the connected comm port is stored in commPort, otherwise,
    //an exception is generated
    public void connect()
    {
    	this.selectedPort = GDPSettingsUtil.instance().getSettings().getPort();
//        selectedPortIdentifier = (CommPortIdentifier)portMap.get(this.selectedPort);
    	
        try
        {
        	selectedPortIdentifier = CommPortIdentifier.getPortIdentifier(this.selectedPort);
            //the CommPort object can be casted to a SerialPort object
            serialPort = (SerialPort)selectedPortIdentifier.open(this.getClass().getName(), TIMEOUT);
            setConnected(true);
            serialPort.setSerialPortParams(DATA_RATE, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
            //logging
            logText = this.selectedPort + " opened successfully.";
            System.out.println(logText);
         // Espero por las dudas a que levante el Arduino
            Thread.sleep(2000);  
        }
        catch (PortInUseException e)
        {
            logText = selectedPort + " is in use. (" + e.toString() + ")";
            System.out.println(logText);
            
        }
        catch (Exception e)
        {
            logText = "Failed to open " + this.selectedPort + "(" + e.toString() + ")";
            System.out.println(logText);

        }
    }

    //open the input and output streams
    //pre: an open port
    //post: initialized intput and output streams for use to communicate data
    public boolean initIOStream()
    {
        //return value for whather opening the streams is successful or not
        boolean successful = false;

        try {
            //
            input = serialPort.getInputStream();
            output = serialPort.getOutputStream();
            //writeData(0);
            
            successful = true;
            return successful;
        }
        catch (IOException e) {
            logText = "I/O Streams failed to open. (" + e.toString() + ")";
            System.out.println(logText);

            return successful;
        }
    }

    //starts the event listener that knows whenever data is available to be read
    //pre: an open serial port
    //post: an event listener for the serial port that knows when data is recieved
    public void initListener()
    {
        if(serialPort == null){
        	return;
        }

    	try
        {
            serialPort.addEventListener(this);
            serialPort.notifyOnDataAvailable(true);
        }
        catch (TooManyListenersException e)
        {
            logText = "Too many listeners. (" + e.toString() + ")";
            System.out.println(logText);
        }
    }

    //disconnect the serial port
    //pre: an open serial port
    //post: clsoed serial port
    public void disconnect()
    {
        //close the serial port
    	if (serialPort == null ) {
    		System.out.println("disconect() port es null");
    		setConnected(false);
    		return;
    	}
    	
        try
        {
            writeData('N');
            writeData(SPACE_ASCII);

            serialPort.removeEventListener();
            serialPort.close();
            input.close();
            output.close();
            serialPort = null;
            setConnected(false);

            logText = "Disconnected.";
            System.out.println(logText);
        }
        catch (Exception e)
        {
            logText = "Failed to close " + serialPort.getName() + "(" + e.toString() + ")";
            System.out.println(logText);
        }
    }

    public void reconnect() {
    	disconnect();
    	searchForPorts();
    	connect();
    	if (getConnected()){
    		initIOStream();
    		initListener();
    	}
    }

    final public boolean getConnected()
    {
        return bConnected;
    }

    public void setConnected(boolean bConnected)
    {
        this.bConnected = bConnected;
    }

    //what happens when data is received
    //pre: serial event is triggered
    //post: processing on the data it reads
    public void serialEvent(SerialPortEvent evt) {
        
    	if (evt.getEventType() == SerialPortEvent.DATA_AVAILABLE)
        {
    		try
            {
                byte singleData = (byte)input.read();

                if (singleData != NEW_LINE_ASCII)
                {
                    logText = new String(new byte[] {singleData});
                    System.out.println(logText);
                }
                else
                {
                    System.out.println("");
                }
            }
            catch (Exception e)
            {
                logText = "Failed to read data. (" + e.toString() + ")";
                System.out.println(logText);
            }
        }
        
    }

    
    public void flush() {
    	try {
    	output.flush();
    	}
    	catch (IOException e) {
        	reconnect();
        }
        catch (Exception e)
        {
            logText = "Failed to flush data. (" + e.toString() + ")";
            System.out.println(logText);
        }
    }
    //method that can be called to send data
    //pre: open serial port
    //post: data sent to the other device
    public void writeData(int data)
    {
    	if (!bConnected) {
    		System.out.println("XXX writeData() no connected");
    		reconnect();
    		return;
    	}
    
        try
        {
        	output.write(data);
            //output.flush();
            //Thread.sleep(100);
            System.out.println("Escribe " + data + " via serie");
           
        }
        catch (IOException e) {
        	reconnect();
        }
        catch (Exception e)
        {
            logText = "Failed to write data. (" + e.toString() + ")";
            System.out.println(logText);
        }
    }
}

