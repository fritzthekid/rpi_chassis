# Raspberry Pi 4 Gehäuse - Export & Druckauftrag Dokumentation

## Projekt-Übersicht
Parametrisches Gehäuse für Raspberry Pi 4 mit:
- 4x PCB-Einschubschienen (für RPi4 + 2x 2.5" SSDs + 1 Reserve)
- Integriertem Deckel
- Abnehmbaren Front- und Rückpanels
- Passiver Kühlung durch Lüftungsschlitze
- Abgerundeten Ecken (4mm Radius)

## Gehäuse-Dimensionen

### Standard-Konfiguration:
- **Außenmaße**: 120mm (B) x 150mm (T) x 100mm (H)
- **Wandstärke**: 3mm
- **Material**: PLA oder PETG empfohlen
- **Ecken-Radius**: 4mm

### Komponenten-Liste für Druck:

#### Variante A - Einteiliges Gehäuse (Empfohlen für Drucker ≥ 200mm):
1. **Hauptgehäuse** (gehaeuse_main.stl)
   - Größe: 120 x 150 x 100 mm
   - Druckzeit ca.: 8-12 Stunden
   - Material-Bedarf ca.: 180-220g

2. **Frontpanel** (panel_front.stl)
   - Größe: ca. 114 x 3 x 94 mm
   - Druckzeit ca.: 1-2 Stunden
   - Material-Bedarf ca.: 15-20g

3. **Rückpanel** (panel_back.stl)
   - Größe: ca. 114 x 3 x 94 mm
   - Druckzeit ca.: 1-2 Stunden
   - Material-Bedarf ca.: 15-20g

**Gesamt Variante A**: ca. 10-16 Stunden, 210-260g Material

#### Variante B - Geteiltes Gehäuse (für kleinere Drucker oder einfachere Fertigung):
1. **Oberschale** (gehaeuse_oberschale.stl)
   - Größe: 120 x 150 x 50 mm
   - Druckzeit ca.: 4-6 Stunden
   - Material-Bedarf ca.: 90-110g

2. **Unterschale** (gehaeuse_unterschale.stl)
   - Größe: 120 x 150 x 50 mm
   - Druckzeit ca.: 4-6 Stunden
   - Material-Bedarf ca.: 90-110g

3. **Frontpanel** (panel_front.stl) - siehe oben
4. **Rückpanel** (panel_back.stl) - siehe oben

**Gesamt Variante B**: ca. 10-16 Stunden, 210-260g Material

## Druck-Spezifikationen für Auftragsdrucker

### Empfohlene Druck-Parameter:

```
Material: PLA oder PETG
Schichtdicke: 0.2mm
Infill: 20-30% (Gitter oder Honeycomb)
Wandlinien: 3-4 Perimeter
Top/Bottom-Layer: 4-5 Schichten
Druckgeschwindigkeit: 50-60 mm/s
Düsendurchmesser: 0.4mm
Drucktemperatur (PLA): 200-210°C
Drucktemperatur (PETG): 230-240°C
Bett-Temperatur (PLA): 60°C
Bett-Temperatur (PETG): 80°C
Support: NICHT erforderlich
Brim/Raft: Optional für große Teile (Hauptgehäuse)
```

### Orientierung auf dem Druckbett:

1. **Hauptgehäuse / Ober-/Unterschale**: 
   - Mit Boden/flacher Seite nach unten
   - Öffnung nach oben

2. **Front- und Rückpanel**: 
   - Flach auf das Druckbett legen
   - Einsteck-Rand zeigt nach oben

### Besondere Anforderungen:

- **Toleranzen**: Die Panels haben 0.3mm Spiel eingebaut
- **Keine Supports nötig**: Design ist support-frei
- **Wichtig**: Erste Schicht muss gut haften (ggf. Brim verwenden)
- **Abgerundete Ecken**: Müssen sauber gedruckt werden (keine Überhänge >45°)

## Material-Empfehlung

### PLA (Empfohlen für Innenbereich):
- ✓ Einfach zu drucken
- ✓ Gute Oberflächenqualität
- ✓ Günstiger
- ✗ Nicht geeignet für >50°C Umgebung
- **Beste Wahl für**: Schreibtisch-Setup, klimatisierte Räume

### PETG (Empfohlen für robuste Anwendung):
- ✓ Höhere Temperaturbeständigkeit
- ✓ Flexibler, weniger spröde
- ✓ Bessere Schlagfestigkeit
- ✗ Schwieriger zu drucken
- ✗ Teurer
- **Beste Wahl für**: Server-Raum, robuste Anwendung

### Farb-Empfehlung:
- Schwarz oder Dunkelgrau: Professionelles Aussehen
- Weiß: Gute Sichtbarkeit von LEDs
- Transparent: Sichtbarkeit der Komponenten

## Export-Dateien erstellen

Die mitgelieferten Export-Scripts ermöglichen einfaches STL-Rendering:

### In OpenSCAD:

**Für Variante A (Einteiliges Gehäuse):**
1. Öffne `export_main.scad` → F6 (Render) → Export als `gehaeuse_main.stl`
2. Öffne `export_front.scad` → F6 → Export als `panel_front.stl`
3. Öffne `export_back.scad` → F6 → Export als `panel_back.stl`

**Für Variante B (Geteiltes Gehäuse):**
1. Öffne `export_oberschale.scad` → F6 → Export als `gehaeuse_oberschale.stl`
2. Öffne `export_unterschale.scad` → F6 → Export als `gehaeuse_unterschale.stl`
3. Öffne `export_front.scad` → F6 → Export als `panel_front.stl`
4. Öffne `export_back.scad` → F6 → Export als `panel_back.stl`

## Kosten-Schätzung

### Bei Online-Druckdiensten (Deutschland):
- **PLA**: ca. 40-80 EUR (Variante A oder B)
- **PETG**: ca. 50-100 EUR (Variante A oder B)

### Lokale Maker-Spaces / FabLabs:
- **PLA**: ca. 20-40 EUR (meist nur Materialkosten)
- **PETG**: ca. 25-50 EUR

### Bekannte deutsche 3D-Druck-Services:
1. **3D Hubs** (jetzt Protolabs Network)
2. **Sculpteo**
3. **Shapeways**
4. **Treatstock**
5. **Lokale FabLabs** (z.B. FabLab München, Stuttgart, etc.)

## Checkliste für Druckauftrag

Beim Beauftragen folgende Informationen angeben:

- [ ] STL-Dateien hochladen (3-4 Dateien je nach Variante)
- [ ] Material: PLA oder PETG
- [ ] Farbe: _____________
- [ ] Schichtdicke: 0.2mm
- [ ] Infill: 20-30%
- [ ] **Wichtig**: Keine Supports erforderlich
- [ ] Optional: Brim für Hauptgehäuse

## Montage-Hinweise

Nach Erhalt der gedruckten Teile:

1. **Qualitätskontrolle**: 
   - Panels auf Passform prüfen
   - Falls zu stramm: Leicht nachschleifen
   - Falls zu locker: Kann mit Klebeband ausgeglichen werden

2. **PCB-Einschub testen**:
   - PCBs sollten leicht in Schienen gleiten
   - Bei Bedarf Schienen mit Feile glätten

3. **Kabel-Durchführungen**:
   - Sind bereits im Rückpanel integriert (8mm Durchmesser)
   - Bei Bedarf mit Tülle oder Gummi auskleiden

4. **Montage-Reihenfolge**:
   - Komponenten in Hauptgehäuse einbauen
   - PCBs in Schienen schieben
   - Verkabelung durch Rückpanel führen
   - Rückpanel einstecken
   - Frontpanel einstecken
   - (Bei Variante B: Oberschale aufstecken)

## Anpassungen vor dem Druck

Falls du vor dem Auftrag noch Änderungen vornehmen möchtest:

### In `rpi_enclosure.scad` anpassen:

```openscad
// Gehäuse-Größe ändern:
gehaeuse_breite = 120;  // Breite in mm
gehaeuse_tiefe = 150;   // Tiefe in mm
gehaeuse_hoehe = 100;   // Höhe in mm

// Mehr/weniger PCB-Slots:
anzahl_slots = 4;       // Anzahl Einschübe
slot_abstand = 20;      // Abstand zwischen Slots in mm

// Ecken-Abrundung ändern:
ecken_radius = 4;       // Radius in mm (0 = scharfe Ecken)

// Wandstärke ändern:
wandstaerke = 3;        // Dicke in mm
```

Nach Änderungen die Export-Scripts neu rendern!

## Support & Fragen

Bei Problemen mit:
- **Passform**: `panel_nut_tolerance` in der .scad Datei anpassen
- **PCB-Schienen**: `schienen_clearance` anpassen
- **Größe**: Hauptmaße am Anfang der Datei ändern

Viel Erfolg mit deinem 3D-Druck-Auftrag!
