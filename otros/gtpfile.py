# Version original de https:/github.com/yole/gtpdiff.git
import os, struct

def read_pstring(f):
    length = ord(f.read(1))
    return f.read(length)

class GTPNote:
    def __init__(self):
        self.fret = None
        self.string = None
        self.duration = None
        self.hammer = False
        self.slide = False

    def __str__(self):
        result = "note("
        if self.fret is not None:
            result += "string=%s fret=%s" % (self.string, self.fret)
        return result + ")"

class GTPBeat:
    def __init__(self):
        self.notes = []
        self.dotted = False

    def note_at_string(self, string):
        """
        :type string: int
        :rtype: GTPNote
        """
        for note in self.notes:
            if note.string == string: return note

class GTPBar:
    def __init__(self):
        self.beats = []

    def shortest_beat(self):
        """
        :return: the length of the shortest beat in this bar
        :rtype: int
        """
        min_duration = -2
        for beat in self.beats:
            if beat.duration > min_duration:
                min_duration = beat.duration
        return min_duration

class GTPTrack:
    def __init__(self):
        self.bars = []
        self.strings = 0
        self.string_pitches = []

class GTPFile:
    def __init__(self):
        self.title = None
        self.subtitle = None
        self.interpret = None
        self.notice = []
        self.tracks = []

    def find_track(self, name):
        for t in self.tracks:
            if t.name == name: return t


class GTPLoader:
    def load(self, f):
        self.file = f
        f.seek(0x1f)
        self.result = GTPFile()
        self.load_header(f, self.result)
        bar_count = self.long()
        track_count = self.long()
        self.load_bar_info(bar_count)
        self.load_track_info(track_count)
        for b in range(bar_count):
            self.current_bar = b
            for t in self.result.tracks:
                self.current_track = t
                self.load_bar(t)
        return self.result

    def skip(self, bytes):
        self.file.seek(bytes, os.SEEK_CUR)

    def byte(self):
        return ord(self.file.read(1))

    def sbyte(self):
        return struct.unpack("b", self.file.read(1))[0]

    def long(self):
        return struct.unpack("i", self.file.read(4))[0]

    def string(self, full_length):
        length = ord(self.file.read(1))
        result = self.file.read(length)
        self.skip(full_length-length)
        return result

    def long_string(self):
        l1, l2 = struct.unpack("IB", self.file.read(5))
        s = self.file.read(l1-1)
        return s[:l2]

    def load_header(self, f, result):
        """
        :param f: file
        :type f: file
        """
        result.title = self.long_string()
        result.subtitle = self.long_string()
        result.interpret = self.long_string()
        result.album = self.long_string()
        result.author = self.long_string()
        result.copyright = self.long_string()
        result.tablature_author = self.long_string()
        result.description = self.long_string()
        notice_lines = self.long()
        for i in range(notice_lines):
            result.notice.append(self.long_string())
        result.triplet_feel = self.byte()
        self.load_lyrics()
        result.tempo = self.long()
        self.load_header2()
        f.seek(64*12, os.SEEK_CUR)

    def load_header2(self):
        self.skip(4)

    def load_lyrics(self):
        pass

    def load_bar_info(self, bar_count):
        for i in range(bar_count):
            flags = self.byte()
            if flags & 1:
                t1 = self.byte()
            if flags & 2:
                t2 = self.byte()
            if flags & 8:
                repeat_count = self.byte()
            if flags & 16:
                alternative_ending = self.byte()
            if flags & 32:
                marker_name = self.long_string()
                marker_color = self.long()
            if flags & 64:
                key = self.byte()
                k2 = self.byte()

    def load_track_info(self, track_count):
        for i in range(track_count):
            flags = self.byte()
            track = GTPTrack()
            track.name = self.string(40)
            track.strings = self.long()
            for i in range(track.strings):
                track.string_pitches.append(self.long())
            self.skip((7-track.strings)*4)
            track.midi_port = self.long()
            track.main_channel = self.long()
            track.fx_channel = self.long()
            track.num_frets = self.long()
            track.capo_position = self.long()
            track.color = self.long()
            self.result.tracks.append(track)

    def load_bar(self, track):
        bar = GTPBar()
        beats = self.long()
        for i in range(beats):
            self.load_beat(bar, track.strings)
        track.bars.append(bar)

    def load_beat(self, bar, track_strings):
        beat = GTPBeat()
        bar.beats.append(beat)
        beat_type = self.byte()
        if beat_type & 64:
            status = self.byte()
        beat.duration = self.sbyte()
        if beat_type & 1:
            beat.dotted = True
        if beat_type & 32:
            ntuplet = self.long()
        if beat_type & 2:
            self.load_chord()
        if beat_type & 4:
            beat.text = self.long_string()
        if beat_type & 8:
            self.load_beat_effect(beat)
        if beat_type & 16:
            self.load_mix_table_change(beat)
        strings = self.byte()
        for string in range(7, -1, -1):
            if strings & (1 << string):
                self.load_note(beat, track_strings-string)

    def load_beat_effect1(self, beat, effect):
        if effect & 1:
            beat.vibrato = True
        if effect & 2:
            beat.wide_vibrato = True
        if effect & 4:
            beat.natural_harmonic = True
        if effect & 16:
            beat.fade_in = True
        if effect & 32:
            self.load_effect32(beat)
        if effect & 64:
            beat.downstroke_duration = self.byte()
            beat.upstroke_duration = self.byte()

    def load_beat_effect(self, beat):
        effect = self.byte()
        self.load_beat_effect1(beat, effect)

    def load_effect32(self, beat):
        unknown = self.byte()
        tremolo_bar = self.long()

    def load_mix_table_change(self, beat):
        new_instrument = self.byte()
        new_volume = self.byte()
        new_pan = self.byte()
        new_chorus = self.byte()
        new_reverb = self.byte()
        new_phaser = self.byte()
        new_tremolo = self.byte()
        new_tempo = self.long()
        if new_volume != 255: volume_transition = self.byte()
        if new_pan != 255: pan_transition = self.byte()
        if new_chorus != 255: chorus_transition = self.byte()
        if new_reverb != 255: reverb_transition = self.byte()
        if new_phaser != 255: phaser_transition = self.byte()
        if new_tremolo != 255: tremolo_transition = self.byte()
        if new_tempo != -1: tempo_transition = self.byte()

    def load_chord(self):
        complete = self.byte()
        if complete:
            raise Exception("complete chords not supported")
        else:
            chord_name = self.long_string()
        diagram_top_fret = self.long()
        if diagram_top_fret:
            fret_values = []
            for i in range(7 if complete else 6):
                fret_values.append(self.long())

    def load_note(self, beat, string):
        note = GTPNote()
        note.string = string
        flag = self.byte()
        if flag & 32:
            note.alteration = self.byte()
            if flag & 1:
                note.duration = self.sbyte()
                self.skip(1)
            if flag & 16:
                note.nuance = self.byte()
            note.fret = self.byte()
        if flag & 128:
            note.left_hand_finger = self.byte()
            note.right_hand_finger = self.byte()
        if flag & 8:
            self.load_note_effect(note)

        beat.notes.append(note)

    def load_note_effect(self, note):
        type = self.byte()
        self.load_note_effect1(note, type)

    def load_note_effect1(self, note, type):
        if type & 1:
            self.load_bend()
        if type & 2:
            note.hammer = True
        if type & 4:
            note.slide = True
        if type & 8:
            note.let_ring = True
        if type & 16:
            self.load_grace_note(note)

    def load_bend(self):
        bend_type = self.byte()
        bend_value = self.long()
        points = self.long()
        for i in range(points):
            t = self.long()
            p = self.long()
            vibrato = self.byte()

    def load_grace_note(self, note):
        fret = self.byte()
        dynamic = self.byte()
        transition = self.byte()
        duration = self.byte()


class GP4Loader(GTPLoader):
    def load_lyrics(self):
        track_no = self.long()
        for i in range(5):
            bar_no = self.long()
            lyrics_line_length = self.long()
            lyrics_line = self.file.read(lyrics_line_length)

    def load_header2(self):
        self.skip(5)

    def load_beat_effect(self, beat):
        effect = self.byte()
        effect2 = self.byte()
        self.load_beat_effect1(beat, effect)
        if effect2 & 2:
            beat.pickstroke_direction = self.byte()
        if effect2 & 4:
            self.load_bend()

    def load_effect32(self, beat):
        beat.stroke_effect = self.byte()

    def load_mix_table_change(self, beat):
        GTPLoader.load_mix_table_change(self, beat)
        all_tracks_flag = self.byte()

    def load_note_effect(self, note):
        effect = self.byte()
        effect2 = self.byte()
        self.load_note_effect1(note, effect)
        if effect2 & 1:
            note.staccato = True
        if effect2 & 2:
            note.palm_mute = True
        if effect2 & 4:
            note.tremolo_picking = self.byte()
        if effect2 & 8:
            note.slide_effect = self.byte()
        if effect2 & 16:
            note.harmonic = self.byte()
        if effect2 & 32:
            note.trill_to_fret = self.byte()
            note.trill_frequency = self.byte()
        if effect2 & 64:
            note.vibrato = True

    def load_chord(self):
        type = self.byte()
        if type != 1: raise Exception("unsupported chord type %s" % type)
        sharp = self.byte()
        self.skip(3)
        root = self.byte()
        major_minor = self.byte()
        nine_eleven = self.byte()
        bass = self.long()
        dim_aug = self.long()
        add = self.byte()
        name = self.string(20)
        self.skip(2)
        fifth = self.byte()
        ninth = self.byte()
        eleventh = self.byte()
        base_fret = self.long()
        for i in range(7):
            fret = self.long()
        barre_count = self.byte()
        barre_frets = self.file.read(5)
        barre_starts = self.file.read(5)
        barre_ends = self.file.read(5)
        omissions = self.file.read(7)
        self.skip(1)
        fingering = self.file.read(7)
        show_fingering = self.byte()


def loader_for_file(f):
    """
    :type f:
    :rtype: GTPLoader
    """
    signature = read_pstring(f)
    if signature.startswith("FICHIER GUITAR PRO v3"):
        return GTPLoader()
    if signature.startswith("FICHIER GUITAR PRO v4"):
        return GP4Loader()
    raise Exception("Unsupported version or not a Guitar Pro file")



if __name__ == '__main__':
    from gtpfile import *
    import sys
    from optparse import OptionParser

    parser = OptionParser(usage="%prog [opciones] archivo")
    parser.add_option("-f", "--gtpfile", help="Archivo Formato GuitarPro", dest="archivo")
    options, args = parser.parse_args()

    if len(args) != 1:
        parser.print_help()
        sys.exit()

    a = open(args[0], "rb")
    loader = loader_for_file(a)
    gtp1 = loader.load(a)

    print "Titulo: %s " %  gtp1.title
    print "Subtitulo: %s " %  gtp1.subtitle
    print "Interprete: %s " %  gtp1.interpret
    print "Album: %s " %  gtp1.album
    print "Autor: %s " %  gtp1.author
    print "Copyright: %s " %  gtp1.copyright
    print "Tab Author: %s " %  gtp1.tablature_author
    print "Descripcion: %s " %  gtp1.description
    print "Tempo: %s" % gtp1.tempo

    for t in gtp1.tracks:
        print "---"        
        print "Pista: %s" %  t.name
        print "Cuerdas: %s" % t.strings
        print "Trastes: %s" % t.num_frets
        for i,b in enumerate(t.bars):
            for j,beat in enumerate(b.beats):
                print "Compas: %s , Posicion: %s" % (i, j)
                #print dir(beat)
                for n in beat.notes:
                    print n

