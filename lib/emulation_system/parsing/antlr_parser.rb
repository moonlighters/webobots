module EmulationSystem::Parsing
  # === Обертка для вызова внешнего парсера ANTLR
  class ANTLRParser
    # Возвращает дерево разбора исходного кода в нотации Lisp
    #
    # Lisp нотация:
    #     (root child child (root child))
    def self.call(code)

      <<-RESULT
(block
  (def some
    (params x y)
    (block
      (= ret 5)
      (return ret)
    )
  )

  (call some
    (params 2.2 3.0)
  )

  (= a 3)
  (= b
    (/ 
      (call some (params a a))
      2
    )
  )
  (= var 1)

  (if (> a 3)
    (block
      (= temp 0)
    )
    (if (var)
      (block
        (= temp 0)
      )
      (block
        (= temp 0)
      )
    )
  )
)
      RESULT
    end
  end
end
