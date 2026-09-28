require "minruby"

def eval(tree, genv, lenv)
    case tree[0]
    when "lit"
        tree[1]
    when "**"
        eval(tree[1], genv, lenv) ** eval(tree[2], genv, lenv)
    when "%"
        eval(tree[1], genv, lenv) % eval(tree[2], genv, lenv)
    when "+"
        if lenv["plus_count"] != nil
            lenv["plus_count"] = lenv["plus_count"] + 1
        else
            0
        end
        eval(tree[1], genv, lenv) + eval(tree[2], genv, lenv)
    when "-"
        eval(tree[1], genv, lenv) - eval(tree[2], genv, lenv)
    when "*"
        eval(tree[1], genv, lenv) * eval(tree[2], genv, lenv)
    when "/"
        eval(tree[1], genv, lenv) / eval(tree[2], genv, lenv)
    when "=="
        eval(tree[1], genv, lenv) == eval(tree[2], genv, lenv)
    when "!="
        eval(tree[1], genv, lenv) != eval(tree[2], genv, lenv)
    when "<"
        eval(tree[1], genv, lenv) < eval(tree[2], genv, lenv)
    when ">"
        eval(tree[1], genv, lenv) > eval(tree[2], genv, lenv)
    when "<="
        eval(tree[1], genv, lenv) <= eval(tree[2], genv, lenv)
    when ">="
        eval(tree[1], genv, lenv) >= eval(tree[2], genv, lenv)
    when "func_def"
        genv[tree[1]] = ["user_defined", tree[2], tree[3]]
    when "func_call"
        args = []
        i = 0
        while tree[i + 2] 
            args[i] = eval(tree[i + 2], genv, lenv)
            i = i + 1
        end
        mhd = genv[tree[1]]
        if mhd[0] == "builtin"
            minruby_call(mhd[1], args)
        else 
            new_lenv = {}
            params = mhd[1]
            i = 0
            while params[i]
                new_lenv[params[i]] = args[i]
                i = i + 1
            end
            eval(mhd[2], genv, new_lenv)
        end
    when "stmts"
        i = 1
        last = nil
        while tree[i] != nil
            last = eval(tree[i], genv, lenv)
            i = i + 1
        end
        last
    when "var_assign"
        lenv[tree[1]] = eval(tree[2], genv, lenv)
    when "var_ref"
        lenv[tree[1]]
    when "if"
        if eval(tree[1], genv, lenv)
            eval(tree[2], genv, lenv)
        else 
            eval(tree[3], genv, lenv)
        end
    when "while"
        while eval(tree[1], genv, lenv)
            eval(tree[2], genv, lenv)
        end
    when "while2"
        eval(tree[2], genv, lenv)
        while eval(tree[1], genv, lenv)
            eval(tree[2], genv, lenv)
        end
    when "ary_new"
        ary = []
        i = 0
        while tree[i + 1]
            ary[i] = eval(tree[i + 1], genv, lenv)
            i = i + 1
        end
        ary
    when "ary_ref"
        ary = eval(tree[1], genv, lenv)
        idx = eval(tree[2], genv, lenv)
        ary[idx]
    when "ary_assign"
        ary = eval(tree[1], genv, lenv)
        idx = eval(tree[2], genv, lenv)
        val = eval(tree[3], genv, lenv)
        ary[idx] = val
    when "hash_new"
        hsh = {}
        i = 0
        while tree[i + 1]
            key = eval(tree[i + 1], genv, lenv)
            val = eval(tree[i + 2], genv, lenv)
            hsh[key] = val
            i = i + 2
        end
        hsh
    else
        raise "Unknown node:"
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
    mx
end

def add(x, y)
    x + y
end

def fizzbuzz(n)
    if n % 15 == 0
        p "FizzBuzz"
    elsif n % 3 == 0
        p "Fizz"
    elsif n % 5 == 0
        p "Buzz"
    else 
        p n
    end
end

genv = {
    "p" => ["builtin", "p"],
    "raise" => ["builtin", "raise"],
    "require" => ["builtin", "require"],
    "minruby_parse" => ["builtin", "minruby_parse"],
    "minruby_load" => ["builtin", "minruby_load"],
    "minruby_call" => ["builtin", "minruby_call"],
}

lenv = {}
input = minruby_load()
tree = minruby_parse(input)
# p(tree)
eval(tree, genv, lenv)