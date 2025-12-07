// ====================================================================
// Raspberry Pi 4 Gehäuse mit PCB-Einschubschienen
// Parametrisches OpenSCAD Design - V2
// Mit abnehmbarer Front/Rückseite, integriertem Deckel
// ====================================================================

// HAUPT-PARAMETER (hier anpassen!)
// ====================================================================

// Gehäuse Außenmaße
gehaeuse_breite = 120;      // Breite des Gehäuses
gehaeuse_tiefe = 110;       // Tiefe des Gehäuses  
gehaeuse_hoehe = 100;       // Höhe des Gehäuses
wandstaerke = 3;            // Wandstärke
ecken_radius = 4;           // Radius der abgerundeten Ecken

// Rendering-Optionen
shell_split_mode = false;   // true = Ober-/Unterschale getrennt rendern
show_front_panel = true;    // Frontplatte anzeigen
show_back_panel = true;     // Rückplatte anzeigen
show_main_body = true;      // Hauptgehäuse anzeigen
show_frame_front = true; // forderen Rahmen anzeigen
show_frame_back = true; // hinteren Rahmen anzeigen

// Panel-Befestigung
panel_nut_tolerance = 0.3;  // Toleranz für Einsteckverbindung
panel_nut_tiefe = 8;        // Tiefe der Einstecknut

// PCB Einschub Parameter
pcb_breite = 100;           // Maximale PCB-Breite (z.B. für 2.5" SSD)
pcb_staerke = 1.6;          // Standard PCB Stärke
anzahl_slots = 4;           // Anzahl der PCB-Einschübe (Pi + 2 SSDs + 1 Reserve)
slot_abstand = 20;          // Vertikaler Abstand zwischen Slots
schienen_tiefe = gehaeuse_tiefe - 2 * wandstaerke - 2;  // Tiefe der Einschubschienen (durchgehend)

// Einschubschienen Design
schienen_breite = 7;        // Breite der Führungsschiene
schienen_hoehe = 2;         // Höhe der unteren Führung
schienen_clearance = 0.3;   // Freiraum über PCB (für leichtes Einschieben)

// Kühlungs-Schlitze
lueftungsschlitz_breite = 2;
lueftungsschlitz_abstand = 5;
anzahl_lueftungsschlitze = 8;

// Front-Griffe (optional aktivierbar)
griffe_aktiviert = false;   // auf true setzen für Griffe
griff_breite = 15;
griff_hoehe = 30;
griff_tiefe = 10;

// Rückwand Kabel-Durchführungen
kabel_durchmesser = 8;
kabel_positionen = [
    [30, 25],   // Position für Raspberry Pi Stromversorgung
    [30, 45],   // Position für serielle Schnittstelle
    [30, 65],   // Position für USB/Netzwerk
    [90, 40]    // Position für SSD Stromversorgung
];

// ====================================================================
// BERECHNUNG INTERNER MAßE
// ====================================================================

innen_breite = gehaeuse_breite - 2 * wandstaerke;
innen_tiefe = gehaeuse_tiefe - 2 * wandstaerke;
innen_hoehe = gehaeuse_hoehe - 2 * wandstaerke;

// Startposition für ersten Slot (von unten)
erster_slot_hoehe = wandstaerke + 10;

// Shell-Split Parameter
shell_split_hoehe = gehaeuse_hoehe / 2;  // Höhe für Teilung Ober-/Unterschale

// Panel-Nut Dimensionen
panel_inset = 2;  // Wie weit das Panel ins Gehäuse eingesteckt wird

// ====================================================================
// HAUPT-MODUL
// ====================================================================

// Hauptgehäuse mit integriertem Deckel, ohne Front/Rückwand
module gehaeuse_hauptkoerper() {
    difference() {
        union() {
            // Grundgehäuse mit Deckel
            gehaeuse_basis_mit_deckel();
            
            // PCB-Einschubschienen
            for (i = [0:anzahl_slots-1]) {
                translate([0, 0, erster_slot_hoehe + i * slot_abstand]) {
                    pcb_einschubschienen();
                }
            }
            
            // Nuten für Front- und Rückpanel
            panel_nuten();
        }
        
        // Lüftungsschlitze in den Seitenwänden
        lueftungsschlitze();
        
        // Bei Shell-Split: Oberschale abschneiden
        if (shell_split_mode) {
            translate([-10, -10, shell_split_hoehe]) {
                cube([gehaeuse_breite + 20, gehaeuse_tiefe + 20, gehaeuse_hoehe]);
            }
        }
    }
    
    // Optional: Griffe an der Front
    if (griffe_aktiviert) {
        griffe();
    }
}

// Oberschale (für Shell-Split Mode)
module oberschale() {
    difference() {
        gehaeuse_hauptkoerper();
        
        // Unterschale abschneiden
        translate([-10, -10, -10]) {
            cube([gehaeuse_breite + 20, gehaeuse_tiefe + 20, shell_split_hoehe + 10]);
        }
    }
    
    // Verbindungsstifte für Ober-/Unterschale
    verbindungsstifte_oben();
}

// Unterschale (für Shell-Split Mode)
module unterschale() {
    intersection() {
        gehaeuse_hauptkoerper();
        
        translate([-10, -10, -10]) {
            cube([gehaeuse_breite + 20, gehaeuse_tiefe + 20, shell_split_hoehe + 10]);
        }
    }
    
    // Aufnahmen für Verbindungsstifte
    verbindungsstifte_aufnahme();
}


// ====================================================================
// KOMPONENTEN
// ====================================================================

// Frame (für Shell-Split Mode)
module frame() {

    union() {
        chasing_frame();
        chasing_frame(frame_extension_x=2,frame_extension_y=2,frame_extension_z=7);
    }
}

//
module chasing_frame(frame_extension_x = 7,frame_extension_y = 7, frame_extension_z = 2) {
    f_ecken_radius = 1;
    //frame_shift = 20;
    //translate([0, frame_shift, 0])
    difference() {
        translate([-frame_extension_x, 0, -frame_extension_y]) 
            rounded_cube([gehaeuse_breite+2*frame_extension_x, frame_extension_z, 
                          gehaeuse_hoehe+2*frame_extension_y], f_ecken_radius);
        translate([0,-gehaeuse_tiefe/2,0]) rounded_cube([gehaeuse_breite+0.1, gehaeuse_tiefe, gehaeuse_hoehe+0.1], ecken_radius);
    }
}


// Grundgehäuse mit integriertem Deckel und abgerundeten Ecken
module gehaeuse_basis_mit_deckel() {
  difference() {
    difference() {
        // Außenhülle mit abgerundeten Ecken
        rounded_cube([gehaeuse_breite, gehaeuse_tiefe, gehaeuse_hoehe], ecken_radius);
        
        // Innenraum aushöhlen (mit Platz für Panel-Nuten)
        translate([wandstaerke, wandstaerke + panel_nut_tiefe, wandstaerke]) {
            cube([innen_breite, innen_tiefe - 2 * panel_nut_tiefe, innen_hoehe]);
        }
        
        // Aussparungen für Front- und Rückpanel
        // Front
        translate([wandstaerke + panel_inset, -1, wandstaerke + panel_inset]) {
            cube([innen_breite - 2*panel_inset, panel_nut_tiefe + 2, innen_hoehe - 2*panel_inset]);
        }
        
        // Rückseite
        translate([wandstaerke + panel_inset, gehaeuse_tiefe - panel_nut_tiefe - 1, wandstaerke + panel_inset]) {
            cube([innen_breite - 2*panel_inset, panel_nut_tiefe + 2, innen_hoehe - 2*panel_inset]);
        }
    };
    translate([2*wandstaerke,2*wandstaerke,wandstaerke]) {
      cube([gehaeuse_breite-4*wandstaerke, gehaeuse_tiefe-4*wandstaerke, gehaeuse_hoehe-2*wandstaerke]);
    }
  }
}

// Hilfsfunktion: Würfel mit abgerundeten Ecken
module rounded_cube(size, radius) {
    hull() {
        translate([radius, radius, radius])
            sphere(r=radius, $fn=30);
        translate([size[0]-radius, radius, radius])
            sphere(r=radius, $fn=30);
        translate([radius, size[1]-radius, radius])
            sphere(r=radius, $fn=30);
        translate([size[0]-radius, size[1]-radius, radius])
            sphere(r=radius, $fn=30);
            
        translate([radius, radius, size[2]-radius])
            sphere(r=radius, $fn=30);
        translate([size[0]-radius, radius, size[2]-radius])
            sphere(r=radius, $fn=30);
        translate([radius, size[1]-radius, size[2]-radius])
            sphere(r=radius, $fn=30);
        translate([size[0]-radius, size[1]-radius, size[2]-radius])
            sphere(r=radius, $fn=30);
    }
}

// Nuten für Panel-Einstecksystem
module panel_nuten() {
    // Diese werden bereits in gehaeuse_basis_mit_deckel() erstellt
    // Hier könnten zusätzliche Führungsrippen ergänzt werden
}

// Frontpanel (abnehmbar, mit Öffnung für RPi Ports)
module frontpanel() {
    panel_breite = innen_breite - 2*panel_inset - 2*panel_nut_tolerance;
    panel_hoehe = innen_hoehe - 2*panel_inset - 2*panel_nut_tolerance;
    
    difference() {
        union() {
            // Hauptpanel
            cube([panel_breite, wandstaerke, panel_hoehe]);
            
            // Einsteck-Rand
            translate([-panel_inset + panel_nut_tolerance, wandstaerke, -panel_inset + panel_nut_tolerance]) {
                cube([panel_breite + 2*panel_inset - 2*panel_nut_tolerance, 
                      panel_nut_tiefe - wandstaerke, 
                      panel_hoehe + 2*panel_inset - 2*panel_nut_tolerance]);
            }
        }
        
        // Öffnung für Raspberry Pi Ports (USB, HDMI, etc.)
        translate([panel_breite * 0.1, -1, 15]) {
            cube([panel_breite * 0.6, wandstaerke + 2, 40]);
        }
        
        // Zusätzliche kleine Kühlschlitze
        for (i = [0:4]) {
            translate([panel_breite * 0.15 + i * 12, -1, panel_hoehe - 20]) {
                cube([2, wandstaerke + 2, 15]);
            }
        }
    }
}

// Rückpanel (abnehmbar, mit Kabel-Durchführungen)
module rueckpanel() {
    panel_breite = innen_breite - 2*panel_inset - 2*panel_nut_tolerance;
    panel_hoehe = innen_hoehe - 2*panel_inset - 2*panel_nut_tolerance;
    
    difference() {
        union() {
            // Hauptpanel
            cube([panel_breite, wandstaerke, panel_hoehe]);
            
            // Einsteck-Rand
            translate([-panel_inset + panel_nut_tolerance, -panel_nut_tiefe + wandstaerke, -panel_inset + panel_nut_tolerance]) {
                cube([panel_breite + 2*panel_inset - 2*panel_nut_tolerance, 
                      panel_nut_tiefe - wandstaerke, 
                      panel_hoehe + 2*panel_inset - 2*panel_nut_tolerance]);
            }
        }
        
        // Kabel-Durchführungen
        for (pos = kabel_positionen) {
            translate([pos[0], -1, pos[1]]) {
                rotate([90, 0, 0]) {
                    cylinder(h = wandstaerke + panel_nut_tiefe, d = kabel_durchmesser, $fn=30);
                }
            }
        }
        
        // Lüftungsschlitze
        for (i = [0:5]) {
            translate([panel_breite * 0.7 + i * 5, -1, panel_hoehe * 0.3]) {
                cube([2, wandstaerke + 2, panel_hoehe * 0.4]);
            }
        }
    }
}

// Verbindungsstifte für Shell-Split (auf Oberschale)
module verbindungsstifte_oben() {
    stift_durchmesser = 4;
    stift_laenge = 8;
    
    positionen = [
        [gehaeuse_breite * 0.2, gehaeuse_tiefe * 0.2],
        [gehaeuse_breite * 0.8, gehaeuse_tiefe * 0.2],
        [gehaeuse_breite * 0.2, gehaeuse_tiefe * 0.8],
        [gehaeuse_breite * 0.8, gehaeuse_tiefe * 0.8]
    ];
    
    for (pos = positionen) {
        translate([pos[0], pos[1], shell_split_hoehe - stift_laenge]) {
            cylinder(h = stift_laenge, d = stift_durchmesser - 0.3, $fn=20);
        }
    }
}

// Aufnahmen für Verbindungsstifte (auf Unterschale)
module verbindungsstifte_aufnahme() {
    stift_durchmesser = 4;
    stift_tiefe = 8;
    
    positionen = [
        [gehaeuse_breite * 0.2, gehaeuse_tiefe * 0.2],
        [gehaeuse_breite * 0.8, gehaeuse_tiefe * 0.2],
        [gehaeuse_breite * 0.2, gehaeuse_tiefe * 0.8],
        [gehaeuse_breite * 0.8, gehaeuse_tiefe * 0.8]
    ];
    
    for (pos = positionen) {
        translate([pos[0], pos[1], shell_split_hoehe]) {
            cylinder(h = stift_tiefe, d = stift_durchmesser, $fn=20);
        }
    }
}

// PCB-Einschubschienen (ein Paar für einen Slot)
module pcb_einschubschienen() {
    schienen_offset_x = (gehaeuse_breite - pcb_breite) / 2;
    schienen_start_y = wandstaerke;  // Direkt an der Innenwand beginnen
    
    // Linke Schiene
    translate([schienen_offset_x - schienen_breite, schienen_start_y, 0]) {
        einzelne_schiene();
    }
    
    // Rechte Schiene
    translate([schienen_offset_x + pcb_breite, schienen_start_y, 0]) {
        einzelne_schiene();
    }
}

// Eine einzelne Einschubschiene
module einzelne_schiene() {
    // Untere Führung
    cube([schienen_breite, schienen_tiefe, schienen_hoehe]);
    
    // Obere Begrenzung (hält PCB von oben)
    translate([0, 0, schienen_hoehe + pcb_staerke + schienen_clearance]) {
        cube([schienen_breite, schienen_tiefe, schienen_hoehe]);
    }
}

// Lüftungsschlitze in beiden Seitenwänden
module lueftungsschlitze() {
    for (seite = [0, 1]) {
        x_pos = seite == 0 ? -1 : gehaeuse_breite - wandstaerke + 1;
        
        for (i = [0:anzahl_lueftungsschlitze-1]) {
            translate([x_pos, 
                       wandstaerke + 10 + i * (lueftungsschlitz_breite + lueftungsschlitz_abstand),
                       wandstaerke + 10]) {
                cube([wandstaerke + 2, 
                      lueftungsschlitz_breite, 
                      gehaeuse_hoehe - 2 * wandstaerke - 20]);
            }
        }
    }
}

// Front-Griffe (optional)
module griffe() {
    for (offset = [0, 1]) {
        x_pos = gehaeuse_breite * 0.25 + offset * gehaeuse_breite * 0.5 - griff_breite/2;
        
        translate([x_pos, panel_nut_tiefe - griff_tiefe, gehaeuse_hoehe/2 - griff_hoehe/2]) {
            difference() {
                cube([griff_breite, griff_tiefe, griff_hoehe]);
                // Griffmulde
                translate([griff_breite/2, griff_tiefe/2, griff_hoehe/2]) {
                    rotate([0, 90, 0]) {
                        cylinder(h = griff_breite + 2, d = griff_hoehe * 0.6, center=true, $fn=40);
                    }
                }
            }
        }
    }
}

// ====================================================================
// ZUSÄTZLICHE HILFS-MODULE
// ====================================================================

// PCB Testplatine (zum Testen der Passform)
module test_pcb() {
    color("green") {
        cube([pcb_breite, 80, pcb_staerke]);
    }
}

// ====================================================================
// RENDERING
// ====================================================================

// Anzeige basierend auf Rendering-Optionen
if (shell_split_mode) {
    // Shell-Split Mode: Ober- und Unterschale separat
    oberschale();
    
    translate([0, gehaeuse_tiefe + 20, 0]) 
        unterschale();
    
    // Panels separat anzeigen
    if (show_front_panel) {
        translate([gehaeuse_breite + 20, wandstaerke + panel_nut_tiefe, wandstaerke + panel_inset + panel_nut_tolerance])
            frontpanel();
    }
    
    if (show_back_panel) {
        translate([gehaeuse_breite + 20, gehaeuse_tiefe + 40 + wandstaerke + panel_nut_tiefe, wandstaerke + panel_inset + panel_nut_tolerance])
            rotate([0, 0, 0])
            rueckpanel();
    }
    
} else {
    // Normaler Mode: Komplettes Gehäuse
    if (show_main_body) {
        gehaeuse_hauptkoerper();
    }
    if (show_frame_front) {
        frame();
    }
    if (show_frame_back) {
        frame();
    }
    
    // Frontpanel (einschiebbar von vorne)
    if (show_front_panel) {
        translate([wandstaerke + panel_inset + panel_nut_tolerance, 
                   wandstaerke + panel_nut_tiefe, 
                   wandstaerke + panel_inset + panel_nut_tolerance])
            frontpanel();
    }
    
    // Rückpanel (einschiebbar von hinten)
    if (show_back_panel) {
        translate([wandstaerke + panel_inset + panel_nut_tolerance, 
                   gehaeuse_tiefe - wandstaerke - panel_nut_tiefe, 
                   wandstaerke + panel_inset + panel_nut_tolerance])
            rotate([0, 0, 0])
            rueckpanel();
    }
}

// Test-PCBs anzeigen (auskommentieren zum Testen der Passform)
/*
for (i = [0:anzahl_slots-1]) {
    translate([(gehaeuse_breite - pcb_breite) / 2, 
               wandstaerke + panel_nut_tiefe + 5, 
               erster_slot_hoehe + i * slot_abstand + schienen_hoehe + 0.5]) {
        test_pcb();
    }
}
*/

// ====================================================================
// NUTZUNGSHINWEISE - Version 2
// ====================================================================

/*
NEUE FEATURES IN V2:
✓ Integrierter Deckel (kein separater Druck mehr nötig)
✓ Abnehmbare Front- und Rückpanel mit Einstecksystem
✓ Abgerundete Ecken für bessere Ästhetik
✓ Optional: Ober-/Unterschalen-Teilung für große Drucker-Betten
✓ Kabel-Durchführungen direkt in Rückpanel integriert

RENDERING-MODI:
1. Komplettes Gehäuse (Standard):
   - shell_split_mode = false
   - show_main_body = true
   - show_front_panel = true (zum Testen der Passform)
   - show_back_panel = true (zum Testen der Passform)

2. Shell-Split für großen Druck:
   - shell_split_mode = true
   - Druckt Ober- und Unterschale getrennt
   - Verbindungsstifte für präzise Montage

EXPORT FÜR 3D-DRUCK:
Schritt 1 - Hauptgehäuse:
   shell_split_mode = false;
   show_main_body = true;
   show_front_panel = false;
   show_back_panel = false;
   → Render (F6) → Export als "gehaeuse_main.stl"

Schritt 2 - Frontpanel:
   show_main_body = false;
   show_front_panel = true;
   show_back_panel = false;
   → Render (F6) → Export als "panel_front.stl"

Schritt 3 - Rückpanel:
   show_main_body = false;
   show_front_panel = false;
   show_back_panel = true;
   → Render (F6) → Export als "panel_back.stl"

ODER bei Shell-Split:
   shell_split_mode = true;
   → Export "oberschale.stl" und "unterschale.stl" separat

WICHTIGE PARAMETER:
- ecken_radius: Radius der Ecken-Abrundung (4mm Standard)
- panel_nut_tolerance: Passspiel für Panel-Einstecksystem (0.3mm)
- shell_split_hoehe: Höhe der Teilung bei Shell-Split

ANPASSUNG DER PARAMETER:
- Ändere die Werte im Abschnitt "HAUPT-PARAMETER" oben
- Wichtigste Parameter: gehaeuse_breite, gehaeuse_tiefe, gehaeuse_hoehe
- anzahl_slots: Anzahl der PCB-Einschübe
- slot_abstand: Vertikaler Abstand zwischen den Einschüben
- griffe_aktiviert: auf true setzen für Front-Griffe
- ecken_radius: Für mehr/weniger Rundung der Ecken

3D-DRUCK EMPFEHLUNGEN:
- Hauptgehäuse: Mit Boden nach unten drucken
- Panels: Flach auf Druckbett legen
- Schichtdicke: 0.2mm
- Infill: 20-30%
- Supports: Normalerweise nicht nötig (außer bei Griffen)
- Material: PLA oder PETG
- Erste Layer: Wichtig für gute Haftung bei großen Teilen

MONTAGE:
1. PCBs in die Schienen schieben (von vorne/hinten)
2. Kabel durch Rückpanel führen
3. Rückpanel einschieben (von hinten)
4. Frontpanel einschieben (von vorne)
5. Bei Shell-Split: Ober- auf Unterschale aufstecken

KABEL-DURCHFÜHRUNGEN:
- Positionen sind in kabel_positionen[] definiert
- Durchmesser: 8mm (anpassbar mit kabel_durchmesser)
- Bereits im Rückpanel eingearbeitet

TIPPS:
- Teste die Panel-Passform mit show_front_panel/show_back_panel = true
- Passe panel_nut_tolerance an wenn Panels zu locker/fest sitzen
- Bei großen Gehäusen: shell_split_mode = true verwenden
- Für Test-Drucke: Skaliere auf 50% für schnelle Iteration
*/

