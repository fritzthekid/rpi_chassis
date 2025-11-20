# Raspberry Pi 4 Gehäuse - 3D-Druck Projekt

## Schnellstart für Export

### Dateien in diesem Ordner:

1. **rpi_enclosure.scad** - Haupt-Design-Datei (editierbar)
2. **export_*.scad** - Export-Scripts für STL-Generierung
3. **EXPORT_ANLEITUNG.md** - Ausführliche Dokumentation

## STL-Export mit OpenSCAD:

### Variante A - Einteiliges Gehäuse (empfohlen):

```bash
openscad -o gehaeuse_main.stl export_main.scad
openscad -o panel_front.stl export_front.scad
openscad -o panel_back.stl export_back.scad
```

### Variante B - Geteiltes Gehäuse:

```bash
openscad -o gehaeuse_oberschale.stl export_oberschale.scad
openscad -o gehaeuse_unterschale.stl export_unterschale.scad
openscad -o panel_front.stl export_front.scad
openscad -o panel_back.stl export_back.stl
```

## Oder manuell in OpenSCAD GUI:

1. Öffne die jeweilige export_*.scad Datei
2. Drücke F6 (Render)
3. File → Export → Export as STL

## Spezifikationen:

- **Dimensionen**: 120 x 150 x 100 mm
- **Material**: PLA oder PETG
- **Schichtdicke**: 0.2mm
- **Infill**: 20-30%
- **Supports**: NICHT erforderlich
- **Geschätzte Kosten**: 40-80 EUR bei Online-Services

## Für Auftragsdrucker:

Alle Details in **EXPORT_ANLEITUNG.md**

- Druck-Parameter
- Material-Empfehlungen
- Kosten-Schätzung
- Service-Empfehlungen
- Montage-Hinweise

## Anpassungen:

Alle Parameter sind in **rpi_enclosure.scad** editierbar:
- Gehäuse-Größe
- Anzahl PCB-Slots
- Wandstärke
- Ecken-Radius

Nach Änderungen die export_*.scad Scripts neu rendern!
