# Lean ↔ Blueprint Check Report

## Slug
avr-iter163

## Iteration
163

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

Scope per directive: the two declarations the prover added this iter —
`hom_additive_decomp_of_rigidity` and `av_regularMap_isHom_of_zero` — plus the
required bidirectional spot-checks (`\uses` acyclicity, headline laundering,
chapter adequacy for the file). Both new declarations were verified axiom-clean
(`{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**) via `lean_verify`.

## Per-declaration

### `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}` (chapter: `lem:hom_additivity_over_product`, tex L644)
- **Lean target exists**: yes (L809).
- **Signature matches**: yes (faithful, with two benign divergences noted below).
  - Hypotheses: `[IsProper V.hom]` = "V complete"; `[GeometricallyIrreducible (V⊗W).hom] + [IsReduced (V⊗W).left] + [LocallyOfFiniteType (V⊗W).hom]` = "V×W a variety"; A as abelian variety (`GrpObj/IsProper/Smooth/GeometricallyIrreducible`); k̄-points `v₀, w₀`; `hh : lift v₀ w₀ ≫ h = η[A]` = "h(v₀,w₀)=0" (η[A] is the hom-group identity = "0"). ✓
  - Conclusion `h = (fst V W ≫ f) * (snd V W ≫ g)` with `f = lift (𝟙 V) (toUnit V ≫ w₀) ≫ h` (= h|_{V×{w₀}}) and `g = lift (toUnit W ≫ v₀) (𝟙 W) ≫ h` (= h|_{{v₀}×W}) — exactly the blueprint's `h = f∘p + g∘q` read multiplicatively in the `GrpObj` hom-group, p=fst, q=snd. ✓ Matches the chapter's explicit "Lean encoding" note (L664–674): operation is the `GrpObj`-induced `*`, no `CommGrpObj` assumed. ✓
  - **Divergence 1 (minor):** blueprint claims the decomposition is *unique* with `f(v₀)=0, g(w₀)=0`; the Lean states only the existence equation with canonical (axis-restriction) witnesses inlined. Uniqueness and the `f(v₀)=η/g(w₀)=η` side-conditions are not exposed (they are proved internally as `hvf/hwg`). The lemma is correspondingly *stronger* on existence; uniqueness is not needed by the downstream consumer. Non-blocking.
  - **Divergence 2 (minor):** blueprint requires *both* V and W complete; Lean requires only `[IsProper V.hom]` (W-completeness is unused — the rigidity step is one-sided). Lean is more general; faithful.
- **Proof follows sketch**: yes. Lean `φ := h / ((fst≫f)*(snd≫g))`; `hcolV` collapses the complete V-axis to `η`; `hcolW` kills it on the `{v₀}×W` section; `rigidity_lemma φ` factors through `snd`; the factor is `1`; `div_eq_one`. This is verbatim Milne Cor 1.5 (form φ, vanishes on both axes, Rigidity, section ⇒ factor 0). ✓
- **notes**: `\uses{thm:rigidity_lemma}` on both statement and proof — correct and forward (Lean body calls `rigidity_lemma` at L855). Axiom-clean, no sorry.

### `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}` (chapter: `lem:av_regular_map_is_hom`, tex L702)
- **Lean target exists**: yes (L879).
- **Signature matches**: partial — faithful to the *pointed* form, with an unrecorded encoding detail (the directive's item #2).
  - The Lean proves the pointed equivalent: `(α : A ⟶ B) (hα : η[A] ≫ α = η[B]) : IsMonHom α`. The lemma *title* (L705) is exactly "A pointed regular map ... is a homomorphism", and the body states the equivalence "if α(0_A)=0_B then α is a homomorphism". So the Lean formalizes the named pointed direction; the full "composite of a homomorphism with a translation" form is not formalized (acceptable — the chapter presents it as equivalent and the consumer needs only the pointed form). ✓
  - **Directive item #2 — the three `A ⊗ A` instances (minor; `% NOTE:` suffices):** the Lean carries `[GeometricallyIrreducible (A⊗A).hom]`, `[LocallyOfFiniteType (A⊗A).hom]`, `[IsReduced (A⊗A).left]` (L883–885), which the prose does not mention. These are *not* a faithfulness defect: they encode "A×A is a variety", which is mathematically automatic for any genuine abelian variety A over k̄ — exactly the same "free downstream" situation the chapter already documents for the rigidity chain (L264–268). They are present only because Mathlib does not yet auto-derive `GeometricallyIrreducible/IsReduced/LocallyOfFiniteType` for the product from the factor. The statement still proves precisely what the prose claims for real abelian varieties; nothing is weakened. **A `% NOTE:` recording these as derivable-but-explicitly-carried instance hypotheses is sufficient this iter** — a full Lean-encoding paragraph is *not* warranted (a one-sentence note is the proportionate fix). The same pattern is *also* present and undocumented on `hom_additive_decomp_of_rigidity` (the V⊗W instances); the cleanest fix is one shared encoding sentence covering both.
- **Directive item #3 — `IsMonHom α` as a rendering of "α is a homomorphism": acceptable, yes.** `IsMonHom` bundles `one_hom` (identity-preservation, discharged by the pointed hyp `hα`) and `mul_hom` (`α(a·a') = α(a)·α(a')`, the blueprint's "α(a+a')=α(a)+α(a')"). For group objects a monoid hom is automatically a group hom, so `IsMonHom` is a standard, faithful — indeed slightly stronger (it also records `one_hom`) — encoding of "homomorphism". ✓
- **Proof follows sketch**: yes. Applies `hom_additive_decomp_of_rigidity` to `h := μ[A] ≫ α` with V=W=A based at `η[A]`; both axis-restrictions reduce to `α` by the monoid unit laws (`lift_comp_one_right/left`); the decomposition is repackaged as `IsMonHom` (`mul_hom` from `key` + `Hom.mul_def`, `one_hom = hα`). This is Milne Cor 1.2's φ-vanishing argument routed through Cor 1.5, matching the chapter. ✓
- **notes**: `\uses{lem:hom_additivity_over_product}` on statement and proof — correct and forward (Lean body calls `hom_additive_decomp_of_rigidity` at L895). Axiom-clean, no sorry.

## Red flags

### Placeholder / suspect bodies
None in the two audited declarations. Both have complete tactic proofs and verify
axiom-clean (no `sorryAx`).

### Proof-block `\leanok` on `sorry` bodies (laundering risk — NOT in the two new lemmas; sync_leanok domain)
Three *downstream* blocks carry a **proof-block `\leanok`** while their Lean bodies
are `sorry`:
- `prop:morphism_P1_to_AV_constant` proof (tex L903) ↔ `morphism_P1_to_grpScheme_const` is `:= sorry` (Lean L928).
- `prop:genusZero_curve_iso_P1` proof (tex L960) ↔ `genusZero_curve_iso_P1` is `:= sorry` (Lean L952).
- `thm:rigidity_genus0_curve_to_AV` proof (tex L1020) ↔ `rigidity_genus0_curve_to_grpScheme` is `:= sorry` (Lean L981).

Per CLAUDE.md, proof-block `\leanok` means "proof closed, no sorry", so these three
markers are currently false and would launder the headline + two props. **However**:
`\leanok` is owned by the deterministic `sync_leanok` phase (runs between prover and
review); this report is likely reading a pre-sync state, and no agent may hand-edit
`\leanok`. Flagging so the plan/review agent confirms `sync_leanok` strips these
three before the headline is treated as anything but open. This is *not* attributable
to the two new lemmas (both genuinely sorry-free) and not a prover/blueprint-writer
fix.

### Axioms / Classical.choice on non-trivial claims
None beyond the three standard kernel axioms; no custom `axiom` declarations in the file.

## Unreferenced declarations (informational)
- The Lean helpers `rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core` are
  not directly `\lean{...}`-referenced but are described in `rmk:rigidity_lemma_decomposition`
  prose — acceptable (decomposition helpers).
- Blueprint blocks `lem:rational_map_to_av_extends` (`\lean{...rationalMap_to_av_extends}`)
  and `lem:hom_from_Ga_trivial` (`\lean{...morphism_Ga_to_av_const}`) name Lean
  declarations that **do not yet exist** in the file. Both blocks are correctly
  *unmarked* (no `\leanok`); the `\lean{}` hints pin future targets. Acceptable —
  informational only, outside this iter's two-declaration scope.

## Blueprint adequacy for this file
- **Coverage** (two new declarations): both `hom_additive_decomp_of_rigidity` and
  `av_regularMap_isHom_of_zero` have faithful `\lean{...}` blocks with `\uses` edges.
- **Proof-sketch depth**: adequate. Both chapter proofs preview the exact Lean
  argument (form the difference φ / repackage as `IsMonHom`); no hidden reasoning.
- **Hint precision**: precise on names; **slightly loose on instance encoding** — the
  prose does not tell a prover to carry the product-level `[GeometricallyIrreducible/
  LocallyOfFiniteType/IsReduced]` instances on `A⊗A` / `V⊗W`. A prover working from
  prose alone would not know to add them. This is the one place the Lean clearly
  needed more guidance than the prose gave (directive item #5).
- **Generality**: matches need (Lean is, if anything, more general — drops
  W-completeness in Cor 1.5).
- **Recommended chapter-side actions**:
  - (minor) Add a one-sentence Lean-encoding note to both `lem:hom_additivity_over_product`
    and `lem:av_regular_map_is_hom` recording that the formalization carries
    `[GeometricallyIrreducible (·⊗·).hom]`, `[LocallyOfFiniteType (·⊗·).hom]`,
    `[IsReduced (·⊗·).left]` on the product — derivable for genuine abelian/complete
    varieties, carried explicitly only because Mathlib lacks the product-instance
    inference. The review agent's planned `% NOTE:` on `lem:av_regular_map_is_hom`
    discharges this for that lemma; mirror it on `lem:hom_additivity_over_product`.
  - (minor, optional) Note in `lem:hom_additivity_over_product` that the Lean states
    the existence half with canonical witnesses (uniqueness not formalized) and
    requires only V (not W) complete.
  - (advisory, not blueprint-writer's) Have the plan/review agent confirm `sync_leanok`
    removed the three false proof-block `\leanok` markers above.

## Severity summary
- **must-fix-this-iter**: none. Both new declarations are faithful, axiom-clean, and
  sorry-free; the extra `A⊗A` instance hypotheses are derivable side-conditions
  consistent with the prose (not a signature mismatch, not a weakened-wrong
  statement), and `IsMonHom` is an accepted rendering of "homomorphism".
- **major**: none.
- **minor**:
  1. `A⊗A` (and `V⊗W`) product-level instance hypotheses unrecorded in prose — a
     `% NOTE:` / one-line encoding sentence on both lemmas suffices (directive #2: NOTE
     confirmed sufficient; no full paragraph needed).
  2. Uniqueness clause + W-completeness of `lem:hom_additivity_over_product` not
     reflected in the (more-general, existence-only) Lean statement.
- **advisory (sync_leanok domain, not the two new lemmas)**: three downstream
  sorry-bodied blocks carry proof-block `\leanok`; confirm the deterministic sync
  strips them so the headline is not laundered.

Overall verdict: The two new declarations faithfully formalize Milne Cor 1.5 / Cor 1.2,
are axiom-clean and sorry-free with forward-acyclic `\uses` edges and no laundering of
the headline through them; the only chapter gap is the unrecorded (mathematically free)
product-level instance hypotheses, for which the review agent's `% NOTE:` is the correct
and sufficient fix.
