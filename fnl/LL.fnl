(let [default {:name :LL :level :warn}
      levels [:debug :info :warn :error]
      toStr (fn [...]
              (let [acc []]
                (for [i 1 (select "#" ...)]
                  (let [v (select i ...)
                        s (if (= (type v) :table)
                              (vim.inspect v)
                              (tostring v))]
                    (tset acc (+ (length acc) 1) s)))
                (table.concat acc " ")))
      new (fn [opts]
            (let [M {}
                  o (vim.tbl_deep_extend :force default (or opts {}))
                  targetLevel (accumulate [target (length levels) index level (ipairs levels)]
                                (if (= level o.level)
                                    index
                                    target))
                  path (.. (vim.fn.stdpath :data) "/" o.name :.log)
                  doLog (fn [level label ...]
                          (if (>= level targetLevel)
                              (let [info (debug.getinfo 2 :Sl)
                                    msg (string.format "[%-6s%s] %s: %s"
                                                       (label:upper)
                                                       (os.date "%Y-%m-%d %H:%M:%S")
                                                       (.. info.short_src ":"
                                                           info.currentline)
                                                       (toStr ...))]
                                (doto (io.open path :a)
                                  (: :write msg)
                                  (: :close)))))]
              ;; register functions.
              (each [num name (ipairs levels)]
                (tset M name
                      (fn [...]
                        (doLog num name ...))))
              M))]
  {: new})
