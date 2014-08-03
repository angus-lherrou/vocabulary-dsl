package org.anc.lapps.vocab.dsl

/**
 * TreeNode objects are used to link elements, which only have a pointer
 * to their parent, into a tree structure that is rendered to HTML.
 *
 * @author Keith Suderman
 */
class TreeNode {
    String name
    List<TreeNode> children = []

    static Map<String,TreeNode> index = [:]

    static TreeNode get(String name) {
        TreeNode node = index[name]
        if (node == null) {
            node = new TreeNode(name:name)
            index[name] = node
        }
        return node
    }
}
