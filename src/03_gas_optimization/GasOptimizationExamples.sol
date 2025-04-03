// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Storage {
    uint256 a; // slot 0
    uint256 b; // slot 1
    uint128 c; // slot 2
    uint64 d; // slot 2
    uint32 e; // slot 2
    uint64 f; // slot 3
    uint256 x;

    function safeA() external {
        a = 1;
    }

    function safeF() external {
        f = 1;
    }

    function safeBC() external {
        b = 1;
        c = 1;
    }

    function safeDE() external {
        d = 1;
        e = 1;
    }

    function safeX(uint256 _x) external {
        x = _x;
    }

    function getData(uint256[] calldata _arr) external returns (uint256) {
        return _arr.length;
    }
}

contract UnOptimized {
    uint256 a = 1; // slot 0
    uint128 c = 1; // slot 1
    uint256 b; // slot 2
    uint128 d; // slot 3
    mapping(uint256 => uint256) public map; // slot 4 //  keccak256(slot + key) => value for the slot
    uint256[] public test; // slot 5 // keccak256(slot + 3) => value for the  [][][x][][]
    uint256 neww; // slot 6
    uint256[3] public fixedArr; // slot 7-9

    function getA() external view returns (uint256) {
        return a;
    }

    function getC() external view returns (uint256) {
        return c;
    }

    function alocateMemory(uint256 length) external pure returns (uint256) {
        uint256[] memory newArr = new uint256[](length);

        return newArr.length;
    }
}

// 830 - 1
// 836 - 2
// 842 - 3
// new allocation = 6 gas
// 945 - 20
// 1445 - 100
// 8800 - 1000 // average cost 8 gas

contract StudentContract {
    struct Student {
        string name;
        uint256 age;
        uint256 numberInClass;
        uint256[] grades;
    }

    string test = "Hellodsadasdadsjadjsadhashdhashdashdhashdhasdhashda";

    Student public rosen;
    // slot 0 => length => ........ like dynamic array
    // slot 1 => age
    // slot 2 => numberInClasss
    // slot 3 => length => ...... values based on keccak

    Student[] public students;
    // slot 4 => length => ....... value bassed on keccak
    // => slot 77654383 => lenght => .... value based on keccak => string values
    // => slot 77654384 => age

    // struct Student {
    //     string name;
    //     uint256 age;
    //     uint256 numberInClass;
    //     Grade[] grades;
    // }

    // struct Grade {
    //     string a;
    //     mapping(uint256 => uint256[]) grades;
    // }
}

contract CalldataVsMemory {
    // Using memory (more expensive)
    function processWithMemory(
        string memory data
    ) external pure returns (uint256) {
        return bytes(data).length; // Simulate some processing
    }

    // Using calldata (cheaper)
    function processWithCalldata(
        string calldata data
    ) external pure returns (uint256) {
        return bytes(data).length; // Simulate some processing
    }
}

// keccak256("processWithCalldata(string)(uint256)") => get first 8 symbols

// [3][3]
// [[][][]][[][][]][[][][]]
