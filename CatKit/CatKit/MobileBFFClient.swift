import Alamofire

public class MobileBFFClient {
    private let baseUrl: String
    private let headers = ["Accept": "application/json"]
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func getItems(response: @escaping ([Dictionary<String, Any>]) -> Void) {

        Alamofire.request("\(baseUrl)/v1/items", headers: self.headers)
            .responseJSON { (result) in
                if let json = result.result.value as? [Dictionary<String, Any>] {
                    var items = [Dictionary<String, Any>]()
                    for json_item in json {
                        var item = [String: Any]()
                        for (key, value) in json_item {
                            item[key] = value
                        }
                        items.append(item)
                    }
                    response(items)
                }
        }
    }
    
    public func getItem(id: String, response: @escaping (Dictionary<String, Any>) -> Void) {
        
        Alamofire.request("\(baseUrl)/v1/items/\(id)", headers: self.headers)
            .responseJSON { (result) in
                if let json = result.result.value as? Dictionary<String, Any> {
                    var item = Dictionary<String, Any>()
                    for (key, value) in json {
                        item[key] = value
                    }
                    response(item)
                }
        }
    }
}
