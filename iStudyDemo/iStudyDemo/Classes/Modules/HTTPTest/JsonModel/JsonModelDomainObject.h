//
//  JsonModelDomainObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

// http://m.blog.csdn.net/article/details?id=40432287
/*
 这个JSONValueTransformer类中有如下支持的转换
 NSMutableString <-> NSString
 NSMutableArray <-> NSArray
 NS(Mutable)Array <- JSONModelArray
 NSMutableDictionary <-> NSDictionary
 NSSet <-> NSArray
 BOOL <-> number/string
 string <-> number
 string <-> url
 string <-> time zone
 string <-> date
 number <-> date
 */

@interface Student : JSONModel

@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, assign) NSInteger age;

@end

@interface JsonModelDomainObject : JSONModel

@property (nonatomic, copy) NSString *bankName; //
@property (nonatomic, strong) NSURL *iconURL; // URL，以及内部类。自动转换
@property (nonatomic, assign) double amount;

@property (nonatomic, strong) NSArray<Student *> *arr; // 数组

@end

// ConvertOnDemand 延迟加载

/*
 JSONModel解析数据成Model
 发表于2014/10/24 20:45:30  40253人阅读
 分类： 技术
 
 JSONModel， Mantle
 这两个开源库都是用来进行封装JSON->Model的， 想想看， 直接向服务器发起一个请求，然后回来后，就是一个Model， 直接使用， 这是一个多么美好的事情。 感谢GitHub的开源精神。
 
 那我们开始吧。
 先说说这两个的差别。
 这两个使用的方法其实都差不多， 详细的使用方法请直接GitHub上找， 还是比较简单地。 就我个人来说JSONModel相对起来使用较为简单，而Mantle使用起来略为复杂，但是Mantle似乎比JSONModel更为强大。
 一般的项目，其实使用JSONModel就已经足够。
 
 下面讲一下JSONModel的使用方法。
 @inteface MyModel : JSONModel
 
 1. 使用JSONModel时，不需要额外去检查所要的服务器属性是否有返回。JSONModel的initWithDictionary方法会自动去进行检查并处理。
 
 2. 有效性检查，如果指定的服务器返回的某个字段没有返回，而且又是必须的， 像下面这样写，则会抛出异常。
 //this property is required
 @property (strong, nonatomic) NSString* string;
 因为默认这个值是必须的。
 
 一般情况下，我们不想因为服务器的某个值没有返回就使程序崩溃， 我们会加关键字Optional.
 //this one's optional
 @property (strong, nonatomic) NSNumber<Optional>* number;
 
 3. 原子数据， 之前可能是如下面这样操作数据
 if (jsonDict[@"name"])
 labelName.text = jsonDict[@"name"];
 else
 [self showErrorMessageAndBailout];
 
 这段代码会使得jsonDict[@"name"], 会被读取，然后进行有效性判断，最后再被使用。 换句话来说，这里使用了三次， 而如果某些情况下，使用一次就已经出错，但却无法阻止它接下来的连续出错。
 而如果使用JSONModel的属性，则只会保证上面只使用一次，就可以进行有效性的判断以及使用。（其实上面也可以做到，只需要把这个值取出来，存下来接着使用却可，但是代码会稍显麻烦）
 同时读取一批数据如下面代码：
 简单模型如下：
 SimpleModel* model = [[SimpleModel alloc] initWithString:@"...json here..." error:nil];
 
 
 复杂模型如下， 这里假设复杂模型包含了简单模型。主要是为了说明模型之前的包含情况下，照样可以进行解析。
 SuperComplicatedModel* model = [[SuperComplicatedModel alloc] initWithString:@"...json here..." error:nil];
 
 模型的批处理，即一次可以处理一批模型。
 NSArray* models = [SuperComplicatedModel arrayOfObjectsFromDictionaries: jsonDatas error:nil];
 4. 数据转换, OC <-> JSON
 注意下面这张图：这意味着JSON的数据格式只有中间的部分, string,number, array, object, 以及null
 
 例如有如下 ＪＳＯＮ数据：
 {
 "first" : 1,
 "second": 35,
 "third" : 10034,
 "fourth": 10000
 }
 
 可以如下定义这个模型
 @interface NumbersModel:JSONModel
 
 @property (assign,nonatomic) short first;
 @property (assign,nonatomic) double second;
 @property (strong,nonatomic) NSNumber* third;
 @property (strong,nonatomic) NSString* fourth;
 
 @end
 注：JSON数据中， first为1,second为35, 但是它们却可以自动被转换成short， double类型。 对于10034, 以及10000会自动转换为NSNumber以及NSString。 这些都是JSONModel会自动进行的。 神奇吧！
 
 5. 内嵌的数据转换， 在JSONValueTransformer类中，有各种内嵌的转换支持。如下面
 {
 "purchaseDate" : "2012-11-26T10:00:01+02:00",
 "blogURL" : "http://www.touch-code-magazine.com"
 }
 
 分别是一个 日期类型，以及一个URL类型。
 @interface SmartModel: JSONModel
 
 @property (strong, nonatomic) NSDate* purchaseDate;
 @property (strong, nonatomic) NSURL* blogUrl;
 
 @end
 
 用上面这个模型，不需要其它代码，即可以得到想要的转换 。
 这个JSONValueTransformer类中有如下支持的转换
 NSMutableString <-> NSString
 NSMutableArray <-> NSArray
 NS(Mutable)Array <- JSONModelArray
 NSMutableDictionary <-> NSDictionary
 NSSet <-> NSArray
 BOOL <-> number/string
 string <-> number
 string <-> url
 string <-> time zone
 string <-> date
 number <-> date
 
 6. 自定义数据转换， 显然上面的内嵌转换有时不能满足我们的需要，所以我们需要如下的自定义转换。
 你需要做的就是自定义一个JSONValueTransformer的类别文件，如下：
 @interface JSONValueTransformer(UIColor)
 
 -(UIColor*)UIColorFromNSString:(NSString*)string;
 -(id)JSONObjectFromUIColor:(UIColor*)color;
 
 @end
 
 
 然后再进行实现即可。
 注意上面的命名是采用：
 -(YourPropertyClass*)YourPropertyClassFromJSONObjectClass:(JSONObjectClass*)name;
 
 
 例如：
 -(UIColor*)UIColorFromNSString:(NSString*)string;
 
 而要把这个类型转换为JSON，则像这样即可：（注下面这个id，可以修改也可以不用修改成NSString，因为一定知道这是一个nsstirng.  heqin:这里其实也可能会是其它类的，应该是根据特定情况来特定判断。）
 -(id)JSONObjectFromYourPropertyClass:(YourPropertyClass*)color;
 
 如下是另一个例子：
 @implementation JSONValueTransformer (CustomTransformer)
 
 - (NSDate *)NSDateFromNSString:(NSString*)string {
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:APIDateFormat];
 return [formatter dateFromString:string];
 }
 
 - (NSString *)JSONObjectFromNSDate:(NSDate *)date {
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:APIDateFormat];
 return [formatter stringFromDate:date];
 }
 
 @end
 
 
 7. 层级嵌套。
 {
 "idImage": 1,
 "name": "house.jpg",
 "copyright": {"author":"Marin Todorov", "year":2012}
 }
 
 可以先定义如下的模型
 @interface CopyModel: JSONModel
 
 @property (strong, nonatomic) NSString* author;
 @property (assign, nonatomic) int year;
 
 @end
 
 然后再定义模型：
 #import "CopyModel.h"
 @interface ImageModel: JSONModel
 
 @property (assign, nonatomic) int idImage;
 @property (strong, nonatomic) NSString* name;
 @property (strong, nonatomic) CopyModel* copyright;
 
 @end
 
 然后在你得到的ImageModel后， 就会发现其中的CopyModel也有数据了。
 如果你想要一个数组的模型属性，如下即可。
 @property (strong, nonatomic) NSArray<TweetModel>* tweets;
 
 
 8. JSONModel转换为Dictioanry, JSONString.
 直接使用JSONModel的方法toDictioanry, 以及toJSONString即可。
 
 9. 保存model数据
 NSDictionary* object = [NSDictionary dictionaryWithContentsOfFile:filePath];
 data = [[MyDataModel alloc] initWithDictionary: object];
 //保存操作
 [[data toDictionary] writeToFile:filePath atomically:YES];
 
 
 10. Key mapping， 有时， 得到的数据不是在一个层级，如下：
 {
 "order_id": 104,
 "order_details" : [
 {
 "name": "Product#1",
 "price": {
 "usd": 12.95
 }
 }
 ]
 }
 
 
 其中的order_id与name就不是一个层级，但我们仍然想在一个model中得到它们的数据。 如下：
 @interface OrderModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (assign, nonatomic) float price;
 @property (strong, nonatomic) NSString* productName;
 @end
 
 @implementation OrderModel
 
 +(JSONKeyMapper*)keyMapper
 {
 return [[JSONKeyMapper alloc] initWithDictionary:@{
 @"order_id": @"id",
 @"order_details.name": @"productName",
 @"order_details.price.usd": @"price" // 这里就采用了KVC的方式来取值，它赋给price属性
 }];
 }
 
 @end
 
 
 
 11. 全局Global key mapping. (使所有的模型都具备)， 个人觉得这个并不是非常通用，因为如果真是需要所有模型都具备这个keyMapper的转换，则直接继承一个基类就行了。
 [JSONModel setGlobalKeyMapper:[
 [JSONKeyMapper alloc] initWithDictionary:@{
 @"item_id":@"ID",
 @"item.name": @"itemName"
 }]
 ];
 
 12. 自动把下划线方式的命名转为驼峰命名属性。还有类似的，如大写转为小写的方法：mapperFromUpperCaseToLowerCase
 {
 "order_id": 104,
 "order_product" : @"Product#1",
 "order_price" : 12.95
 }
 
 生成的模型
 @interface OrderModel : JSONModel
 
 @property (assign, nonatomic) int orderId;
 @property (assign, nonatomic) float orderPrice;
 @property (strong, nonatomic) NSString* orderProduct;
 
 @end
 
 @implementation OrderModel
 
 +(JSONKeyMapper*)keyMapper
 {
 return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
 }
 
 @end
 
 13. 可选属性，建议尽量使用这种方式来避免异常。
 {
 "id": "123",
 "name": null,
 "price": 12.95
 }
 
 生成的模型如下：
 @interface ProductModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (strong, nonatomic) NSString<Optional>* name;
 @property (assign, nonatomic) float price;
 @property (strong, nonatomic) NSNumber<Optional>* uuid;
 @end
 
 @implementation ProductModel
 @end
 
 通过上面的optional的方式， 我们可以给这个类添加一个isSuccess方法，该方法中判断name和uuid是否存在来决定是否从服务器成功取数据。 而不是把这两个属性设置为required，可以有效避免异常。
 
 14. Ignore属性， 会使得解析时会完全忽略它。 一般情况下，忽略的属性主要用在该值不从服务器获取，而是通过后面的代码进行设置。
 {
 "id": "123",
 "name": null
 }
 
 模型为：
 @interface ProductModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (strong, nonatomic) NSString<Ignore>* customProperty;
 @end
 
 @implementation ProductModel
 @end
 
 可以用下面方法，使当前类的全部属性都为可选，官网上说尽量避免这样的使用， （个人觉得官网的意思是指，尽量避免用来面方法来指定所有的属性为可选，即使要全部属性为可选，也尽量是在每个属性那里标注为Optional）
 @implementation ProductModel
 +(BOOL)propertyIsOptional:(NSString*)propertyName
 {
 return YES;
 }
 @end
 
 15. 延迟加载， 这种比较推荐，可以减少在网络读取时的性能消耗：关键字为： ConvertOnDemand
 {
 "order_id": 104,
 "total_price": 103.45,
 "products" : [
 {
 "id": "123",
 "name": "Product #1",
 "price": 12.95
 },
 {
 "id": "137",
 "name": "Product #2",
 "price": 82.95
 }
 ]
 }
 
 使用模型：
 @protocol ProductModel
 @end
 
 @interface ProductModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (strong, nonatomic) NSString* name;
 @property (assign, nonatomic) float price;
 @end
 
 @implementation ProductModel
 @end
 
 @interface OrderModel : JSONModel
 @property (assign, nonatomic) int order_id;
 @property (assign, nonatomic) float total_price;
 @property (strong, nonatomic) NSArray<ProductModel, ConvertOnDemand>* products;
 @end
 
 @implementation OrderModel
 @end
 
 16. 使用JSONHttpClient进行请求。
 //add extra headers
 [[JSONHTTPClient requestHeaders] setValue:@"MySecret" forKey:@"AuthorizationToken"];
 
 //make post, get requests
 [JSONHTTPClient postJSONFromURLWithString:@"http://mydomain.com/api"
 params:@{@"postParam1":@"value1"}
 completion:^(id json, JSONModelError *err) {
 
 //check err, process json ...
 
 }];
 
 好了， 所以的JSONModel的使用方法都已经在这里了， 综合了官网的使用方法。
 */

