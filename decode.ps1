Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Decrypt-Image {
    # The key must match the one used during encryption
    $keyString = "secureKey12345" # Use the same key as in the C# encryption code
    $key = [System.Text.Encoding]::UTF8.GetBytes($keyString.PadRight(16, ' '))  # Ensure the key is 16 bytes
    $iv = @(0..15 | ForEach-Object { 0 })  # 16-byte zero IV, same as during encryption

    $tempPath = [System.IO.Path]::GetTempPath()
    $hiddenDir = Join-Path $tempPath "hidden"
    $inputFile = Join-Path $hiddenDir "photo.dat"
    $outputFile = Join-Path $hiddenDir "photo.jpg"

    if (-Not (Test-Path $inputFile)) {
        Write-Host "❌ Encrypted file not found at: $inputFile"
        return
    }

    try {
        $cipherBytes = [System.IO.File]::ReadAllBytes($inputFile)

        # AES decryption
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $key
        $aes.IV = $iv

        # Ensure that you're using the correct decryption mode and padding scheme
        $decryptor = $aes.CreateDecryptor()
        $ms = New-Object System.IO.MemoryStream
        $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

        $cs.Write($cipherBytes, 0, $cipherBytes.Length)
        $cs.FlushFinalBlock()
        $cs.Close()

        $plainBytes = $ms.ToArray()
        [System.IO.File]::WriteAllBytes($outputFile, $plainBytes)

        Write-Host "✅ Decrypted image saved to: $outputFile"
    }
    catch {
        Write-Host "⚠️ Error:" $_.Exception.Message
    }
}

Decrypt-Image
