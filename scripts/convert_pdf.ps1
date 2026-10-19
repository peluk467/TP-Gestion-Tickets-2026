[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFolder, Windows.Storage, ContentType = WindowsRuntime] | Out-Null

$scriptDir = $PSScriptRoot
$repoDir = Split-Path $scriptDir -Parent
$incidenciaDir = Split-Path $repoDir -Parent
$folderPath = Join-Path $incidenciaDir "CAPTURAS_TP"
$pdfPath = Join-Path $folderPath "Resumen - MantisBT.pdf"

Write-Output "Carpeta capturas: $folderPath"
Write-Output "Archivo PDF: $pdfPath"

$storageFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath).GetAwaiter().GetResult()
$pdfDoc = [Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($storageFile).GetAwaiter().GetResult()

Write-Output ("Total paginas PDF: " + $pdfDoc.PageCount)

$folder = [Windows.Storage.StorageFolder]::GetFolderFromPathAsync($folderPath).GetAwaiter().GetResult()

for ($i = 0; $i -lt $pdfDoc.PageCount; $i++) {
    $page = $pdfDoc.GetPage($i)
    $fileName = "Resumen_MantisBT_page$($i + 1).png"
    $file = $folder.CreateFileAsync($fileName, [Windows.Storage.CreationCollisionOption]::ReplaceExisting).GetAwaiter().GetResult()
    $stream = $file.OpenAsync([Windows.Storage.FileAccessMode]::ReadWrite).GetAwaiter().GetResult()
    
    $options = [Windows.Data.Pdf.PdfPageRenderOptions]::new()
    $options.DestinationWidth = 2400
    
    $page.RenderWithOptionsToStreamAsync($stream, $options).GetAwaiter().GetResult()
    $stream.FlushAsync().GetAwaiter().GetResult()
    $stream.Dispose()
    Write-Output "Generado exitosamente: $fileName"
}
