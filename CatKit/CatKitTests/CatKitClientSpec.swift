import Quick
import Nimble
import PactConsumerSwift
import CatKit

let APPLICATION_JSON = "application/json"

class MobileBFFClientSpec: QuickSpec {
    override func spec() {
        var mobileBFFService: MockService?
        // TODO: Replace the API Client with the app specific one when
        // integrating these tests into the real app.
        var mobileBFFClient: MobileBFFClient?
        
        describe("test requests to Mobile BFF") {
            beforeEach {
                mobileBFFService = MockService(provider: "guacamole-mobile-bff", consumer: "ios-app")
                mobileBFFClient = MobileBFFClient(baseUrl: mobileBFFService!.baseUrl)
            }
            
            // MARK: - /v1/items
            it("returns a list of items") {
                mobileBFFService!.uponReceiving("a list of items")
                    .withRequest(method: .GET, path: "/v1/items", headers: ["Accept": APPLICATION_JSON])
                    .willRespondWith(status: 200, headers: ["Content-Type": APPLICATION_JSON],
                                     body: Matcher.eachLike([
                                            "id": Matcher.somethingLike("28"),
                                            "title": Matcher.somethingLike("Critical Role"),
                                            "category": Matcher.somethingLike("Games & Hobbies"),
                                            "image_url": Matcher.somethingLike("image.png"),
                                            "link": Matcher.somethingLike([
                                                "href": Matcher.somethingLike("/v1/items/28"),
                                                "type": Matcher.somethingLike("podcast")
                                            ])
                                        ])
                )
                
                // Run the tests
                mobileBFFService!.run { (testComplete) -> Void in
                    mobileBFFClient!.getItems { (items) -> Void in
                        // TODO: Replace these assertions with the actual data structures used
                        // within the app.
                        expect(items.count).to(equal(1))
                        expect(items[0]["title"] as! String).to(equal("Critical Role"))
                        expect(items[0]["category"] as! String).to(equal("Games & Hobbies"))
                        expect(items[0]["image_url"] as! String).to(equal("image.png"))
                        expect(items[0]["id"] as! String).to(equal("28"))
                        expect((items[0]["link"] as! [String: String])).to(equal(["href": "/v1/items/28", "type": "podcast"]))
                        testComplete()
                    }
                }
            }
            
            // MARK: - /v1/items/<id>
            it("returns a single item") {
                mobileBFFService!.uponReceiving("a single item")
                    .withRequest(method: .GET, path: "/v1/items/1", headers: ["Accept": APPLICATION_JSON])
                    .willRespondWith(status: 200, headers: ["Content-Type": APPLICATION_JSON],
                                     body: Matcher.somethingLike([
                                        "id": Matcher.somethingLike("1"),
                                        "title": Matcher.somethingLike("Case Notes"),
                                        "category": Matcher.somethingLike("Society & Culture"),
                                        "image_url": Matcher.somethingLike("image.png"),
                                        "copyright": Matcher.somethingLike("Classic FM"),
                                        "link": Matcher.somethingLike([
                                            "href": Matcher.somethingLike("/v1/items/1"),
                                            "type": Matcher.somethingLike("podcast")
                                        ])
                                    ])
                )

                // Run the tests
                mobileBFFService!.run { (testComplete) -> Void in
                    mobileBFFClient!.getItem(id: "1", response: { (itemDict) -> Void in
                        expect(itemDict["id"] as! String).to(equal("1"))
                        expect(itemDict["title"] as! String).to(equal("Case Notes"))
                        expect(Set(itemDict.keys)).to(equal(Set(["id", "title", "category",
                                                                 "image_url", "copyright", "link"])))
                        testComplete()
                    }, failure: { () -> Void in
                    })
                }
            }

            // MARK: - /v1/pages/<slug>
            it("returns single page based on the slug") {
                mobileBFFService!.uponReceiving("a single page")
                    .withRequest(method: .GET, path: "/v1/pages/podcasts", headers: ["Accept": APPLICATION_JSON])
                    .willRespondWith(status: 200, headers: ["Content-Type": APPLICATION_JSON],
                                     body: [
                                        "id": Matcher.somethingLike("999"),
                                        "title": Matcher.somethingLike("Podcasts"),
                                        "items": Matcher.eachLike([
                                            "id": Matcher.somethingLike("1"),
                                            "title": Matcher.somethingLike("Featured"),
                                            "type": Matcher.somethingLike("hero"),
                                            "items": Matcher.eachLike([
                                                "id": Matcher.somethingLike("1"),
                                                "title": Matcher.somethingLike("Podcast title"),
                                                "image_url": Matcher.somethingLike("artwork.png"),
                                                "link": Matcher.somethingLike([
                                                    "href": Matcher.somethingLike("string"),
                                                    "type": Matcher.somethingLike("podcast")
                                                ]),
                                                "category": Matcher.somethingLike("string")
                                            ]),
                                            "link": Matcher.somethingLike([
                                                "href": Matcher.somethingLike("string"),
                                                "type": Matcher.somethingLike("podcast_list")
                                            ])
                                        ])
                                    ]
                )

                // Run the tests
                mobileBFFService!.run { (testComplete) -> Void in
                    mobileBFFClient!.getPage(slug: "podcasts", response: { (pageDict) -> Void in
                        expect(Set(pageDict.keys)).to(equal(Set(["id", "title", "items"])))
                        let podcastLists = pageDict["items"] as! [Dictionary<String, Any>]
                        expect(podcastLists.count).to(equal(1))
                        expect(Set(podcastLists[0].keys)).to(equal(Set(["id", "title", "type", "items", "link"])))
                        let podcasts = podcastLists[0]["items"] as! [Dictionary<String, Any>]
                        expect(Set(podcasts[0].keys)).to(equal(Set(["id", "title", "image_url", "link", "category"])))
                        testComplete()
                    })
                }
            }
            
        }
    }
}
