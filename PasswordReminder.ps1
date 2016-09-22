import-module ActiveDirectory;

$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
#Modify next two lines by entering email address and email server to send from
$from = "Enter Email Address"
$smtp = "Enter Mail Server IP"

Get-ADUser -filter * -properties PasswordLastSet, PasswordExpired, PasswordNeverExpires, EmailAddress, GivenName | foreach {
 
    $today=get-date
    $UserName=$_.GivenName
    $Email=$_.EmailAddress
 
    if (!$_.PasswordExpired -and !$_.PasswordNeverExpires) {
 
        $ExpiryDate=$_.PasswordLastSet + $maxPasswordAgeTimeSpan
        $DaysLeft=($ExpiryDate-$today).days
 
        if ($DaysLeft -lt 7 -and $DaysLeft -gt 0){
 
        $WarnMsg = "
<p style='font-family:calibri'>Hi $UserName,</p>
<p style='font-family:calibri'>Your Windows login password will expire in $DaysLeft days, please press CTRL-ALT-DEL and change your password.  As a reminder, you will have to enter your new password into your Fritz connected mobile device if prompted.</p>

<p style='font-family:calibri'>Requirements for the password are as follows:</p>
<ul style='font-family:calibri'>
<li>Must not contain the user's account name or parts of the user's full name that exceed two consecutive characters</li>
<li>Must not be one of your last 7 passwords</li>
<li>Contain characters from three of the following four categories:</li>
<li>English uppercase characters (A through Z)</li>
<li>English lowercase characters (a through z)</li>
<li>Base 10 digits (0 through 9)</li>
<li>Non-alphabetic characters (for example, !, $, #, %)</li>
</ul>

<p style='font-family:calibri'>-Technology Services</p>
 
"
ForEach ($email in $_.EmailAddress) { 
send-mailmessage -to $email -from $from -Subject "Password Reminder: Your password will expire in $DaysLeft days" -body $WarnMsg  -smtpserver $smtp -BodyAsHtml }

    	}
 
    }
}