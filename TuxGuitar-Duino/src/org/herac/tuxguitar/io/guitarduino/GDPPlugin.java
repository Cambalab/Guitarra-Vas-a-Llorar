package org.herac.tuxguitar.io.guitarduino;

import java.util.Iterator;

import org.eclipse.swt.widgets.Shell;

import org.herac.tuxguitar.app.TuxGuitar;
import org.herac.tuxguitar.app.transport.TGTransport;
import org.herac.tuxguitar.app.transport.TGTransportListener;
import org.herac.tuxguitar.player.base.MidiPlayerListener;

import org.herac.tuxguitar.app.editors.TGExternalBeatViewerListener;
import org.herac.tuxguitar.app.editors.TGRedrawListener;
import org.herac.tuxguitar.app.editors.TGUpdateListener;

import org.herac.tuxguitar.app.system.plugins.TGPluginSetup;
import org.herac.tuxguitar.app.system.plugins.base.TGPluginAdapter;
import org.herac.tuxguitar.song.models.TGBeat;
import org.herac.tuxguitar.song.models.TGNote;
import org.herac.tuxguitar.song.models.TGVoice;



public class GDPPlugin extends TGPluginAdapter implements TGPluginSetup, TGExternalBeatViewerListener, TGRedrawListener, TGUpdateListener {
	private int beatIdx = 0;
	
	private TGBeat beat;
	private TGBeat externalBeat;
		
	private GDPSerialCommunicator serial;
	
	public GDPPlugin() {
	}
	
	public void init() {
		TuxGuitar.instance().getEditorManager().addBeatViewerListener(this);
		TuxGuitar.instance().getEditorManager().addRedrawListener(this);
		TuxGuitar.instance().getEditorManager().addUpdateListener(this);
			
		//this.composite.addPaintListener(this);
		//TuxGuitar.instance().getkeyBindingManager().appendListenersTo(this.composite);
		//TuxGuitar.instance().getTransport()
		System.out.println("guitarduino init");
		
		this.serial = new GDPSerialCommunicator();
        this.serial.connect();
        if (this.serial.getConnected() == true) {
                if (this.serial.initIOStream() == true) {
                        this.serial.initListener();
                }
        }
	}
	
	public void close() {
		if (serial != null) {
			this.serial.disconnect();
		}
	}
	
	public void setEnabled(boolean enabled) {
		
	}
	
	public void setupDialog(Shell parent) {
		GDPSettingsUtil.instance().configure(parent);
	}
	
	public String getAuthor() {
		return "Crear - Arte y Tecnologia - http://elarteylatecnologia.com.ar";
	}
	
	public String getName() {
		return "Guitarduino Link";
	}
	
	public String getDescription() {
		return "Guitarduino Link";
	}
	
	public String getVersion() {
		return "1.0";
	}
	
	public void hideExternalBeat() {
	
	}
	
	public void showExternalBeat(TGBeat beat) {
		System.out.println("showExternalBeat()");
	}
	
	private void setBeat(){
		if(TuxGuitar.instance().getPlayer().isRunning()){
			this.beat = TuxGuitar.instance().getEditorCache().getPlayBeat();
		}else if(this.externalBeat != null){
			//vienen de la entrada midi.
			//this.beat = this.externalBeat;
		}else{
			this.beat = TuxGuitar.instance().getEditorCache().getEditBeat();
		}
	}
	
	public void doRedraw(int type) {
		if( type == TGRedrawListener.NORMAL ){
//
		}else if( type == TGRedrawListener.PLAYING_NEW_BEAT ){
			//System.out.println("doRedraw() BEAT");
		}
		setBeat();
		this.dumpBeats(this.beat);
	}
	
	public void doUpdate(int type) {
		//System.out.println("doUpdate()");
		setBeat();
		dumpBeats(this.beat);
	}
	
	public void notifyStarted() {
		
	}
	
	public void notifyStopped() {
		
	}
	
	public void notifyLoop() {
		
	}
	
	
	
	private void dumpBeats(TGBeat beat) {
		long[] ledArray =  {}; //18 bytes, 3 por cuerda
		long pows[] = { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 
				8192, 16384, 32768, 65536, 131072, 262144, 
				524288, 1048576, 2097152, 4194304, 8388608};
 		boolean muestro = false;
		if (beat == null){
			return;
		}
		System.out.println("BEAT idx = " + this.beatIdx);

        //tercero de 17 a 21, segundo byte del 16-9, tercer byte de 8-1 (aire)
        ledArray = new long[] { 0,0,0,0,0,0};

		for(int v = 0; v < beat.countVoices(); v ++){
			TGVoice voice = beat.getVoice( v );
			Iterator it = voice.getNotes().iterator();
			while (it.hasNext()) {
				TGNote note = (TGNote) it.next();
				int fretIndex = note.getValue();
				int stringIndex = note.getString() - 1;
				System.out.println("cuerda " + stringIndex + " traste " + fretIndex );
					ledArray[stringIndex] += pows[(fretIndex)]; 
			}
        }
		if (serial != null) {
            this.serial.writeData('N'); //N ascii char
            for(int i = (ledArray.length-1); i>=0; i--) {
                this.serial.writeData((int)((ledArray[i]>>16) & 0xff)); // highbyte
                this.serial.writeData((int)((ledArray[i]>>8) & 0xff)); // midbyte
                this.serial.writeData((int)(ledArray[i] & 0xff)); //lowbyte
            }
            //this.serial.writeData(GDPSerialCommunicator.NEW_LINE_ASCII);
            this.serial.flush();
        }


		this.beatIdx++;
	}
	
		
}
