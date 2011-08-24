package org.herac.tuxguitar.io.guitarduino;

import java.util.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.herac.tuxguitar.app.TuxGuitar;
import org.herac.tuxguitar.app.system.config.TGConfigManager;
import org.herac.tuxguitar.app.system.plugins.TGPluginConfigManager;
import org.herac.tuxguitar.app.util.DialogUtils;

public class GDPSettingsUtil {
	
	public static final String KEY_PORT = "Port";
	
	private List ports;
	
	private static GDPSettingsUtil instance;
	
	private TGConfigManager config;
	
	private GDPSettings settings;
	
	private GDPSettingsUtil(){
		this.settings = new GDPSettings();
		System.out.println("settingsutil ctor");
		load();
	}
	
	public static GDPSettingsUtil instance(){
		if( instance == null ){
			instance = new GDPSettingsUtil();
		}
		return instance;
	}
	
	public GDPSettings getSettings(){
		return this.settings;
	}
	
	public TGConfigManager getConfig(){
		if(this.config == null){ 
			this.config = new TGPluginConfigManager("tuxguitar-gdp");
			this.config.init();
		}
		return this.config;
	}
	
	public void load(){
		System.out.println("settings load()");
		String portDefault = getConfig().getStringConfigValue(KEY_PORT, GDPSettings.DEFAULT_SERIAL_PORT);
		System.out.println("load() port: " + portDefault);
		this.settings.setPort(portDefault );
	}
	
	public void configure(Shell parent) {
			
		final Shell dialog = DialogUtils.newDialog(parent, SWT.DIALOG_TRIM | SWT.APPLICATION_MODAL);
		dialog.setLayout(new GridLayout());
		dialog.setText(TuxGuitar.getProperty("gdp.settings.title"));
		
		//------------------DEVICE-----------------------
		Group group = new Group(dialog,SWT.SHADOW_ETCHED_IN);
		group.setLayout(new GridLayout(2,false));
		group.setLayoutData(new GridData(SWT.FILL,SWT.FILL,true,true));
		group.setText(TuxGuitar.getProperty("gdp.settings.port.tip"));
		
		final Label label = new Label(group,SWT.LEFT);
		label.setText(TuxGuitar.getProperty("gdp.settings.port.select") + ":");
		
		final Combo value = new Combo(group,SWT.DROP_DOWN | SWT.READ_ONLY);
		value.setLayoutData(new GridData(250,SWT.DEFAULT));
		for(int i = 0 ; i < ports.size(); i ++){
			String port = (String)ports.get(i);
			value.add( port );
			if(port.equals(this.settings.getPort())){
				value.select( i );
			}
		}
		
		//------------------BUTTONS--------------------------
		Composite buttons = new Composite(dialog, SWT.NONE);
		buttons.setLayout(new GridLayout(2,false));
		buttons.setLayoutData(new GridData(SWT.END,SWT.FILL,true,true));
		
		GridData data = new GridData(SWT.FILL,SWT.FILL,true,true);
		data.minimumWidth = 80;
		data.minimumHeight = 25;
		
		final Button buttonOK = new Button(buttons, SWT.PUSH);
		buttonOK.setText(TuxGuitar.getProperty("ok"));
		buttonOK.setLayoutData(data);
		buttonOK.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(SelectionEvent arg0) {
				int selection = value.getSelectionIndex();
				if(selection >= 0 && selection < ports.size() ){
					TGConfigManager config = getConfig();
					config.setProperty(KEY_PORT, (String)ports.get(selection));
					config.save();
					load();
				}
				dialog.dispose();
			}
		});
		
		Button buttonCancel = new Button(buttons, SWT.PUSH);
		buttonCancel.setText(TuxGuitar.getProperty("cancel"));
		buttonCancel.setLayoutData(data);
		buttonCancel.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(SelectionEvent arg0) {
				dialog.dispose();
			}
		});
		
		dialog.setDefaultButton( buttonOK );
		
		DialogUtils.openDialog(dialog,DialogUtils.OPEN_STYLE_CENTER | DialogUtils.OPEN_STYLE_PACK | DialogUtils.OPEN_STYLE_WAIT);
	}
	
	public void  setAvailablePorts(List av_ports){
		this.ports = av_ports;
	}
	
	
}
