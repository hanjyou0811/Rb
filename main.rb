require "minruby"

def eval(tree, env)
    case tree[0]
    when "lit"
        tree[1]
    when "**"
        eval(tree[1], env) ** eval(tree[2], env)
    when "%"
        eval(tree[1], env) % eval(tree[2], env)
    when "+"
        if env.key?("plus_count")
            env["plus_count"] += 1
        end
        eval(tree[1], env) + eval(tree[2], env)
    when "-"
        eval(tree[1], env) - eval(tree[2], env)
    when "*"
        eval(tree[1], env) * eval(tree[2], env)
    when "/"
        eval(tree[1], env) / eval(tree[2], env)
    when "=="
        eval(tree[1], env) == eval(tree[2], env)
    when "!="
        eval(tree[1], env) != eval(tree[2], env)
    when "<"
        eval(tree[1], env) < eval(tree[2], env)
    when ">"
        eval(tree[1], env) > eval(tree[2], env)
    when "<="
        eval(tree[1], env) <= eval(tree[2], env)
    when ">="
        eval(tree[1], env) >= eval(tree[2], env)
    when "func_call"
        p(eval(tree[2], env))
    when "stmts"
        i = 1
        last = nil
        while tree[i] != nil
            last = eval(tree[i], env)
            i = i + 1
        end
        last
    when "var_assign"
        env[tree[1]] = eval(tree[2], env)
    when "var_ref"
        env[tree[1]]
    when "if"
        if eval(tree[1], env)
            eval(tree[2], env)
        else 
            eval(tree[3], env)
        end
    when "while"
        while eval(tree[1], env)
            eval(tree[2], env)
        end
    when "while2"
        eval(tree[2], env)
        while eval(tree[1], env)
            eval(tree[2], env)
        end
    else
        p "unknown node: #{tree[0]}"
    end
end

def max(tree)
    mx = 0
    if tree[0] == "lit"
        if tree[1] > mx
            mx = tree[1]
        end
    else
        m = max(tree[1])
        if m > mx
            mx = m
        end
        m = max(tree[2])
        if m > mx
            mx = m
        end
    end
    return mx
end

env = {}
input = minruby_load()
tree = minruby_parse(input)
p(tree)
eval(tree, env)