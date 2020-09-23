module Config
  def self.get_config
    {
      'public_key_id': 'AEO4YB57QJUNBB5GHTCIK5E2', # Enter your Public Key ID
      'private_key': %(-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCh++Y3ZmSqiKXv
tNeOcQYDRJIR1iw3PMWV7jlMByURqORSAXzz/uOW1BkwSJxkoSZw+46ASyxPQFcJ
wozeh25QkQwtC+DyfSNdSU0RmwaEPn5kRQu5c+0cWf4ms0mmNb2KLc9Yz7xrGu8C
sjh7se7fhjnqNahTWx29cCgj/9d5RC/a2S8SuW2yhJUQjEu0dGTfRvibm1j//itn
9ULJDRGLsISIxmvk8WvJ78LUcwnHXQmBz+JtqWk0MzCSsPQ12Fw/C1dPze6U1wiW
DYcfPjqrsJnbTp3D4WSBlWA8r+YFkLZ5Zlk9eXXVXi3xL9bR5n6eES6AwKRwPdXq
zASZX52dAgMBAAECggEAAhedWSDW8wbx0b9Nu3bFQ5yKoHVaO9pqmO2rSsqa1XgP
fumrAgHMUcHqk1+UuY4FT5dIN2sBJwLnPOaI6ETqjVraQ+iv3qH0J3vPZYdRlbqy
6jukE6CmMuQMrtZJAL8X9CV0VKrWPbHq3WeM6DgbpEJ5FAfeZTk7kJtWwWRIFbZg
/vbVJgHDp6WhXHSf57I7lUpqrWxq+QZ24eV+6GJr6U4zwdHcXDayuVw6s6sIIQzq
V/y61gaJV3KnWHZ256TLrhhLR3E+WiVpCf+f/gf22x3ljAbj/wc4WBMqpOIFaBIn
9SWSFf2EGoQqJNDoPyVwt/X1S0CCLNgmtJLydlBdcQKBgQDPFAeKKoVaBLg2Oxaj
js6FV/zc2gktcSv27pjTwm6682xn3Bx8s/mUQczuI7SnVAMSygOqtpa6OEW6K+gQ
nF6Me0yke4rFiHcBXqDsHWsv9aY2dlc3akyqIcsbJR7Kxz11mZi6MqqM3beO+Oi4
yKb/0Tgf+uUvefDn51DivL1LZQKBgQDIQJhzz+KGeYtY6R8OHgu0bSFKh1Ny8lY9
cAXZXQL0ip9sqIujQssaMrdNFdVHW+Z4fIA2Rum+3a/UuMxoLcDIY25xlfTlMCH5
yUsKGZPeryjiIdj/2n+Y3gxIZ1swFS1Kdcu8golTG47VG/K5AtczYDmaeweh6o7+
bW8GQzUR2QKBgCccZ1gnM8yOu6QygNIfdM4mkjG8VKNqjp0y71Z/kJ5qv3zWS+MZ
svfXfbc0szgvW+0+jna9ybYeTr0c8dXBUvJBj3Y5hzpLzf5KOyadX9NNGDmNHGfx
Ac3YWB4mYqx1+RuvCPOSAjhc4AB27q2H6FLE107i+kp/Q4rpW5OXhkEpAoGAENVF
O279Jrqu2QF3p9MkvrzxsHchr6bpUu7IvxXPesjwT8z3N/kUY5ZhzCwKqp3yCKzG
hkl9upqd/i6umA9Ihk+9Z/ToCh/6qymdkjLGOFDXCfM4b4Fpemsn8yolAyy0iu7N
+oGqk37cidN4ms6/UkVDclXnNVgnPwHp9EfP/TkCgYBTnZCO04F1QRmwJTu8y8pV
M3mDBn+yMPr/2GITvt5eVyIkjwWLRqqDF93mYKJjgoKXmw/hgg6mqU454ml2vZat
+F3zYwzzvAT9DtvJtM/ExkF8dqpHKNxAQY9UT2G/V2IinltTt4HJiMXFa6flR3PX
I+9JK52UwNh9XlrU2XtkPQ==
-----END PRIVATE KEY-----
),
      #File.read(File.expand_path('tst/private.pem', __dir__)), # Path to your private key file or replace with your private key string
      'region': 'us',
      'sandbox': true,
      'currency_code': 'USD',
      'country_code': 'US',
      'store_id': 'amzn1.application-oa2-client.a950c92bb0cc4ae08ef395668b702bb9'
    }
  end
end
