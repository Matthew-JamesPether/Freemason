<%
' --- Creates a error email if there are errors
Dim emailErrorBody

  ' --- Collect Form Data ---
  Dim name, email, phone, question1, question2, question3, question4, question5
  Dim quesOne, quesTwo, isEmployed, acknowledgesResponsibility, hasConsented
  Dim ipAddress, apiUrl, country 
  
  name = Request.Form("FNAME")
  email = Request.Form("EMAIL")
  phone = Request.Form("PHONE")
  question1 = Request.Form("question1")
  question2 = Request.Form("question2")
  question3 = Request.Form("question3")
  question4 = Request.Form("question4")
  question5 = Request.Form("question5")
  quesOne = Request.Form("QUESONE")
  quesTwo = Request.Form("QUESTWO")
  isEmployed = Request.Form("checkbox1")
  acknowledgesResponsibility = Request.Form("checkbox2")
  hasConsented = Request.Form("checkbox3")
  
  ' --- Gets IP Address ---
  On Error Resume Next
    ipAddress = Request.ServerVariables("HTTP_X_FORWARDED_FOR") ' May contain real IP if behind a proxy
  
    If ipAddress = "" Or IsNull(ipAddress) Then
        ipAddress = Request.ServerVariables("REMOTE_ADDR") ' Fallback to direct IP
    End If
  
    If Err.Number <> 0 Or ipAddress = "" Then
        emailErrorBody = emailErrorBody & "Error retrieving IP Address: " & Err.Description & vbCrLf & vbCrLf
        ipAddress = "Error"
    End If
  On Error GoTo 0
  
  ' --- Gets Location ---
  On Error Resume Next
    apiUrl = "http://ip-api.com/json/" & ipAddress & "?fields=country"
    Dim xmlHttp, responseText
  
    Set xmlHttp = Server.CreateObject("MSXML2.XMLHTTP")
    xmlHttp.Open "GET", apiUrl, False
    xmlHttp.Send
    responseText = xmlHttp.responseText
  
    Dim startPos, endPos
    startPos = InStr(responseText, "country") + 10
    endPos = InStr(startPos, responseText, """")
  
    country = Mid(responseText, startPos, endPos - startPos)
  
    If Err.Number <> 0 Or country = "" Then
        emailErrorBody = emailErrorBody & "Error retrieving Location: " & Err.Description & vbCrLf & vbCrLf
        country = "Error"
    End If

    Set xmlHttp = Nothing
  On Error GoTo 0
  
  ' --- Converts checkbox on to yes ---
  If isEmployed = "on" Then
      isEmployed = "yes"
  End If
  
  If acknowledgesResponsibility = "on" Then
      acknowledgesResponsibility = "yes"
  End If
  
  If hasConsented = "on" Then
      hasConsented = "yes"
  End If
  
  ' --- Construct Email Body ---
  Dim emailBody
  emailBody = "New Contact Form Submission:" & vbCrLf & vbCrLf
  emailBody = emailBody & "Name & Surname: " & name & vbCrLf
  emailBody = emailBody & "Email: " & email & vbCrLf
  emailBody = emailBody & "Phone: +27 " & phone & vbCrLf & vbCrLf
  emailBody = emailBody & "Are you a Male?: " & question1 & vbCrLf
  emailBody = emailBody & "Are you at least 21?: " & question2 & vbCrLf
  emailBody = emailBody & "Believe in Higher Power?: " & question3 & vbCrLf
  emailBody = emailBody & "Regular Income?: " & question4 & vbCrLf
  emailBody = emailBody & "Fluent in English/Afrikaans?: " & question5 & vbCrLf & vbCrLf
  emailBody = emailBody & "Understanding of Freemasonry: "& vbCrLf & quesOne & vbCrLf & vbCrLf
  emailBody = emailBody & "Expectations from Freemasonry: " & vbCrLf & quesTwo & vbCrLf & vbCrLf
  emailBody = emailBody & "Is Employed?: " & isEmployed & vbCrLf
  emailBody = emailBody & "Acknowledges Responsibility?: " & acknowledgesResponsibility & vbCrLf
  emailBody = emailBody & "Has consented to Privacy Policy?: " & hasConsented & vbCrLf & vbCrLf
  emailBody = emailBody & "IP Address: " & ipAddress & vbCrLf
  emailBody = emailBody & "Location: " & country & vbCrLf
  
  ' --- Creates an Email Object ---
  Dim objEmail
  Set objEmail = CreateObject("CDO.Message")
  
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.westerford.capetown"
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "website@westerford.capetown"
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "!5mEJrkj.#[1"
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
  objEmail.Configuration.Fields.Update
  
  objEmail.From = ""
  objEmail.To = ""
  objEmail.Subject = "New Applicant About Freemasonry"
  objEmail.TextBody = emailBody
  
  ' --- Sends the Email ---
  On Error Resume Next
    objEmail.Send
    If Err.Number <> 0 Then
        emailErrorBody = emailErrorBody & "Error sending email: " & Err.Description & vbCrLf & vbCrLf
    End If
  On Error GoTo 0

  ' --- Stores Data ---
  On Error Resume Next
  ' Define file path
  Dim filePath
  'filePath = Server.MapPath("data.txt")
  filePath = Server.MapPath("data.csv")

' --- Create FileSystemObject ---
  Dim fso, file
   Set fso = Server.CreateObject("Scripting.FileSystemObject")

' --- Check if the file exists, if not, create it ---
  If Not fso.FileExists(filePath) Then
    Set file = fso.CreateTextFile(filePath, True)
   Else
    Set file = fso.OpenTextFile(filePath, 8, True) ' 8 = Append mode
  End If

 ' --- Write data to the file ---
 If Not file Is Nothing Then
  '  file.WriteLine "Name: " & name
  '  file.WriteLine "Email: " & email
  '   file.WriteLine "Phone: " & phone
  '   file.WriteLine "Question 1: " & question1
  '   file.WriteLine "Question 2: " & question2
  '   file.WriteLine "Question 3: " & question3
  '   file.WriteLine "Question 4: " & question4
  '   file.WriteLine "Question 5: " & question5
  '   file.WriteLine "Ques One: " & quesOne
  '   file.WriteLine "Ques Two: " & quesTwo
  '   file.WriteLine "Is Employed: " & isEmployed
  '   file.WriteLine "Acknowledges Responsibility: " & acknowledgesResponsibility
  '   file.WriteLine "Has Consented: " & hasConsented
  '   file.WriteLine "IP Address: " & ipAddress
  '   file.WriteLine "Country: " & country
  '   file.WriteLine "----------------------------"
    file.WriteLine name & "," & email & "," & phone & "," & question1 & "," & question2 & "," & question3 & "," & question4 & "," & question5 & "," & quesOne & "," & quesTwo & "," & isEmployed & "," & acknowledgesResponsibility & "," & hasConsented & "," & ipAddress & "," & country
    file.Close
  End If

' --- Clean Up ---
  Set file = Nothing
  Set fso = Nothing

    If Err.Number <> 0 Then
        Response.Redirect "Error downloading data: " & Err & vbCrLf & vbCrLf
    End If
  On Error GoTo 0

  ' --- Sends Errors ---
  On Error Resume Next
    if Not IsNull(emailErrorBody) And emailErrorBody <> "" Then
       objEmail.To = ""
       objEmail.Subject = "New Applicant About Freemasonry ERROR"
       objEmail.TextBody = emailErrorBody
       objEmail.Send
    End If
  On Error GoTo 0

' --- Clean Up ---
Set objEmail = Nothing

Response.Redirect "/callmeback/" 
%>