# CertificateSigningRequestSwift_Test
Simple app that tests the CertificateSigningRequestSwift framework

This application tests the CertificateSigningRequestSwift framework (https://github.com/cbaker6/CertificateSigningRequestSwift). If the framework is not available after forking. Follow these directions:

- Fork the CertificateSigningRequestSwift framework (https://github.com/cbaker6/CertificateSigningRequestSwift)
- Build the project
- Look under "Frameworks" in the CertificateSigningRequestSwift, and drag "CertificateSigningRequestSwift.framework" into CertificateSigningRequestSwift_Test project in the following:

- In CertificateSigningRequestSwift_Test Targets, click on "General"
- Place "CertificateSigningRequestSwift.framework" in "Embedded Binaries" and it should automatically appear in "Linked Frameworks and Libraries"
- Select copy to directory if needed
- Then, simply place "import CertificateSigningRequestSwift" at the top of any file that needs the framework.

Build and run the test and the CSR will be printing in the debug window. You should get something like:

-----BEGIN CERTIFICATE REQUEST-----
MIIBFTCBuwIBADBZMQswCQYDVQQGDAJVUzENMAsGA1UECgwEVGVzdDENMAsGA1UE
CwwEVGVzdDEsMCoGA1UEAwwjQ2VydGlmaWNhdGVTaWduaW5nUmVxdWVzdFN3aWZ0
IFRlc3QwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATC24iJCr7abrZN0BPaYcM+
cKd/4iXBtHuIM4LzOszsU5pQ9dc9s+srChfWu6m1nCgN48ZHwApTyKV/O0yWWcLA
oAAwCgYIKoZIzj0EAwIDSQAwRgIhAPI2FW/izEz8SHAMStctamIzTne+g6AHQWai
X0OfkwoBAiEAzXqgv6WVn+VMyxiA25eMc8/Zzrj/mWpew6INRZ1pA1g=
-----END CERTIFICATE REQUEST-----

You can test if the CSR was created correctly here: https://redkestrel.co.uk/products/decoder/
