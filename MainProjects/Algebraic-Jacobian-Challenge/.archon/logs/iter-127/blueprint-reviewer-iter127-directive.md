# Blueprint Reviewer Directive

## Slug
iter127

## Iter
127

## Strategy snapshot

The project is mid-execution on milestone M2 (genus-0 witness `genusZeroWitness`). Iter-126 landed two structural refactors: (a) **M1 EXCISED** — 7 declarations deleted from `Differentials.lean` (572 → 144 LOC), including the parked bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE` + its support helpers; (b) **M2.a scaffold** — new file `RigidityKbar.lean` (87 LOC) with the named declaration `AlgebraicGeometry.rigidity_over_kbar` and a single `sorry` body, encoded in Option B (abstract genus-0 curve, not literal `ℙ¹`). The iter-126 mathlib-analogist consult on the **shared cotangent-vanishing pile** produced `analogies/cotangent-vanishing-pile.md` with per-piece (i)+(ii)+(iii) LOC budgets (piece (iv) Serre duality DEFERRED out of the iter-129+ build entirely).

Iter-127 will dispatch `refactor-m2b-scaffold-iter127` to add a `genusZeroWitness` builder to `Jacobian.lean` (or possibly a new file), with `isAlbaneseFor` branching on `C(k) = ∅` vacuity vs `rigidity_over_kbar` application. Iter-128 must dispatch a prover lane on a concrete piece-(i) sub-lemma per the iter-126 progress-critic META-PATTERN TRIPWIRE; iter-127 plan agent commits to staging that target this iter.

## Specific concerns for this audit

1. **`RigidityKbar.tex`** (NEW iter-126) — per the iter-126 `lean-vs-blueprint-checker-rigiditykbar` minor flags: (a) C.2.e at L55 waves at "integrated into the application of C.2.b" — does this need expansion for the future iter-128+ prover lane? (b) The chapter doesn't preview whether `[IsAlgClosed kbar]` may need to be added when piece (iii) lands. (c) The underscore-prefixed `_hgenus` / `_hf` hypothesis names will need de-underscoring when the body lands. Are any of these blocking for iter-127's staging deliverables?

2. **`Jacobian.tex`** — per STRATEGY.md the genus-stratified body decomposition (`by_cases h : genus C = 0`) for `nonempty_jacobianWitness` is the long-arc structural restructure. Iter-127 will scaffold `genusZeroWitness` (the positive-half of that decomposition); is `Jacobian.tex` adequate for guiding a prover on the genus-0 witness builder? In particular: does the chapter explicitly state how the `isAlbaneseFor` field's vacuity vs rigidity-application branching works (the C(k) = ∅ vs C(k) ≠ ∅ dichotomy)?

3. **Piece (i) sub-lemma decomposition** — the iter-126 progress-critic-iter126 META-PATTERN TRIPWIRE for iter-128 requires that iter-127 stage a concrete piece-(i) prover-ready sub-lemma. Does `RigidityKbar.tex` § "The shared cotangent-vanishing Mathlib pile" piece (i) (L63–64) contain enough decomposition (Lie-algebra-of-`GrpObj` + mulRight-globalisation + relative-cotangent-presheaf trivialisation) to scope the first prover-ready Lean target, or is a blueprint-writer dispatch on piece (i) sub-decomposition needed this iter? If the latter: name the specific must-fix items.

4. **`Differentials.tex` post-excise** — the iter-126 `lean-vs-blueprint-checker-differentials-iter126` returned PASS with one minor (Mathlib-name precision drift on `component_nontrivial` vs `Nonempty V` + `algebraize`). Re-verify the chapter is in a clean post-excise state and the 5 retained declarations are all `\lean{...}`-tagged.

5. **Cross-route blueprint coverage for the over-k alternative** — STRATEGY.md § Alternative "direct over-k rigidity" is dispatched to a `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` consult this iter, but the over-k variant is NOT covered by any blueprint chapter yet. Is this a blueprint coverage gap that requires a writer dispatch?

6. **Orphan chapters** (`Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`) — informational carry-over from earlier strategy iterations; not in `content.tex`. iter-124 and iter-125 + iter-126 reviewers flagged these as cleanup candidates. Should the iter-127 plan agent dispatch a blueprint-writer to delete them, or are they harmless?

## Files

- All `blueprint/src/chapters/*.tex`.
- `blueprint/src/content.tex`.
- `blueprint/src/macros/common.tex`.

## Cross-chapter dependencies (verify)

- `Jacobian.tex` `\uses{thm:rigidity_over_kbar}` → `RigidityKbar.tex` `thm:rigidity_over_kbar`. Confirm the cross-ref resolves.
- `Rigidity.tex` "Use in the project" cross-ref to `RigidityKbar.tex` (added iter-126). Confirm.
- `Differentials.tex` no longer claims any bridge declaration (M1 excise iter-126). Confirm.

## Lean target verification (spot-check)

- `AlgebraicGeometry.rigidity_over_kbar` — exists at `RigidityKbar.lean:75`.
- `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` — exists at `Rigidity.lean:91` (post iter-125 refactor).
- `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf` + 4 other Differentials declarations — exist post-excise.
- `AlgebraicGeometry.GrpObj.omega_free` / `AlgebraicGeometry.GrpObj.omega_rank_eq_dim` — PHANTOM (not yet introduced); these are the proposed iter-128+ build targets per `RigidityKbar.tex` § Shared pile piece (i).

## Output requested

Per the descriptor: per-chapter checklist (complete: yes/no, correct: yes/no, soon flags) plus cross-cutting summaries (missing definitions, broken `\uses{}`, hallucinated `\lean{...}` targets, multi-route coverage gaps, strategy-modifying findings).

Pay special attention to whether iter-127's planned M2.b scaffold refactor has adequate blueprint backing (the HARD GATE rule per your `dispatcher_notes`: prover dispatches require chapter `complete: true` AND `correct: true`; iter-128's piece-(i) prover dispatch requires piece-(i) blueprint adequacy).
