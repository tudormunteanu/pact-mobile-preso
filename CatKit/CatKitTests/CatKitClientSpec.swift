import Quick
import Nimble
import PactConsumerSwift
import CatKit

let APPLICATION_JSON = "application/json"

class MobileBFFClientSpec: QuickSpec {
    override func spec() {
        var mobileBFFService: MockService?
        var mobileBFFClient: MobileBFFClient?
        
        describe("test requests to Mobile BFF") {
            beforeEach {
                mobileBFFService = MockService(provider: "guacamole-mobile-bff", consumer: "ios-app")
                mobileBFFClient = MobileBFFClient(baseUrl: mobileBFFService!.baseUrl)
            }
            
            it("returns a list of items") {
                mobileBFFService!.uponReceiving("a list of items")
                    .withRequest(method: .GET, path: "/v1/items", headers: ["Accept": APPLICATION_JSON])
                    .willRespondWith(status: 200, headers: ["Content-Type": APPLICATION_JSON],
                                     body:
                                        [
                                            [
                                                "id": "28",
                                                "title": "Critical Role",
                                                "category": "Games & Hobbies",
                                                "image_url": "image.png",
                                                "link": [
                                                    "href": "/v1/items/28",
                                                    "type": "podcast"
                                                ]
                                            ]
                                        ]
                )
                // Run the tests
                mobileBFFService!.run { (testComplete) -> Void in
                    mobileBFFClient!.getItems { (items) -> Void in
                        expect(items.count).to(equal(1))
                        expect(items[0]["title"] as! String).to(equal("Critical Role"))
                        expect(items[0]["category"] as! String).to(equal("Games & Hobbies"))
                        expect(items[0]["image_url"] as! String).to(equal("image.png"))
                        expect(items[0]["id"] as! String).to(equal("28"))
                        expect(items[0]["link"] as! [String: String]).to(equal(["href": "/v1/items/28", "type": "podcast"]))
                        testComplete()
                    }
                }
            }
            
            it("returns a single item") {
                mobileBFFService!.uponReceiving("a single item")
                    .withRequest(method: .GET, path: "/v1/items/1", headers: ["Accept": APPLICATION_JSON])
                    .willRespondWith(status: 200, headers: ["Content-Type": APPLICATION_JSON],
                                     body: [
                                        "id": "1",
                                        "title": "Case Notes",
                                        "category": "Society & Culture",
                                        "image_url": "image.png",
                                        "copyright": "Classic FM",
                                        "link": [
                                            "href": "/v1/items/1",
                                            "type": "podcast"
                                        ]
                        ]
                        
                )
                // Run the tests
                mobileBFFService!.run { (testComplete) -> Void in
                    mobileBFFClient!.getItem(id: "1") { (item) -> Void in
                        testComplete()
                    }
                }
                
            }
        }
    }
}
