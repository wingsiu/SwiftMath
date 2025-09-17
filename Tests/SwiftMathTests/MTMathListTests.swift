import XCTest
@testable import SwiftMath

//
//  MathRenderSwiftTests.swift
//  MathRenderSwiftTests
//
//  Created by Mike Griebling on 2023-01-02.
//

final class MTMathListTests: XCTestCase {
    
    func testSubScript() throws {
        let str = "-52x^{13+y}_{15-} + (-12.3 *)\\frac{-12}{15.2}"
        let list = MTMathListBuilder.build(fromString: str)!
        let finalized = list.finalized
        try self.checkListContents(finalized)
        // refinalizing a finalized list should not cause any more changes
        try self.checkListContents(finalized.finalized)
    }
    
    func checkListContents(_ finalized:MTMathList) throws {
        // check
        XCTAssertEqual((finalized.atoms.count), 10, "Num atoms");
        var atom = finalized.atoms[0];
        XCTAssertEqual(atom.type, .unaryOperator, "Atom 0");
        XCTAssertEqual(atom.nucleus, "−", "Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 1)), "Range");
        atom = finalized.atoms[1];
        XCTAssertEqual(atom.type, .number, "Atom 1");
        XCTAssertEqual(atom.nucleus, "52", "Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(1, 2)), "Range");
        atom = finalized.atoms[2];
        XCTAssertEqual(atom.type, .variable, "Atom 2");
        XCTAssertEqual(atom.nucleus, "x", "Atom 2 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(3, 1)), "Range");
        
        let superScr = atom.superScript!
        XCTAssertEqual((superScr.atoms.count), 3, "Super script");
        atom = superScr.atoms[0];
        XCTAssertEqual(atom.type, .number, "Super Atom 0");
        XCTAssertEqual(atom.nucleus, "13", "Super Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 2)), "Range");
        atom = superScr.atoms[1];
        XCTAssertEqual(atom.type, .binaryOperator, "Super Atom 1");
        XCTAssertEqual(atom.nucleus, "+", "Super Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(2, 1)), "Range");
        atom = superScr.atoms[2];
        XCTAssertEqual(atom.type, .variable, "Super Atom 2");
        XCTAssertEqual(atom.nucleus, "y", "Super Atom 2 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(3, 1)), "Range");
        
        atom = finalized.atoms[2];
        let subScr = atom.subScript!
        XCTAssertEqual((subScr.atoms.count), 2, "Sub script");
        atom = subScr.atoms[0];
        XCTAssertEqual(atom.type, .number, "Sub Atom 0");
        XCTAssertEqual(atom.nucleus, "15", "Sub Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 2)), "Range");
        atom = subScr.atoms[1];
        XCTAssertEqual(atom.type, .unaryOperator, "Sub Atom 1");
        XCTAssertEqual(atom.nucleus, "−", "Sub Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(2, 1)), "Range");
        
        atom = finalized.atoms[3];
        XCTAssertEqual(atom.type, .binaryOperator, "Atom 3");
        XCTAssertEqual(atom.nucleus, "+", "Atom 3 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(4, 1)), "Range");
        atom = finalized.atoms[4];
        XCTAssertEqual(atom.type, .open, "Atom 4");
        XCTAssertEqual(atom.nucleus, "(", "Atom 4 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(5, 1)), "Range");
        atom = finalized.atoms[5];
        XCTAssertEqual(atom.type, .unaryOperator, "Atom 5");
        XCTAssertEqual(atom.nucleus, "−", "Atom 5 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(6, 1)), "Range");
        atom = finalized.atoms[6];
        XCTAssertEqual(atom.type, .number, "Atom 6");
        XCTAssertEqual(atom.nucleus, "12.3", "Atom 6 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(7, 4)), "Range");
        atom = finalized.atoms[7];
        XCTAssertEqual(atom.type, .unaryOperator, "Atom 7");
        XCTAssertEqual(atom.nucleus, "*", "Atom 7 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(11, 1)), "Range");
        atom = finalized.atoms[8];
        XCTAssertEqual(atom.type, .close, "Atom 8");
        XCTAssertEqual(atom.nucleus, ")", "Atom 8 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(12, 1)), "Range");
        
        let frac = finalized.atoms[9] as! MTFraction
        XCTAssertEqual(frac.type, .fraction, "Atom 9");
        XCTAssertEqual(frac.nucleus, "", "Atom 9 value");
        XCTAssertTrue(NSEqualRanges(frac.indexRange, NSMakeRange(13, 1)), "Range");
        
        let numer = frac.numerator!
        XCTAssertNotNil(numer, "Numerator");
        XCTAssertEqual((numer.atoms.count), 2, "Numer script");
        atom = numer.atoms[0];
        XCTAssertEqual(atom.type, .unaryOperator, "Numer Atom 0");
        XCTAssertEqual(atom.nucleus, "−", "Numer Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 1)), "Range");
        atom = numer.atoms[1];
        XCTAssertEqual(atom.type, .number, "Numer Atom 1");
        XCTAssertEqual(atom.nucleus, "12", "Numer Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(1, 2)), "Range");
        
        
        let denom = frac.denominator!
        XCTAssertNotNil(denom, "Denominator");
        XCTAssertEqual((denom.atoms.count), 1, "Denom script");
        atom = denom.atoms[0];
        XCTAssertEqual(atom.type, .number, "Denom Atom 0");
        XCTAssertEqual(atom.nucleus, "15.2", "Denom Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 4)), "Range");
        
    }
    
    func testAdd() throws {
        let list = MTMathList()
        XCTAssertEqual(list.atoms.count, 0);
        let atom = MTMathAtomFactory.placeholder()
        list.add(atom)
        XCTAssertEqual(list.atoms.count, 1);
        XCTAssertEqual(list.atoms[0], atom);
        let atom2 = MTMathAtomFactory.placeholder()
        list.add(atom2);
        XCTAssertEqual(list.atoms.count, 2);
        XCTAssertEqual(list.atoms[0], atom);
        XCTAssertEqual(list.atoms[1], atom2);
    }
    
    private var options : XCTExpectedFailure.Options {
        let op = XCTExpectedFailure.Options()
        op.isStrict = true
        return op
    }

    func testAddErrors() throws {
        let list = MTMathList()
        var atom : MTMathAtom? = nil
        list.add(atom)
        atom = MTMathAtom(type: .boundary, value: "")
        XCTExpectFailure("Test adding an illegal atom", options:options) {
            XCTAssertThrowsError(list.add(atom))
        }
    }

    func testInsert() throws {
        let list = MTMathList()
        XCTAssertEqual(list.atoms.count, 0);
        let atom = MTMathAtomFactory.placeholder()
        list.insert(atom, at: 0)
        XCTAssertEqual(list.atoms.count, 1);
        XCTAssertEqual(list.atoms[0], atom);
        let atom2 = MTMathAtomFactory.placeholder()
        list.insert(atom2, at: 0)
        XCTAssertEqual(list.atoms.count, 2);
        XCTAssertEqual(list.atoms[0], atom2);
        XCTAssertEqual(list.atoms[1], atom);
        let atom3 = MTMathAtomFactory.placeholder()
        list.insert(atom3, at: 2)
        XCTAssertEqual(list.atoms.count, 3);
        XCTAssertEqual(list.atoms[0], atom2);
        XCTAssertEqual(list.atoms[1], atom);
        XCTAssertEqual(list.atoms[2], atom3);
    }

    func testInsertErrors() throws {
        let list = MTMathList()
        var atom : MTMathAtom? = nil
        list.insert(atom, at: 0)
        atom = MTMathAtom(type: .boundary, value:"")
        XCTExpectFailure("Test adding an illegal atom", options:options) {
            XCTAssertThrowsError(list.insert(atom, at:0))
        }
        atom = MTMathAtomFactory.placeholder()
        list.insert(atom, at:1)
    }

    func testAppend() throws {
        let list1 = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.placeholder()
        let atom3 = MTMathAtomFactory.placeholder()
        list1.add(atom)
        list1.add(atom2)
        list1.add(atom3)
        
        let list2 = MTMathList()
        let atom5 = MTMathAtomFactory.times()
        let atom6 = MTMathAtomFactory.divide()
        list2.add(atom5)
        list2.add(atom6)
        
        XCTAssertEqual(list1.atoms.count, 3);
        XCTAssertEqual(list2.atoms.count, 2);
        
        list1.append(list2)
        XCTAssertEqual(list1.atoms.count, 5);
        XCTAssertEqual(list1.atoms[3], atom5);
        XCTAssertEqual(list1.atoms[4], atom6);
    }

    func testRemoveLast() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        list.add(atom)
        XCTAssertEqual(list.atoms.count, 1);
        list.removeLastAtom()
        XCTAssertEqual(list.atoms.count, 0);
        // Removing from empty list.
        list.removeLastAtom()
        XCTAssertEqual(list.atoms.count, 0);
        let atom2 = MTMathAtomFactory.placeholder()
        list.add(atom)
        list.add(atom2);
        XCTAssertEqual(list.atoms.count, 2);
        list.removeLastAtom()
        XCTAssertEqual(list.atoms.count, 1);
        XCTAssertEqual(list.atoms[0], atom);
    }

    func testRemoveAtomAtIndex() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.placeholder()
        list.add(atom)
        list.add(atom2);
        XCTAssertEqual(list.atoms.count, 2);
        list.removeAtom(at:0)
        XCTAssertEqual(list.atoms.count, 1);
        XCTAssertEqual(list.atoms[0], atom2);
        
        // Index out of range
        XCTExpectFailure("Test removing an out-of-index cell", options: options) {
            XCTAssertThrowsError(list.removeAtom(at:2))
        }
    }

    func testRemoveAtomsInRange() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.placeholder()
        let atom3 = MTMathAtomFactory.placeholder()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)
        XCTAssertEqual(list.atoms.count, 3)
        list.removeAtoms(in: 1...2)
        XCTAssertEqual(list.atoms.count, 1);
        XCTAssertEqual(list.atoms[0], atom);
        
        // Index out of range
        XCTExpectFailure("Test removing an out-of-bounds range", options: options) {
            XCTAssertThrowsError(list.removeAtoms(in: 1...3))
        }
    }

//    func MTAssertEqual(test, expression1, expression2, ...) \
//    _XCTPrimitiveAssertEqual(test, expression1, @#expression1, expression2, @#expression2, __VA_ARGS__)
//
//    func MTAssertNotEqual(test, expression1, expression2, ...) \
//    _XCTPrimitiveAssertNotEqual(test, expression1, @#expression1, expression2, @#expression2, __VA_ARGS__)

    func checkAtomCopy(_ copy:MTMathAtom?, original:MTMathAtom?, forTest test:String) throws {
        guard let copy = copy, let original = original else { return }
        XCTAssertEqual(copy.type, original.type, test)
        XCTAssertEqual(copy.nucleus, original.nucleus, test)
        // Should be different objects with the same content
        XCTAssertNotEqual(copy, original, test)
    }

    func checkListCopy(_ copy:MTMathList?, original:MTMathList?, forTest test:String) throws {
        guard let copy = copy, let original = original else { return }
        XCTAssertEqual(copy.atoms.count, original.atoms.count, test)
        for (i, copyAtom) in copy.atoms.enumerated() {
            let origAtom = original.atoms[i];
            try self.checkAtomCopy(copyAtom, original:origAtom, forTest:test)
        }
    }

    func testCopy() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList(list)
        try checkListCopy(list2, original:list, forTest:self.description)
    }

    func testAtomInit() throws {
        var atom = MTMathAtom(type: .open, value: "(")
        XCTAssertEqual(atom.nucleus, "(")
        XCTAssertEqual(atom.type, .open)

        atom = MTMathAtom(type: .radical, value:"(")
        XCTAssertEqual(atom.nucleus, "");
        XCTAssertEqual(atom.type, .radical);
    }

    func testAtomScripts() throws {
        var atom = MTMathAtom(type: .open, value:"(")
        XCTAssertTrue(atom.isScriptAllowed())
        atom.subScript = MTMathList()
        XCTAssertNotNil(atom.subScript);
        atom.superScript = MTMathList()
        XCTAssertNotNil(atom.superScript);

        atom = MTMathAtom(type: .boundary, value:"(")
        XCTAssertFalse(atom.isScriptAllowed());
        // Can set to nil
        atom.subScript = nil;
        XCTAssertNil(atom.subScript);
        atom.superScript = nil;
        XCTAssertNil(atom.superScript);
        // Can't set to value
        let list = MTMathList()
        
        XCTExpectFailure("No sub/super-script on boundary atoms", options: options) {
            XCTAssertThrowsError(atom.subScript = list)
            XCTAssertThrowsError(atom.superScript = list)
        }
    }

    func testAtomCopy() throws {
        let list = MTMathList()
        let atom1 = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom1)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList()
        list2.add(atom3)
        list2.add(atom2)

        let atom = MTMathAtom(type: .open, value:"(")
        atom.subScript = list;
        atom.superScript = list2;
        let copy : MTMathAtom = atom.copy()

        try checkAtomCopy(copy, original:atom, forTest:self.description)
        try checkListCopy(copy.superScript, original:atom.superScript, forTest:self.description)
        try checkListCopy(copy.subScript, original:atom.subScript, forTest:self.description)
    }

    func testCopyFraction() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList()
        list2.add(atom3)
        list2.add(atom2)

        let frac = MTFraction(hasRule: false)
        XCTAssertEqual(frac.type, .fraction);
        frac.numerator = list;
        frac.denominator = list2;
        frac.leftDelimiter = "a";
        frac.rightDelimiter = "b";

        let copy = MTFraction(frac)
        try checkAtomCopy(copy, original:frac, forTest:self.description)
        try checkListCopy(copy.numerator, original:frac.numerator, forTest:self.description)
        try checkListCopy(copy.denominator, original:frac.denominator, forTest:self.description)
        XCTAssertFalse(copy.hasRule)
        XCTAssertEqual(copy.leftDelimiter, "a");
        XCTAssertEqual(copy.rightDelimiter, "b");
    }

    func testCopyRadical() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList()
        list2.add(atom3)
        list2.add(atom2)

        let rad = MTRadical()
        XCTAssertEqual(rad.type, .radical)
        rad.radicand = list;
        rad.degree = list2;

        let copy = MTRadical(rad)
        try checkAtomCopy(copy, original:rad, forTest:self.description)
        try checkListCopy(copy.radicand, original:rad.radicand ,forTest:self.description)
        try checkListCopy(copy.degree, original:rad.degree, forTest:self.description)
    }

    func testCopyLargeOperator() throws {
        let lg = MTLargeOperator(value: "lim", limits:true)
        XCTAssertEqual(lg.type, .largeOperator);
        XCTAssertTrue(lg.limits);

        let copy = MTLargeOperator(lg)
        try checkAtomCopy(copy, original:lg, forTest:self.description)
        XCTAssertEqual(copy.limits, lg.limits);
    }
    
    func testCopyInner() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)
        
        let inner = MTInner()
        inner.innerList = list;
        inner.leftBoundary = MTMathAtom(type: .boundary, value: "(")
        inner.rightBoundary = MTMathAtom(type: .boundary, value:")")
        XCTAssertEqual(inner.type, .inner);
        
        let copy = MTInner(inner)
        try checkAtomCopy(copy, original:inner, forTest:self.description)
        try checkListCopy(copy.innerList, original:inner.innerList, forTest:self.description)
        try checkAtomCopy(copy.leftBoundary!, original:inner.leftBoundary, forTest:self.description)
        try checkAtomCopy(copy.rightBoundary, original:inner.rightBoundary, forTest:self.description)
    }

    func testSetInnerBoundary() throws {
        let inner = MTInner()

        // Can set non-nil
        inner.leftBoundary = MTMathAtom(type: .boundary, value:"(")
        inner.rightBoundary = MTMathAtom(type: .boundary, value:")")
        XCTAssertNotNil(inner.leftBoundary);
        XCTAssertNotNil(inner.rightBoundary);
        // Can set nil
        inner.leftBoundary = nil;
        inner.rightBoundary = nil;
        XCTAssertNil(inner.leftBoundary);
        XCTAssertNil(inner.rightBoundary);
        // Can't set non boundary
        let atom = MTMathAtomFactory.placeholder()
        XCTExpectFailure("Setting illegal boundary atoms", options: options) {
            XCTAssertThrowsError(inner.leftBoundary = atom);
            XCTAssertThrowsError(inner.rightBoundary = atom);
        }
    }

    func testCopyOverline() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let over = MTOverLine()
            XCTAssertEqual(over.type, .overline);
        over.innerList = list;

        let copy = MTOverLine(over)
        try checkAtomCopy(copy, original:over, forTest:self.description)
        try checkListCopy(copy.innerList, original:over.innerList, forTest:self.description)
    }

    func testCopyUnderline() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let under = MTUnderLine()
        XCTAssertEqual(under.type, .underline);
        under.innerList = list;

        let copy = MTUnderLine(under)
        try checkAtomCopy(copy, original:under, forTest:self.description)
        try checkListCopy(copy.innerList, original:under.innerList, forTest:self.description)
    }

    func testCopyAcccent() throws {
        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let accent = MTAccent(value: "^")
        XCTAssertEqual(accent.type, .accent);
        accent.innerList = list;

        let copy = MTAccent(accent)
        try checkAtomCopy(copy, original:accent, forTest:self.description)
        try checkListCopy(copy.innerList ,original:accent.innerList, forTest:self.description)
    }

    func testCopySpace() throws {
        let space = MTMathSpace(space: 3)
        XCTAssertEqual(space.type, .space);
        
        let copy = MTMathSpace(space)
        try checkAtomCopy(copy, original:space, forTest:self.description)
        XCTAssertEqual(space.space, copy.space);
    }
    
    func testCopyStyle() throws {
        let style = MTMathStyle(style: .script)
        XCTAssertEqual(style.type, .style);
        
        let copy = MTMathStyle(style)
        try checkAtomCopy(copy, original:style, forTest:self.description)
        XCTAssertEqual(style.style, copy.style);
    }

    func testCreateMathTable() throws {
        let table = MTMathTable()
        XCTAssertEqual(table.type, .table);

        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList()
        list2.add(atom3)
        list2.add(atom2)

        table.set(cell: list, forRow:3, column:2)
        table.set(cell: list2, forRow:1, column:0)

        table.set(alignment: .left, forColumn: 2)
        table.set(alignment: .right, forColumn:1)

        // Verify that everything is created correctly
        XCTAssertEqual(table.cells.count, 4);  // 4 rows
        XCTAssertNotNil(table.cells[0]);
        XCTAssertEqual(table.cells[0].count, 0); // 0 elements in row 0
        XCTAssertEqual(table.cells[1].count, 1); // 1 element in row 1
        XCTAssertNotNil(table.cells[2]);
        XCTAssertEqual(table.cells[2].count, 0);
        XCTAssertEqual(table.cells[3].count, 3);

        // Verify the elements in the rows
        XCTAssertEqual(table.cells[1][0].atoms.count, 2);
        XCTAssertEqual(table.cells[1][0], list2);
        XCTAssertNotNil(table.cells[3][0]);
        XCTAssertEqual(table.cells[3][0].atoms.count, 0);

        XCTAssertNotNil(table.cells[3][0]);
        XCTAssertEqual(table.cells[3][0].atoms.count, 0);

        XCTAssertNotNil(table.cells[3][1]);
        XCTAssertEqual(table.cells[3][1].atoms.count, 0);

        XCTAssertEqual(table.cells[3][2], list);

        XCTAssertEqual(table.numRows, 4);
        XCTAssertEqual(table.numColumns, 3);

        // Verify the alignments
        XCTAssertEqual(table.alignments.count, 3);
            XCTAssertEqual(table.alignments[0], .center);
            XCTAssertEqual(table.alignments[1], .right);
            XCTAssertEqual(table.alignments[2], .left);
    }

    func testCopyMathTable() throws {
        let table = MTMathTable()
        XCTAssertEqual(table.type, .table);

        let list = MTMathList()
        let atom = MTMathAtomFactory.placeholder()
        let atom2 = MTMathAtomFactory.times()
        let atom3 = MTMathAtomFactory.divide()
        list.add(atom)
        list.add(atom2);
        list.add(atom3)

        let list2 = MTMathList()
        list2.add(atom3)
        list2.add(atom2)

        table.set(cell:list, forRow:0, column:1)
        table.set(cell:list2, forRow:0, column:2)

        table.set(alignment: .left, forColumn:2)
        table.set(alignment: .right, forColumn:1)
        table.interRowAdditionalSpacing = 3;
        table.interColumnSpacing = 10;

        let copy = MTMathTable(table)
        try checkAtomCopy(copy, original:table, forTest:self.description)
        XCTAssertEqual(copy.interColumnSpacing, table.interColumnSpacing);
        XCTAssertEqual(copy.interRowAdditionalSpacing, table.interRowAdditionalSpacing);
        XCTAssertEqual(copy.alignments, table.alignments)

        XCTAssertNotEqual(copy.cells, table.cells);
        XCTAssertNotEqual(copy.cells[0], table.cells[0] );
        XCTAssertEqual(copy.cells[0].count, table.cells[0].count);
        XCTAssertEqual(copy.cells[0][0].atoms.count, 0);
        XCTAssertNotEqual(copy.cells[0][0], table.cells[0][0]);
        try checkListCopy(copy.cells[0][1], original:list, forTest:self.description)
        try checkListCopy(copy.cells[0][2], original:list2, forTest:self.description)
    }

    // MARK: - IndexRange Update Tests
    
    func testUpdateIndexRanges() throws {
        let list = MTMathList()
        
        // Create atoms with specific index ranges
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .binaryOperator, value: "+")
        atom2.indexRange = NSMakeRange(1, 1)
        
        let atom3 = MTMathAtom(type: .variable, value: "y")
        atom3.indexRange = NSMakeRange(2, 1)
        
        list.add(atom1)
        list.add(atom2)
        list.add(atom3)
        
        // Test updating from index 1 with offset +2
        list.updateIndexRanges(from: 1, offset: 2)
        
        // atom1 should remain unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        
        // atom2 should be shifted by +2
        XCTAssertEqual(atom2.indexRange.location, 3)
        XCTAssertEqual(atom2.indexRange.length, 1)
        
        // atom3 should be shifted by +2  
        XCTAssertEqual(atom3.indexRange.location, 4)
        XCTAssertEqual(atom3.indexRange.length, 1)
    }
    
    func testInsertAtomUpdatesIndexRanges() throws {
        let list = MTMathList()
        
        // Create initial atoms
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .variable, value: "y")
        atom2.indexRange = NSMakeRange(1, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Insert a new atom at index 1
        let newAtom = MTMathAtom(type: .binaryOperator, value: "+")
        newAtom.indexRange = NSMakeRange(1, 1)
        list.insert(newAtom, at: 1)
        
        // Verify atom1 remains unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        
        // Verify newAtom is at the correct position
        XCTAssertEqual(newAtom.indexRange.location, 1)
        XCTAssertEqual(newAtom.indexRange.length, 1)
        
        // Verify atom2 is shifted by the inserted atom's length
        XCTAssertEqual(atom2.indexRange.location, 2)
        XCTAssertEqual(atom2.indexRange.length, 1)
    }
    
    func testRemoveAtomUpdatesIndexRanges() throws {
        let list = MTMathList()
        
        // Create atoms
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .binaryOperator, value: "+")
        atom2.indexRange = NSMakeRange(1, 1)
        
        let atom3 = MTMathAtom(type: .variable, value: "y")
        atom3.indexRange = NSMakeRange(2, 1)
        
        list.add(atom1)
        list.add(atom2)
        list.add(atom3)
        
        // Remove atom at index 1 (atom2)
        list.removeAtom(at: 1)
        
        // Verify atom1 remains unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        
        // Verify atom3 is shifted back by the removed atom's length
        XCTAssertEqual(atom3.indexRange.location, 1)
        XCTAssertEqual(atom3.indexRange.length, 1)
        
        // Verify the list now has 2 atoms
        XCTAssertEqual(list.atoms.count, 2)
        XCTAssertEqual(list.atoms[0], atom1)
        XCTAssertEqual(list.atoms[1], atom3)
    }
    
    func testRemoveAtomsInRangeUpdatesIndexRanges() throws {
        let list = MTMathList()
        
        // Create atoms
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .binaryOperator, value: "+")
        atom2.indexRange = NSMakeRange(1, 1)
        
        let atom3 = MTMathAtom(type: .variable, value: "y")
        atom3.indexRange = NSMakeRange(2, 1)
        
        let atom4 = MTMathAtom(type: .binaryOperator, value: "=")
        atom4.indexRange = NSMakeRange(3, 1)
        
        let atom5 = MTMathAtom(type: .number, value: "5")
        atom5.indexRange = NSMakeRange(4, 1)
        
        list.add(atom1)
        list.add(atom2)
        list.add(atom3)
        list.add(atom4)
        list.add(atom5)
        
        // Remove atoms at range 1...2 (atom2 and atom3)
        list.removeAtoms(in: 1...2)
        
        // Verify atom1 remains unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        
        // Verify atom4 and atom5 are shifted back by 2 (removed atoms' combined length)
        XCTAssertEqual(atom4.indexRange.location, 1)
        XCTAssertEqual(atom4.indexRange.length, 1)
        
        XCTAssertEqual(atom5.indexRange.location, 2)
        XCTAssertEqual(atom5.indexRange.length, 1)
        
        // Verify the list now has 3 atoms
        XCTAssertEqual(list.atoms.count, 3)
        XCTAssertEqual(list.atoms[0], atom1)
        XCTAssertEqual(list.atoms[1], atom4)
        XCTAssertEqual(list.atoms[2], atom5)
    }
    
    func testInsertWithMultiCharacterLength() throws {
        let list = MTMathList()
        
        // Create an atom with multi-character length
        let atom1 = MTMathAtom(type: .number, value: "123")
        atom1.indexRange = NSMakeRange(0, 3)
        
        let atom2 = MTMathAtom(type: .variable, value: "x")
        atom2.indexRange = NSMakeRange(3, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Insert a new multi-character atom
        let newAtom = MTMathAtom(type: .number, value: "45")
        newAtom.indexRange = NSMakeRange(3, 2)
        list.insert(newAtom, at: 1)
        
        // Verify atom1 remains unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 3)
        
        // Verify atom2 is shifted by the inserted atom's length (2)
        XCTAssertEqual(atom2.indexRange.location, 5)
        XCTAssertEqual(atom2.indexRange.length, 1)
    }
    
    func testNestedStructuresIndexRangeUpdate() throws {
        let list = MTMathList()
        
        // Create a fraction with nested sublists
        let fraction = MTFraction()
        fraction.indexRange = NSMakeRange(0, 1)
        
        // Create numerator
        let numAtom1 = MTMathAtom(type: .variable, value: "x")
        numAtom1.indexRange = NSMakeRange(0, 1)
        let numAtom2 = MTMathAtom(type: .binaryOperator, value: "+")
        numAtom2.indexRange = NSMakeRange(1, 1)
        
        fraction.numerator = MTMathList()
        fraction.numerator!.add(numAtom1)
        fraction.numerator!.add(numAtom2)
        
        // Create denominator
        let denomAtom = MTMathAtom(type: .variable, value: "y")
        denomAtom.indexRange = NSMakeRange(0, 1)
        
        fraction.denominator = MTMathList()
        fraction.denominator!.add(denomAtom)
        
        // Add fraction to main list
        list.add(fraction)
        
        // Add another atom after the fraction
        let atom2 = MTMathAtom(type: .variable, value: "z")
        atom2.indexRange = NSMakeRange(1, 1)
        list.add(atom2)
        
        // Insert a new atom at the beginning
        let newAtom = MTMathAtom(type: .number, value: "2")
        newAtom.indexRange = NSMakeRange(0, 1)
        list.insert(newAtom, at: 0)
        
        // Verify the fraction's index range is updated
        XCTAssertEqual(fraction.indexRange.location, 1)
        
        // Verify nested structures in numerator are updated
        XCTAssertEqual(numAtom1.indexRange.location, 1)
        XCTAssertEqual(numAtom2.indexRange.location, 2)
        
        // Verify nested structure in denominator is updated
        XCTAssertEqual(denomAtom.indexRange.location, 1)
        
        // Verify the last atom is updated
        XCTAssertEqual(atom2.indexRange.location, 2)
    }
    
    func testAppendListUpdatesIndexRanges() throws {
        let list1 = MTMathList()
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .binaryOperator, value: "+")
        atom2.indexRange = NSMakeRange(1, 1)
        list1.add(atom1)
        list1.add(atom2)
        
        let list2 = MTMathList()
        let atom3 = MTMathAtom(type: .variable, value: "y")
        atom3.indexRange = NSMakeRange(0, 1)
        
        let atom4 = MTMathAtom(type: .number, value: "2")
        atom4.indexRange = NSMakeRange(1, 1)
        list2.add(atom3)
        list2.add(atom4)
        
        // Append list2 to list1
        list1.append(list2)
        
        // Verify original atoms in list1 remain unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        XCTAssertEqual(atom2.indexRange.location, 1)
        XCTAssertEqual(atom2.indexRange.length, 1)
        
        // Verify appended atoms have updated index ranges
        XCTAssertEqual(atom3.indexRange.location, 2) // Base offset (2) + original location (0)
        XCTAssertEqual(atom3.indexRange.length, 1)
        XCTAssertEqual(atom4.indexRange.location, 3) // Base offset (2) + original location (1)
        XCTAssertEqual(atom4.indexRange.length, 1)
        
        // Verify list1 now contains all atoms
        XCTAssertEqual(list1.atoms.count, 4)
    }
    
    func testInsertAtBeginning() throws {
        let list = MTMathList()
        
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .variable, value: "y")
        atom2.indexRange = NSMakeRange(1, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Insert at beginning
        let newAtom = MTMathAtom(type: .number, value: "5")
        newAtom.indexRange = NSMakeRange(0, 1)
        list.insert(newAtom, at: 0)
        
        // All subsequent atoms should be shifted
        XCTAssertEqual(newAtom.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.location, 1)
        XCTAssertEqual(atom2.indexRange.location, 2)
    }
    
    func testInsertAtEnd() throws {
        let list = MTMathList()
        
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .variable, value: "y")
        atom2.indexRange = NSMakeRange(1, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Insert at end
        let newAtom = MTMathAtom(type: .number, value: "5")
        newAtom.indexRange = NSMakeRange(2, 1)
        list.insert(newAtom, at: 2)
        
        // Previous atoms should remain unchanged
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom2.indexRange.location, 1)
        XCTAssertEqual(newAtom.indexRange.location, 2)
    }
    
    func testRemoveLastAtomNoIndexUpdate() throws {
        let list = MTMathList()
        
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .variable, value: "y")
        atom2.indexRange = NSMakeRange(1, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Remove last atom
        list.removeLastAtom()
        
        // First atom should remain unchanged (no subsequent atoms to update)
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
        XCTAssertEqual(list.atoms.count, 1)
    }
    
    func testUpdateIndexRangesWithZeroOffset() throws {
        let list = MTMathList()
        
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        let atom2 = MTMathAtom(type: .variable, value: "y")
        atom2.indexRange = NSMakeRange(1, 1)
        
        list.add(atom1)
        list.add(atom2)
        
        // Update with zero offset should do nothing
        list.updateIndexRanges(from: 0, offset: 0)
        
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom2.indexRange.location, 1)
    }
    
    func testUpdateIndexRangesOutOfBounds() throws {
        let list = MTMathList()
        
        let atom1 = MTMathAtom(type: .variable, value: "x")
        atom1.indexRange = NSMakeRange(0, 1)
        
        list.add(atom1)
        
        // Update from index beyond list bounds should do nothing
        list.updateIndexRanges(from: 5, offset: 2)
        
        XCTAssertEqual(atom1.indexRange.location, 0)
        XCTAssertEqual(atom1.indexRange.length, 1)
    }

}
