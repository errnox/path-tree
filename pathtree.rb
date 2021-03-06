require 'pp'

class TreeNode
  attr_accessor :name, :data, :children, :html_string

  def initialize(name, data, children = [])
    @name = name
    @data = data
    @children = children

    @pp_indentation_width = 2
    @html_string = []
  end

  def pp(counter, string)
    string << ' ' * (counter * @pp_indentation_width) +
      File.basename(@name) + "\n"
    counter += 1

    @children.each do |child|
      child.pp counter, string
    end

    counter -= 1
  end

  def html
    self.htmlize([]).join("\n")
  end

  def htmlize(html)
    html << '<ul>'
    html << "<li><a href=\"#{@name}\">#{File.basename @name}</a></li>"

    @children.each do |child|
      child.htmlize html
    end

    html << '</ul>'
  end

end


class Tree
  attr_accessor :root

  def initialize(root)
    @root = root
    @last_found_node = nil  # Semi-global state!
  end

  def find(node_name, node, is_node=false)
    # Special case: the searched node is one of the children of the root
    # note.
    if is_node
      if node.children.collect { |c| c.name }.include? node_name
        @last_found_node = node.children[0]
      end
    end

    node.children.each do |child|
      children = child.children.select { |n| n.name == node_name }

      if (!children.collect { |n| n.name }.include? node_name)
        self.find node_name, child
      else
        @last_found_node = children[0]  # Semi-global state!
      end

    end
    return @last_found_node
  end

  def insert_child(node_name, new_node, node=@root)
    node.children.each do |child|
      if child.name == node_name
        child.children << new_node
      else
        self.insert_child node_name, new_node, child
      end

    end
  end

  def insert_pathes(pathes)
    pathes.each_pair do |key, value|
      value.each_pair do |k, v|
        if File.basename(k) != 'index.html'
          self.insert_child(key, TreeNode.new(k, ['data']))
        end
      end

      self.insert_pathes value

    end
  end

  def pp
    counter = 0
    string = []
    @root.pp counter, string
    string.join
  end

  def html
    @root.htmlize @root.html_string
    @root.html_string.join "\n"
  end

end
