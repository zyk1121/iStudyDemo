//
//  TestCoreData+CoreDataProperties.h
//  
//
//  Created by zhangyuanke on 16/3/8.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TestCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *intType;
@property (nullable, nonatomic, retain) NSNumber *floatType;
@property (nullable, nonatomic, retain) NSNumber *doubleType;
@property (nullable, nonatomic, retain) NSString *stringType;

@end

NS_ASSUME_NONNULL_END
