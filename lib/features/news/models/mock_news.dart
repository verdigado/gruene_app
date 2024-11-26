import 'package:gruene_app/features/news/models/news_model.dart';

List<NewsModel> news = [
  NewsModel(
    id: 1,
    title: 'Webinar: Windenergie vom Meer',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image:
        'https://s3-alpha-sig.figma.com/img/bfd0/2ea5/749fd412dde388ef7d9e7267af8a0986?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=hUAbUIwao6v6OSKxGpMwi~qu8y2-Jd0pSGjukJRy5ypQVr7I62Odqt4aoOING8-4y2UW3TpJ7GMZNUCiRjPKp3uOxkVKOfKRIHoGUJHTGzp~CkavaYNrOaXjDMnyYBbCoIVafTFJ5buL21uzPAKppmeYrErJvzeD1jpUpEn85AUqosW9gWzwEgtQ1IK35EBp6hCVP~CuE535yYDMttXJ20UsdGLiAtW~J0AQHSmtpC4119gJlP3Pt0Xa4~dbpV6JK7hsgcuxJBKHU5z3axD6dbVA8o5XKRIosvBFXs6bhwx7gfT4gzL6rN-Dc4TU4BEYdHecQL3tdswo1WT5IZX33g__',
    type: 'event',
    creator: 'federal',
    categories: ['education'],
    date: DateTime(2022, 12, 12),
  ),
  NewsModel(
    id: 1,
    title: 'Webinar: Arbeit im Kreisverband',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image:
        'https://s3-alpha-sig.figma.com/img/e795/0097/61d6245d6cdf8ffa3424fe89b5ec2428?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=dx~vxzw5T~NzEUd4~4QyHyttDB0AXApAEwHhnrjZFFjF-f~JiW~HU3yClTkgze-16bEHEGDKC4aBBAH~JI-Oo4Etss6iBFFX7TY6c~vgoBVQwxKTrHLKSorYBE5sXffHS94uXv~PhqSyq6SoPEUCXnxqaBEpWUdoRw5UZ8k8qM04ONuNR1SJU2~cF7VsePYNSZ2jED~vdrGEAZoVKge7LS8sOQcTqha5vgrT8ZQjTkW2IUYJ5OroSugTpIHGTzSaMUvs~a6D4xRyRfZs4EI1boYHRIY41WJMPrCJA-Q3JfBA1mYQNEWqZaKipjor6vNAiEXI8FXzY1rWneQrYUbgoA__',
    type: 'event',
    creator: 'state',
    categories: ['campaign'],
    date: DateTime(2022, 1, 14),
  ),
  NewsModel(
    id: 1,
    title: 'Gemeinsam haben wir unseren Rekord gebrochen',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image:
        'https://s3-alpha-sig.figma.com/img/09c8/39a2/2b6fd45df27601911f9cd808020fa182?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=T-onORwX6fIsfqGHnyNqdxJqFTYP4olsw6Lh9Li3H9tDdqIJt-wj~ZK~IzFxTReQYYEblOQOEf69VUQOr3mOcP9iopo1kj23CackPR6ForQHz~f99mCYIUqEC5-347Ph54qp3Yr~MQU-uhRHxkB8B1vFc-t4IHNmlxEPuzmL0CP~9Dr89dVo1uKXUZ0qjpriajVi3dxRg7vIsIUGPjWnEVCw8WZp9PCQAP5VAxaJtG7IvsbXMQor4pLDLPFy2Xg7VwHinYNR9p4Y4Q7Bz3Bscz7ZTTiwG7amHw~uEcsgTiKeI7BBhMUCCWShhb2d67OKVHawZ4bhBNmknZiHC0kdwQ__',
    type: 'event',
    creator: 'district',
    categories: ['argumentation'],
    date: DateTime(2024, 10, 2),
  ),
  NewsModel(
    id: 1,
    title: 'Webinar: Windenergie vom Meer',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image:
        'https://s3-alpha-sig.figma.com/img/bfd0/2ea5/749fd412dde388ef7d9e7267af8a0986?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=hUAbUIwao6v6OSKxGpMwi~qu8y2-Jd0pSGjukJRy5ypQVr7I62Odqt4aoOING8-4y2UW3TpJ7GMZNUCiRjPKp3uOxkVKOfKRIHoGUJHTGzp~CkavaYNrOaXjDMnyYBbCoIVafTFJ5buL21uzPAKppmeYrErJvzeD1jpUpEn85AUqosW9gWzwEgtQ1IK35EBp6hCVP~CuE535yYDMttXJ20UsdGLiAtW~J0AQHSmtpC4119gJlP3Pt0Xa4~dbpV6JK7hsgcuxJBKHU5z3axD6dbVA8o5XKRIosvBFXs6bhwx7gfT4gzL6rN-Dc4TU4BEYdHecQL3tdswo1WT5IZX33g__',
    type: 'event',
    creator: 'federal',
    categories: ['education'],
    date: DateTime(2022, 12, 12),
  ),
];
