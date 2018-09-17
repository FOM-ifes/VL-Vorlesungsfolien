#
# private_mail_default.R
# ======================
#
# Bitte hier die Einstellungen einarbeiten und die 
# Datei unter "private_mail.R" im Hauptverzeichnis speichern!
#
smtpPrivate = list(
    host.name = "smtp-mail.outlook.com",     # SMTP Host
    port = 587,                              # SMTP Port
    user.name = "nmarkgraf@hotmail.com",     # User 
    passwd = "<PASSWORT>",                   # Password
    tls = TRUE                               # StartTLS ?
#   SSL = TRUE                               # SSL ?
)

# Entweder so:
#senderPrivate = "Norman Markgraf <nmarkgraf@hotmail.com>"
# Oder alternativ so:
#senderPrivate = "nmarkgraf@hotmail.com

senderPrivate = "Norman Markgraf <nmarkgraf@hotmail.com>"