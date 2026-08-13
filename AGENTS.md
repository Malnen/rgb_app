# Dart Coding Rules

## Class Member Ordering

Members within a Dart class must appear in this exact order:

1. Public static fields
2. Protected static fields
3. Private static fields
4. Public fields
5. Protected fields
6. Private fields
7. Constructor(s)
8. Static public getters
9. Static protected getters
10. Static private getters
11. Static public methods
12. Static protected methods
13. Static private methods
14. Factories
15. Public getters / setters
16. Protected getters / setters
17. Private getters / setters
18. Public abstract methods
19. Protected abstract methods
20. Public methods
21. Protected methods
22. Private methods

Within each group, order modifiers as: `const`, `final`, `late final`, `late`, then no modifier or
nullable.

Within modifier groups, put abstract members first, then `@override`, then the rest. Instance
methods use the dedicated abstract visibility groups above.

Order methods by usage with callers above callees. If a private method is called by multiple
callers, place it below the last caller. Visibility boundaries are hard constraints.

## Formatting And Expressions

- Add a blank line immediately before `return` when the method has more than one preceding
  statement, unless the preceding line is a closing `}`.
- Add a blank line after a braced `if`, `when`, `for`, `while`, or `try` block when more code
  follows.
- Avoid method chaining; assign intermediate results to named variables.
- Avoid nested calls as arguments; assign the inner result before calling the outer method.
- Always use curly braces for control-flow bodies.
- Omit redundant `else` after `return`, `throw`, `break`, or `continue`.
- Avoid early-return negation; use a positive branch for the remaining work.
- Prefer collection/stream-style transformations such as `where`, `map`, `groupListsBy`, and
  `forEach` over manual aggregation loops when the operation is a pure filter, transform, grouping,
  or dispatch. Keep imperative loops when they make stateful sequencing or side effects clearer.
