# Blueprint-writer directive — slug `wd-spec-refine`

## Target chapter

`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (445 LOC, iter-171 landing).

## Why

iter-172 lean-vs-blueprint-checker `wd172` flagged the chapter as **materially under-specified**. The Lean file `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane C iter-172 landing) shipped with:

- A helper structure `Scheme.PrimeDivisor` carrying a placeholder field `isCodim1AndIntegral : True := trivial` because the chapter does not name a Mathlib predicate for "codim-1 integral closed subscheme of a scheme `X`".
- Signatures on `Scheme.WeilDivisor.degree`, `WeilDivisor.principal`, `WeilDivisor.principal_hom`, `WeilDivisor.ofClosedPoint`, `Scheme.RationalMap.order` that use only `[IsIntegral X]` for the standing hypothesis $(*)$ — but Hartshorne's $(*)$ is "noetherian + integral + separated + **regular in codimension 1**", and the chapter does not pin which Mathlib predicate(s) capture it.

iter-172 lean-auditor `iter172` flagged the `True` placeholder as a **must-fix-this-iter** weakened-wrong definition: with `True := trivial`, every point trivially satisfies the "codim-1 integral" condition, so `Scheme.WeilDivisor X` is structurally `(X.carrier →₀ ℤ)` — the free abelian group on ALL points of `X`, not on prime divisors.

The iter-173 planner needs the chapter to:

1. **Name a concrete Mathlib predicate** (or a concrete combination of predicates) that captures "codim-1 integral" for the `Scheme.PrimeDivisor` carrier. The iter-172 lean-vs-blueprint-checker proposed candidates:
   - `Order.coheight (X.toPresheafedSpace.carrier ⟨x, hx⟩) = 1` (if Mathlib exposes coheight on the topological space of a scheme — verify).
   - `IsIntegral (X.closedSubschemeOfPoint x)` (if Mathlib has `closedSubschemeOfPoint` — verify or propose a project-side helper).
   - A bundled `Scheme.PrimeDivisor` carrier as a `Scheme.IdealSheafData` of codim 1 (if Mathlib has the API).

   You **must** locate the right Mathlib name (or, if none exists, propose a precise project-side new declaration with its signature and a 1-paragraph informal proof). Do **not** leave the chapter pointing at a vague concept.

2. **Pin the standing hypothesis $(*)$** to a Mathlib typeclass set. The chapter currently says "$(*)$ — see Hartshorne II.6" in prose; the Lean file uses only `[IsIntegral X]`. Either tighten the Lean (and pin the right typeclass set in the chapter so the prover knows what to add), or amend the chapter to acknowledge that the broader signature `[IsIntegral X]` is sufficient for `degree` / `principal` (with the understanding that downstream `principal_degree_zero` etc. add the stronger hypothesis).

3. **Decide the signature of `degree` / `ofClosedPoint`**: the Lean defines `degree` over an arbitrary scheme; the chapter pins "smooth proper curve over $\bar k$". This is a project-side scope question — either constrain the Lean signature (and pin the right hypothesis set in the chapter so iter-173 prover can update the Lean) OR widen the chapter's prose to acknowledge the broader signature.

4. **Add a pin for `Scheme.PrimeDivisor`** (currently unreferenced in the chapter). Use the predicate decided in #1.

## Output requirements

- Edited `RiemannRoch_WeilDivisor.tex` (write_domain).
- Each new / refined block must keep the chapter's existing source citations + verbatim quotes intact (Hartshorne quotes are already in place; do not paraphrase them).
- For the new `def:prime_divisor` block (or expanded `def:codim1_cycles` block), include:
  - `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` pin.
  - A `% SOURCE: Hartshorne, II.6.A (read from references/...)` (if you decide a verbatim quote is needed — check what the chapter currently has).
  - The visible Lean-side encoding decision (specific Mathlib predicate names cited with stable Mathlib paths).
- For the $(*)$ pin, add a `\variable[...]` block or a Lean-side `variable` block instruction so the prover knows what to thread.
- **NEVER** add `\leanok` or `\mathlibok` markers (managed elsewhere).
- Authorize reference-retriever if you need to consult a new source (write_domain includes `references/**`).

## Constraints

- Stay within the chapter's existing scope (RR.1 = Weil divisors only). Do not pull RR.2/RR.3/RR.4 content forward.
- Do not change the 9 existing `\lean{...}` pins — only add new pins and refine the standing-hypothesis prose.
- The iter-173 prover will read the refined chapter and either (a) replace the `True` placeholder with the real predicate in `Scheme.PrimeDivisor`, or (b) widen the placeholder to a typed `sorry` if the predicate requires a Mathlib-side sub-build the project doesn't have yet. Your job is to make the choice clear to the prover.

## Verification step

After writing, re-read the chapter and verify:
- The chapter now answers: "what Mathlib predicate(s) capture codim-1 prime divisor?"
- The chapter now answers: "what typeclass set captures Hartshorne $(*)$?"
- The chapter is internally consistent (no contradiction between the new pins and the existing prose).
