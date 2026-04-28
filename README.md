   # CastingApp — ME222 IITG Sand Casting Pattern Generator

A web-based tool that takes a 3D CAD file (.STEP format) and automatically:
1. Applies **Shrinkage Allowance** (scales up the part)
2. Applies **Machining Allowance** (offsets all surfaces outward)
3. Applies **Draft Angle** (tapers side walls for pattern withdrawal)
4. Detects the **optimal Parting Line/Plane** for sand casting
5. **Splits** the pattern into **Cope (top)** and **Drag (bottom)** halves
6. Exports all results as **.STEP files** ready for CNC/pattern making

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| CAD Engine | **pythonOCC** (OpenCASCADE Python bindings) |
| Backend | **Flask** (Python REST API) |
| 3D Viewer | **Three.js** (WebGL in browser) |
| Environment | **Anaconda** Python 3.10 |

---

## STEP-BY-STEP SETUP

### Prerequisites
- **Anaconda** or **Miniconda** installed
- **Windows 10/11** or **Linux/macOS**
- Internet connection (for Three.js CDN on first run)

---

### Step 1: Create Conda Environment

Open Anaconda Prompt (Windows) or Terminal (Linux/Mac):

```bash
conda create -n casting_app python=3.10
conda activate casting_app
```

---

### Step 2: Install pythonOCC (OpenCASCADE)

This is the CAD kernel — MUST be installed via conda, not pip:

```bash
conda install -c conda-forge pythonocc-core=7.7.2
```

> ⚠️ This download is ~500MB and takes 5–15 minutes. Be patient.

---

### Step 3: Install Python packages

```bash
pip install flask flask-cors werkzeug numpy scipy
```

---

### Step 4: Verify Installation

```bash
python -c "from OCC.Core.STEPControl import STEPControl_Reader; print('pythonOCC OK')"
```

You should see: `pythonOCC OK`

---

### Step 5: Run the Application

**Windows:**
```batch
cd casting_app
start_windows.bat
```

**Linux/macOS:**
```bash
cd casting_app
chmod +x start.sh
./start.sh
```

**Manual start (any OS):**
```bash
# Terminal 1: Backend
conda activate casting_app
cd casting_app/backend
python app.py

# Then open frontend/index.html in browser
```

---

## Usage

1. **Upload** a `.step` / `.stp` / `.iges` file using the upload panel
2. **View** the 3D model immediately in the viewer (left-click + drag to orbit)
3. **Select material** from the grid (Gray Cast Iron, Steel, Aluminium, etc.)
4. Click **"Generate Casting Pattern"**
5. Wait ~30–120 seconds (depends on part complexity)
6. **Download** the three output STEP files:
   - `pattern_with_allowances_*.step` — Full pattern with all allowances
   - `cope_upper_*.step` — Top half of mold
   - `drag_lower_*.step` — Bottom half of mold

---

## Allowance Values (per IS 2710 / Shigley's)

### Shrinkage Allowance
| Material | Linear Shrinkage |
|----------|-----------------|
| Gray Cast Iron | 1.0% |
| Carbon Steel | 2.0% |
| Aluminium | 1.3% |
| Copper/Bronze | 1.5% |
| Zinc | 0.7% |

### Machining Allowance
| Part Size | Gray CI | Steel | Al |
|-----------|---------|-------|-----|
| < 300 mm | 3.0 mm | 4.5 mm | 2.5 mm |
| 300–600 mm | 4.0 mm | 6.0 mm | 3.5 mm |
| > 600 mm | 5.0 mm | 8.0 mm | 4.5 mm |

### Draft Angle
| Material | External | Internal |
|----------|----------|----------|
| Gray Cast Iron | 1.5° | 2.0° |
| Steel | 2.0° | 3.0° |
| Aluminium | 1.0° | 1.5° |

---

## Parting Plane Selection Algorithm

The algorithm scores 6 candidate planes (XY, XZ, YZ at various heights):
- **Undercut penalty** — faces that would trap the pattern
- **COM distance** — prefer plane through centre of mass
- **Balance score** — prefer symmetric cope/drag volumes

The lowest-scoring plane is selected automatically.

---

## Project Structure

```
casting_app/
├── backend/
│   ├── app.py            ← Flask REST API
│   ├── cad_processor.py  ← STEP read/write, OBJ export
│   ├── allowances.py     ← Shrinkage, machining, draft
│   ├── parting_line.py   ← Parting plane detection + split
│   └── materials.py      ← Material database
├── frontend/
│   ├── index.html        ← Main UI
│   ├── style.css         ← Dark industrial theme
│   └── main.js           ← Three.js viewer + logic
├── uploads/              ← Temp uploaded files
├── outputs/              ← Generated STEP + OBJ files
├── requirements.txt
├── start_windows.bat
└── start.sh
```

---

## Troubleshooting

**"pythonOCC not found"**
→ Make sure you activated the conda env: `conda activate casting_app`

**"Flask CORS error" in browser**
→ The backend must be running at localhost:5000. Check the terminal.

**"Null shape" error on upload**
→ Some STEP files use non-standard AP203 schemas. Try exporting from FreeCAD/SolidWorks as AP214.

**Shape processing fails**
→ Complex freeform surfaces may fail BRepOffsetAPI. Simplify the geometry or reduce allowance values.

**Three.js model looks empty**
→ The OBJ may have zero triangles. Check mesh quality by reducing `linear_deflection` in `cad_processor.py`.

---

## Academic References

- IS 2710: Foundry Technology — Allowances in Castings
- Shigley's Mechanical Engineering Design (10th ed) — Ch. 2 Materials
- Kalpakjian, Manufacturing Engineering & Technology — Ch. 11 Sand Casting
- pythonOCC documentation: https://dev.opencascade.org/
