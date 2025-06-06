# Afet Acil Durum Uygulaması
## Proje Tanımı
Bu proje, Türkiye’de yaşayan bireylerin deprem riskine karşı daha bilinçli ve hazırlıklı olmalarını sağlamak amacıyla geliştirilecek bir mobil uygulamayı kapsamaktadır. Flutter ile geliştirilecek olan bu uygulama sayesinde kullanıcılar sisteme kayıt olacakTIR. . Olası bir afet durumunda kullanıcılar, uygulama üzerinden yer alan "Acil Durum" butonunu kullanarak yardım talebinde bulunabilecek; uygun altyapı ve yetkilendirme mekanizmaları sayesinde bu bildirimle birlikte konum bilgileri, sistemde tanımlı olan yetkili kullanıcılarla (örneğin doktorlar, arama kurtarma ve acil müdahale ekipleri) paylaşılabilecektir. Uygulamanın şu aşamasında bu hizmetler tam sağlanamasa da zamanla geliştirlmesi hedeflenmektedir. Uygulamada şuan kayıt, tekilendirme ve doğrulama, REST API bağlantıları, database bağlantısı, telefon özelliklerine erişebilme, konum alma, bildirim gönderme ve sesli mesaj kaydının tutulması gibi özellikler eklenmiştir. Diğer özellikler şu aşamada gerçekleştirilememiş ama zaman içerisinde yapılması hedeflenmektedir.


## Kurulum
Proje, Android Studio kullanılarak Flutter ile geliştirilmiştir.
- Projeyi bağlantıdan klonlayın: *https://github.com/mvturkmen/afet_acil_durum_app.git*
- Android Studio üzerinden klonlanan proje klasörünü seçerek açın.
- Flutter ve Dart eklentilerinin kurulu ve etkin olduğundan emin olun.
- Bağımlılıkları yüklemek için terminalde *flutter pub get* komutunu çalıştırın.
- Uygun bir emülatör başlatın veya fiziksel bir cihaz bağlayın.
- Uygulamayı çalıştırmak için terminale *flutter run* komutunu girin.
- Uygulamanın veritabanı işlemleri Spring Boot projesi üzerinden REST API ile sağlanır.
- Flutter ve REST API iletişimi için localhost ngrok ile iletişime açılmıltır.
- ngrok adresini API bağlatılarının önüne kelemek gerekmektedir. 

*Not: Uygulamadaki kayıt/giriş, kişi ekleme/çıkarma gibi işlemler için, sunucunun (http://192.168.x.x:8080) çalışır durumda ve erişilebilir olması gerekmektedir.*
## Proje Ekibi ve Görev Dağılımı
### Ekip
| İsim                               |
|------------------------------------|
| Mehmet Vasfi Türkmen (Ekip Lideri) |
| Yavuz Selim Çoraklı                |
| Emir Sağlam                        |
| İrem Bengü Bal                     |

### Görev Dağılımı
| Özellik                                                   | Sorumlu              | Dal                             |
| :-------------------------------------------------------- | :------------------  | :------------------------------ |
| UI                                                        | İrem Bengü Bal       | develop-ui                      |
| Storage / Basic Data                                      | Yavuz Selim Çoraklı  | develop-storage-basic-data      |
| Local Database (Room / CoreData)                          | Mehmet Vasfi Türkmen | develop                         |
| RESTful API                                               | Mehmet Vasfi Türkmen | develop-rest-api                |
| Background Process / Task                                 | Yavuz Selim Çoraklı  | develop-background-process-task |
| Broadcast Receiver / NSNotification Server                | Emir Sağlam          | develop-notification-service    |
| Sensor (Location)                                         | Yavuz Selim Çoraklı  | develop-sensor-location         |
| Connectivity (BLE / Wi-Fi / Cellular Network / USB / NFC) | İrem Bengü Bal       | develop-connectivity            |
| Authorization (OAuth / OpenID / JWT)                      | Mehmet Vasfi Türkmen | develop-auth                    |
| Cloud Service (AI)                                        | Emir Sağlam          | develop-cloud-ai                |


## Özellikler ve Detayları
**1- UI**
  Uygulamanın acil durumlarda kullanımını kolaylaştırmak adına UI tasarımında amaç basit ve kullanım zorluğu olmayan etkili bir tasarım ortaya çıkarmaktı. Uygulamamızın ana tasarım prensibi AppBar() kullanılmadan ekrana temel butonların işlenmesi ve sayfa yönlendirmeleri için bottom_navigation_bqar kullanımı ile oluşturulmuştur. Uygulamamız ana sayfa, ayarlar, acil kişilerim, bildirimler, profil ve harita sayfalarından oluşmaktadır. 'material.dart' import'u ile er sayfada kullanılan widget tasarımları clean code prensibine uygun olarak dosyalara ayrılmıştır.

**2- Storage / Basic Data**
  Basic Data uygulamamız içerisinde kullanıcıların açık/koyu mod tercihini belirlemek ve bu bilgiyi depolamak amacıyla kullanılmıştır. Uygulama ayarları sekmesinden açık/koyu mod seçeneklerine ulaşan kullanıcıların tercihleri 'shared_preferences: ^2.5.3' paketi ile uygulamanın çalıştığı mobil cihazın depolama alanında json formatı ile tutulur ve buna göre özellik kullanılmış olur. 'shared_preferences: ^2.5.3' özelliği genel mobil programlama dünyasında LogIn işlemleri gibi kullanıcılara ait basit bilgilerin tutulmasında sıkça kullanılmaktadır. örn: 'Beni Hatırla' seçenekli giriş sayfaları. 

**3- Local Database (Room / CoreData)**
Kullanıcı tablolarını PostgreSql üzerinde tuttuk. Bu tercihimizde RESTFul API geliştirmesi sırasında JPA Repository kullanma avantajı etkili olmuştur. Bu aşamada users, emergency_contact,users_emergency_contacts ve deprem_bildirimi tabloları mevcuttur.  Users ve emergency_contact arasında many to many ilişkisi mevcuttur.

**4- RESTful API**
Uygulamamız için kendimiz API yazmaya karar verdik. Bunu yapmamızdaki ana sebep bazı verilerin yapay olması gerekmektedir (örneğin deprem bildirimi). Bu sebeple Spring Boot kullanarak RESTFul API yazdık. Create işlemi için kullanıcı kaydı, acil durum kişisinin eklenmesi; Read için deprem bildirimin okunması, kullanıcıya ait verilerin oknuması, kullancının belirlemiş olduğu acil durum kişilerinin listelenmesi; Update için acil durum kişisinin değişitirlmesi, Delere için acil durum kişisnin silinmesi örnek verilebilir. Bütün bu eylemler flutterda get,post,put,delete tipinde uygulanmıştır.


**5- Background Process / Task**


**6- Broadcast Receiver / NSNotification Server**
  Acil durumlarda insanlara anlık bilgilerin verilmesi amacı ile bildirimler ilgili projemizde oldukça önemli yer kaplamaktadır. Farklı kullanıcılardan gelen etkileşimler, yakınınızda meydana gelen depremler, bazı özelliklerin kullanımı durumlarında uygulamamızın bildirim sistemi çalışmaktadır. 'flutter_local_notifications: ^19.2.1' paketi ile etkili bir bildirim servisi oluşturulmuştur ve bildirim gönderme fonksiyonları özelleştirilerek farklı işlevlere farklı bildirimler gönderilmesi sağlanmıştır.

**7- Sensor (Location)**
  Uygulamanız, acil durumlarda bulunduğunuz konumu doğru ve hızlı bir şekilde tespit etmek için geolocator paketini kullanarak cihazınızın GPS sensöründen yararlanır. Bu sayede, yardım ekiplerine kesin konum bilgilerinizi (enlem ve boylam) ileterek size en kısa sürede ulaşmalarını sağlar.

Uygulama, mevcut konumunuzu otomatik olarak almanın yanı sıra, shared_preferences paketi aracılığıyla bu bilgiyi daha sonra kullanmak üzere güvenli bir şekilde kaydeder. Ayrıca, geocoding paketi sayesinde alınan koordinatları anlaşılır bir adres bilgisine dönüştürerek size ve yardım çağrısında bulunduğunuz kişilere daha net bilgi sunar. Konum servisleri kapalıysa veya izin reddedilirse, uygulama sizi uyararak izinleri yönetmenizi sağlar. Güvenliğiniz ve acil durumlarda hızlı müdahale için bu sensörün aktif ve izinlerinin verilmiş olması büyük önem taşır.

**8- Connectivity (BLE / Wi-Fi / Cellular Network / USB / NFC)**
  Uygulamanız, acil durumlarda kesintisiz iletişim sağlamak amacıyla cihazınızın internet bağlantı durumunu sürekli olarak izler. Bu izleme, connectivity_plus paketi kullanılarak Wi-Fi, mobil veri (hücresel ağ), Ethernet ve hatta VPN gibi çeşitli bağlantı tiplerini kapsar.

Uygulama, internet bağlantınızın çevrimiçi, çevrimdışı veya sınırlı olup olmadığını otomatik olarak algılar. İnternet erişimini kontrol etmek için http paketi ile düzenli aralıklarla güvenilir sunuculara ping atar ve DNS kontrolleri yaparak ağ durumunu doğrular. Bağlantı kesintilerinde veya değişikliklerinde sizi anında bilgilendirerek, acil durum mesajlarınızın ulaşılabilirliğini maksimize eder. Acil bir durumda, mevcut bağlantı durumunuzu hızlıca değerlendirerek mesaj gönderme veya yardım çağırma yeteneğinizi en iyi şekilde yönetir.

Bu kapsamlı bağlantı yönetimi, uygulamanızın kritik anlarda her zaman iletişimde kalmasını sağlar.

**9- Authorization (OAuth / OpenID / JWT)**
Yetkilendirme ve doğrulama işlemleri için Spring Security aracılığıyla JWT Token kullanılmıştır. Kayıt olma ve giriş yapma işlemleri dışındak tüm işlemler token beklemektedir. Token olmadan appin veritabanına veya bazı özel işlevlere erişmesi engellenmiştir. Ayrıca token ile beraber kullanıcı rolü de taşınmaktadır böylelikle ilerlyen gelişitirme aşamalarında kolaylık sağlaması beklenmektedir.


**10- Cloud Service (AI)**
  Deprem Afet Uygulamamızda yapay zeka teknolojisini insanların en zor durumda kalacağı zamanlarda kullanabileceği şekilde dahil etmek istedik. Kullanıcıların sıkıntılı anlarında tek tuş ile sesli mesajlarını oluşturabilecek ve bu ses metine dönüştürülebilir. Bunun için Dart dilinde 'speech_to_text: ^7.0.0' paketi kullanılmıştır. SpeechToText service dosyasında oluşturulan fonksiyonlar ile bu özellik doğru şekilde ui tarafına implemente edilmiş ve kullanılmıştır.



## Sonuç
