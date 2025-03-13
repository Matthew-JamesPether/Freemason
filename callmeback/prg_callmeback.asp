<%
' --- Collect Form Data ---
Dim name, email, phone, question1, question2, question3, question4, question5
Dim quesOne, quesTwo, isEmployed, acknowledgesResponsibility, hasConsented

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
' ipAddress = Request.Form("IPADDRESS");

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
emailBody = emailBody & "Understanding of Freemasonry: " & quesOne & vbCrLf
emailBody = emailBody & "Expectations from Freemasonry: " & quesTwo & vbCrLf & vbCrLf
emailBody = emailBody & "Is Employed?: " & isEmployed & vbCrLf
emailBody = emailBody & "Acknowledges Responsibility?: " & acknowledgesResponsibility & vbCrLf
emailBody = emailBody & "Has consented to Privacy Policy?: " & hasConsented & vbCrLf
' emailBody = emailBody & "IP Address: " & ipAddress & vbCrLf

' --- Create and Send Email ---
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

objEmail.From = "website@westerford.capetown"
objEmail.To = "sean@twhconsult.co.za, Za.marco.petronio@gmail.com"
objEmail.Subject = "New Applicant About Freemasonry"
objEmail.TextBody = emailBody

' Send Email
On Error Resume Next
objEmail.Send
If Err.Number <> 0 Then
    Response.Write "Error sending email, please inform the freemason that sent you the link: " & Err.Description
Else
    Response.Write "Thank you! Your message has been sent."
    Response.Redirect "/callmeback/"
End If
On Error GoTo 0

' Clean Up
Set objEmail = Nothing
%>