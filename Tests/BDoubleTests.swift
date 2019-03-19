import XCTest
import Foundation
@testable import BigNumber

class BDoubleTests : XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInitialization() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		XCTAssertNil(BDouble("alphabet"))
		XCTAssertNil(BDouble("-0.123ad2e+123"))
		XCTAssertNil(BDouble("0.123.ad2e123"))
		XCTAssertNil(BDouble("0.123ae123"))
		XCTAssertNil(BDouble("0.123ae1.23"))
		XCTAssertNotNil(BDouble("1.2e+123"))
		XCTAssertNotNil(BDouble("-1.2e+123"))
		XCTAssertNotNil(BDouble("+1.2e-123"))
		XCTAssertEqual(BDouble("0"), 0.0)
		XCTAssertEqual(BDouble("10"), 10.0)
		XCTAssertEqual(BDouble("1.2e10")?.fractionDescription, "12000000000")
		XCTAssertEqual(BDouble("1.2e+10")?.fractionDescription, "12000000000")
		XCTAssertEqual(BDouble("+1.2e+10")?.fractionDescription, "12000000000")
		XCTAssertEqual(BDouble("-1.2e10")?.fractionDescription, "-12000000000")
		XCTAssertEqual(BDouble("1.2e-3")?.fractionDescription, "3/2500")
		XCTAssertEqual(BDouble("-1.2e-3")?.fractionDescription, "-3/2500")
		XCTAssertEqual(BDouble(123000000000000000000.0), 123000000000000000000.0)
		XCTAssertEqual(BDouble("1.2")?.fractionDescription, "6/5")
		
		for _ in 0..<100 {
			let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
			XCTAssertNotNil(BDouble(rn))
			
			let rn2 = pow(rn * 100, 2.0)
			XCTAssertNotNil(BDouble(rn2))
		}
	}
	
	func testCompare() {
		XCTAssertEqual(BDouble(1.0), BDouble(1.0))
		XCTAssert(BDouble(1.1) != BDouble(1.0))
		XCTAssert(BDouble(2.0) > BDouble(1.0))
		XCTAssert(BDouble(-1) < BDouble(1.0))
		XCTAssert(BDouble(0.0) <= BDouble(1.0))
		XCTAssert(BDouble(1.1) >= BDouble(1.0))
		
		XCTAssertEqual(1.0, BDouble(1.0))
		XCTAssert(1.1 != BDouble(1.0))
		XCTAssert(2.0 > BDouble(1.0))
		XCTAssert(0.0 < BDouble(1.0))
		XCTAssert(-1.0 <= BDouble(1.0))
		XCTAssert(1.1 >= BDouble(1.0))
		
		XCTAssertEqual(BDouble(1.0), 1.0)
		XCTAssert(BDouble(1.1) != 1.0)
		XCTAssert(BDouble(2.0) > 1.0)
		XCTAssert(BDouble(-1) < 1.0)
		XCTAssert(BDouble(0.0) <= 1.0)
		XCTAssert(BDouble(1.1) >= 1.0)
		
		for _ in 1..<100 {
			let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
			let rn2 = pow(rn * 100, 2.0)
			
			XCTAssert(BDouble(rn) < BDouble(rn2))
			XCTAssert(BDouble(rn) <= BDouble(rn2))
			XCTAssert(BDouble(rn2) > BDouble(rn))
			XCTAssert(BDouble(rn2) >= BDouble(rn))
			XCTAssertEqual(BDouble(rn), BDouble(rn))
			XCTAssert(BDouble(rn2) != BDouble(rn))
		}
	}
	
	func testPow() {
		// Test that a number to the zero power is 1
		for i in 0..<100 {
			XCTAssertEqual(pow(BDouble(Double(i)), 0), 1.0)
			
			let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
			XCTAssert(pow(BDouble(rn), 0) == 1.0)
		}
		
		// Test that a number to the one power is itself
		for i in 0..<100 {
			XCTAssertEqual(pow(BDouble(Double(i)), 1), BDouble(Double(i)))
			
			let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
			XCTAssertEqual(pow(BDouble(rn), 1), BDouble(rn))
		}
	}
	
	
	func testDecimalExpansionWithoutRounding()
	{
		let testValues = [
			("0", "0.0", 0),
			("0", "0.0", 1),
			("0", "0.00", 2),
			("0", "0.000", 3),
			("12.345", "12.0", 0),
			("12.345", "12.3", 1),
			("12.345", "12.34", 2),
			("12.345", "12.345", 3),
			("12.345", "12.3450", 4),
			("-0.00009", "0.0000", 4),
			("-0.00009", "-0.00009", 5),
			("-0.00009", "-0.000090", 6),
			]
		
		for (original, test, precision) in testValues
		{
			let result = BDouble(original)!.decimalExpansion(precisionAfterDecimalPoint: precision, rounded: false)
			XCTAssertEqual(result, test)
		}
	}
	
	func testDecimalExpansionWithRounding()
	{
		let testValues = [
			("0", "0.0", 0),
			("0", "0.0", 1),
			("0", "0.00", 2),
			("0", "0.000", 3),
			("12.345", "12.0", 0),
			("12.345", "12.3", 1),
			("12.345", "12.35", 2),
			("12.345", "12.345", 3),
			("12.345", "12.3450", 4),
			("-0.00009", "0.000", 3),
			("-0.00009", "-0.0001", 4),
			("-0.00009", "-0.00009", 5),
			("-0.00009", "-0.000090", 6),
			]
		
		for (original, test, precision) in testValues
		{
			let result = BDouble(original)!.decimalExpansion(precisionAfterDecimalPoint: precision, rounded: true)
			XCTAssertEqual(result, test)
		}
	}
	
	func test_decimalExpansionRandom()
	{
		func generateDoubleString(preDecimalCount: Int, postDecimalCount: Int) -> String
		{
			var numStr = ""
			
			if preDecimalCount == 0 && postDecimalCount == 0
			{
				return math.random(0...1) == 1 ? "0" : "0.0"
			}
			
			if preDecimalCount == 0
			{
				numStr = "0."
			}
			
			if postDecimalCount == 0
			{
				numStr = math.random(0...1) == 1 ? "" : ".0"
			}
			
			
			for i in 0..<preDecimalCount
			{
				if i == (preDecimalCount - 1) && preDecimalCount > 1
				{
					numStr = math.random(1...9).description + numStr
				}
				else
				{
					numStr = math.random(0...9).description + numStr
				}
			}
			
			if postDecimalCount != 0 && preDecimalCount != 0
			{
				numStr += "."
			}
			
			for _ in 0..<postDecimalCount
			{
				numStr = numStr + math.random(0...9).description
			}
			
			return math.random(0...1) == 1 ? numStr : "-" + numStr
		}
		
		for _ in 0..<2000
		{
			let preDecimalCount = math.random(0...4)
			let postDecimalCount = math.random(0...4)
			let doubleString = generateDoubleString(
				preDecimalCount: preDecimalCount,
				postDecimalCount: postDecimalCount
			)
			
			let toBDoubleAndBack = BDouble(doubleString)!.decimalExpansion(precisionAfterDecimalPoint: postDecimalCount)
			
			if toBDoubleAndBack != doubleString
			{
				if toBDoubleAndBack == "0.0" && ["0", "-0"].contains(doubleString) { continue }
				// For expmple, input: "13" and output "13.0" is okay
				if toBDoubleAndBack[0..<(toBDoubleAndBack.count - 2)] == doubleString && toBDoubleAndBack.hasSuffix(".0") { continue }
				// For expmple, input: "13" and output "13.0" is okay
				if doubleString[1..<doubleString.count] == toBDoubleAndBack && doubleString.hasPrefix("-0.") { continue }
				
				print("\nError: PreDecCount: \(preDecimalCount) PostDecCount: \(postDecimalCount)")
				print("Previ: \(doubleString)")
				print("After: \(toBDoubleAndBack)")
				XCTAssert(false)
			}
			
			
		}
	}
	
	func testRounding() {
		XCTAssertEqual(BDouble("-1.0")?.rounded(), BInt("-1"))
		XCTAssertEqual(BDouble("-1.1")?.rounded(), BInt("-1"))
		XCTAssertEqual(BDouble("-1.5")?.rounded(), BInt("-1"))
		XCTAssertEqual(BDouble("-1.6")?.rounded(), BInt("-2"))
		XCTAssertEqual(BDouble("0")?.rounded(), BInt("0"))
		XCTAssertEqual(BDouble("1.0")?.rounded(), BInt("1"))
		XCTAssertEqual(BDouble("1.1")?.rounded(), BInt("1"))
		XCTAssertEqual(BDouble("1.5")?.rounded(), BInt("1"))
		XCTAssertEqual(BDouble("1.6")?.rounded(), BInt("2"))
		
		XCTAssertEqual(floor(BDouble(-1.0)), BInt("-1"))
		XCTAssertEqual(floor(BDouble(-1.1)), BInt("-2"))
		XCTAssertEqual(floor(BDouble(-1.5)), BInt("-2"))
		XCTAssertEqual(floor(BDouble(-1.6)), BInt("-2"))
		XCTAssertEqual(floor(BDouble(0)), BInt("0"))
		XCTAssertEqual(floor(BDouble(1.0)), BInt("1"))
		XCTAssertEqual(floor(BDouble(1.1)), BInt("1"))
		XCTAssertEqual(floor(BDouble(1.5)), BInt("1"))
		XCTAssertEqual(floor(BDouble(1.6)), BInt("1"))
		
		XCTAssertEqual(ceil(BDouble(-1.0)), BInt("-1"))
		XCTAssertEqual(ceil(BDouble(-1.1)), BInt("-1"))
		XCTAssertEqual(ceil(BDouble(-1.5)), BInt("-1"))
		XCTAssertEqual(ceil(BDouble(-1.6)), BInt("-1"))
		XCTAssertEqual(ceil(BDouble(0)), BInt("0"))
		XCTAssertEqual(ceil(BDouble(1.0)), BInt("1"))
		XCTAssertEqual(ceil(BDouble(1.1)), BInt("2"))
		XCTAssertEqual(ceil(BDouble(1.5)), BInt("2"))
		XCTAssertEqual(ceil(BDouble(1.6)), BInt("2"))
	}
	
	func testPrecision() {
		var bigD = BDouble("123456789.123456789")
		bigD?.precision = 2
		XCTAssertEqual(bigD?.decimalDescription, "123456789.12")
		bigD?.precision = 4
		XCTAssertEqual(bigD?.decimalDescription, "123456789.1235")
		bigD?.precision = 10
		XCTAssertEqual(bigD?.decimalDescription, "123456789.1234567890")
		bigD?.precision = 20
		XCTAssertEqual(bigD?.decimalDescription, "123456789.12345678900000000000")
		bigD?.precision = 0
		XCTAssertEqual(bigD?.decimalDescription, "123456789.0")
		
		
		bigD = BDouble("-123456789.123456789")
		bigD?.precision = 2
		XCTAssertEqual(bigD?.decimalDescription, "-123456789.12")
		bigD?.precision = 4
		XCTAssertEqual(bigD?.decimalDescription, "-123456789.1235")
		bigD?.precision = 10
		XCTAssertEqual(bigD?.decimalDescription, "-123456789.1234567890")
		bigD?.precision = 20
		XCTAssertEqual(bigD?.decimalDescription, "-123456789.12345678900000000000")
		bigD?.precision = 0
		XCTAssertEqual(bigD?.decimalDescription, "-123456789.0")
		
		bigD = BDouble("0.0000000003") // nine zeroes
		bigD?.precision = 0
		XCTAssertEqual(bigD?.decimalDescription, "0.0")
		bigD?.precision = 10
		XCTAssertEqual(bigD?.decimalDescription, "0.0000000003")
		bigD?.precision = 15
		XCTAssertEqual(bigD?.decimalDescription, "0.000000000300000")
		bigD?.precision = 5
		XCTAssertEqual(bigD?.decimalDescription, "0.00000")
	}
	
	func testNearlyEqual() {
		//BDouble.precision = 50
		let BDMax = BDouble(Double.greatestFiniteMagnitude)
		let BDMin = BDouble(Double.leastNormalMagnitude)
		let eFourty = BDouble("0.00000 00000 00000 00000 00000 00000 00000 00001".replacingOccurrences(of: " ", with: ""))!
		
		//print(BDMax.decimalDescription, BDMin.decimalDescription, eFourty.decimalDescription)
		
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100), epsilon: 0.00001))
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100.00000001), epsilon: 0.00001))
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100.0000001), epsilon: 0.00001))
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100.000001), epsilon: 0.00001))
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100.0001), epsilon: 0.00001))
		XCTAssert(BDouble.nearlyEqual(BDouble(100), BDouble(100.001), epsilon: 0.00001))
		XCTAssert(false == BDouble.nearlyEqual(BDouble(100), BDouble(100.01), epsilon: 0.00001))
		XCTAssert(false == BDouble.nearlyEqual(BDouble(100), BDouble(100.1), epsilon: 0.00001))
		XCTAssert(false == BDouble.nearlyEqual(BDouble(100), BDouble(101), epsilon: 0.00001))
		XCTAssert(false == BDouble.nearlyEqual(BDouble(100), BDouble(11), epsilon: 0.00001))
		XCTAssert(false == BDouble.nearlyEqual(BDouble(100), BDouble(1), epsilon: 0.00001))
		
		// Regular large numbers - generally not problematic
		XCTAssert(BDouble.nearlyEqual(BDouble(1000000), BDouble(1000001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(1000001), BDouble(1000000)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(10000), BDouble(10001)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(10001), BDouble(10000)));
		
		// Negative large numbers
		XCTAssert(BDouble.nearlyEqual(BDouble(-1000000), BDouble(-1000001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-1000001), BDouble(-1000000)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(-10000), BDouble(-10001)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(-10001), BDouble(-10000)));
		
		// Numbers around 1
		XCTAssert(BDouble.nearlyEqual(BDouble(1.0000001), BDouble(1.0000002)));
		XCTAssert(BDouble.nearlyEqual(BDouble(1.0000002), BDouble(1.0000001)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(1.0002), BDouble(1.0001)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(1.0001), BDouble(1.0002)));
		
		// Number around -1
		XCTAssert(BDouble.nearlyEqual(BDouble(-1.000001), BDouble(-1.000002)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-1.000002), BDouble(-1.000001)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(-1.0001), BDouble(-1.0002)));
		XCTAssert(false == BDouble.nearlyEqual(BDouble(-1.0002), BDouble(-1.0001)));
		
		// Numbers between 0 and 1
		XCTAssert(BDouble.nearlyEqual(BDouble(0.000000001000001), BDouble(0.000000001000002)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.000000001000002), BDouble(0.000000001000001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.000000000001002), BDouble(0.000000000001001)));
		XCTAssert( BDouble.nearlyEqual(BDouble(0.000000000001001), BDouble(0.000000000001002)));
		
		// Numbers between -1 and 0
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.000000001000001), BDouble(-0.000000001000002)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.000000001000002), BDouble(-0.000000001000001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.000000000001002), BDouble(-0.000000000001001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.000000000001001), BDouble(-0.000000000001002)));
		
		// small difference away from zero
		XCTAssert(BDouble.nearlyEqual(BDouble(0.3), BDouble(0.30000003)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.3), BDouble(-0.30000003)));
		
		// comparisons involving zero
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), BDouble(0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), BDouble(-0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.0), BDouble(-0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.00000001), BDouble(0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), BDouble(0.00000001)));
		XCTAssert(BDouble.nearlyEqual(BDouble(-0.00000001), BDouble(0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), BDouble(-0.00000001)));
		
		XCTAssert(BDouble(0.0) != eFourty)
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), eFourty, epsilon: 0.01));
		XCTAssert(BDouble.nearlyEqual(eFourty, BDouble(0.0), epsilon: 0.01));
		XCTAssert(BDouble.nearlyEqual(eFourty, BDouble(0.0), epsilon: 0.000001));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), eFourty, epsilon: 0.000001));
		
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), -eFourty, epsilon:0.1));
		XCTAssert(BDouble.nearlyEqual(-eFourty, BDouble(0.0), epsilon:0.1));
		XCTAssert(BDouble.nearlyEqual(-eFourty, BDouble(0.0), epsilon: 0.00000001));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), -eFourty, epsilon:0.00000001));
		
		// comparisons involving "extreme" values
		XCTAssert(BDouble.nearlyEqual(BDMax, BDMax));
		XCTAssert(false == BDouble.nearlyEqual(BDMax, -BDMax));
		XCTAssert(false == BDouble.nearlyEqual(-BDMax, BDMax));
		XCTAssert(false == BDouble.nearlyEqual(BDMax, BDMax / 2));
		XCTAssert(false == BDouble.nearlyEqual(BDMax, -BDMax / 2));
		XCTAssert(false == BDouble.nearlyEqual(-BDMax, BDMax / 2));
		
		// comparions very close to zero
		XCTAssert(BDouble.nearlyEqual(BDMin, BDMin));
		XCTAssert(BDouble.nearlyEqual(BDMin, -BDMin));
		XCTAssert(BDouble.nearlyEqual(-BDMin, BDMin));
		XCTAssert(BDouble.nearlyEqual(BDMin, BDouble(0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), BDMin));
		XCTAssert(BDouble.nearlyEqual(-BDMin, BDouble(0.0)));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.0), -BDMin));
		
		XCTAssert(BDouble.nearlyEqual(BDouble(0.000000001), -BDMin));
		XCTAssert(BDouble.nearlyEqual(BDouble(0.000000001), BDMin));
		XCTAssert(BDouble.nearlyEqual(BDMin, BDouble(0.000000001)));
		XCTAssert(BDouble.nearlyEqual(-BDMin, BDouble(0.000000001)));
	}
	
	func testRadix() {
		XCTAssertEqual(BDouble("aa", radix: 16), 170)
		XCTAssertEqual(BDouble("0xaa", radix: 16), 170)
		XCTAssertEqual(BDouble("invalid", radix: 16), nil)
		
		XCTAssertEqual(BDouble("252", radix: 8), 170)
		XCTAssertEqual(BDouble("0o252", radix: 8), 170)
		XCTAssertEqual(BDouble("invalid", radix: 8), nil)
		
		XCTAssertEqual(BDouble("11", radix: 2), 3)
		XCTAssertEqual(BDouble("0b11", radix: 2), 3)
		XCTAssertEqual(BDouble("invalid", radix: 2), nil)
		
		XCTAssertEqual(BDouble("ffff",radix:16), 65535)
		XCTAssertEqual(BDouble("rfff",radix:16), nil)
		XCTAssertEqual(BDouble("ff",radix:10), nil)
		XCTAssertEqual(BDouble("255",radix:6), 107)
		XCTAssertEqual(BDouble("999",radix:10), 999)
		XCTAssertEqual(BDouble("ff",radix:16), 255.0)
		XCTAssert(BDouble("ff",radix:16) != 100.0)
		XCTAssert(BDouble("ffff",radix:16)! > 255.0)
		XCTAssert(BDouble("f",radix:16)! < 255.0)
		XCTAssert(BDouble("0",radix:16)! <= 1.0)
		XCTAssert(BDouble("f",radix:16)! >= 1.0)
		XCTAssertEqual(BDouble("44",radix:5), 24)
		XCTAssert(BDouble("44",radix:5) != 100.0)
		XCTAssertEqual(BDouble("321",radix:5)!, 86)
		XCTAssert(BDouble("3",radix:5)! < 255.0)
		XCTAssert(BDouble("0",radix:5)! <= 1.0)
		XCTAssert(BDouble("4",radix:5)! >= 1.0)
		XCTAssertEqual(BDouble("923492349",radix:32)!, 9967689075849)
	}
	
	func testOperations() {
		XCTAssertEqual(BDouble(1.5) + BDouble(2.0), BDouble(3.5))
		XCTAssertEqual(BDouble(1.5) - BDouble(2.0), BDouble(-0.5))
		XCTAssertEqual(BDouble(1.5) * BDouble(2.0), BDouble(3.0))
		XCTAssert(BDouble(1.0) / BDouble(2.0) == BDouble(0.5))
		XCTAssertEqual(-BDouble(6.54), BDouble(-6.54))
		testPow()
	}
	
	func testPerformanceStringInit() {
		self.measure {
			for _ in (0...1000) {
				let _ = BDouble(String(arc4random()))
				let _ = BDouble(String(arc4random())+"."+String(arc4random()))
			}
		}
	}
	
	func testPerformanceStringRadixInit() {
		self.measure {
			for _ in (0...1000) {
				let _ = BDouble(String(arc4random()), radix: 10)
				let _ = BDouble(String(arc4random())+"."+String(arc4random()), radix: 10)
			}
		}
	}
	
	func testDescriptionDoubleValuesValue1() {
		
		//arrange
		let stringValue1 = "0.00001"
		let stringValue2 = "-0.00001"
		let stringValue3 = "0.000000"
		let stringValue4 = "-0.000000146"
		let stringValue5 = "0.00000014614515123512341235151615341234161341235161351"
		let stringValue6 = "-0.00000014614515123512341235151615341234161341235161351"
		let stringValue7 = "-0.000000"
		
		//act
		let bDouble1 = BDouble.init(stringValue1)!
		let bDouble2 = BDouble.init(stringValue2)!
		let bDouble3 = BDouble.init(stringValue3)!
		let bDouble4 = BDouble.init(stringValue4)!
		let bDouble5 = BDouble.init(stringValue5)!
		let bDouble6 = BDouble.init(stringValue6)!
		let bDouble7 = BDouble.init(stringValue7)!
		
		//assert
		XCTAssertEqual(bDouble1.decimalDescription, stringValue1)
		XCTAssertEqual(bDouble2.decimalDescription, stringValue2)
		XCTAssertEqual(bDouble3.decimalDescription, stringValue3)
		XCTAssertEqual(bDouble4.decimalDescription, stringValue4)
		XCTAssertEqual(bDouble5.decimalDescription, stringValue5)
		XCTAssertEqual(bDouble6.decimalDescription, stringValue6)
		XCTAssertNotEqual(bDouble7.decimalDescription, stringValue7)
	}
	
	func testExponentiationNumberDescription() {
		
		//arrange
		let stringValue1 = "1.2e-3"
		let stringValueDecimal1 = "0.0012"
		let stringValue2 = "-1.2e-3"
		let stringValueDecimal2 = "-0.0012"
		let stringValue3 = "1.2e3"
		let stringValueDecimal3 = "1200"
		let stringValue4 = "-1.2e3"
		let stringValueDecimal4 = "-1200"
		let stringValue5 = "-1.2e+3"
		let stringValueDecimal5 = "-1200"
		let stringValue6 = "1.2e+3"
		let stringValueDecimal6 = "1200"
		
		//act
		let bDouble1 = BDouble.init(stringValue1)!
		let bDouble2 = BDouble.init(stringValue2)!
		let bDouble3 = BDouble.init(stringValue3)!
		let bDouble4 = BDouble.init(stringValue4)!
		let bDouble5 = BDouble.init(stringValue5)!
		let bDouble6 = BDouble.init(stringValue6)!
		
		
		//assert
		XCTAssertEqual(bDouble1.decimalDescription, stringValueDecimal1)
		XCTAssertEqual(bDouble2.decimalDescription, stringValueDecimal2)
		XCTAssertEqual(bDouble3.decimalDescription, stringValueDecimal3)
		XCTAssertEqual(bDouble4.decimalDescription, stringValueDecimal4)
		XCTAssertEqual(bDouble5.decimalDescription, stringValueDecimal5)
		XCTAssertEqual(bDouble6.decimalDescription, stringValueDecimal6)
	}
	
	func testDescriptionLikeBIntValues() {
		
		//arrange
		let stringValue1 = "2000"
		let stringValue2 = "-2000"
		let stringValue3 = "115792089237316195423570985008687907853269984665640564039457584007913129639935"
		let stringValue4 = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
		
		//act
		let bDouble1 = BDouble.init(stringValue1)!
		let bDouble2 = BDouble.init(stringValue2)!
		let bDouble3 = BDouble.init(stringValue3)!
		let bDouble4 = BDouble.init(stringValue4)!
		
		//assert
		XCTAssertEqual(bDouble1.decimalDescription, stringValue1)
		XCTAssertEqual(bDouble2.decimalDescription, stringValue2)
		XCTAssertEqual(bDouble3.decimalDescription, stringValue3)
		XCTAssertEqual(bDouble4.decimalDescription, stringValue4)
	}
}
