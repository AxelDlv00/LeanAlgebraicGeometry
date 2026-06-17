# Lean ↔ Blueprint Check Report

## Slug
av-rigidity-iter157

## Iteration
157

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Summary of the headline finding
The `rigidity_lemma` **statement** faithfully matches the blueprint (the three added
instances and `x₀` are justified by Mumford's "variety" terminology and the Milne-1.1
remark). But its **proof is unsound**: it discards the collapse hypothesis `_hf` and
delegates to `rigidity_core` / `rigidity_eqOn_dense_open`, both of which **omit the collapse
hypothesis and are therefore false as stated**. The sole "remaining geometric sorry"
(`rigidity_eqOn_dense_open`, line 81) is *broader* than the geometric gap the blueprint
names — it can never be honestly discharged, yet `rigidity_lemma` already presents as proved.

---

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chapter: thm:rigidity_lemma)
- **Lean target exists**: yes (line 225).
- **Signature matches**: **yes.** Blueprint prose ("complete variety `X`, any varieties
  `Y`,`Z`") in Mumford's usage means integral (reduced+irreducible) and separated. The added
  `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`
  are exactly the unbundling of "variety", and the statement-block prose itself names a fixed
  `x₀` ("`g(y)=f(x₀,y)` for any fixed `x₀∈X`"). The Milne-1.1 remark (lines 121–122) explicitly
  lists "`V` complete, `V×W` geometrically irreducible, `Z` separated", which corroborates the
  instance set. The collapse hypothesis `_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`
  correctly encodes "`f(X×{y₀})` is the single point `z₀`". No `\lean{}`/prose mismatch on the
  **statement**.
- **Proof follows sketch**: **NO.** The blueprint proof (lines 84–111, faithful to Mumford
  p.43) crucially uses `_hf` to make `V := Y∖G` non-empty (`y₀∉G since f(X×{y₀})={z₀}⊆U`).
  The Lean proof (lines 237–242) is `refine ⟨…⟩; rw [← Category.assoc, rigidity_snd_lift];
  exact rigidity_core f x₀` — it **never uses `_hf`** (verified: at line 242 the goal is
  `f = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f` with `_hf` inert in context, and
  `rigidity_core` does not take `_hf`). A proof of a conditional theorem that ignores its key
  hypothesis by delegating to a stronger lemma is the classic unsoundness smell, realised here
  literally (see Red flags).
- **notes**: blueprint marks both statement and proof `\leanok`. The proof transitively rests
  on the `sorry` at line 81; if `sync_leanok` only inspects direct `sorry` in the named decl,
  it will keep `rigidity_lemma`'s proof `\leanok` even though the chain bottoms out in a *false*
  deferred lemma. Informational (`\leanok` is sync-managed, not my domain), but worth the plan
  agent's attention.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: prop:morphism_P1_to_AV_constant)
- **Lean target exists**: yes (line 258), body `:= sorry`.
- **Signature matches**: yes — pinned to the genus-0 proxy encoding; matches prose.
- **Proof follows sketch**: N/A (deferred bare `sorry`).
- **notes**: KNOWN deferred scaffold (per directive). Blueprint honestly marks it as resting
  on `thm:theorem_of_the_cube`, itself disclosed as a deferred deep input with no Lean target.
  Honest. Not re-reported as a finding.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: prop:genusZero_curve_iso_P1)
- **Lean target exists**: yes (line 282), body `:= sorry`.
- **Signature matches**: yes — both `C` and `ℙ¹` are the abstract genus-0 proxy; prose
  ("any two such genus-0 curves are isomorphic") and Lean agree.
- **Proof follows sketch**: N/A (deferred bare `sorry`).
- **notes**: KNOWN deferred scaffold. Blueprint `rmk:genusZero_iso_subbuild` honestly flags
  this as a Riemann–Roch sub-build (Mathlib has none). Honest.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: thm:rigidity_genus0_curve_to_AV)
- **Lean target exists**: yes (line 307), body `:= sorry`.
- **Signature matches**: yes — verbatim `rigidity_over_kbar` minus `[CharZero kbar]`, as the
  prose claims (curve typeclasses, AV typeclasses, pointed conclusion `f = toUnit C ≫ η[A]`).
- **Proof follows sketch**: N/A (deferred bare `sorry`); blueprint proof prose (compose
  `genusZero_curve_iso_P1` with `morphism_P1_to_grpScheme_const`, pin constant via the point)
  is an adequate sketch for when it is filled.
- **notes**: KNOWN deferred scaffold. Honest.

### `theorem_of_the_cube` (chapter: thm:theorem_of_the_cube)
- No `\lean{}` hint; explicitly recorded as a deferred input with no Lean target. Correct and
  honest — nothing to check on the Lean side.

---

## Red flags

### Placeholder / suspect bodies — and a FALSE deferred statement (must-fix)

- **`rigidity_eqOn_dense_open` (line 81): `:= sorry` on a statement that is FALSE as written.**
  The lemma omits any collapse hypothesis (no `y₀`, no `_hf`). Counterexample: take `X=Y=Z`
  all the proper geom-irred reduced ℙ¹-proxy over an algebraically closed `kbar`, and
  `f := fst : X ⊗ Y ⟶ X = Z`. All instances (`IsProper X.hom`) hold, yet `fst.left` agrees
  with `(retract ≫ f).left = (toUnit ≫ x₀)` (a constant) on *no* non-empty open. So the
  existential is unsatisfiable — the `sorry` can never be discharged. The lemma's own
  docstring even reproduces Mumford's argument *using* `f(X×{y₀})={z₀}` ("`y₀∉G since
  f(X×{y₀})={z₀}`") — i.e. the prose in the docstring contradicts the lemma's signature, which
  has dropped that hypothesis.

- **`rigidity_core` (line 147): conclusion is FALSE as stated (same missing hypothesis).** It
  carries the four instances but still no `_hf`; conclusion `f = lift (toUnit ≫ x₀) (snd) ≫ f`.
  The same `f := fst` counterexample (instances all satisfied) refutes it. It "compiles" only
  because it consumes the false `rigidity_eqOn_dense_open`. Its docstring claims it is "PROVEN,
  modulo `rigidity_eqOn_dense_open`" and is "the entirety of the geometric content" — but it is
  not a true statement, so this is not an honest deferral.

- **Consequence for `rigidity_lemma` (line 225).** Because its proof routes through the false
  `rigidity_core` and never touches `_hf`, the *only* reason `rigidity_lemma` type-checks is the
  downstream `sorry`. The statement is true (it has `_hf`), but the project does not actually
  have a proof of it: any attempt to discharge `rigidity_eqOn_dense_open` will fail, exposing
  that the `_hf → nonempty V` step was silently dropped. This is the genuine must-fix.

**This is NOT one of the three known-issue deferred scaffolds.** The directive's known-issues
exemption covers only `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, and
`rigidity_genus0_curve_to_grpScheme`. `rigidity_eqOn_dense_open` / `rigidity_core` are a
separate, newly-introduced problem on the lane (`rigidity_lemma`) that *was* worked this iter.

### Excuse-comments
- None of the forbidden form. The docstrings are extensive and largely accurate about the
  *algebra* (`rigidity_snd_lift` is genuinely true and proven), but the `rigidity_core` /
  `rigidity_eqOn_dense_open` docstrings assert these are "the sole remaining sorry" / "PROVEN
  modulo …" while the statements they describe are false — effectively an inadvertent
  excuse-narrative around an unprovable obligation. Flagged under suspect bodies above.

### Axioms / Classical.choice
- None.

---

## Unreferenced declarations (informational)

- `rigidity_snd_lift` (line 64) — pure cartesian-monoidal algebra helper; **true and proven**
  (`ext1 <;> simp`). Acceptable as an unreferenced helper, though see Q2 below.
- `rigidity_eqOn_dense_open` (line 81) — unreferenced helper hosting the deferred geometric
  content. **Should be surfaced in the blueprint** (it is where the genuine gap lives) AND it is
  mis-stated (Red flags).
- `rigidity_core` (line 147) — unreferenced helper; mis-stated (Red flags).

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 substantive headline declarations have `\lean{}` blocks. 3 helper
  declarations (`rigidity_snd_lift`, `rigidity_eqOn_dense_open`, `rigidity_core`) are
  unreferenced. Two of those three host the deferred geometric content and the unsoundness.
- **Proof-sketch depth**: **adequate for the statements, but the chapter is silent on the
  three-lemma decomposition** the Lean actually uses. The `thm:rigidity_lemma` proof prose is a
  faithful single-block transcription of Mumford and *does* carry the collapse hypothesis
  through to non-emptiness of `V` — which is precisely the step the Lean decomposition dropped.
  Had the chapter pinned a block (or `\lean{}`+`% NOTE`) for `rigidity_eqOn_dense_open` stating
  its hypotheses, the missing `_hf` would have been caught at formalisation time. So: the
  blueprint prose is *correct* and *more complete* than the Lean here — this is a Lean-side
  failure, not a blueprint under-specification — but the chapter should still add a helper
  block so the deferred geometric `sorry` has an explicit, hypothesis-complete target.
- **Hint precision**: precise for all four `\lean{}` blocks. No wrong/loose hint on the
  headline declarations.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Add a `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` block (or a `% NOTE:` under
     `thm:rigidity_lemma`) stating the deferred dense-open agreement **with** the collapse
     hypothesis `f(X×{y₀})={z₀}` explicit, so the Lean target is pinned hypothesis-complete and
     cannot silently drop `_hf`.
  2. Optionally add a one-line note recording the intended three-helper decomposition
     (`rigidity_snd_lift` = monoidal algebra, `rigidity_core` = geometric heart,
     `rigidity_eqOn_dense_open` = the non-empty open), so reviewers can map the Lean to the
     prose.

---

## Severity summary

- **must-fix-this-iter**:
  - `rigidity_eqOn_dense_open` (line 81) and `rigidity_core` (line 147) are **false as stated**
    (missing the collapse hypothesis `_hf` / a fixed `y₀`,`z₀`); the deferred `sorry` is
    therefore unsatisfiable, and the `sorry` is *broader* than the geometric gap the blueprint
    names (Mumford's "non-empty open `V` + slice constancy" depends on `f(X×{y₀})={z₀}`).
    Directive Q3 answer: **broader / false**, not an exact match.
  - `rigidity_lemma` (line 225): its proof discards `_hf` and delegates to the false
    `rigidity_core`, so the project has **no actual proof** of a theorem the blueprint marks
    `\leanok` and references via `\lean{}`. Directive Q1 answer: **statement matches the prose;
    proof does not — it is unsound** (the `_hf → nonempty V` step is silently dropped).
  - Fix direction (Lean): restore a `y₀`/`z₀`+`_hf` (or a section through `z₀`) to
    `rigidity_eqOn_dense_open` and `rigidity_core`, and thread `_hf` through `rigidity_lemma`'s
    proof so the key hypothesis is genuinely consumed.

- **major**:
  - Directive Q2 answer: `rigidity_snd_lift`, `rigidity_core`, `rigidity_eqOn_dense_open` are
    not referenced from the chapter and the three-lemma decomposition is not reflected; add at
    least a hypothesis-complete block/note for `rigidity_eqOn_dense_open` (the home of the
    genuine deferred geometry).

- **minor**:
  - `rigidity_lemma` proof+statement `\leanok` may be carried despite a transitive `sorry`;
    flag for the plan agent (sync-managed, informational).

- **Not re-reported** (per directive known-issues): the bare `:= sorry` on
  `morphism_P1_to_grpScheme_const` (258), `genusZero_curve_iso_P1` (282),
  `rigidity_genus0_curve_to_grpScheme` (307). Confirmed: the blueprint honestly marks all three
  as deferred (theorem-of-the-cube / Riemann–Roch sub-builds), with `thm:theorem_of_the_cube`
  disclosed as a no-Lean-target deferred input. Honest disclosure verified.

**Overall verdict**: `rigidity_lemma`'s statement matches the blueprint, but its proof is
unsound — it routes through `rigidity_core`/`rigidity_eqOn_dense_open`, which dropped the
collapse hypothesis and are false as written, so the "sole remaining geometric sorry" is
unsatisfiable; this is a must-fix on the very lane that received prover work this iter.
