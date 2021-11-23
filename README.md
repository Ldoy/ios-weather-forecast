# 🌤날씨정보 리드미(ing) 


# 키워드 


# 구현 기능과 이를 위한 설계
1. 유연하고 재사용성이 높은 네트워크 요청 타입 구현하기
- POP를 지향하여 수평적인 확장 이루어 질 수 있도록 설계
    <details>
    <summary> <b> 코드 </b>  </summary>
    <div markdown="1">
    
    ```swift
    //HTTP Reqeust시 사용되는 요소를 가지고 있는 EndPoint 프로토콜
    protocol EndPoint {
        var httpTask: HTTPTask { get }
        var httpMethod: HTTPMethod { get }
        var baseUrl: URL { get }
    }    
    
    /*HTTP 메소드에 따라 바뀌는 URL 및  
    HTTP Reqeust Body의 생성 여부를 분기하기 위한 열거형*/
    enum HTTPTask {
    case request(withUrlParameters: Parameters)
    }
    
    // URLRequest의 url, httpBody 정보 등을 구성하는 프로토콜 구현. 
    protocol RequesConfigurable {
        static func configure(urlRequest: inout URLRequest, with parameter: Parameters) throws
    }
    
    // 네트워크 요청과 취소 기능을 가진 NetworkRouter프로토콜 구현
    protocol NetworkRouter {
        associatedtype EndPointType = EndPoint
    
        func request<T>(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (T) -> ())
        func cancel()
    }

    ```
    </div>
    </details>
    <br>
 

2. 파싱한 JSON 데이터와 매핑할 모델 설계
- 현재 앱에서 사용하는 정보만 매핑할 수 있도록 아래와 같이 설계
    <details>
    <summary> <b> 코드 </b>  </summary>
    <div markdown="1">
    
    ```swift
    struct CurrentWeather: Decodable {
        var coordination: Coordinate
        var weather: [Weather]
        var main: Main
    
    enum CodingKeys: String, CodingKey {
        case coordination = "coord"
        case weather, main
    }
    
    struct Weather: Decodable {
        var icon: String
    }
    
    struct Main: Decodable {
        var temperatureMinimum: Double
        var temperatureMaximum: Double
        
        enum CodingKeys: String, CodingKey {
            case temperatureMinimum = "temp_min"
            case temperatureMaximum = "temp_max"
            }
    }
    
    struct Coordinate: Decodable {
        var longitude: Double
        var lattitude: Double
        
            enum CodingKeys: String, CodingKey {
                case longitude = "lon"
                case lattitude = "lat"
            }
        }
    }

    struct FiveDaysForecast: Decodable {
        var list: [ListDetail]
    }

    struct ListDetail: Decodable {
        var date: Int
        var main: MainDetail
        var weather: [WeatherDetail]

        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main, weather
        }
    }

    struct MainDetail: Decodable {
        var temperature: Double

        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
        }
    }

    struct WeatherDetail: Decodable {
        var icon: String
    }

    ```
    </div>
    </details>
    <br>
    
3. 코어로케이션을 통해 사용자의 현재 위치 정보 및 주소정보 구하기  
- CLLocationManager와 CLLocationManagerDelegate를 통해 사용자의 현재 위치 정보 가져온 후 CLGeocoder를 통해 주소정보를 가져옴
    <details>
    <summary> <b> 코드 </b>  </summary>
    <div markdown="1">

    ```swift
        //LocatinoManager
        class LocationManager: CLLocationManager {
            func askUserLocation() {
                    self.requestWhenInUseAuthorization()
                self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            }
        }

        // ViewController
        final class ViewController: UIViewController {
            private let locationManager = LocationManager()
            var address: String?

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let networkManager = NetworkManager()

            //1️⃣ 위치정보
            guard let longitude = manager.location?.coordinate.longitude,
                  let latitude = manager.location?.coordinate.latitude,
                  let fiveDaysUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast") else  {
                return
                }

            //2️⃣ 주소정보
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placeMarks, error in
                guard error == nil else {
                    return
                }

                guard let addresses = placeMarks,
                      let address = addresses.last?.name else {
                    return
                }

                self.address = address
            }
            .
            .
        }

    ```

    </div>
    </details>
    <br>
        
4. URLSession 을 통해 API호출 
    <details>
    <summary> <b> 코드 </b>  </summary>
    <div markdown="1">
    
    ```swift
    // NetworkManager
    final class NetworkManager { 
    .
    .
        private let router = Router<WeatherApi>()

        func getCurrentWeatherData(weatherAPI: WeatherApi, _ session: URLSession, _ completion: @escaping (Data) -> ()) {
        router.request(weatherAPI, session) { data in
            completion(data)
            }
        }
    }
    final class Router<EndPointType: EndPoint>: NetworkRouter {
        private var task: URLSessionDataTask?
        var data: FiveDaysForecast?
    
        func request<Data>(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ()) {
            let request = self.buildRequest(from: route)
        
            guard let url = request.url else {
                return
            }
        
            task = session.dataTask(with: url) { data, response, error in
                guard error == nil else  {
                    return
                }
            
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    return
                }

                guard let data = data as? Data else {
                    return
                }

                completionHandler(data)
            }
            self.task?.resume()
        }
    
        .
        .
        
        private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            self.configureRequestUrl(&request, urlParameter)
        }
        
        return request
    }
    
    private func configureRequestUrl(_ request: inout URLRequest, _ urlParameters: Parameters) {
        do {
            try URLManager.configure(urlRequest: &request, with: urlParameters)
        } catch {
            print(error)
        }
    }
    ```
    

    </div>
    </details>
    <br>
    
5. JSON데이터 파싱 및 모델에 매칭하기 
- parsing 오류를 알 수 있게 하기 위해 DecodingError 열거형 이용 
    <details>
    <summary> <b> 코드 </b>  </summary>
    <div markdown="1">
    
    ```swift
    struct Parser {
    private let decoder = JSONDecoder()

        func decode<Model: Decodable>(_ data: Data, to model: Model.Type) throws -> Model {
            do {
                let parsedData = try decoder.decode(model, from: data)
                return parsedData
            } catch DecodingError.dataCorrupted(let context) {
                throw DecodingError.dataCorrupted(context)
            } catch DecodingError.keyNotFound(let codingKey, let context) {
                throw DecodingError.keyNotFound(codingKey, context)
            } catch DecodingError.typeMismatch(let type, let context) {
                throw DecodingError.typeMismatch(type, context)
            } catch DecodingError.valueNotFound(let value, let context) {
                throw DecodingError.valueNotFound(value, context) 
            }
        }
    }
    
    //ViewController 내부 적절한 위치에서 JSON파싱하기 
    do {
        self.data = try Parser.decode(data: requestedData, to: FiveDaysForecast.self)
    } catch {
        showAlert()
    }
    
    
    ```

    </div>
    </details>
    <br>

6. 뷰컨트롤러 역할의 `Decomposition`



# Trouble Shooting
#### 1. requestlocation 호출 시 생기는 오류  

- `상황`
    <img src = "https://i.imgur.com/10bIuPJ.png" width = 500, height = 200>
    
    - `시도1` : requestLocation이 아닌 startUpdatingLocation 으로 메서드 바꿨더니 오류 사라짐
        
    - `시도2` : requestLocation 메서드 호출을`locationManager(_:didChangeAuthorization)` 내부로 변경했더니 오류메세지가 나오지 않음
        ```swift
        class LocationManager: CLLocationManager {
            func askUserLocation() {
                self.requestWhenInUseAuthorization()
               // self.requestLocation()
            }
        }
        
        // ViewController
        let locationManager = LocationManager()
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .restricted, .denied:
                showAlert(title: "❌", 
                          message: "날씨 정보를 사용 할 수 없습니다.")
                break
                
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                manager.requestLocation()
                break
            }
        }
        
        ```
        
    - `이유` 
        - `requestWhenInUseAuthorization()` 메소드는 비동기적으로 작동하는데 유저의 결과를 받지도 않고 바로 `requestLocation()`을 호출했기 때문
        ([참고문서](https://fluffy.es/current-location/))
        - startUpdatingLocation 으로 메소드를 변경 했을 땐 오류가 발생하지 않았던 이유
        : `CLLocation` 가 생성하는 `runloop` 내부에서 이벤트처리가 다음과 같이 진행되지 않을까 예상해 본다. 
        ```
        startUpdatingLocation메소드 호출

        👇

        유저가 정보요청에 대한 의사표현을 했는가?

        → Yes : `startUpdaingLocation` 메소드 실행 or `stopUpdatingLocation` 호출됨(유저가 거부한 경우)

        → No :   `startUpdaingLocation` 메소드 대기
        ```
    <br>
    
#### 2. Invalid JSON(DecodingError열거형의 case 중 하나)이 계속 나오는 문제

- 상황 : URLSessionDelegate를 이용하여 ViewController에서 데이터를 받아 디코딩 한 데이터를 `decodedData` 속성에 저장하려고 하는데 안 됨
    - 코드 
        ```swift
        final class ViewController: UIViewController, URLSessionDataDelegate { 
                var decodedData: FiveDaysForcast
                .
                .

                func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                    do {
                        let parsedData = try Parser().decode(data, to: FiveDaysForecast.self)
                        decodedData = parsedData
                        } catch {
                            print(error)
                        }
                }
            .
            .
            }
        // 디코딩에러 파악하기 위해 임시 객체를 만들었습니다. 
        struct Parser {
                private let decoder = JSONDecoder()

                func decode<Model: Decodable>(_ data: Data, to model: Model.Type) throws -> Model {
                    do {
                        let parsedData = try decoder.decode(model, from: data)
                        return parsedData
                    } catch DecodingError.dataCorrupted(let context) {
                        throw DecodingError.dataCorrupted(context)
                    } catch DecodingError.keyNotFound(let codingKey, let context) {
                        throw DecodingError.keyNotFound(codingKey, context)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        throw DecodingError.typeMismatch(type, context)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        throw DecodingError.valueNotFound(value, context)
                    }
                }
            }

            
        ```
        
    - 오류메세지
        > "The given data was not valid JSON."
![](https://i.imgur.com/MZdc3c4.png)


    - `시도1`: JSON 이 제대로 들어오는지 확인하기 위해 해당 메소드에서 들어오는 데이터를 String으로 디코딩해서 확인해 봄 
        - 코드 
        ``` swift
        final class ViewController: UIViewController, URLSessionDataDelegate { 
            var json: FiveDaysForcast
                .
                .

            func urlSession(_ session: URLSession, 
                            dataTask: URLSessionDataTask,
                            didReceive data: Data) {
                do {
                    //let parsedData = try Parser().decode(data, to: FiveDaysForecast.self)
                    //json = parsedData
                    
                    print(String(decoding: data, as: UTF-8.self))
                } catch {
                    print(error)
                }
            }
            .
            .
        }
        ```
        - 결과
        <img src = "https://i.imgur.com/8SCGrLl.png" width = 300, height = 100>
        
    - 다음과 같이 나오는 이유
        > [urlSession(_:dataTask:didReceive:)
](https://developer.apple.com/documentation/foundation/urlsessiondatadelegate/1411528-urlsession) Because the data object parameter is often pieced together from a number of different data objects, whenever possible, use the enumerateBytes(_:) method to iterate through the data rather than using the bytes method (which flattens the data object into a single memory block).
This delegate method may be called more than once, and each call provides only data received since the previous call. The app is responsible for accumulating this data if needed.

        해당 메소드는 여러 번 호출될 수 있으며 이전 호출에 의해 받은 데이터만을 전달하고 있다. 따라서 추측하기론 해당 메소드가 여러 번 호출되면서 데이터가 조각나서 들어오고 이를 디코딩 시도하기 때문에 invalidJSON 이라는 에러가 생기는게 아닐까 싶다.
    
    - `시도2` : 들어오는 데이터를 Data 타입의 속성에 저장한 다음에 디코딩하려고 시도
    ```swift
        // 버튼을 누르면 디코딩하도록 구현
        final class ViewController: UIViewController {
            var deliveredData: Data?
        
            @IBAction func testButton(_ sender: Any) {
                do  {
                    guard let deliverdData = self.deliveredData else {
                        return
                    }
                    
                    let decodedData = try JSONDecoder().decode(FiveDaysForecast.self, from: self.deliveredData)
                    print(deliveredData)
                } catch {
                    print(error)
                }
            }
        
        extension ViewController: URLSessionDataDelegate {
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
            do {
                // 데이터 잘 들어오고 있는지 확인
                let dataString = String(data: data, encoding: .utf8)
                print(dataString)
                
                //ViewController 내부에 property 선언하여 이 메소드로 들어온 데이터를 저장
                self.deliveredData?.append(data)

            } catch {
                print(error)
                self.showAlert("😵", message: "No data")
            }
        }
    ```
        
    - 결과: 데이터는 들어오는데 할당이 안됨 
            <img src = "https://i.imgur.com/SVVYJp2.png" width = 300, height = 200> 
    
    - 이유 : 초기화 하지 않은 상태에서 `append` 메소드를 호출하고 있기 때문
    
- `시도2` : delegate채택이 아닌 바로 datatask에서 데이터를 받도록 구현 → 디코딩 에러 사라짐

- `시도3` : urlsessiondelegate 중 `urlSession(_:dataTask:willCacheResponse:completionHandler)`메서드 사용 
    ```swift
     func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
       let data = proposedResponse.data
        self.deliveredData = proposedResponse.data
    }
    ```
    
    - 결과 : ViewController 속성에 assign성공 및 디코딩성공
    - 이유 : 데이터를 모두 받은 후 호출되는 메서드이기 때문  
        > [공식문서](https://developer.apple.com/documentation/foundation/urlsessiondatadelegate/1411612-urlsession)
The session calls this delegate method after the task finishes receiving all of the expected data.

- `시도4` : `data` 속성을 옵셔널이 아닌 초기화 한 상태에서 받아 온 데이터를 append
    ```swift
    class ViewController: URLSessionDataDelegate {
        // 수정 전코드 
        //var data: Data?
        
        //수정 후 코드 
        var data = Data()
        .
        .
    }
    ```

# 고민한 기능과 결론
1. 에러처리를 어떻게 할 수 있을까? 
    - 유저의 관점에선 어떤 에러인지 알 필요가 없다. 따라서 앱의 crash상황을 제외하곤 유저 중심의 에러처리를 하면 어떨까?
    - 예시
        ```swift
        //
        ```

2. 이 프로젝트에서 `APIKey` 감춰야 할까?

- 현재 ApiKey는 공개적인 키. 따라서 해당 키를 통해 개인정보에 접근할 수는 없을 것이다.(서버에 정보 요청 시 이미 url에 포함을 하기 때문에 )

        만약 AWS에서 제공하는  키를 이렇게 하드코딩 했다면 큰 문제가 생겼겠지만 지금은 무료계정의 오픈API소스이기 때문에 문제되지 않음

        만약 우리가 진행하는 앱이 독자적인 서버를 가지고 있었다면 키를 가지고 있지 않아도 되었을 것이다.(프록시 서버에 요청을 하고 해당 서버에서 키를 가지고 있는 상태에서 정보를 얻어오면 되기 때문)

        - 프록시 서버 : 클라이언트가 자신을 통해서 다른 네트워크 서비스에 간접적으로 접속할 수 있게 해 주는 컴퓨터 시스템이나 응용 프로그램을 가리킨다

- APIkey를 안전하게 보관하는 방법에 대하여 
    - KeyChain
    - plist
    ```swift
    get {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
            return APIError.filePathError.description
        }

        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: "API_KEY") as? String else {
        return APIError.plistError.description
        }

        return value
        }
    ```


3. URLSessionDelegate에 대하여 
- 네트워크 요청을 하는 모델타입 내부에서 `data`, `error`, `response`처리를 하던 방식을 `URLSession Delegate` 를 사용하여 `ViewController`에서 처리하도록 구현 해 보았습니다. 네트워크 요청을 하는 객체와 그 결과를 처리하는 객체를 분리 할 수 있다는 장점이 있다고 생각되어 이렇게 진행 해 보았습니다. 


4. Naming
    - `EndPoint`
        ![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f34af045-eabb-47e7-b46e-a9c6290d14c2/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f34af045-eabb-47e7-b46e-a9c6290d14c2/Untitled.png)

        - 왜 endPoint인가 : 서버 API 제일 끝 이라서?
    - `Router` : 데이터를 담고 있는 패킷이라고 생각하면됨
        - A router[a] is a `networking device` that forwards data packets between computer networks.


5. BackGround 상태에서의 위치정보 요청에 관하여 
    - 장단점
        장점
        단점
6. `reqeustLocation` vs `startUpdatingLocation`



8. HTTPResponse 상태코드에 관하여 
- 조금 더 상세한 구현으로 추후 생길 수 있느 문제에 대비할 수 있을 것 같다. 
    ```swift
    switch response.statusCode {
            case 202:
                break
            case 200..<300:
                completionHandler(.allow)
                break
            case 400:
                print("잘못된 요청입니다.")
                completionHandler(.cancel)
            case 401:
                print("인증이 잘못되었습니다.")
                completionHandler(.cancel)
            case 403:
                print("해당 정보에 접근할 수 없습니다. ")
                completionHandler(.cancel)
            case 500...:
                print("서버에러")
                completionHandler(.cancel)
            default:
                completionHandler(.cancel)
            }
    ```



9. 앱 첫 화면에서 날씨정보가 표시되도록 하기 
    - 방법1 : DispatchGroup을 이용해서 현재 날씨 및 5일 예보에 대한 정보를 받아오고 그 정볼르 통해 아이콘이 뷰에 그려지기 전까진 첫 화면이 보이지 않도록 하기 
    - 공부해야하는 것 :scene delegate복습하기




# UML
step1-2 UML
![](https://i.imgur.com/gnvj0Ld.png)
