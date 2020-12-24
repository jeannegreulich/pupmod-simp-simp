# Valid SSL Cipher Suites for puppetdb
type Simp::Puppetdb::Ciphersuites = Enum[
  'TLS_RSA_WITH_AES_256_GCM_SHA384',
  'TLS_RSA_WITH_AES_256_CBC_SHA256',
  'TLS_RSA_WITH_AES_256_CBC_SHA',
  'TLS_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_RSA_WITH_AES_128_CBC_SHA',
  'TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384',
  'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384',
  'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA',
  'TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA',
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384',
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA',
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA',
  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384',
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384',
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA',
  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA',
  'TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384',
  'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384',
  'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA',
  'TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA',
  'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384',
  'TLS_DHE_RSA_WITH_AES_256_CBC_SHA256',
  'TLS_DHE_RSA_WITH_AES_256_CBC_SHA',
  'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_DHE_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_DHE_RSA_WITH_AES_128_CBC_SHA',
  'TLS_DHE_DSS_WITH_AES_256_GCM_SHA384',
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256',
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA',
  'TLS_DHE_DSS_WITH_AES_128_GCM_SHA256',
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256',
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA',
  'TLS_EMPTY_RENEGOTIATION_INFO_SCSV'
]