import Foundation

class Trie {
    var is_leaf: Bool
    var children = [Character : Trie]()
    
    init() {
        is_leaf = false
    }
}

func insert(word: String, root: Trie) {
    var current = root
    for char in word {
        if (current.children[char] == nil) {
            current.children[char] = Trie()
        }
        current = current.children[char] ?? Trie()
    }
    current.is_leaf = true;
}

func find(word: String, root: Trie) -> Bool {
    var current = root
    for char in word {
        if (current.children[char] == nil) {
            current.children[char] = Trie()
        }
        current = current.children[char] ?? Trie()
    }
    return current.is_leaf
}

func is_valid(i: Int,
                j: Int,
                m: Int,
                n: Int,
                visited: [[Bool]]) -> Bool {
    return i >= 0 && i < m && j >= 0 && j < n &&
            !visited[i][j];
}


let row_diff = [-1, -1, -1, 0, 0, 1, 1, 1]
let col_diff = [-1, 1, 0, -1, 1, 0, -1, 1]

func search_words(root: Trie,
                    visited: inout [[Bool]],
                    result: inout Set<String>,
                    path: String,
                    i: Int,
                    j: Int,
                    m: Int,
                    n: Int,
                    table: [[Character]]) {
    if (root.is_leaf) {
        result.insert(path)
    }
    visited[i][j] = true
    for node in root.children {
        for k in 0...7 {
            if (is_valid(i: i + row_diff[k],
                            j: j + col_diff[k],
                            m: m,
                            n: n,
                            visited: visited)
                    && node.key == table[i + row_diff[k]][j + col_diff[k]]) {
                search_words(root: node.value,
                                visited: &visited,
                                result: &result,
                                path: path + String(node.key),
                                i: i + row_diff[k],
                                j: j + col_diff[k],
                                m: m,
                                n: n,
                                table: table)
            }
        }
    }
    visited[i][j] = false
}


let words = readLine(strippingNewline: true)!.characters
    .split {$0 == " "}
    .map (String.init)
let dimens = readLine(strippingNewline: true)!.characters
    .split {$0 == " "}
    .map{ Int(String($0)) }
let m: Int = dimens[0] ?? 1
let n: Int = dimens[1] ?? 1
var table = [[Character]]()
for _ in 0...(m-1) {
    let newLine = readLine(strippingNewline: true)!.characters
        .split {$0 == " "}
        .map{ Character(String($0)) }
    table.append(newLine)
}

let root = Trie()
for word in words {
    insert(word: word, root: root)
}

var found_words = [String]()
var visited = Array(repeating: Array(repeating: false, count: n), count: m)
var result: Set<String> = []
for i in 0...(m-1) {
    for j in 0...(n-1) {
        if (root.children[table[i][j]] != nil) {
            let to_insert = String(table[i][j])
            search_words(
                root: root.children[table[i][j]] ?? Trie(),
                visited: &visited,
                result: &result,
                path: to_insert,
                i: i,
                j: j,
                m: m,
                n: n,
                table: table);
        }
    }
}

for found_str in result {
    print(found_str)
}

