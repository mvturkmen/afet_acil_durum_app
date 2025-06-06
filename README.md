# Afet Acil Durum Uygulaması
## Tanım
Bu proje, Türkiye’de yaşayan bireylerin deprem riskine karşı daha bilinçli ve hazırlıklı olmalarını sağlamak amacıyla geliştirilen bir mobil uygulamayı kapsamaktadır. Flutter ile geliştirilecek olan bu uygulama sayesinde kullanıcılar sisteme kayıt olabileceklerdir. Olası bir afet durumunda, kullanıcılar uygulama üzerinde yer alan "Acil Durum" butonunu kullanarak yardım talebinde bulunabilecek; uygun altyapı ve yetkilendirme mekanizmaları sayesinde bu bildirimle birlikte konum bilgileri, sistemde tanımlı yetkili kullanıcılarla (örneğin; doktorlar, arama kurtarma ve acil müdahale ekipleri) paylaşılabilecektir.

Uygulamanın bu aşamasında söz konusu hizmetlerin tamamı henüz sağlanamasa da, zaman içinde geliştirilmesi hedeflenmektedir. Mevcut durumda uygulamaya kayıt, tekil kullanıcı tanımlama ve doğrulama, REST API bağlantıları, veritabanı entegrasyonu, telefonun yerel özelliklerine erişim, konum alma, bildirim gönderme ve sesli mesaj kaydı gibi özellikler eklenmiştir. Diğer planlanan özelliklerin ise ilerleyen süreçte uygulamaya entegre edilmesi amaçlanmaktadır.


## Kurulum
Proje, Android Studio kullanılarak Flutter ile geliştirilmiştir.
- Projeyi bağlantıdan klonlayın: **https://github.com/mvturkmen/afet_acil_durum_app.git**
- Android Studio üzerinden klonlanan proje klasörünü seçerek açın.
- Flutter ve Dart eklentilerinin kurulu ve etkin olduğundan emin olun.
- Bağımlılıkları yüklemek için terminalde **flutter pub get** komutunu çalıştırın.
- Uygun bir emülatör başlatın veya fiziksel bir cihaz bağlayın.
- Uygulamayı çalıştırmak için terminale **flutter run** komutunu girin.

**Not: Uygulamadaki kayıt/giriş, kişi ekleme/çıkarma gibi işlemlerin sorunsuz çalışabilmesi için, veritabanı işlemlerini yürüten sunucunun (http://192.168.x.x:8080) aktif ve erişilebilir olması gerekmektedir. Bu işlemler, Spring Boot ile sağlanan REST API üzerinden gerçekleştirilmektedir. Flutter uygulaması ile bu REST API arasındaki iletişim, localhost üzerinden ngrok ile dış erişime açılmıştır. Bu nedenle, API bağlantılarında ngrok tarafından sağlanan adresin kullanılması gerekmektedir.**


## Ekip ve Görev Dağılımı
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
| Local Database (Room / CoreData)                          | Mehmet Vasfi Türkmen | develop-rest-api / develop-auth |
| RESTful API                                               | Mehmet Vasfi Türkmen | develop-rest-api                |
| Background Process / Task                                 | Yavuz Selim Çoraklı  | develop-background-process-task |
| Broadcast Receiver / NSNotification Server                | Emir Sağlam          | develop-notification-service    |
| Sensor (Location)                                         | Yavuz Selim Çoraklı  | develop-sensor-location         |
| Connectivity (BLE / Wi-Fi / Cellular Network / USB / NFC) | İrem Bengü Bal       | develop-connectivity            |
| Authorization (OAuth / OpenID / JWT)                      | Mehmet Vasfi Türkmen | develop-auth                    |
| Cloud Service (AI)                                        | Emir Sağlam          | develop-cloud-ai                |


## Özellikler ve Detayları
**1- UI**:
Uygulamanın acil durumlarda kullanımını kolaylaştırmak adına, UI tasarımında amaç; basit, kullanıcı dostu ve etkili bir arayüz ortaya çıkarmaktır. Uygulamamızın ana tasarım prensibi, AppBar() kullanılmadan temel butonların doğrudan ekrana yerleştirilmesi ve sayfa yönlendirmeleri için bottom_navigation_bar kullanılması şeklinde oluşturulmuştur. Uygulama; Ana Sayfa, Ayarlar, Acil Kişilerim, Bildirimler, Profil ve Harita sayfalarından oluşmaktadır. "material.dart" içe aktarılmasıyla her sayfada kullanılan widget tasarımları, temiz kod prensibine uygun olarak ayrı dosyalara ayrılmıştır.

**2- Storage / Basic Data**:
Uygulamamız içerisinde kullanıcıların açık/koyu mod tercihini belirlemek ve bu bilgiyi saklamak amacıyla kullanılmıştır. Uygulama içerisindeki "Ayarlar" sekmesinden açık/koyu mod seçeneklerine ulaşan kullanıcıların tercihleri, "shared_preferences" paketi kullanılarak cihazın yerel depolama alanında JSON formatında saklanır ve bu tercihe göre uygulama teması şekillendirilir. shared_preferences paketi, mobil programlama dünyasında genellikle kullanıcıya ait basit verilerin (örneğin, giriş bilgilerinin) saklanmasında tercih edilmektedir. Örnek kullanım alanlarından biri, "Beni Hatırla" seçeneğinin bulunduğu giriş ekranlarıdır.

**3- Local Database (Room / CoreData)**:
Kullanıcı tabloları PostgreSQL üzerinde tutulmuştur. Bu tercihte, RESTful API geliştirme sürecinde JPA Repository kullanımının sağladığı avantajlar etkili olmuştur. Bu aşamada veritabanında "users", "emergency_contact", "users_emergency_contacts" ve "deprem_bildirimi" adlı tablolar mevcuttur. users ve emergency_contact tabloları arasında many-to-many (çoktan çoğa) bir ilişki bulunmaktadır.

**4- RESTful API**:
Uygulamamız için kendi API'mizi yazmaya karar verdik. Bu kararı almamızdaki temel neden, bazı verilerin yapay olarak oluşturulması gerekmesiydi (örneğin, deprem bildirimi). Bu nedenle, Spring Boot kullanarak bir RESTful API geliştirdik.
- Create işlemleri kapsamında: kullanıcı kaydı ve acil durum kişisi ekleme,
- Read işlemleri kapsamında: deprem bildiriminin görüntülenmesi, kullanıcıya ait verilerin okunması ve kullanıcının belirlediği acil durum kişileri listesinin alınması,
- Update işlemleri kapsamında: acil durum kişisinin bilgilerinin güncellenmesi,
- Delete işlemleri kapsamında: acil durum kişisinin silinmesi  
örnek olarak verilebilir. Tüm bu işlemler Flutter tarafında sırasıyla GET, POST, PUT, ve DELETE HTTP metodları kullanılarak gerçekleştirilmiştir.

**5- Background Process / Task**:
Uygulama, ön planda veya arka planda çalışırken konum takibi yapmaktadır. Bu amaçla, "workmanager" paketinin zamanla görevleri tetiklemesi sayesinde; kullanıcı konum izni verdiğinde, uygulama 15 dakikalık aralıklarla otomatik olarak güncel konumu almaktadır. Alınan konumlar, shared_preferences paketi ile cihazın yerel depolama alanında güvenli bir şekilde saklanır. Böylece, uygulama aktif olduğu sürece konum geçmişi tutulabilir ve acil durumlarda bu bilgiler kullanılabilir. Bu yöntem, uygulamanın performansını korurken, kullanıcıların konum verilerinin düzenli ve güvenli biçimde güncellenmesini sağlar.

**6- Broadcast Receiver / NSNotification Server**:
Acil durumlarda kullanıcılara anlık bilgi sağlamak, uygulamamızda büyük önem taşımaktadır. Bildirim sistemi; farklı kullanıcılardan gelen etkileşimler, yakın çevrede meydana gelen depremler ve belirli özelliklerin kullanımı gibi durumlarda devreye girmektedir. Bu sistem, "flutter_local_notifications" paketi kullanılarak oluşturulmuştur. Bildirim gönderme fonksiyonları özelleştirilmiş ve böylece farklı senaryolar için farklı türde bildirimlerin iletilmesi sağlanmıştır.

**7- Sensor (Location)**:
Uygulama, acil durumlarda bulunduğunuz konumu doğru ve hızlı bir şekilde tespit edebilmek için "geolocator" paketi aracılığıyla cihazınızın GPS sensöründen yararlanır. Bu sayede yardım ekiplerine kesin konum bilgileriniz (enlem ve boylam) iletilerek size en kısa sürede ulaşmaları sağlanır. Mevcut konumunuzu otomatik olarak alan uygulama, bu bilgiyi shared_preferences paketi ile güvenli bir şekilde yerel depolamaya kaydeder ve gerektiğinde tekrar kullanır. Ayrıca, "geocoding" paketi sayesinde alınan koordinatlar, anlaşılır bir adres bilgisine dönüştürülerek hem size hem de yardım çağrısı gönderdiğiniz kişilere daha net bilgi sunulur. Konum servisleri kapalıysa veya konum izni reddedilmişse, uygulama sizi bilgilendirerek gerekli izinleri yönetmenizi sağlar. Güvenliğiniz ve acil durumlarda hızlı müdahale için konum servislerinin aktif olması ve gerekli izinlerin verilmiş olması büyük önem taşır.

**8- Connectivity (BLE / Wi-Fi / Cellular Network / USB / NFC)**:
Uygulama, acil durumlarda kesintisiz iletişim sağlamak amacıyla cihazınızın internet bağlantı durumunu sürekli olarak izler. Bu izleme, "connectivity_plus" paketi kullanılarak Wi-Fi, mobil veri (hücresel ağ), Ethernet ve VPN gibi çeşitli bağlantı türlerini kapsar. İnternet bağlantınızın çevrimiçi, çevrimdışı veya sınırlı olup olmadığını uygulama otomatik olarak algılar. Bağlantı durumunu doğrulamak için http paketi ile düzenli aralıklarla güvenilir sunuculara ping atar ve DNS kontrolleri gerçekleştirir. Bağlantı kesildiğinde veya değiştiğinde sizi anında bilgilendirerek, acil durum mesajlarınızın ulaşılabilirliğini maksimize eder. Acil bir durumda mevcut bağlantı durumunu hızlıca değerlendirerek mesaj gönderme veya yardım çağırma işlemlerinin en etkin şekilde yönetilmesini sağlar. Bu kapsamlı bağlantı yönetimi, uygulamanın kritik anlarda her zaman iletişimde kalmasını garanti eder.

**9- Authorization (OAuth / OpenID / JWT)**:
Yetkilendirme ve doğrulama işlemleri için Spring Security kullanılarak JWT (JSON Web Token) tabanlı bir sistem uygulanmıştır. Kayıt olma ve giriş yapma işlemleri dışındaki tüm API çağrılarında geçerli bir token talep edilmektedir. Token olmadan uygulamanın veritabanına veya bazı özel işlevlere erişim engellenmiştir. Ayrıca, token içerisinde kullanıcı rolü bilgisi de taşınmaktadır; bu sayede ilerleyen geliştirme aşamalarında rol bazlı yetkilendirme işlemleri kolayca uygulanabilecektir.

**10- Cloud Service (AI)**:
Uygulamamızda, yapay zeka teknolojisini kullanıcıların en zor anlarında faydalı olacak şekilde entegre etmeyi hedefledik. Kullanıcılar, tek bir dokunuşla sesli mesajlarını oluşturabilir ve bu sesli mesajlar metne dönüştürülebilir. Bu özellik için Dart dilinde "speech_to_text" paketi kullanılmıştır. SpeechToText servis dosyasında oluşturulan fonksiyonlar sayesinde, bu özellik doğru ve etkin bir şekilde UI tarafına entegre edilmiştir.
