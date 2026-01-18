# GENERICITY SCAN: simple_mock

## Summary
- Generic classes currently: 0
- Genericity opportunities found: 0
- Estimated code reduction: 0%

---

## Current Genericity Usage

**None.** All classes are concrete with no type parameters.

---

## Duplicate Structure Detection

**No duplicate structures found.**

All 7 classes have distinct purposes:
| Class | Purpose | Similar to |
|-------|---------|------------|
| SIMPLE_MOCK | Facade | None |
| MOCK_SERVER | Server lifecycle | None |
| MOCK_EXPECTATION | Request-response pairing | None |
| MOCK_MATCHER | URL/body matching | None |
| MOCK_RESPONSE | Response definition | MOCK_REQUEST (partial) |
| MOCK_REQUEST | Request record | MOCK_RESPONSE (partial) |
| MOCK_VERIFIER | Verification helpers | None |

**MOCK_REQUEST vs MOCK_RESPONSE similarity:**
- Both have: `headers`, `body`, `add_header`, `has_body`
- Difference: Request is incoming data, Response is configuration
- Semantic difference prevents generic abstraction

---

## Parallel Hierarchy Detection

**None found.**

No type-specific class variants exist:
- No STRING_MATCHER, INTEGER_MATCHER, etc.
- No GET_EXPECTATION, POST_EXPECTATION, etc.
- All classes handle all HTTP methods uniformly

---

## Type-Specific Feature Detection

**None found.**

No features are duplicated for different types:
- No `match_string_body`, `match_json_body`, etc.
- All features work with STRING type consistently
- HTTP protocol is inherently string-based

---

## Unconstrained ANY Detection

**None found.**

All collections are properly typed:

| Location | Type | Status |
|----------|------|--------|
| MOCK_SERVER.expectations | ARRAYED_LIST [MOCK_EXPECTATION] | TYPED |
| MOCK_SERVER.received_requests | ARRAYED_LIST [MOCK_REQUEST] | TYPED |
| MOCK_MATCHER.required_headers | HASH_TABLE [STRING, STRING] | TYPED |
| MOCK_MATCHER.json_path_requirements | ARRAYED_LIST [TUPLE [path: STRING; value: STRING]] | TYPED |
| MOCK_REQUEST.headers | HASH_TABLE [STRING, STRING] | TYPED |
| MOCK_RESPONSE.headers | HASH_TABLE [STRING, STRING] | TYPED |
| MOCK_VERIFIER.unmatched_expectations | ARRAYED_LIST [MOCK_EXPECTATION] | TYPED |
| MOCK_VERIFIER.requests_to | ARRAYED_LIST [MOCK_REQUEST] | TYPED |

**All collections are type-safe.**

---

## Type Casting Detection

**None found.**

No type casts (`attached {TYPE}` patterns used for downcasting) exist in the codebase.

The only `attached` patterns are for void-safety with detachable types:
- `attached headers.item (key) as l_value` - null check, not type cast
- `attached body_contains as l_contains` - null check, not type cast
- `attached query_string as l_qs` - null check, not type cast

---

## Collection Type Analysis

All collections properly typed (see Unconstrained ANY section above).

---

## Constrained Genericity Opportunities

**None identified.**

No algorithms operate on unknown types that would benefit from constraints.

---

## Algorithm Generalization

**None needed.**

All algorithms are specific to HTTP mocking domain:
- URL matching operates on STRING (URLs are strings)
- Header matching operates on HASH_TABLE [STRING, STRING]
- Body matching operates on STRING

Making these generic would not provide reuse benefit.

---

## Genericity Impact Assessment

| Opportunity | Benefit | Recommendation |
|-------------|---------|----------------|
| HTTP_MESSAGE [G] | Minimal - semantics differ | NOT RECOMMENDED |
| Generic matcher | None - domain-specific | NOT RECOMMENDED |
| Generic collections | Already generic (ARRAYED_LIST [X]) | ALREADY DONE |

---

## Should Genericity Be Added?

**NO.**

Reasons:
1. **Domain-specific library** - HTTP mocking has fixed types (strings, headers, bodies)
2. **No code duplication** - Each class has unique purpose
3. **Type safety already achieved** - All collections properly typed
4. **No parallel hierarchies** - No TYPE_X variants to collapse
5. **YAGNI** - Adding genericity would add complexity without benefit

---

## Comparison with Other Libraries

| Library | Genericity | Appropriate? |
|---------|------------|--------------|
| simple_mock | None | YES - domain types fixed |
| simple_json | JSON_VALUE [G] possible | Debatable |
| simple_http | None | YES - HTTP types fixed |
| EiffelBase | ARRAYED_LIST [G] | YES - collection library |

**HTTP libraries typically don't need genericity** because:
- HTTP protocol defines the types (methods, headers, bodies are all strings)
- No user-defined element types needed
- No algorithm reuse across different types

---

## Recommended Generic Classes

**None.**

---

## Implementation Priority

**No genericity changes needed.**

---

## Overall Assessment

**Genericity Design: APPROPRIATE**

The simple_mock library correctly avoids unnecessary genericity:
- All types are domain-specific (HTTP concepts)
- No code duplication that would benefit from parameterization
- Collections use EiffelBase generics (ARRAYED_LIST, HASH_TABLE) appropriately
- Adding genericity would add complexity without providing reuse

## Next Step
→ D05-REFACTOR-PLAN.md (if refactoring needed)
