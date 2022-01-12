pragma solidity ^0.8.0;

contract Library {
    uint private bookCount = 0;

    struct Book {
        string title;
        uint numberOfCopies;
        address[] rentals;
    }

    mapping (uint => Book) private books;
    mapping(address => uint) currentRentals;
    
    address public owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Not invoked by the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addBook(string calldata _title, uint _numberOfCopies) external onlyOwner {
        address[] memory rentals;

        bookCount++;
        books[bookCount] = Book(_title, _numberOfCopies, rentals);
    }

    function getBooks() external view returns (Book[] memory) {
        Book[] memory result = new Book[](bookCount);

        for (uint i = 0; i < bookCount; i++) {
            result[i] = books[i + 1];
        }

        return result;
    }

    function rentBook(uint _id) external {
        require(currentRentals[msg.sender] < 1, "Return the book first");

        Book storage theBook = books[_id];

        require(theBook.numberOfCopies > 0, "No more copies");

        theBook.numberOfCopies--;
        theBook.rentals.push(msg.sender);
        currentRentals[msg.sender] = _id;
    }

    function returnBook() external {
        uint id = currentRentals[msg.sender];

        require(id > 0, "No book to return");

        Book storage theBook = books[id];

        theBook.numberOfCopies++;
        delete currentRentals[msg.sender];
    }
}