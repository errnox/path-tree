require_relative 'pathtree'

class PathTreeTest
  attr_accessor :tree, :nested_pathes

  def initialize()
    @pathes =
      ["index.html",
       "pages/colors/dark/blue/index.html",
       "pages/colors/dark/purple/index.html",
       "pages/colors/bright/orange/index.html",
       "pages/colors/bright/red/index.html",
       "pages/colors/bright/yellow/index.html",
       "pages/colors/index.html",
       "pages/animals/large/elephant/index.html",
       "pages/animals/large/giraffe/index.html",
       "pages/animals/small/cat/index.html",
       "pages/animals/small/mouse/index.html"]
    @nested_hash = {
      "colors" => {
        "bright" => {
          "red" => {},
          "orange" => {},
          "yellow" => {},
        },
        "dark" => {
          "blue" => {},
          "purple" => {},
        },
        # "people" => {
        #   "tall" => {
        #     "funny" => {},
        #     "boring" => {},
        #     "sad" => {},
        #   },
        #   "small" => {
        #     "interesting" => {},
        #     "uninteresting" => {},
        #   },
        # }
      },
    }
    @nested_pathes = {"/index.html" => {},
      "/pages" =>
      {"/pages/colors" =>
        {"/pages/colors/dark" =>
          {"/pages/colors/dark/blue" =>
            {"/pages/colors/dark/blue/index.html" => {}},
            "/pages/colors/dark/purple" =>
            {"/pages/colors/dark/purple/index.html" => {}}},
          "/pages/colors/bright" =>
          {"/pages/colors/bright/orange" =>
            {"/pages/colors/bright/orange/index.html" => {}},
            "/pages/colors/bright/red" =>
            {"/pages/colors/bright/red/index.html" => {}},
            "/pages/colors/bright/yellow" =>
            {"/pages/colors/bright/yellow/index.html" => {}}},
          "/pages/colors/index.html" => {}},
        "/pages/animals" =>
        {"/pages/animals/large" =>
          {"/pages/animals/large/elephant" =>
            {"/pages/animals/large/elephant/index.html" => {}},
            "/pages/animals/large/giraffe" =>
            {"/pages/animals/large/giraffe/index.html" => {}}},
          "/pages/animals/small" =>
          {"/pages/animals/small/cat" =>
            {"/pages/animals/small/cat/index.html" => {}},
            "/pages/animals/small/mouse" =>
            {"/pages/animals/small/mouse/index.html" => {}}}}}}
    @tree
  end

  def initialize_tree
    @tree = Tree.new(TreeNode.new('root', ['root', 'data', 1, 2, 3],
                                  [TreeNode.new('/pages', ['root',
                                                           'data',
                                                           1, 2, ])]))
  end

  def initialize_tree_with_colors
    @tree = Tree.new(TreeNode.new('root', ['root', 'data', 1, 2, 3],
                                  [TreeNode.new('colors',
                                                ['various colors',
                                                 'hex colors',
                                                 'rgb colors'])]))
  end

  def initialize_tree_with_nested_children

    tree = Tree.new(TreeNode.new('root', ['root', 'data', 1, 2, 3],
                                 [TreeNode.new('colors', ['root',
                                                          'data',
                                                          1, 2, 3],
                                               [TreeNode.new('bright',
                                                             ['root',
                                                              'data',
                                                              1, 2, 3]),
                                                TreeNode.new('dark',
                                                             ['root',
                                                              'data',
                                                              1, 2,
                                                              3])])]))
  end

  def insert_children
    @tree.insert_child('colors', TreeNode.new('bright',
                                              ['bright colors',
                                               'example: #FF0000']))
    @tree.insert_child('bright', TreeNode.new('red',
                                              ['#FF0000',
                                               'rgb(255, 0, 0)']))
    @tree.insert_child('bright', TreeNode.new('white',
                                              ['#FFFFFF',
                                               'rgb(255, 255, 255)']))
    @tree.insert_child('colors', TreeNode.new('dark',
                                              ['dark colors',
                                               'example: #000000']))
    @tree.insert_child('dark', TreeNode.new('blue',
                                            ['#0000FF',
                                             'rgb(0, 0, 255)']))
    @tree.insert_child('dark', TreeNode.new('black',
                                            ['#000000',
                                             'rgb(0, 0, 0)']))
  end

  def insert_pathes(pathes)
    pathes.each_pair do |key, value|
      value.each_pair do |k, v|
        if File.basename(k) != 'index.html'
          @tree.insert_child(key, TreeNode.new(k, ['data']))
        end
      end

      self.insert_pathes value

    end
  end

end


path_tree_test = PathTreeTest.new

#--------------------------------------------------------------------------
# Test 1 - `find' + `insert_children'
#--------------------------------------------------------------------------

# path_tree_test.insert_children

# # pp '###################################################################\
# # ########'
# # pp tree.find('bright', tree.root)


# puts "====================================================================\
# ======="
# pp path_tree_test.tree.find('bright', path_tree_test.tree.root, true)

# # puts '------------------------------------------------------------------\
# # ---------'
# # pp tree


#--------------------------------------------------------------------------
# Test 2 - `pp'
#--------------------------------------------------------------------------

# path_tree_test.initialize_tree
# # path_tree_test.insert_pathes(path_tree_test.nested_pathes['/pages'])
# path_tree_test.insert_pathes({ '/pages' =>
#                                path_tree_test.nested_pathes['/pages'] })


# puts "====================================================================\
# ======="
# # pp path_tree_test.tree
# puts path_tree_test.tree.pp


#--------------------------------------------------------------------------
# Test 3 - `htmlize'/`html'
#--------------------------------------------------------------------------

path_tree_test.initialize_tree
# path_tree_test.insert_pathes(path_tree_test.nested_pathes['/pages'])
# path_tree_test.insert_pathes({ '/pages' =>
#                                path_tree_test.nested_pathes['/pages'] })

path_tree_test.tree.insert_pathes({ '/pages' =>
                                    path_tree_test.nested_pathes['/pages']
                                  })


# pp path_tree_test.tree
# puts path_tree_test.tree.html

# puts path_tree_test.tree.find('/pages/colors',
#                               path_tree_test.tree.root,
#                               true).html


puts path_tree_test.tree.html
