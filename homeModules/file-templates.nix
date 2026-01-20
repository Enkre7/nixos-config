{ config, pkgs, lib, ... }:

let
  templatesDir = "${config.home.homeDirectory}/Templates";
  
  # Template DOCX vide (document Word)
  docxTemplate = pkgs.runCommand "template.docx" {
    buildInputs = [ pkgs.zip ];
  } ''
    mkdir -p temp/_rels temp/docProps temp/word/_rels temp/word/theme
    
    # [Content_Types].xml
    cat > temp/[Content_Types].xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
EOF

    # _rels/.rels
    cat > temp/_rels/.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
EOF

    # word/document.xml
    cat > temp/word/document.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p/>
  </w:body>
</w:document>
EOF

    # word/_rels/document.xml.rels
    cat > temp/word/_rels/document.xml.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
EOF

    # word/styles.xml
    cat > temp/word/styles.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults/>
</w:styles>
EOF

    # docProps/core.xml
    cat > temp/docProps/core.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:creator>NixOS Template</dc:creator>
  <dcterms:created xsi:type="dcterms:W3CDTF">2025-01-20T00:00:00Z</dcterms:created>
</cp:coreProperties>
EOF

    # docProps/app.xml
    cat > temp/docProps/app.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>OnlyOffice</Application>
</Properties>
EOF

    cd temp
    zip -r $out * [Content_Types].xml
  '';

  # Template XLSX vide (tableur Excel)
  xlsxTemplate = pkgs.runCommand "template.xlsx" {
    buildInputs = [ pkgs.zip ];
  } ''
    mkdir -p temp/_rels temp/docProps temp/xl/_rels temp/xl/worksheets
    
    # [Content_Types].xml
    cat > temp/[Content_Types].xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
EOF

    # _rels/.rels
    cat > temp/_rels/.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
EOF

    # xl/workbook.xml
    cat > temp/xl/workbook.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="Sheet1" sheetId="1" r:id="rId1"/>
  </sheets>
</workbook>
EOF

    # xl/_rels/workbook.xml.rels
    cat > temp/xl/_rels/workbook.xml.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
EOF

    # xl/worksheets/sheet1.xml
    cat > temp/xl/worksheets/sheet1.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <sheetData/>
</worksheet>
EOF

    # xl/sharedStrings.xml
    cat > temp/xl/sharedStrings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="0" uniqueCount="0"/>
EOF

    # xl/styles.xml
    cat > temp/xl/styles.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"/>
EOF

    # docProps/core.xml
    cat > temp/docProps/core.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:creator>NixOS Template</dc:creator>
  <dcterms:created xsi:type="dcterms:W3CDTF">2025-01-20T00:00:00Z</dcterms:created>
</cp:coreProperties>
EOF

    # docProps/app.xml
    cat > temp/docProps/app.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>OnlyOffice</Application>
</Properties>
EOF

    cd temp
    zip -r $out * [Content_Types].xml
  '';

  # Template PPTX vide (présentation PowerPoint)
  pptxTemplate = pkgs.runCommand "template.pptx" {
    buildInputs = [ pkgs.zip ];
  } ''
    mkdir -p temp/_rels temp/docProps temp/ppt temp/ppt/_rels temp/ppt/slides temp/ppt/slides/_rels temp/ppt/slideLayouts temp/ppt/slideMasters
    
    # [Content_Types].xml
    cat > temp/[Content_Types].xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
  <Override PartName="/ppt/slides/slide1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
EOF

    # _rels/.rels
    cat > temp/_rels/.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
EOF

    # ppt/presentation.xml
    cat > temp/ppt/presentation.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:sldIdLst>
    <p:sldId id="256" r:id="rId1"/>
  </p:sldIdLst>
  <p:sldSz cx="9144000" cy="6858000"/>
</p:presentation>
EOF

    # ppt/_rels/presentation.xml.rels
    cat > temp/ppt/_rels/presentation.xml.rels << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide1.xml"/>
</Relationships>
EOF

    # ppt/slides/slide1.xml
    cat > temp/ppt/slides/slide1.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr>
        <p:cNvPr id="1" name=""/>
        <p:cNvGrpSpPr/>
        <p:nvPr/>
      </p:nvGrpSpPr>
      <p:grpSpPr/>
    </p:spTree>
  </p:cSld>
</p:sld>
EOF

    # docProps/core.xml
    cat > temp/docProps/core.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:creator>NixOS Template</dc:creator>
  <dcterms:created xsi:type="dcterms:W3CDTF">2025-01-20T00:00:00Z</dcterms:created>
</cp:coreProperties>
EOF

    # docProps/app.xml
    cat > temp/docProps/app.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>OnlyOffice</Application>
</Properties>
EOF

    cd temp
    zip -r $out * [Content_Types].xml
  '';

  # Template Draw.io vide
  drawioTemplate = pkgs.writeText "template.drawio" ''
    <mxfile host="app.diagrams.net" modified="2025-01-20T00:00:00.000Z" agent="NixOS" version="24.0.0" etag="" type="device">
      <diagram id="template" name="Page-1">
        <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
          <root>
            <mxCell id="0"/>
            <mxCell id="1" parent="0"/>
          </root>
        </mxGraphModel>
      </diagram>
    </mxfile>
  '';

in
{
  home.activation.createTemplates = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p ${templatesDir}
    
    $DRY_RUN_CMD cp ${docxTemplate} ${templatesDir}/"Document.docx"
    $DRY_RUN_CMD cp ${xlsxTemplate} ${templatesDir}/"Tableur.xlsx"
    $DRY_RUN_CMD cp ${pptxTemplate} ${templatesDir}/"Présentation.pptx"
    $DRY_RUN_CMD cp ${drawioTemplate} ${templatesDir}/"Diagramme.drawio"
    
    $DRY_RUN_CMD chmod 644 ${templatesDir}/*
  '';

  xdg.userDirs.templates = templatesDir;
}
